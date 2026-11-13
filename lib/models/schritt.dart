class Schritt {
  final String id;
  final String name;
  final String beschreibung;


  Schritt({
    required this.id,
    required this.name,
    required this.beschreibung,
  });

  factory Schritt.fromMap(Map<String, dynamic> map) {
    return Schritt(
      id: map['id'] as String,
      name: map['name'] as String,
      beschreibung: map['beschreibung'] as String,
    );
  }

}