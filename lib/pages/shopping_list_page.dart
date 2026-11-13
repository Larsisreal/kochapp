import 'package:material_ui/material_ui.dart';

import '../daten/cook_state_save.dart';
import '../logik/menge.dart';
import '../models/rezept.dart';
import 'cooking_page.dart';

class ShoppingListPage extends StatefulWidget {
  final Rezept rezept;
  final Kochvorgang kochvorgang;

  const ShoppingListPage({
    super.key,
    required this.rezept,
    required this.kochvorgang,
  });

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  Future<void> _save() async {
    try {
      await saveKochvorgang(widget.rezept.id, widget.kochvorgang);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stand konnte nicht gespeichert werden: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final zutaten = widget.rezept.zutaten;

    return Scaffold(
      appBar: AppBar(title: const Text('Einkaufsliste')),
      body: ListView(
        children: [
          ...zutaten.map((zutat) {
            final angaben = format(
              scale(
                zutat.menge,
                widget.rezept.basisPersonen,
                widget.kochvorgang.personen,
              ),
              zutat.einheit,
            );
            final istAbgehakt = widget.kochvorgang.abgehakt.contains(
              zutat.name,
            );

            return CheckboxListTile(
              value: istAbgehakt,
              onChanged: (checked) {
                if (checked == null) return;
                setState(() {
                  if (checked) {
                    widget.kochvorgang.abgehakt.add(zutat.name);
                  } else {
                    widget.kochvorgang.abgehakt.remove(zutat.name);
                  }
                });
                _save();
              },
              title: Text(
                zutat.name,
                style: TextStyle(
                  decoration: istAbgehakt ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: angaben.isEmpty ? null : Text(angaben),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CookingPage(
                      rezept: widget.rezept,
                      kochvorgang: widget.kochvorgang,
                    ),
                  ),
                );
              },
              child: const Text('Weiter zum Kochen'),
            ),
          ),
        ],
      ),
    );
  }
}
