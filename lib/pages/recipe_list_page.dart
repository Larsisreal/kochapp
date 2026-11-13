import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '/main.dart';
import '../models/rezept.dart';
import 'recipe_detail_page.dart';
import 'recipe_edit_page.dart';
import '/daten/recipe_save.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final List<Rezept> rezepte = [];
  bool loading = true;
  Timer? _refreshTimer;


  @override
  void initState() {
    super.initState();
    _refreshRecipes();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _refreshRecipes(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _newRecipe() async {
    final neu = await Navigator.of (context).push<Rezept>(
      MaterialPageRoute(builder: (_) => const RecipeEditPage()),
    );
    if (neu == null) return;

    try {
      await insertRecipe(neu);
      await _loadRecipes();
    } catch (error) {
      showError(error);
    }
  }

  void showError(Object error){
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fehler: $error'),)
    );
  }


  Future<void> _refreshRecipes() async {
    try {
      await _loadRecipes();
    } catch (error) {
      showError(error);
      if (mounted && loading) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _loadRecipes() async {
    final data = await supabase
        .from('rezepte')
        .select('*, zutaten(*), schritte(*)')
        .order('name');

      if (!mounted) return;
      setState(() {
        rezepte.clear();
        rezepte.addAll(data.map(Rezept.fromMap));
        loading = false;
      });
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

Future<void> _deleteRecipe(int index) async {
  try{
    await deleteRecipe(rezepte[index].id);
    setState(() {
      rezepte.removeAt(index);
    });
  } catch (error) {
    showError(error);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meine Rezepte')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
