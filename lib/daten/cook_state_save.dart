import '../main.dart';

class Kochvorgang {
  final int personen;
  final Set<String> abgehakt;
  int schritt;

  Kochvorgang({
    required this.personen,
    required this.abgehakt,
    required this.schritt,
  });
}

Future<Kochvorgang?> loadKochvorgang(String rezeptId) async {
  final row = await supabase
      .from('kochvorgaenge')
      .select()
      .eq('rezept_id', rezeptId)
      .maybeSingle();

  if (row == null) return null;

  return Kochvorgang(
    personen: row['personen'] as int,
    abgehakt: Set<String>.from(row['abgehakte_zutaten'] as List),
    schritt: row['aktueller_schritt'] as int,
  );
}

Future<void> saveKochvorgang(String rezeptId, Kochvorgang k) async {
  await supabase.from('kochvorgaenge').upsert({
    'rezept_id': rezeptId,
    'personen': k.personen,
    'abgehakte_zutaten': k.abgehakt.toList(),
    'aktueller_schritt': k.schritt,
  }, onConflict: 'benutzer_id,rezept_id');
}

Future<void> deleteKochvorgang(String rezeptId) async {
  await supabase.from('kochvorgaenge').delete().eq('rezept_id', rezeptId);
}