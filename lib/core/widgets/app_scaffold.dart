import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app_drawer.dart';
import 'app_bottom_nav.dart';
import 'profile_menu.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final int navIndex;
  final Widget child;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.title,
    required this.navIndex,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...(actions ?? []),
          const ProfileMenu(),
        ],
      ),
      drawer: isDesktop ? null : const AppDrawer(),
      body: Row(
        children: [
          if (isDesktop) const SizedBox(width: 280, child: AppDrawer()),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar:
          isDesktop ? null : AppBottomNav(currentIndex: navIndex),
    );
  }
}
