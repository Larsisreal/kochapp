import '../main.dart';
import '../models/rezept.dart';

Future<void> insertRecipe(Rezept rezept) async {
  final row = await supabase
      .from('rezepte')
      .insert({'name': rezept.name, 'basis_personen': rezept.basisPersonen})
      .select()
      .single();

  await _insertChildren(row['id'] as String, rezept);
}

Future<void> updateRecipe(Rezept rezept) async {
  await supabase
      .from('rezepte')
      .update({'name': rezept.name, 'basis_personen': rezept.basisPersonen})
      .eq('id', rezept.id);

  await supabase.from('zutaten').delete().eq('rezept_id', rezept.id);
  await supabase.from('schritte').delete().eq('rezept_id', rezept.id);

  await _insertChildren(rezept.id, rezept);
}

Future<void> deleteRecipe(String id) async {
  await supabase.from('rezepte').delete().eq('id', id);
}

Future<void> _insertChildren(String rezeptId, Rezept rezept) async {
  if (rezept.zutaten.isNotEmpty) {
    await supabase.from('zutaten').insert([
      for (var i = 0; i < rezept.zutaten.length; i++)
        {
          'rezept_id': rezeptId,
          'position': i,
          'name': rezept.zutaten[i].name,
          'menge': rezept.zutaten[i].menge,
          'einheit': rezept.zutaten[i].einheit,
        },
    ]);
  }

  if (rezept.schritte.isNotEmpty) {
    await supabase.from('schritte').insert([
      for (var i = 0; i < rezept.schritte.length; i++)
        {
          'rezept_id': rezeptId,
          'position': i,
          'name': rezept.schritte[i].name,
          'beschreibung': rezept.schritte[i].beschreibung,
        },
    ]);
  }
}