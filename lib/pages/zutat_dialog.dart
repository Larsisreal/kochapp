import 'package:material_ui/material_ui.dart';

import '../models/zutat.dart';

class ZutatDialog extends StatefulWidget {
  const ZutatDialog({super.key});

  @override
  State<ZutatDialog> createState() => _ZutatDialogState();
}

class _ZutatDialogState extends State<ZutatDialog> {
  final TextEditingController ingredientNameController =
      TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ingredientNameController.dispose();
    amountController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zutat hinzufügen'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: ingredientNameController,
                decoration: const InputDecoration(labelText: 'Zutat'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Bitte einen Namen eingeben.'
                    : null,
              ),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Menge'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final amount = num.tryParse(
                    value.trim().replaceAll(',', '.'),
                  );
                  return amount == null || amount <= 0
                      ? 'Bitte eine gültige Menge eingeben.'
                      : null;
                },
              ),
              TextFormField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Einheit'),
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

            final amountText = amountController.text.trim();
            Navigator.pop(
              context,
              Zutat(
                id: DateTime.now().microsecondsSinceEpoch.toString(),
                name: ingredientNameController.text.trim(),
                menge: amountText.isEmpty
                    ? null
                    : num.parse(amountText.replaceAll(',', '.')),
                einheit: unitController.text.trim().isEmpty
                    ? null
                    : unitController.text.trim(),
              ),
            );
          },
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }
}
