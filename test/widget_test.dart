// Basic smoke test for VogueEarth Boutique Catalogue

import 'package:flutter_test/flutter_test.dart';

import 'package:boutique_catalogue/main.dart';

void main() {
  testWidgets('App loads and shows VogueEarth branding', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BoutiqueCatalogueApp());

    // Verify that the VogueEarth brand name appears on the home screen.
    expect(find.text('VogueEarth'), findsOneWidget);
  });
}
