import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '/logik/platzhalter.dart';

import '../daten/cook_state_save.dart';
import '../models/rezept.dart';

class CookingPage extends StatefulWidget {
  final Rezept rezept;
  final Kochvorgang kochvorgang;

  const CookingPage({
    super.key,
    required this.rezept,
    required this.kochvorgang,
  });

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  late final PageController _pageController;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    final letzter = widget.rezept.schritte.length - 1;
    currentPage = letzter < 0
        ? 0
        : widget.kochvorgang.schritt.clamp(0, letzter).toInt();
    _pageController = PageController(initialPage: currentPage);
  }

  Future<void> _saveStep(int index) async {
    widget.kochvorgang.schritt = index;
    try {
      await saveKochvorgang(widget.rezept.id, widget.kochvorgang);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stand konnte nicht gespeichert werden: $error'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schritte = widget.rezept.schritte;
    final isLastPage = currentPage == schritte.length - 1;

    return Scaffold(
      appBar: AppBar(title: Text(widget.rezept.name)),
      body: schritte.isEmpty
          ? const Center(
              child: Text('Noch keine Zubereitungsschritte vorhanden.'),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Schritt ${currentPage + 1} von ${schritte.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: schritte.length,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                      unawaited(_saveStep(index));
                    },
                    itemBuilder: (context, index) {
                      final schritt = schritte[index];
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schritt.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text.rich(
                              TextSpan(
                                style: const TextStyle(fontSize: 18),
                                children: placeholderSpans(
                                  schritt.beschreibung,
                                  widget.rezept.zutaten,
                                  widget.rezept.basisPersonen,
                                  widget.kochvorgang.personen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: currentPage == 0
                            ? null
                            : () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                );
                              },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Zurück'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (isLastPage) {
                            try {
                              await deleteKochvorgang(widget.rezept.id);
                            } catch (error) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Kochfortschritt konnte nicht gelöscht werden: $error',
                                  ),
                                ),
                              );
                              return;
                            }
                            if (!context.mounted) return;
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        icon: Icon(
                          isLastPage ? Icons.check : Icons.arrow_forward,
                        ),
                        label: Text(isLastPage ? 'Fertig' : 'Weiter'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
