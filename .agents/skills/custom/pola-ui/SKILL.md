---
name: pola-ui
description: "Trigger: saat menerapkan pola UI Flutter | Indeks: visualisasi-progres-impian, isolasi-widget-timer, withvalues-opacity-warna, normalisasi-tanggal, widget-custom. Prinsip single responsibility dan textTheme + copyWith."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Indeks Pola UI Standar

Skill ini berfungsi sebagai indeks/ringkasan yang merujuk ke skill spesifik untuk setiap pola UI. Jangan menduplikasi isi skill spesifik di sini. Semua pola UI yang tercantum di bawah ini sudah terimplementasi di proyek Flutter dan dapat digunakan sebagai referensi untuk pola serupa di proyek lain.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `StatelessWidget`, `StatefulWidget`, `Timer`, `Column`, `Row`, `Card`, `LinearProgressIndicator`, `Stack`, `Icon`, `Text`, `Chip`, `ColorScheme`, `ThemeData`)
- Class: `ImpianProgresHelper`, `VisualTabunganImpian`, `_TimerCravingView`, `_HeaderPemulihan`, `DateTime`, `FormatUang`
- Properti: `spacing`, `padding`, `rasio`, `saldo`, `target`, `mounted`
- Method: `ImpianProgresHelper.rasio()`, `ImpianProgresHelper.tercapai()`, `ImpianProgresHelper.sisa()`, `Timer.periodic()`, `Timer.cancel()`, `DateTime.normalize()`

## Aturan

1. Setiap widget UI handle 1 hal saja (single responsibility: timer, progres, empty, error, atau loading).
2. Timer wajib diisolasi ke widget kecil sendiri, bukan di widget halaman penuh.
3. Logika bisnis (hitung rasio, cek tercapai, normalisasi tanggal) wajib di helper/provider, widget hanya render.
4. Wajib menggunakan `textTheme + copyWith` untuk styling konsisten melalui tema.
5. Wajib menggunakan `Column.spacing` untuk jarak konsisten tanpa `SizedBox` berulang.
6. Empty/Error/Loading state wajib dibungkus `SafeArea` + padding tepi layar.
7. Navigasi non-blocking wajib menggunakan `unawaited()` dengan `.catchError()`.
8. Wajib cek `mounted` di callback timer sebelum update state.
9. Wajib panggil `timer.cancel()` di `dispose()` untuk mencegah memory leak.
10. Rasio progres wajib di-clamp ke 0.0–1.0 sebelum dipakai di `LinearProgressIndicator`.

## Larangan

- DILARANG `withOpacity()` → gunakan `withValues(alpha:)` (lihat `withvalues-opacity-warna` / `gaya`).
- DILARANG timer di widget halaman penuh → isolasi ke widget kecil (lihat `isolasi-widget-timer`).
- DILARANG lupa `cancel()` di `dispose()` untuk timer (lihat `isolasi-widget-timer`).
- DILARANG lupa cek `mounted` di callback timer (lihat `isolasi-widget-timer`).
- DILARANG aset gambar/Lottie untuk visual progres → gunakan `Stack` + `LinearProgressIndicator` + `Icon` (lihat `visualisasi-progres-impian` / `widget-custom`).
- DILARANG rasio progres tanpa clamp → `LinearProgressIndicator` error jika > 1.0 (lihat `visualisasi-progres-impian`).
- DILARANG perbandingan tanggal tanpa normalisasi → hasil bisa salah 1 hari (lihat `normalisasi-tanggal`).

## Contoh Benar

```dart
// Timer terisolasi di widget kecil (StatefulWidget terpisah)
class _TimerCravingView extends StatefulWidget {
  const _TimerCravingView({super.key});

  @override
  State<_TimerCravingView> createState() => _TimerCravingViewState();
}

class _TimerCravingViewState extends State<_TimerCravingView> {
  Timer? _timer;
  int _detik = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _detik++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Wajib cancel di dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('${_detik ~/ 60}:${_detik % 60}');
  }
}
```

## Contoh Salah

```dart
// DILARANG: Timer di widget halaman penuh (harus diisolasi)
class HalamanPenuh extends StatefulWidget {
  @override
  State<HalamanPenuh> createState() => _HalamanPenuhState();
}

class _HalamanPenuhState extends State<HalamanPenuh> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {}); // Timer di halaman penuh - SALAH!
    });
  }

  @override
  void dispose() {
    // Lupa cancel() - SALAH!
    super.dispose();
  }
}

// DILARANG: Lupa cek mounted di callback timer
Timer.periodic(const Duration(seconds: 1), (_) {
  setState(() {}); // SALAH! Tidak ada cek mounted
});

// DILARANG: withOpacity deprecated
warna.withOpacity(0.2) // SALAH! Gunakan withValues(alpha:)
```

## Sumber Evaluasi

- File: `lib/fitur/impian/widget/visual_tabungan_impian.dart`, `lib/fitur/sos_craving/screens/sos_craving_screen.dart`, `lib/fitur/kalender_smokefree/screens/kalender_smokefree_screen.dart`
- Class terkait: `ImpianProgresHelper`, `VisualTabunganImpian`, `_TimerCravingView`, `_HeaderPemulihan`, `Timer`, `DateTime`
- Commit rujukan: `c7337d1` — `ImpianProgresHelper`, `VisualTabunganImpian`, `DetailImpianScreen`; `3b67d309` — `_TimerCravingView` di `SosCravingScreen`, `warna.withValues(alpha: 0.2)`; `02aa6b29` — `_HeaderPemulihan` di `PemulihanKesehatanScreen`; `6fd979fd` — `_SelHari`, `_GridKalender` di `KalenderSmokeFreeScreen`
