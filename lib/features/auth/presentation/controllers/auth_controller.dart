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
    final currentUser = _client.auth.currentUser;
    state = AsyncValue.data(currentUser);

    _client.auth.onAuthStateChange.listen((data) {
      state = AsyncValue.data(data.session?.user);
    });
  }

  // ================= SIGN IN =================
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
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

  // ================= SIGN UP =================
  Future<void> signUp({
    required String email,
    required String password,
    required String companyName,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    state = const AsyncValue.loading();

    try {
      // 1️⃣ Create Auth User
      final authRes = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = authRes.user;

      if (user == null) {
        throw Exception("User creation failed");
      }

      // 2️⃣ Create Company
      final companyRes = await _client
          .from('companies')
          .insert({
            'name': companyName,
          })
          .select()
          .single();

      final companyId = companyRes['id'];

      // 3️⃣ Create Membership
      await _client.from('company_members').insert({
        'company_id': companyId,
        'user_id': user.id,
        'role': 'super_admin',
      });

      // 4️⃣ Create Employee
      await _client.from('employees').insert({
        'company_id': companyId,
        'user_id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'status': 'active',
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
