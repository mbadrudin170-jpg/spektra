// Basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spektra/app.dart';
import 'package:spektra/fitur/statistik/model/baterai_info.dart';
import 'package:spektra/fitur/statistik/notifier/baterai_notifier.dart';

// Notifier baterai palsu untuk lingkungan test (plugin tidak tersedia).
class _BateraiNotifierPalsu extends BateraiNotifier {
  @override
  Future<BateraiInfo?> build() async {
    return const BateraiInfo(
      kapasitasTersisaMah: 4500,
      levelPersen: 80,
      statusPengisian: 'charging',
      sumberCharger: 'USB',
      kesehatan: 'health_good',
      suhuCelcius: 30,
      teganganMv: 3800,
      teknologi: 'Li-ion',
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Plugin baterai tidak tersedia pada VM test; gunakan notifier palsu agar
    // section statistik tidak menggantung pada panggilan platform channel.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [bateraiProvider.overrideWith(_BateraiNotifierPalsu.new)],
        child: const MyApp(),
      ),
    );

    // Tunggu pemuatan mode tema dari SharedPreferences selesai.
    await tester.pumpAndSettle();

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
