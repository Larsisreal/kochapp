import 'package:material_ui/material_ui.dart';

class RecipeEditPage extends StatefulWidget {
  const RecipeEditPage({super.key});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController personsController = TextEditingController(text: '4');

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
            ElevatedButton(
              onPressed: () {},
              child: const Text('Rezept speichern'),
            ),
          ],
        ),
      ),
    );
  }
}