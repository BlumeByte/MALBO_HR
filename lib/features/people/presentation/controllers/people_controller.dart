import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/current_membership_provider.dart';
import '../../domain/entities/employee.dart';

final peopleControllerProvider =
    StateNotifierProvider<PeopleController, PeopleState>(
        (ref) => PeopleController(ref));

class PeopleState {
  final List<Employee> employees;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String? error;

  const PeopleState({
    required this.employees,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.page,
    required this.error,
  });

  factory PeopleState.initial() => const PeopleState(
        employees: [],
        isLoading: true,
        isLoadingMore: false,
        hasMore: true,
        page: 0,
        error: null,
      );

  PeopleState copyWith({
    List<Employee>? employees,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? error,
  }) {
    return PeopleState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
    );
  }
}

class PeopleController extends StateNotifier<PeopleState> {
  final Ref ref;
  final _client = Supabase.instance.client;
  static const int pageSize = 20;

  PeopleController(this.ref) : super(PeopleState.initial()) {
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, page: 0, hasMore: true);

    try {
      final membership = await ref.read(membershipProvider.future);

      final res = await _client
          .from('employees')
          .select()
          .eq('company_id', membership.companyId)
          .order('created_at', ascending: false)
          .range(0, pageSize - 1);

      final list = (res as List).map((e) => Employee.fromJson(e)).toList();

      state = state.copyWith(
        employees: list,
        isLoading: false,
        hasMore: list.length == pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final membership = await ref.read(membershipProvider.future);

      final nextPage = state.page + 1;
      final from = nextPage * pageSize;
      final to = from + pageSize - 1;

      final res = await _client
          .from('employees')
          .select()
          .eq('company_id', membership.companyId)
          .order('created_at', ascending: false)
          .range(from, to);

      final list = (res as List).map((e) => Employee.fromJson(e)).toList();

      state = state.copyWith(
        employees: [...state.employees, ...list],
        isLoadingMore: false,
        hasMore: list.length == pageSize,
        page: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    await _client
        .from('employees')
        .update(employee.toUpdate())
        .eq('id', employee.id);

    await loadFirstPage();
  }

  Future<void> deleteEmployee(String id) async {
    await _client.from('employees').delete().eq('id', id);
    await loadFirstPage();
  }
}
