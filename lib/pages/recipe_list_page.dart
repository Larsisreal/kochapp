import 'package:material_ui/material_ui.dart';

import '../beispieldaten.dart';
import '../models/rezept.dart';
import 'recipe_detail_page.dart';
import 'recipe_edit_page.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final List<Rezept> rezepte = [beispielRezept];

  Future<void> _newRecipe() async {
    final newRecipe = await Navigator.of(
      context,
    ).push<Rezept>(MaterialPageRoute(builder: (_) => const RecipeEditPage()));
    if (newRecipe != null) {
      setState(() {
        rezepte.add(newRecipe);
      });
    }
  }

  Future<void> _editRecipe(int index) async {
    final updatedRecipe = await Navigator.of(context).push<Rezept>(
      MaterialPageRoute(builder: (_) => RecipeEditPage(rezept: rezepte[index])),
    );
    if (updatedRecipe != null) {
      setState(() {
        rezepte[index] = updatedRecipe;
      });
    }
  }

  void _deleteRecipe(int index) {
    setState(() {
      rezepte.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Rezepte')),
      body: ListView.builder(
        itemCount: rezepte.length,
        itemBuilder: (context, index) {
          final rezept = rezepte[index];
          return ListTile(
            title: Text(rezept.name),
            subtitle: Text('für ${rezept.basisPersonen} Personen'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editRecipe(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteRecipe(index),
                ),
              ],
            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _newRecipe,
        child: const Icon(Icons.add),
      ),
    );
  }
}
