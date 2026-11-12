import 'package:material_ui/material_ui.dart';
import '../beispieldaten.dart';
import 'recipe_detail_page.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rezepte = [beispielRezept];

    return Scaffold(
      appBar: AppBar(title: const Text('Meine Rezepte')),
      body: ListView.builder(
        itemCount: rezepte.length,
        itemBuilder: (context, index) {
          final rezept = rezepte[index];
          return ListTile(
            title: Text(rezept.name),
            subtitle: Text('für ${rezept.basisPersonen} Personen'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                builder: (_) => RecipeDetailsPage(rezept: rezept),
                ),
              );
            },
          );
        },
      ),
    );
  }
}