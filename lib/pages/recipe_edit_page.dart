import 'package:material_ui/material_ui.dart';
import '../models/rezept.dart';

class RecipeEditPage extends StatefulWidget {
  const RecipeEditPage({super.key});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController personsController = TextEditingController(text: '4');

  void saveRecipe(){
    final name = nameController.text.trim();
    final persons = int.tryParse(personsController.text.trim());

    if(name.isEmpty || persons == null || persons <= 0){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte gültige Eingaben machen.')),
      );
      return;
    }

    var newRecipe = Rezept(
      id: DateTime.now().toString(),
      name: name,
      basisPersonen: persons,
      zutaten: [],
      schritte:[],
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