import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/current_membership_provider.dart';

class DashboardKpis {
  final int totalEmployees;
  final int activeEmployees;
  final int inactiveEmployees;

  final int pendingLeave; // will be 0 until leave tables exist
  final int documentsCount; // will be 0 until documents tables exist

  final Map<String, int> statusCounts; // active/inactive/etc
  final List<MonthlyCount> hiresPerMonth; // last 6 months

  const DashboardKpis({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.inactiveEmployees,
    required this.pendingLeave,
    required this.documentsCount,
    required this.statusCounts,
    required this.hiresPerMonth,
  });
}

class MonthlyCount {
  final String label; // e.g. "Sep"
  final int count;
  const MonthlyCount(this.label, this.count);
}

final dashboardKpisProvider = FutureProvider<DashboardKpis>((ref) async {
  final client = Supabase.instance.client;
  final membership = await ref.read(membershipProvider.future);

  // Employees (we rely on these columns commonly existing)
  final employees = await client
      .from('employees')
      .select('id, status, created_at')
      .eq('company_id', membership.companyId);

  final list = (employees as List).cast<Map<String, dynamic>>();

  final statusCounts = <String, int>{};
  for (final e in list) {
    final s = (e['status'] ?? 'active').toString().toLowerCase();
    statusCounts[s] = (statusCounts[s] ?? 0) + 1;
  }

  final total = list.length;
  final active = (statusCounts['active'] ?? 0) + (statusCounts['enabled'] ?? 0);
  final inactive = total - active;

  // Leave / Documents: safe fallback (until tables exist)
  int pendingLeave = 0;
  int documentsCount = 0;

  try {
    final leaveRes = await client
        .from('leave_requests')
        .select('id')
        .eq('company_id', membership.companyId)
        .eq('status', 'pending');
    pendingLeave = (leaveRes as List).length;
  } catch (_) {
    pendingLeave = 0;
  }

  try {
    final docRes = await client
        .from('documents')
        .select('id')
        .eq('company_id', membership.companyId);
    documentsCount = (docRes as List).length;
  } catch (_) {
    documentsCount = 0;
  }

  // Hires per month (last 6 months) from created_at
  final now = DateTime.now();
  final months = List.generate(6, (i) {
    final dt = DateTime(now.year, now.month - (5 - i), 1);
    final label = _monthLabel(dt.month);
    return MonthlyCount(label, 0);
  });

  final monthIndex = <String, int>{
    for (int i = 0; i < months.length; i++) months[i].label: i
  };

  for (final e in list) {
    final createdAtRaw = e['created_at'];
    if (createdAtRaw == null) continue;
    final dt = DateTime.tryParse(createdAtRaw.toString());
    if (dt == null) continue;

    // match by month label in the last 6 months window
    final label = _monthLabel(dt.month);
    if (monthIndex.containsKey(label)) {
      final idx = monthIndex[label]!;
      months[idx] = MonthlyCount(months[idx].label, months[idx].count + 1);
    }
  }

  return DashboardKpis(
    totalEmployees: total,
    activeEmployees: active,
    inactiveEmployees: inactive,
    pendingLeave: pendingLeave,
    documentsCount: documentsCount,
    statusCounts: statusCounts,
    hiresPerMonth: months,
  );
});

String _monthLabel(int m) {
  const labels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return labels[m - 1];
}
