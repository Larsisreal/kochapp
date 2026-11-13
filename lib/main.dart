import 'package:kochapp/pages/login_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:kochapp/pages/recipe_list_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zktjbiqnguyevhnphwth.supabase.co',
    publishableKey: 'sb_publishable_ueLsdkSy2ZFljWDzMSiYvA_Uo8xtI-s',
  );

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
      home: supabase.auth.currentSession == null
            ? const LoginPage()
            : const RecipeListPage(),
    );
  }
}


final supabase = Supabase.instance.client;