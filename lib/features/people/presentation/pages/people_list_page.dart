import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class PeopleListPage extends StatelessWidget {
  const PeopleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'People',
      navIndex: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
                'People module placeholder. Next step will fetch employees from Supabase.'),
          ),
        ),
      ),
    );
  }
}
