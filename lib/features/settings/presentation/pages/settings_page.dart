import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Settings',
      navIndex: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
                'Settings placeholder. Next step will manage departments, job titles, leave types, holidays.'),
          ),
        ),
      ),
    );
  }
}
