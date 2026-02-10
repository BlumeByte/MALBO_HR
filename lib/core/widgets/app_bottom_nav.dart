import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (i) {
        switch (i) {
          case 0:
            context.go(AppRoutes.dashboard);
            break;
          case 1:
            context.go(AppRoutes.people);
            break;
          case 2:
            context.go(AppRoutes.leave);
            break;
          case 3:
            context.go(AppRoutes.documents);
            break;
          case 4:
            context.go(AppRoutes.settings);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.dashboard_outlined), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.badge_outlined), label: 'People'),
        NavigationDestination(
            icon: Icon(Icons.event_available_outlined), label: 'Leave'),
        NavigationDestination(icon: Icon(Icons.folder_outlined), label: 'Docs'),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined), label: 'Settings'),
      ],
    );
  }
}
