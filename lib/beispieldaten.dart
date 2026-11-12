import 'models/rezept.dart';
import 'models/zutat.dart';
import 'models/schritt.dart';


final beispielRezept = Rezept(
  id: '1',
  name: 'Spaghetti Bolognese',
  basisPersonen: 4,
  zutaten: [
    Zutat(id: '1', name: 'Spaghetti', menge: 400, einheit: 'g'),
    Zutat(id: '2', name: 'Hackfleisch', menge: 500, einheit: 'g'),
    Zutat(id: '3', name: 'Zwiebel', menge: 1, einheit: null),
    Zutat(id: '4', name: 'Knoblauchzehe', menge: 2, einheit: null),
    Zutat(id: '5', name: 'Tomatenmark', menge: 2, einheit: 'EL'),
    Zutat(id: '6', name: 'Passierte Tomaten', menge: 400, einheit: 'ml'),
    Zutat(id: '7', name: 'Olivenöl', menge: 2, einheit: 'EL'),
    Zutat(id: '8', name: 'Salz', menge: null, einheit: null),
    Zutat(id: '9', name: 'Pfeffer', menge: null, einheit: null),
    Zutat(id: '10', name: 'Basilikum', menge: null, einheit: null),
  ],
  schritte:[
    Schritt(id: '1', name: 'Zwiebel und Knoblauch vorbereiten', beschreibung: 'Zwiebel und Knoblauch schälen und fein hacken.'),
    Schritt(id: '2', name: 'Hackfleisch anbraten', beschreibung: 'In einer großen Pfanne das Olivenöl erhitzen und das Hackfleisch darin anbraten, bis es braun ist.'),
    Schritt(id: '3', name: 'Zwiebel und Knoblauch hinzufügen', beschreibung: 'Die gehackte Zwiebel und den Knoblauch zum Hackfleisch geben und kurz mitbraten.'),
    Schritt(id: '4', name: 'Tomatenmark hinzufügen', beschreibung: 'Das Tomatenmark in die Pfanne geben und gut umrühren.'),
    Schritt(id: '5', name: 'Passierte Tomaten hinzufügen', beschreibung: 'Die passierten Tomaten in die Pfanne geben, gut umrühren und zum Kochen bringen.'),
    Schritt(id: '6', name: 'Würzen', beschreibung: 'Mit Salz, Pfeffer und Basilikum abschmecken. Die Sauce bei niedriger Hitze etwa 20 Minuten köcheln lassen.'),
    Schritt(id: '7', name: 'Spaghetti kochen', beschreibung: 'In der Zwischenzeit die Spaghetti nach Packungsanweisung in einem großen Topf mit Salzwasser kochen.'),
    Schritt(id: '8', name: 'Servieren', beschreibung: 'Die Spaghetti abgießen, auf Teller verteilen und die Bolognese-Sauce darüber geben. Mit frischem Basilikum garnieren und servieren.'),
  ],
);