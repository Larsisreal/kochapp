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
}