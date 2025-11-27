// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusmate/app.dart';
import 'package:focusmate/providers/app_provider.dart';
import 'package:focusmate/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('FocusMate app smoke test', (WidgetTester tester) async {
    // Create test storage service
    final storageService = StorageService();
    
    // Wrap app with required Provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(storageService: storageService),
        child: const FocusMateApp(),
      ),
    );
    
    // Wait for the app to settle
    await tester.pumpAndSettle();
    
    // Basic test - verify app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
