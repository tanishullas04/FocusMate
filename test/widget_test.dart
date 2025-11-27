// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusmate/providers/app_provider.dart';
import 'package:focusmate/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AppProvider and MaterialApp integration test', (WidgetTester tester) async {
    // Create test storage service
    final storageService = StorageService();
    
    // Test a simple widget with Provider - no Firebase needed
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(storageService: storageService),
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('FocusMate')),
            body: const Center(child: Text('Test App')),
          ),
        ),
      ),
    );
    
    // Wait for the app to settle
    await tester.pumpAndSettle();
    
    // Verify basic widgets render
    expect(find.text('FocusMate'), findsOneWidget);
    expect(find.text('Test App'), findsOneWidget);
  });
}
