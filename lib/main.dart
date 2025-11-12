import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/app_provider.dart';
import 'services/firebase_service.dart';
import 'services/storage_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize Firebase; if it fails, we'll fallback to local storage.
  FirebaseService? firebaseService;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseService = FirebaseService();
    print('Firebase initialized');
  } catch (e) {
    print('Firebase init failed, falling back to local storage: $e');
    firebaseService = null;
  }

  final storageService = StorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(
            firebaseService: firebaseService,
            storageService: storageService,
          ),
        ),
      ],
      child: const FocusMateApp(),
    ),
  );
}
