import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final SupabaseClient _client = Supabase.instance.client;

  AuthController() : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    try {
      final currentUser = _client.auth.currentUser;
      state = AsyncValue.data(currentUser);

      _client.auth.onAuthStateChange.listen((data) {
        state = AsyncValue.data(data.session?.user);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // =========================
  // SIGN IN
  // =========================
  Future<void> signIn(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = AsyncValue.error(
        Exception("Email and password required"),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      final res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      state = AsyncValue.data(res.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // =========================
  // SIGN UP (FULL COMPANY CREATION)
  // =========================
  Future<void> signUp({
    required String email,
    required String password,
    required String companyName,
    required String firstName,
    required String lastName,
  }) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        companyName.trim().isEmpty ||
        firstName.trim().isEmpty ||
        lastName.trim().isEmpty) {
      state = AsyncValue.error(
        Exception("All fields are required"),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncValue.loading();

    try {
      // 1️⃣ Create auth user
      final authRes = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final user = authRes.user;

      if (user == null) {
        throw Exception("User creation failed");
      }

      // 2️⃣ Create company
      final companyRes = await _client
          .from('companies')
          .insert({'name': companyName.trim()})
          .select()
          .single();

      final companyId = companyRes['id'];

      // 3️⃣ Add membership (super_admin)
      await _client.from('company_members').insert(
          {'company_id': companyId, 'user_id': user.id, 'role': 'super_admin'});

      // 4️⃣ Create employee profile
      await _client.from('employees').insert({
        'company_id': companyId,
        'user_id': user.id,
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'email': email.trim(),
        'status': 'active'
      });

      state = AsyncValue.data(user);
    } catch (e, st) {
      print("SIGNUP ERROR: $e");
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    state = const AsyncValue.data(null);
  }
}
