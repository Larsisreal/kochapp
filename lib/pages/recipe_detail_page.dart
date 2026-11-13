import 'package:material_ui/material_ui.dart';

import '../daten/cook_state_save.dart';
import '../logik/menge.dart';
import '../models/rezept.dart';
import 'shopping_list_page.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Rezept rezept;

  const RecipeDetailsPage({super.key, required this.rezept});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late int persons;
  Kochvorgang? vorhanden;

  @override
  void initState() {
    super.initState();
    persons = widget.rezept.basisPersonen;
    _loadKochvorgang();
  }

  Future<void> _loadKochvorgang() async {
    try {
      final k = await loadKochvorgang(widget.rezept.id);
      if (!mounted || k == null) return;
      setState(() {
        vorhanden = k;
        persons = k.personen;
      });
    } catch (error) {
      debugPrint('Kochfortschritt konnte nicht geladen werden: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.rezept.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: persons > 1 ? () => setState(() => persons--) : null,
              ),
              Text('$persons Personen'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => persons++),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Zutaten',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...widget.rezept.zutaten.map((zutat) {
            final menge = scale(
              zutat.menge,
              widget.rezept.basisPersonen,
              persons,
            );
            final angaben = format(menge, zutat.einheit);

            return ListTile(
              title: Text(zutat.name),
              subtitle: angaben.isEmpty ? null : Text(angaben),
            );
          }),
          const SizedBox(height: 16),
          const Text(
            'Zubereitung',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...widget.rezept.schritte.asMap().entries.map((eintrag) {
            final schritt = eintrag.value;

            return ListTile(
              leading: CircleAvatar(child: Text('${eintrag.key + 1}')),
              title: Text(schritt.name),
              subtitle: Text(schritt.beschreibung),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final k = Kochvorgang(
            personen: persons,
            abgehakt: vorhanden?.abgehakt ?? {},
            schritt: vorhanden?.schritt ?? 0,
          );
          try {
            await saveKochvorgang(widget.rezept.id, k);
          } catch (error) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Fehler: $error')));
            return;
          }
          if (!context.mounted) return;
          setState(() => vorhanden = k);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  ShoppingListPage(rezept: widget.rezept, kochvorgang: k),
            ),
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Einkaufsliste'),
      ),
    );
  }
}
