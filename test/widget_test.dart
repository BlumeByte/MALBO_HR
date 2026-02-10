import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:malbo_hr/app.dart';

void main() {
  testWidgets('MALBO HR app builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MalboHRApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
