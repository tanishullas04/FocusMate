import 'package:flutter/material.dart';
import '../../models/subject.dart';

class SubjectForm extends StatefulWidget {
  final void Function(Subject) onSave;
  const SubjectForm({required this.onSave, super.key});

  @override
  State<SubjectForm> createState() => _SubjectFormState();
}

class _SubjectFormState extends State<SubjectForm> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _creditsCtrl = TextEditingController(text: '0');
  String _color = '#2196F3';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Subject', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              TextFormField(controller: _creditsCtrl, decoration: const InputDecoration(labelText: 'Credits'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Color: '),
                  GestureDetector(
                    onTap: () async {
                      // basic cycle color
                      setState(() {
                        _color = _color == '#2196F3' ? '#4CAF50' : '#2196F3';
                      });
                    },
                    child: CircleAvatar(backgroundColor: Color(int.parse(_color.replaceFirst('#', '0xff')))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  final s = Subject(name: _nameCtrl.text, color: _color, credits: int.tryParse(_creditsCtrl.text) ?? 0);
                  widget.onSave(s);
                  _nameCtrl.clear();
                  _creditsCtrl.text = '0';
                },
                child: const Text('Save Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
