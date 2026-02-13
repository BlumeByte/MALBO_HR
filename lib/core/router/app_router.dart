import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:malbo_hr/core/router/go_router_refresh_stream.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_routes.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/people/presentation/pages/people_list_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange
          .map((event) => event.session),
    ),
    redirect: (context, state) {
      final user = Supabase.instance.client.auth.currentUser;

      final isLoggedIn = user != null;

      final loggingIn = state.matchedLocation == AppRoutes.login;
      final signingUp = state.matchedLocation == AppRoutes.signup;

      if (!isLoggedIn && !loggingIn && !signingUp) {
        return AppRoutes.login;
      }

      if (isLoggedIn && (loggingIn || signingUp)) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (_, __) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, __) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.people,
        builder: (_, __) => const PeopleListPage(),
      ),
    ],
  );
});
