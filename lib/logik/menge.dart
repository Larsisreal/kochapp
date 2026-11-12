



double? scale(num? amount, int basePersons, int newPersons) {
  if (newPersons <= 0 || basePersons <= 0) {
    throw ArgumentError('Die Anzahl der Personen muss größer als 0 sein.');
  }

  if (amount == null) {
    return null;
    
  }

  return (amount * newPersons) / basePersons;
}


String format(double? amount, String? unit) {
  if (amount == null) {
    return '';
  }

  // Schritt 1: runden, je nach Einheit
  double rounded;
  if (unit == 'g' || unit == 'ml') {
    rounded = amount.roundToDouble();
  } else if (unit == 'kg' || unit == 'l') {
    rounded = double.parse(amount.toStringAsFixed(2));
  } else {
    rounded = (amount * 2).round() / 2;   // halbe Schritte
  }

  // Schritt 2: Zahl in Text umwandeln
  String text;
  if (rounded == rounded.roundToDouble()) {
    text = rounded.toInt().toString();      // ganze Zahl ohne ".0"
  } else {
    text = rounded.toString().replaceFirst('.', ',');      // mit Komma statt Punkt
  }

  // Schritt 3: Einheit anhängen, falls vorhanden
  return unit != null && unit.isNotEmpty ? '$text $unit' : text;
}