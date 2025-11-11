import 'package:flutter/material.dart';
import '../../models/app_state.dart';
import '../../services/export_service.dart';

class ExportImport extends StatelessWidget {
  final void Function(String raw) onImport;
  const ExportImport({required this.onImport, super.key});

  @override
  Widget build(BuildContext context) {
    final exporter = ExportService();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // For demonstration, export and show in dialog
                // In a fuller app, you'd write file or share
                final raw = exporter.exportState(AppState.empty()); // placeholder; replace with provider state as needed
                showDialog(context: context, builder: (_) => AlertDialog(content: SingleChildScrollView(child: Text(raw))));
              },
              child: const Text('Export (JSON)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                // For now show a simple input dialog to paste JSON
                final result = await showDialog<String>(context: context, builder: (c) {
                  final ctrl = TextEditingController();
                  return AlertDialog(
                    title: const Text('Paste JSON to import'),
                    content: TextField(controller: ctrl, maxLines: 8),
                    actions: [TextButton(onPressed: () => Navigator.pop(c, null), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(c, ctrl.text), child: const Text('Import'))],
                  );
                });
                if (result != null && result.isNotEmpty) onImport(result);
              },
              child: const Text('Import (paste JSON)'),
            ),
          ],
        ),
      ),
    );
  }
}
