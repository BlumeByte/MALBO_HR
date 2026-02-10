import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class LeaveHomePage extends StatelessWidget {
  const LeaveHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Leave',
      navIndex: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
                'Leave module placeholder. Next step will show balances, requests, approvals.'),
          ),
        ),
      ),
    );
  }
}
