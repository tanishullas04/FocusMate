import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final DateTime date;
  DayCell({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text('${date.day}'),
    );
  }
}
