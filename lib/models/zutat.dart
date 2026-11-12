class Zutat {
  final String id;
  final String name;
  final num? menge;
  final String? einheit;

  Zutat({
    required this.id,
    required this.name,
    this.menge,
    this.einheit,
  });
}