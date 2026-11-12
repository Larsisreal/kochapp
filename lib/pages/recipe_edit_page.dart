import 'package:material_ui/material_ui.dart';

import '../logik/menge.dart';
import '../models/rezept.dart';
import '../models/zutat.dart';
import 'zutat_dialog.dart';

class RecipeEditPage extends StatefulWidget {
  const RecipeEditPage({super.key});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController personsController = TextEditingController(
    text: '4',
  );
  final List<Zutat> zutaten = [];

  Future<void> _addZutat() async {
    final zutat = await showDialog<Zutat>(
      context: context,
      builder: (_) => const ZutatDialog(),
    );

    if (zutat != null && mounted) {
      setState(() => zutaten.add(zutat));
    }
  }

  void saveRecipe() {
    final name = nameController.text.trim();
    final persons = int.tryParse(personsController.text.trim());

    if (name.isEmpty || persons == null || persons <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gültige Eingaben machen.')),
      );
      return;
    }

    final newRecipe = Rezept(
      id: DateTime.now().toString(),
      name: name,
      basisPersonen: persons,
      zutaten: List<Zutat>.of(zutaten),
      schritte: [],
    );

    Navigator.pop(context, newRecipe);
  }

  @override
  void dispose() {
    nameController.dispose();
    personsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neues Rezept hinzufügen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Rezeptname'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: personsController,
              decoration: const InputDecoration(labelText: 'Anzahl Personen'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const Text(
              'Zutaten',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...zutaten.map((zutat) {
              final angaben = format(zutat.menge?.toDouble(), zutat.einheit);
              return ListTile(
                title: Text(zutat.name),
                subtitle: angaben.isEmpty ? null : Text(angaben),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => zutaten.remove(zutat)),
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: _addZutat,
              icon: const Icon(Icons.add),
              label: const Text('Zutat hinzufügen'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveRecipe,
              child: const Text('Rezept speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
