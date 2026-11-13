// Widget test untuk fitur Tes Diagnostik: grid kartu tampil di tab Dashboard,
// navigasi ke layar grid berjalan, dan layar ringkasan tampil.
//
// Plugin audio/senter/mikrofon tidak tersedia di VM test; layar grid tidak
// memanggil plugin saat dirender — hanya layar tes tertentu yang
// membutuhkannya, dan tidak dibuka di sini. Override notifier statistik
// dipakai karena IndexedStack membangun seluruh tab sejak frame pertama.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spektra/app.dart';
import 'package:spektra/fitur/statistik/model/baterai_info.dart';
import 'package:spektra/fitur/statistik/model/memori_info.dart';
import 'package:spektra/fitur/statistik/notifier/baterai_notifier.dart';
import 'package:spektra/fitur/statistik/notifier/memori_notifier.dart';

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

class _MemoriNotifierPalsu extends MemoriNotifier {
  @override
  Future<MemoriInfo?> build() async {
    return const MemoriInfo(
      ramTotalMb: 6144,
      ramTersediaMb: 2048,
      ramTerpakaiMb: 4096,
      perangkatRamRendah: false,
      penyimpananTotalByte: 128000000000,
      penyimpananBebasByte: 64000000000,
      penyimpananTerpakaiByte: 64000000000,
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'Tab Dashboard memuat kartu Tes Diagnostik dan navigasi ke grid',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bateraiProvider.overrideWith(_BateraiNotifierPalsu.new),
            memoriProvider.overrideWith(_MemoriNotifierPalsu.new),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Kartu entry point ada di tab Dashboard.
      expect(find.text('Tes Diagnostik'), findsOneWidget);

      await tester.tap(find.text('Tes Diagnostik'));
      await tester.pumpAndSettle();

      // Layar grid diagnostik tampil.
      expect(find.text('Diagnostik Perangkat'), findsOneWidget);
      expect(find.text('Warna Layar'), findsOneWidget);
      expect(find.text('Dead Pixel'), findsOneWidget);
      expect(find.text('Multi-Touch'), findsOneWidget);
      expect(find.text('Kecerahan'), findsOneWidget);
      expect(find.text('Getar'), findsOneWidget);
      expect(find.text('Audio Speaker'), findsOneWidget);
      expect(find.text('Audio Mikrofon'), findsOneWidget);
      expect(find.text('Senter'), findsOneWidget);
      expect(find.text('Tombol Volume'), findsOneWidget);

      // Buka ringkasan; belum ada tes yang dijalankan.
      await tester.tap(find.text('Ringkasan'));
      await tester.pumpAndSettle();

      expect(find.text('Ringkasan Hasil'), findsOneWidget);
      expect(find.text('0 lulus / 0 gagal / 0 tidak tersedia'), findsOneWidget);
    },
  );
}
