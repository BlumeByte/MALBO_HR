import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/people/presentation/pages/people_list_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      // 🚫 DO NOT redirect while auth is loading
      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.value != null;

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
