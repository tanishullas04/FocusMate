import 'package:flutter/material.dart';

class UserSettings {
  ThemeMode theme;
  int defaultReminderMinutes;
  int firstDayOfWeek; // 0 = Sunday, 1 = Monday

  UserSettings({
    this.theme = ThemeMode.light,
    this.defaultReminderMinutes = 60,
    this.firstDayOfWeek = 1,
  });

  factory UserSettings.fromJson(Map<String, dynamic> j) => UserSettings(
        theme: (j['theme'] == 'dark') ? ThemeMode.dark : ThemeMode.light,
        defaultReminderMinutes: j['defaultReminderMinutes'] ?? 60,
        firstDayOfWeek: j['firstDayOfWeek'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'theme': theme == ThemeMode.dark ? 'dark' : 'light',
        'defaultReminderMinutes': defaultReminderMinutes,
        'firstDayOfWeek': firstDayOfWeek,
      };
}
