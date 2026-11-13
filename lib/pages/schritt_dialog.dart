import 'package:material_ui/material_ui.dart';

import '../models/schritt.dart';
import '../models/zutat.dart';

class SchrittDialog extends StatefulWidget {
  final List<Zutat> zutaten;

  const SchrittDialog({super.key, required this.zutaten});

  @override
  State<SchrittDialog> createState() => _SchrittDialogState();
}

class _SchrittDialogState extends State<SchrittDialog> {
  final TextEditingController stepNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _insertPlaceholder(String name) {
    final text = descriptionController.text;
    final selection = descriptionController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final placeholder = '{$name}';

    descriptionController.value = TextEditingValue(
      text: text.replaceRange(start, end, placeholder),
      selection: TextSelection.collapsed(offset: start + placeholder.length),
    );
  }

  @override
  void dispose() {
    stepNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Schritt hinzufügen'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: stepNameController,
                decoration: const InputDecoration(labelText: 'Schritt'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Bitte einen Namen eingeben.'
                    : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Beschreibung'),
                maxLines: 3,
              ),
              PopupMenuButton<Zutat>(
                enabled: widget.zutaten.isNotEmpty,
                onSelected: (zutat) => _insertPlaceholder(zutat.name),
                itemBuilder: (context) => [
                  for (final zutat in widget.zutaten)
                    PopupMenuItem(value: zutat, child: Text(zutat.name)),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Zutat einfügen'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),

        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            Navigator.pop(
              context,
              Schritt(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                name: stepNameController.text.trim(),
                beschreibung: descriptionController.text.trim(),
              ),
            );
          },
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }
}
