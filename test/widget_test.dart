// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusmate/pages/login_page.dart';
import 'package:focusmate/providers/app_provider.dart';
import 'package:focusmate/services/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FocusMate login page renders', (WidgetTester tester) async {
    // Create test storage service
    final storageService = StorageService();
    
    // Test the login page directly without Firebase initialization
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(storageService: storageService),
        child: const MaterialApp(home: LoginPage()),
      ),
    );
    
    // Wait for the app to settle
    await tester.pumpAndSettle();
    
    // Verify login page renders
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
