import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/documents_provider.dart';

class DocumentsHomePage extends ConsumerWidget {
  const DocumentsHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(documentsProvider);

    return AppScaffold(
      title: 'Documents',
      navIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: docsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
          data: (docs) {
            if (docs.isEmpty) {
              return const Center(child: Text("No documents uploaded yet"));
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final d = docs[i];
                return Card(
                  child: ListTile(
                    title: Text(d['title']),
                    subtitle: Text(d['category'] ?? 'General'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
