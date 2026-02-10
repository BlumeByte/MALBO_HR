import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class MalboHRApp extends StatelessWidget {
  const MalboHRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MALBO HR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 600, name: MOBILE),
          Breakpoint(start: 601, end: 1024, name: TABLET),
          Breakpoint(start: 1025, end: double.infinity, name: DESKTOP),
        ],
      ),
    );
  }
}
