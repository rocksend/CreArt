import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:creart/main.dart';

void main() {
  testWidgets('CreArt theme and artwork interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CreArtApp());

    expect(find.text('Karya bertemu cerita.'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);

    final loginButton = find.widgetWithText(ElevatedButton, 'Masuk');
    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Halo, Ardi.'), findsOneWidget);
    await tester.tap(find.byType(ChoiceChip).at(2));
    await tester.pumpAndSettle();
    expect(tester.widget<ChoiceChip>(find.byType(ChoiceChip).at(2)).selected, isTrue);

    await tester.tap(find.text('Ruang Sunyi'));
    await tester.pumpAndSettle();
    expect(find.text('24 apresiasi'), findsOneWidget);

    await tester.tap(find.text('24 apresiasi'));
    await tester.pumpAndSettle();
    expect(find.text('25 apresiasi'), findsOneWidget);

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Tersimpan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koleksi tersimpan (8)'));
    await tester.pumpAndSettle();
    expect(find.text('Ruang Sunyi'), findsOneWidget);
  });
}
