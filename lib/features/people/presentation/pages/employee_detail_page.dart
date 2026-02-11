import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/employee.dart';
import '../controllers/people_controller.dart';
import '../controllers/org_controller.dart';

class EmployeeDetailPage extends ConsumerStatefulWidget {
  final Employee employee;
  const EmployeeDetailPage({super.key, required this.employee});

  @override
  ConsumerState<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends ConsumerState<EmployeeDetailPage> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final emp = widget.employee;

    return AppScaffold(
      title: emp.fullName,
      navIndex: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () async {
            final updated = await showDialog<Employee>(
              context: context,
              builder: (_) => _EditEmployeeDialog(employee: emp),
            );

            if (updated != null) {
              await ref
                  .read(peopleControllerProvider.notifier)
                  .updateEmployee(updated);
              if (context.mounted) Navigator.pop(context); // go back to list
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      child: Text(emp.firstName.isNotEmpty
                          ? emp.firstName[0].toUpperCase()
                          : '?'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(emp.fullName,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(emp.email ?? 'No email'),
                        ],
                      ),
                    ),
                    Chip(label: Text(emp.status)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Overview')),
                ButtonSegment(value: 1, label: Text('Job')),
                ButtonSegment(value: 2, label: Text('Documents')),
                ButtonSegment(value: 3, label: Text('Leave')),
              ],
              selected: {tab},
              onSelectionChanged: (s) => setState(() => tab = s.first),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: IndexedStack(
                index: tab,
                children: [
                  _OverviewTab(employee: emp),
                  _JobTab(employee: emp),
                  const _PlaceholderTab(
                      title: 'Documents',
                      note: 'We will connect employee docs here next.'),
                  const _PlaceholderTab(
                      title: 'Leave',
                      note:
                          'We will connect leave requests and balances here next.'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Employee employee;
  const _OverviewTab({required this.employee});

  @override
  Widget build(BuildContext context) {
    final e = employee;
    return Card(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kv('Employee No', e.employeeNo ?? '—'),
          _kv('Email', e.email ?? '—'),
          _kv('Phone', e.phone ?? '—'),
          _kv('Status', e.status),
        ],
      ),
    );
  }
}

class _JobTab extends ConsumerWidget {
  final Employee employee;
  const _JobTab({required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deptAsync = ref.watch(departmentsProvider);
    final jobAsync = ref.watch(jobTitlesProvider);
    final locAsync = ref.watch(locationsProvider);

    String nameById(List<dynamic> list, String? id) {
      if (id == null) return '—';
      final match = list.where((x) => x.id == id);
      return match.isEmpty ? '—' : match.first.name;
    }

    return Card(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          deptAsync.when(
            data: (d) => _kv('Department', nameById(d, employee.departmentId)),
            loading: () => _kv('Department', 'Loading...'),
            error: (e, _) => _kv('Department', 'Error: $e'),
          ),
          jobAsync.when(
            data: (j) => _kv('Job title', nameById(j, employee.jobTitleId)),
            loading: () => _kv('Job title', 'Loading...'),
            error: (e, _) => _kv('Job title', 'Error: $e'),
          ),
          locAsync.when(
            data: (l) => _kv('Location', nameById(l, employee.locationId)),
            loading: () => _kv('Location', 'Loading...'),
            error: (e, _) => _kv('Location', 'Error: $e'),
          ),
          _kv('Manager (id)', employee.managerEmployeeId ?? '—'),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final String note;
  const _PlaceholderTab({required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(child: Text('$title: $note')),
    );
  }
}

class _EditEmployeeDialog extends ConsumerStatefulWidget {
  final Employee employee;
  const _EditEmployeeDialog({required this.employee});

  @override
  ConsumerState<_EditEmployeeDialog> createState() =>
      _EditEmployeeDialogState();
}

class _EditEmployeeDialogState extends ConsumerState<_EditEmployeeDialog> {
  late final first = TextEditingController(text: widget.employee.firstName);
  late final last = TextEditingController(text: widget.employee.lastName);
  late final email = TextEditingController(text: widget.employee.email ?? '');
  late final phone = TextEditingController(text: widget.employee.phone ?? '');
  String status = 'active';

  String? departmentId;
  String? jobTitleId;
  String? locationId;

  @override
  void initState() {
    super.initState();
    status = widget.employee.status;
    departmentId = widget.employee.departmentId;
    jobTitleId = widget.employee.jobTitleId;
    locationId = widget.employee.locationId;
  }

  @override
  Widget build(BuildContext context) {
    final dept = ref.watch(departmentsProvider);
    final jobs = ref.watch(jobTitlesProvider);
    final locs = ref.watch(locationsProvider);

    return AlertDialog(
      title: const Text('Edit employee'),
      content: SizedBox(
        width: 520,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
                controller: first,
                decoration: const InputDecoration(labelText: 'First name')),
            const SizedBox(height: 8),
            TextField(
                controller: last,
                decoration: const InputDecoration(labelText: 'Last name')),
            const SizedBox(height: 8),
            TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(
                controller: phone,
                decoration: const InputDecoration(labelText: 'Phone')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: status,
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                DropdownMenuItem(
                    value: 'terminated', child: Text('Terminated')),
              ],
              onChanged: (v) => setState(() => status = v ?? 'active'),
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 12),
            dept.when(
              data: (d) => DropdownButtonFormField<String>(
                initialValue: departmentId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...d.map((x) =>
                      DropdownMenuItem(value: x.id, child: Text(x.name))),
                ],
                onChanged: (v) => setState(() => departmentId = v),
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              loading: () => const Padding(
                  padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
              error: (e, _) => Text('Departments error: $e'),
            ),
            const SizedBox(height: 12),
            jobs.when(
              data: (j) => DropdownButtonFormField<String>(
                initialValue: jobTitleId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...j.map((x) =>
                      DropdownMenuItem(value: x.id, child: Text(x.name))),
                ],
                onChanged: (v) => setState(() => jobTitleId = v),
                decoration: const InputDecoration(labelText: 'Job title'),
              ),
              loading: () => const Padding(
                  padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
              error: (e, _) => Text('Job titles error: $e'),
            ),
            const SizedBox(height: 12),
            locs.when(
              data: (l) => DropdownButtonFormField<String>(
                initialValue: locationId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...l.map((x) =>
                      DropdownMenuItem(value: x.id, child: Text(x.name))),
                ],
                onChanged: (v) => setState(() => locationId = v),
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              loading: () => const Padding(
                  padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
              error: (e, _) => Text('Locations error: $e'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final e = widget.employee;
            Navigator.pop(
              context,
              Employee(
                id: e.id,
                companyId: e.companyId,
                userId: e.userId,
                firstName: first.text.trim(),
                lastName: last.text.trim(),
                email: email.text.trim().isEmpty ? null : email.text.trim(),
                phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
                status: status,
                employeeNo: e.employeeNo,
                departmentId: departmentId,
                jobTitleId: jobTitleId,
                locationId: locationId,
                managerEmployeeId: e.managerEmployeeId,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

Widget _kv(String k, String v) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        SizedBox(
            width: 150,
            child:
                Text(k, style: const TextStyle(fontWeight: FontWeight.w700))),
        Expanded(child: Text(v)),
      ],
    ),
  );
}
