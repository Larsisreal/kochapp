// import 'package:supabase_flutter/supabase_flutter.dart';

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

 factory Zutat.fromMap(Map<String, dynamic> map) {
  return Zutat(
    id: map['id'] as String,
    name: map['name'] as String,
    menge: map['menge'] as num?,
    einheit: map['einheit'] as String?,
  );
}

}