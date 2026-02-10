import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Reports',
      navIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Reports placeholder. Next step will run headcount and leave summary queries.'),
          ),
        ),
      ),
    );
  }
}
