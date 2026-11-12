import 'package:material_ui/material_ui.dart';

import '../models/schritt.dart';

class SchrittDialog extends StatefulWidget {
  const SchrittDialog({super.key});

  @override
  State<SchrittDialog> createState() => _SchrittDialogState();
}

class _SchrittDialogState extends State<SchrittDialog> {
  final TextEditingController stepNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
