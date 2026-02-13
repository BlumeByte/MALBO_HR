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

  Future<void> signOut() async {
    await _client.auth.signOut();
    state = const AsyncValue.data(null);
  }
}
