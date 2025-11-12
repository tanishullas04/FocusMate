import 'package:flutter/material.dart';
import '../../models/assignment.dart';
import '../../models/subject.dart';

class AssignmentForm extends StatefulWidget {
  final List<Subject> subjects;
  final void Function(Assignment) onSave;

  const AssignmentForm({required this.subjects, required this.onSave, super.key});

  @override
  State<AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime? _dueDate;
  String? _subjectId;
  String _priority = 'medium';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      value: _subjectId,
                      items: [const DropdownMenuItem<String?>(value: null, child: Text('No subject'))] +
                          widget.subjects.map((s) => DropdownMenuItem<String?>(value: s.id, child: Text(s.name))).toList(),
                      onChanged: (v) => setState(() => _subjectId = v),
                      decoration: const InputDecoration(labelText: 'Subject'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
                      if (picked != null) setState(() => _dueDate = picked);
                    },
                    child: const Text('Pick Due Date'),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Priority: '),
                  Radio<String>(value: 'low', groupValue: _priority, onChanged: (v) => setState(() => _priority = v!)),
                  const Text('Low'),
                  Radio<String>(value: 'medium', groupValue: _priority, onChanged: (v) => setState(() => _priority = v!)),
                  const Text('Med'),
                  Radio<String>(value: 'high', groupValue: _priority, onChanged: (v) => setState(() => _priority = v!)),
                  const Text('High'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  final a = Assignment(title: _title.text, subjectId: _subjectId, dueDate: _dueDate, priority: _priority, description: _desc.text);
                  widget.onSave(a);
                  _title.clear();
                  _desc.clear();
                  setState(() {
                    _dueDate = null;
                    _subjectId = null;
                    _priority = 'medium';
                  });
                },
                child: const Text('Add Assignment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
