import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/leave_provider.dart';

class LeaveHomePage extends ConsumerWidget {
  const LeaveHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveAsync = ref.watch(leaveRequestsProvider);

    return AppScaffold(
      title: 'Leave Management',
      navIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: leaveAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
          data: (leaves) {
            if (leaves.isEmpty) {
              return const Center(child: Text("No leave requests yet"));
            }

            return ListView.builder(
              itemCount: leaves.length,
              itemBuilder: (context, i) {
                final l = leaves[i];
                return Card(
                  child: ListTile(
                    title: Text(
                        "${l['employees']['first_name']} ${l['employees']['last_name']}"),
                    subtitle: Text(
                        "${l['leave_types']['name']} | ${l['start_date']} → ${l['end_date']}"),
                    trailing: Chip(
                      label: Text(l['status']),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
