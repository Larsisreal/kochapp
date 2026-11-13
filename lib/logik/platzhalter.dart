import 'package:flutter/widgets.dart';

import '../models/zutat.dart';
import 'menge.dart';

final _pattern = RegExp(r'\{([^{}:]+)(?::([0-9.,]+))?\}');

String _replacement(
  Match match,
  List<Zutat> zutaten,
  int basePersons,
  int persons,
) {
  final name = match.group(1)!.trim();
  final teilmenge = match.group(2);

  final treffer = zutaten.where(
    (z) => z.name.toLowerCase() == name.toLowerCase(),
  );
  if (treffer.isEmpty) {
    return match.group(0)!;
  }
  final zutat = treffer.first;

  final num? basis = teilmenge != null
      ? num.tryParse(teilmenge.replaceAll(',', '.'))
      : zutat.menge;

  final angaben = format(scale(basis, basePersons, persons), zutat.einheit);
  return angaben.isEmpty ? zutat.name : '$angaben ${zutat.name}';
}

String fillPlaceholders(
  String text,
  List<Zutat> zutaten,
  int basePersons,
  int persons,
) {
  return text.replaceAllMapped(
    _pattern,
    (match) => _replacement(match, zutaten, basePersons, persons),
  );
}

List<TextSpan> placeholderSpans(
  String text,
  List<Zutat> zutaten,
  int basePersons,
  int persons,
) {
  final spans = <TextSpan>[];
  var position = 0;

  for (final match in _pattern.allMatches(text)) {
    if (match.start > position) {
      spans.add(TextSpan(text: text.substring(position, match.start)));
    }
    spans.add(
      TextSpan(
        text: _replacement(match, zutaten, basePersons, persons),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    position = match.end;
  }

  if (position < text.length) {
    spans.add(TextSpan(text: text.substring(position)));
  }
  return spans;
}