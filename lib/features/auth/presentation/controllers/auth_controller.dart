import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final _client = Supabase.instance.client;

  AuthController() : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    final user = _client.auth.currentUser;
    state = AsyncValue.data(user);

    _client.auth.onAuthStateChange.listen((data) {
      state = AsyncValue.data(data.session?.user);
    });
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(res.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String companyName,
    required String firstName,
    required String lastName,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authRes = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = authRes.user;
      if (user == null) throw Exception("Signup failed");

      // Create company
      final companyRes = await _client
          .from('companies')
          .insert({'name': companyName})
          .select()
          .single();

      final companyId = companyRes['id'];

      // Insert membership
      await _client.from('company_members').insert(
          {'company_id': companyId, 'user_id': user.id, 'role': 'super_admin'});

      // Create employee profile
      await _client.from('employees').insert({
        'company_id': companyId,
        'user_id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'status': 'active'
      });

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    state = const AsyncValue.data(null);
  }
}
