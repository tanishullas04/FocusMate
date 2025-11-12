import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subject.dart';
import '../models/assignment.dart';
import '../models/user_settings.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID from Firebase Auth
  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _subjectsRef() {
    if (_userId == null) throw Exception('User not authenticated');
    return _firestore.collection('users').doc(_userId).collection('subjects');
  }

  CollectionReference<Map<String, dynamic>> _assignmentsRef() {
    if (_userId == null) throw Exception('User not authenticated');
    return _firestore.collection('users').doc(_userId).collection('assignments');
  }

  DocumentReference<Map<String, dynamic>> _settingsDoc() {
    if (_userId == null) throw Exception('User not authenticated');
    return _firestore.collection('users').doc(_userId).collection('settings').doc('user_settings');
  }

  // ===== Subject methods =====
  Future<List<Subject>> getSubjects() async {
    final snapshot = await _subjectsRef().get();
    return snapshot.docs.map((d) => Subject.fromJson(d.data())).toList();
  }

  Future<void> addOrUpdateSubject(Subject s) async {
    await _subjectsRef().doc(s.id).set(s.toJson());
  }

  Future<void> deleteSubject(String id) async {
    await _subjectsRef().doc(id).delete();
  }

  // ===== Assignment methods =====
  Future<List<Assignment>> getAssignments() async {
    final snapshot = await _assignmentsRef().get();
    return snapshot.docs.map((d) => Assignment.fromJson(d.data())).toList();
  }

  Future<void> addOrUpdateAssignment(Assignment a) async {
    await _assignmentsRef().doc(a.id).set(a.toJson());
  }

  Future<void> deleteAssignment(String id) async {
    await _assignmentsRef().doc(id).delete();
  }

  // ===== Settings methods =====
  Future<UserSettings?> getSettings() async {
    final doc = await _settingsDoc().get();
    if (!doc.exists) return null;
    return UserSettings.fromJson(doc.data()!);
  }

  Future<void> saveSettings(UserSettings s) async {
    await _settingsDoc().set(s.toJson());
  }
}
