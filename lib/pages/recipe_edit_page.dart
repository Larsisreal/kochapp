import 'package:material_ui/material_ui.dart';

import '../logik/menge.dart';
import '../models/rezept.dart';
import '../models/schritt.dart';
import '../models/zutat.dart';
import 'schritt_dialog.dart';
import 'zutat_dialog.dart';

class RecipeEditPage extends StatefulWidget {
  final Rezept? rezept;
  const RecipeEditPage({super.key, this.rezept});

  @override
  State<RecipeEditPage> createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController personsController = TextEditingController(
    text: '4',
  );
  final List<Zutat> zutaten = [];
  final List<Schritt> schritte = [];

  Future<void> _addZutat() async {
    final zutat = await showDialog<Zutat>(
      context: context,
      builder: (_) => const ZutatDialog(),
    );

    if (zutat != null && mounted) {
      setState(() => zutaten.add(zutat));
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.rezept != null) {
      nameController.text = widget.rezept!.name;
      personsController.text = widget.rezept!.basisPersonen.toString();
      zutaten.addAll(widget.rezept!.zutaten);
      schritte.addAll(widget.rezept!.schritte);
    }
  }

  Future<void> _addSchritt() async {
    final schritt = await showDialog<Schritt>(
      context: context,
      builder: (_) => const SchrittDialog(),
    );

    if (schritt != null && mounted) {
      setState(() => schritte.add(schritt));
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
      id: widget.rezept?.id ?? DateTime.now().toString(),
      name: name,
      basisPersonen: persons,
      zutaten: List<Zutat>.of(zutaten),
      schritte: List<Schritt>.of(schritte),
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
      appBar: AppBar(
        title: Text(
          widget.rezept == null ? 'Neues Rezept' : 'Rezept bearbeiten',
        ),
      ),
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
            const Text(
              'Zubereitung',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...schritte.asMap().entries.map((entry) {
              final schritt = entry.value;
              return ListTile(
                leading: CircleAvatar(child: Text('${entry.key + 1}')),
                title: Text(schritt.name),
                subtitle: schritt.beschreibung.isEmpty
                    ? null
                    : Text(schritt.beschreibung),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => schritte.remove(schritt)),
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: _addSchritt,
              icon: const Icon(Icons.add),
              label: const Text('Schritt hinzufügen'),
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
