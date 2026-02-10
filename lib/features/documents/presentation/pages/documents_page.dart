import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Documents',
      navIndex: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
                'Documents module placeholder. Next step will list and upload via Supabase Storage.'),
          ),
        ),
      ),
    );
  }
}
