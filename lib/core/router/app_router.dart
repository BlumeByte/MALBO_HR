import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final user = container.read(authControllerProvider);

    final loggingIn = state.matchedLocation == '/login';

    if (user == null && !loggingIn) return '/login';
    if (user != null && loggingIn) return '/';

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (_, __) => const DashboardPage(),
    ),
  ],
);
