import 'package:flutter/material.dart';

class ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Dark theme'),
      value: false,
      onChanged: (_) {},
    );
  }
}
