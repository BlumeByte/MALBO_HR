import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/people_controller.dart';
import '../../domain/entities/employee.dart';
import 'employee_detail_page.dart';

class PeopleListPage extends ConsumerStatefulWidget {
  const PeopleListPage({super.key});

  @override
  ConsumerState<PeopleListPage> createState() => _PeopleListPageState();
}

class _PeopleListPageState extends ConsumerState<PeopleListPage> {
  final _search = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(peopleControllerProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(peopleControllerProvider);

    return AppScaffold(
      title: 'People',
      navIndex: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () =>
              ref.read(peopleControllerProvider.notifier).loadFirstPage(),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search people',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildList(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(PeopleState state) {
    final filtered = _filter(state.employees);

    return ListView.builder(
      controller: _scrollController,
      itemCount: filtered.length + 1,
      itemBuilder: (context, index) {
        if (index == filtered.length) {
          if (!state.hasMore) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text("All employees loaded")),
            );
          }

          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final emp = filtered[index];

        return Card(
          child: ListTile(
            title: Text(emp.fullName),
            subtitle: Text(emp.email ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmployeeDetailPage(employee: emp),
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<Employee> _filter(List<Employee> list) {
    final q = _search.text.toLowerCase();
    if (q.isEmpty) return list;

    return list.where((e) {
      return e.fullName.toLowerCase().contains(q) ||
          (e.email ?? '').toLowerCase().contains(q);
    }).toList();
  }
}
