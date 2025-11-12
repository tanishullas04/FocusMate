import 'package:flutter/material.dart';
import '../../models/user_settings.dart';

class ProfileForm extends StatefulWidget {
  final UserSettings settings;
  final void Function(UserSettings) onSave;
  const ProfileForm({required this.settings, required this.onSave, super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.settings.theme == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SwitchListTile(
          title: const Text('Dark Theme'),
          value: _isDark,
          onChanged: (v) {
            setState(() => _isDark = v);
            // Apply theme immediately
            final s = UserSettings(
              theme: v ? ThemeMode.dark : ThemeMode.light,
              defaultReminderMinutes: widget.settings.defaultReminderMinutes,
              firstDayOfWeek: widget.settings.firstDayOfWeek,
            );
            widget.onSave(s);
          },
        ),
      ),
    );
  }
}
