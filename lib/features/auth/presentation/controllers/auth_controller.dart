import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<User?> {
  AuthController() : super(Supabase.instance.client.auth.currentUser) {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      state = data.session?.user;
    });
  }

  Future<void> signIn(String email, String password) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
