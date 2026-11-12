import 'package:material_ui/material_ui.dart';
import 'package:kochapp/pages/recipe_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kochapp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
),
      home: const RecipeListPage(),
    );
  }
}
