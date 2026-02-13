import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/config/current_membership_provider.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: 'Reports & Export',
      navIndex: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            final membership = await ref.read(membershipProvider.future);
            final client = Supabase.instance.client;

            final employees = await client
                .from('employees')
                .select('*')
                .eq('company_id', membership.companyId);

            final csv = const JsonEncoder.withIndent('  ').convert(employees);

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Export JSON Preview"),
                content: SizedBox(
                  width: 600,
                  child: SingleChildScrollView(
                    child: Text(csv),
                  ),
                ),
              ),
            );
          },
          child: const Text("Export Employees Data"),
        ),
      ),
    );
  }
}
