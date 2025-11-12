import 'dart:convert';
import '../models/app_state.dart';

class ExportService {
  String exportState(AppState s) {
    return jsonEncode(s.toJson());
  }

  AppState importState(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AppState.fromJson(json);
  }
}
