import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpisAsync = ref.watch(dashboardKpisProvider);

    return AppScaffold(
      title: 'Dashboard',
      navIndex: 0,
      actions: [
        IconButton(
          tooltip: 'Refresh',
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(dashboardKpisProvider),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: kpisAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorState(error: e.toString()),
          data: (kpis) => LayoutBuilder(
            builder: (context, c) {
              final isDesktop = c.maxWidth >= 900;

              return ListView(
                children: [
                  _QuickLinksRow(isDesktop: isDesktop),
                  const SizedBox(height: 16),
                  _KpiGrid(kpis: kpis, isDesktop: isDesktop),
                  const SizedBox(height: 18),
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _StatusPie(kpis: kpis)),
                            const SizedBox(width: 16),
                            Expanded(child: _HiresBar(kpis: kpis)),
                          ],
                        )
                      : Column(
                          children: [
                            _StatusPie(kpis: kpis),
                            const SizedBox(height: 16),
                            _HiresBar(kpis: kpis),
                          ],
                        ),
                  const SizedBox(height: 18),
                  _InsightsCard(kpis: kpis),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dashboard failed to load:\n$error',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _QuickLinksRow extends StatelessWidget {
  final bool isDesktop;
  const _QuickLinksRow({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickLink('People', Icons.groups, AppRoutes.people),
      _QuickLink('Leave', Icons.event_available, AppRoutes.leave),
      _QuickLink('Documents', Icons.folder, AppRoutes.documents),
      _QuickLink('Reports', Icons.bar_chart, AppRoutes.reports),
      _QuickLink('Settings', Icons.settings, AppRoutes.settings),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick actions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: items
                  .map((i) => FilledButton.tonalIcon(
                        onPressed: () => context.go(i.route),
                        icon: Icon(i.icon),
                        label: Text(i.title),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLink {
  final String title;
  final IconData icon;
  final String route;
  const _QuickLink(this.title, this.icon, this.route);
}

class _KpiGrid extends StatelessWidget {
  final DashboardKpis kpis;
  final bool isDesktop;
  const _KpiGrid({required this.kpis, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _KpiCard(
        title: 'Headcount',
        value: kpis.totalEmployees.toString(),
        subtitle: 'Total employees',
        icon: Icons.badge,
      ),
      _KpiCard(
        title: 'Active',
        value: kpis.activeEmployees.toString(),
        subtitle: 'Currently active',
        icon: Icons.verified,
      ),
      _KpiCard(
        title: 'Pending Leave',
        value: kpis.pendingLeave.toString(),
        subtitle: 'Awaiting approval',
        icon: Icons.pending_actions,
      ),
      _KpiCard(
        title: 'Documents',
        value: kpis.documentsCount.toString(),
        subtitle: 'Company & employee docs',
        icon: Icons.folder_copy,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            Expanded(child: cards[i]),
            if (i != cards.length - 1) const SizedBox(width: 12),
          ],
        ],
      );
    }

    return Column(
      children: [
        for (final c in cards) ...[
          c,
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPie extends StatelessWidget {
  final DashboardKpis kpis;
  const _StatusPie({required this.kpis});

  @override
  Widget build(BuildContext context) {
    final data = kpis.statusCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = data.fold<int>(0, (p, e) => p + e.value);
    final sections = <PieChartSectionData>[];

    for (int i = 0; i < data.length; i++) {
      final e = data[i];
      final pct = total == 0 ? 0 : (e.value / total) * 100;
      sections.add(
        PieChartSectionData(
          value: e.value.toDouble(),
          title: pct >= 8 ? '${pct.toStringAsFixed(0)}%' : '',
          radius: 60,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Employee status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: total == 0
                  ? const Center(child: Text('No employee data yet'))
                  : PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: data
                  .map((e) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.circle, size: 10),
                          const SizedBox(width: 6),
                          Text('${_titleCase(e.key)} (${e.value})'),
                        ],
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _HiresBar extends StatelessWidget {
  final DashboardKpis kpis;
  const _HiresBar({required this.kpis});

  @override
  Widget build(BuildContext context) {
    final maxY = (kpis.hiresPerMonth
        .map((e) => e.count)
        .fold<int>(0, (p, c) => p > c ? p : c)).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New hires (last 6 months)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  maxY: (maxY <= 3 ? 3 : maxY + 1),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= kpis.hiresPerMonth.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(kpis.hiresPerMonth[i].label),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (int i = 0; i < kpis.hiresPerMonth.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: kpis.hiresPerMonth[i].count.toDouble(),
                            width: 18,
                          ),
                        ],
                      ),
                  ],
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightsCard extends StatelessWidget {
  final DashboardKpis kpis;
  const _InsightsCard({required this.kpis});

  @override
  Widget build(BuildContext context) {
    final inactive = kpis.inactiveEmployees;
    final total = kpis.totalEmployees;

    final msg = total == 0
        ? 'Add your first employees to start tracking the team.'
        : inactive > 0
            ? '$inactive employees are inactive. Review status in People.'
            : 'All employees are active. Great!';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.tips_and_updates, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
