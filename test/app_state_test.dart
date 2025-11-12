import 'package:flutter_test/flutter_test.dart';
import 'package:focusmate/models/app_state.dart';

void main() {
  test('AppState default is empty', () {
    final s = AppState.empty();
    expect(s.subjects.length, 0);
    expect(s.assignments.length, 0);
  });
}
