import 'zutat.dart';
import 'schritt.dart';

class Rezept {
  final String id;
  final String name;
  final int basisPersonen;
  final List<Zutat> zutaten;
  final List<Schritt> schritte;

  Rezept({
    required this.id,
    required this.name,
    required this.basisPersonen,
    required this.zutaten,
    required this.schritte,
  });

 factory Rezept.fromMap(Map<String, dynamic> map) {
  final zutatenMaps = List<Map<String, dynamic>>.from(map['zutaten']);
  zutatenMaps.sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));

  final schritteMaps = List<Map<String, dynamic>>.from(map['schritte']);
  schritteMaps.sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));

  return Rezept(
    id: map['id'] as String,
    name: map['name'] as String,
    basisPersonen: map['basis_personen'] as int,
    zutaten: zutatenMaps.map(Zutat.fromMap).toList(),
    schritte: schritteMaps.map(Schritt.fromMap).toList(),
  );
}


}