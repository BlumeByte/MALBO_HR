import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(child: Icon(Icons.people_alt_outlined)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'MALBO HR',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  _item(context, Icons.dashboard_outlined, 'Dashboard',
                      AppRoutes.dashboard, location),
                  _item(context, Icons.badge_outlined, 'People',
                      AppRoutes.people, location),
                  _item(context, Icons.event_available_outlined, 'Leave',
                      AppRoutes.leave, location),
                  _item(context, Icons.folder_outlined, 'Documents',
                      AppRoutes.documents, location),
                  _item(context, Icons.insights_outlined, 'Reports',
                      AppRoutes.reports, location),
                  _item(context, Icons.settings_outlined, 'Settings',
                      AppRoutes.settings, location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, String route,
      String location) {
    final selected =
        location == route || (route == AppRoutes.dashboard && location == '/');
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.of(context).maybePop();
        context.go(route);
      },
    );
  }
}
