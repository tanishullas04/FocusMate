import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/app_provider.dart';
import 'pages/dashboard_page.dart';
import 'pages/subjects_page.dart';
import 'pages/assignments_page.dart';
import 'pages/calendar_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'routes.dart';

class FocusMateApp extends StatelessWidget {
  const FocusMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    return MaterialApp(
      title: 'FocusMate',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: provider.state.settings.theme == ThemeMode.light ? ThemeMode.light : ThemeMode.dark,
      home: const AuthWrapper(),
      routes: {
        Routes.login: (c) => const LoginPage(),
        Routes.register: (c) => const RegisterPage(),
        Routes.subjects: (c) => const SubjectsPage(),
        Routes.assignments: (c) => const AssignmentsPage(),
        Routes.calendar: (c) => const CalendarPage(),
        Routes.profile: (c) => const ProfilePage(),
      },
    );
  }
}

// Auth wrapper to handle authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // If user is logged in, show dashboard
          if (snapshot.hasData) {
            // Ensure provider reloads state from Firebase when auth becomes available
            // so that user-specific Firestore data (users/{uid}/...) is fetched.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final provider = Provider.of<AppProvider>(context, listen: false);
              provider.load();
            });

            return const DashboardPage();
          }
        
        // Otherwise show login page
        return const LoginPage();
      },
    );
  }
}
