import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/assignment.dart';
import '../../services/utils.dart';

class WeekView extends StatefulWidget {
  final List<Assignment> assignments;
  const WeekView({required this.assignments, super.key});

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Assignment> _getAssignmentsForDay(DateTime day) {
    return widget.assignments.where((a) {
      if (a.dueDate == null) return false;
      return isSameDay(a.dueDate!, day);
    }).toList();
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay ?? DateTime.now(), selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      final assignments = _getAssignmentsForDay(selectedDay);
      _showTasksDialog(selectedDay, assignments);
    }
  }

  void _showTasksDialog(DateTime day, List<Assignment> assignments) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tasks for ${formatDateOnly(day)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: assignments.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No tasks scheduled for this day',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          assignment.completed
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: assignment.completed
                              ? Colors.green
                              : _getPriorityColor(assignment.priority),
                        ),
                        title: Text(
                          assignment.title,
                          style: TextStyle(
                            decoration: assignment.completed
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (assignment.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  assignment.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    size: 14,
                                    color: _getPriorityColor(assignment.priority),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    assignment.priority.toUpperCase(),
                                    style: TextStyle(
                                      color: _getPriorityColor(assignment.priority),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: assignment.description.isNotEmpty,
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay ?? DateTime.now(), day),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 1,
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          eventLoader: _getAssignmentsForDay,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _buildSelectedDayTasks(),
        ),
      ],
    );
  }

  Widget _buildSelectedDayTasks() {
    final selectedDay = _selectedDay ?? DateTime.now();
    final assignments = _getAssignmentsForDay(selectedDay);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Tasks for ${formatDateOnly(selectedDay)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: assignments.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks for this day',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final assignment = assignments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            assignment.completed
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: assignment.completed
                                ? Colors.green
                                : _getPriorityColor(assignment.priority),
                          ),
                          title: Text(
                            assignment.title,
                            style: TextStyle(
                              decoration: assignment.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            assignment.priority.toUpperCase(),
                            style: TextStyle(
                              color: _getPriorityColor(assignment.priority),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
