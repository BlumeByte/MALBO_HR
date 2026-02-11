import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/people/presentation/pages/people_list_page.dart';
import '../../features/leave/presentation/pages/leave_home_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
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
      GoRoute(
        path: AppRoutes.leave,
        builder: (_, __) => const LeaveHomePage(),
      ),
      GoRoute(
        path: AppRoutes.documents,
        builder: (_, __) => const DocumentsPage(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (_, __) => const ReportsPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsPage(),
      ),
    ],
  );
});
