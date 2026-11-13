---
name: widget-custom
description: "Trigger: saat membuat widget custom reusable | Indeks: visualisasi-progres-impian, isolasi-widget-timer, empty-state-daftar. Wajib StatelessWidget, pure, aman tema (ColorScheme), Column.spacing."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Indeks Widget Custom Reusable

Skill ini berfungsi sebagai indeks/ringkasan yang merujuk ke skill spesifik untuk setiap widget custom. Jangan menduplikasi isi skill spesifik di sini. Widget custom yang dicantumkan di bawah ini adalah komponen reusable yang sudah teruji di proyek Flutter.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `StatelessWidget`, `Card`, `Column`, `Row`, `Stack`, `FractionallySizedBox`, `SizedBox`, `Padding`, `SafeArea`, `CircularProgressIndicator`, `FilledButton`, `Icon`, `Text`, `Chip`, `LinearProgressIndicator`)
- Class: `VisualTabunganImpian`, `EmptyStateView`, `TimerCravingView` (dan `Napas478View`, `Napas90DetikView`, `BoxBreathingView`, `Grounding54321View`, `UrgeSurfingView`, `DistraksiView`), `_HeaderPemulihan`, `ImpianProgresHelper`
- Properti: `rasio`, `saldo`, `target`, `spacing`, `padding`, `onRetry`
- Method: `ImpianProgresHelper.rasio()`, `ImpianProgresHelper.tercapai()`, `ImpianProgresHelper.sisa()`, `ref.refresh()`

## Aturan

1. Setiap widget custom wajib `StatelessWidget` (tidak butuh state internal kecuali timer yang diisolasi ke widget terpisah).
2. Widget custom harus pure — logika bisnis (hitung rasio, cek tercapai) dilakukan di helper/provider, bukan di widget.
3. Wajib menggunakan `Theme.of(context).colorScheme` untuk warna UI, bukan hardcode (kecuali status semantic yang harus sama di light/dark).
4. Wajib menggunakan `Column.spacing` atau `Row.spacing` untuk jarak antar anak, bukan `SizedBox` berulang.
5. Widget reusable dilarang mengambil tanggung jawab padding tepi layar (kecuali empty/error/loading yang dipakai langsung di `Scaffold.body`).
6. Timer wajib diisolasi ke widget kecil sendiri, dengan `cancel()` di `dispose()` dan cek `mounted` di callback.
7. Tidak boleh menggunakan aset gambar/Lottie untuk visual progres — gunakan `Stack` + `LinearProgressIndicator`/`FractionallySizedBox` + `Icon` bawaan Flutter.
8. Rasio progres wajib di-clamp ke rentang 0.0–1.0 sebelum digunakan di `FractionallySizedBox`/`LinearProgressIndicator`.

## Larangan

- DILARANG timer di widget halaman penuh → isolasi ke widget kecil (lihat `isolasi-widget-timer`).
- DILARANG aset gambar/Lottie untuk progress visual → gunakan `Stack` + `LinearProgressIndicator` + `Icon` (lihat `visualisasi-progres-impian`).
- DILARANG widget reusable ambil tanggung jawab padding tepi layar (kecuali empty/error/loading yang dipakai langsung di `Scaffold.body`) (lihat `spacing`).
- DILARANG logika bisnis (hitung rasio, cek tercapai) di widget → gunakan helper murni (lihat `visualisasi-progres-impian`, `ekstraksi-perhitungan-turunan`).
- DILARANG `LinearProgressIndicator` langsung tanpa custom visual jika kebutuhan visual spesifik.
- DILARANG rasio progres tanpa clamp → `LinearProgressIndicator` error jika > 1.0.

## Contoh Benar

```dart
// Widget custom reusable: StatelessWidget, pure, pakai ColorScheme, pakai spacing
class VisualTabunganImpian extends StatelessWidget {
  const VisualTabunganImpian({
    required this.rasio,
    required this.saldo,
    required this.target,
    super.key,
  });

  final double rasio; // 0.0 - 1.0 (sudah di-clamp oleh helper)
  final double saldo;
  final double target;

  @override
  Widget build(BuildContext context) {
    final bool sudahTercapai = rasio >= 1.0;

    final Color warnaProgres = sudahTercapai
        ? const Color(0xFF4CAF50) // Hardcode diperbolehkan: status sukses
        : Theme.of(context).colorScheme.primary;

    final Color warnaBackground = warnaProgres.withValues(alpha: 0.2);

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12,
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: warnaBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: rasio,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: warnaProgres,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sudahTercapai
                  ? 'Target tercapai! 🎉'
                  : 'Terkumpul: ${FormatUang.format(saldo)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: sudahTercapai
                    ? const Color(0xFF4CAF50)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            if (!sudahTercapai)
              Text(
                'Sisa: ${FormatUang.format(ImpianProgresHelper.sisa(saldo, target))}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
```

## Contoh Salah

```dart
// DILARANG: Logika hitung rasio di widget (harus di helper)
class VisualTabunganImpian extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rasio = saldo / target; // LOGIKA DI WIDGET - SALAH!
    // ...
  }
}

// DILARANG: LinearProgressIndicator langsung (kurang custom)
LinearProgressIndicator(
  value: rasio,
  backgroundColor: warna.withOpacity(0.2),
)

// DILARANG: Pakai aset Lottie/gambar
Lottie.asset('assets/progress.json')

// DILARANG: withOpacity deprecated
color: warna.withOpacity(0.2)

// DILARANG: Tidak clamp rasio (crash jika > 1.0)
FractionallySizedBox(widthFactor: rasioTanpaClamp)
```

## Sumber Evaluasi

- File: `lib/fitur/impian/widget/visual_tabungan_impian.dart`
- Class terkait: `VisualTabunganImpian`, `EmptyStateView`, `TimerCravingView` (dan sibling teknik SOS), `_HeaderPemulihan`, `ImpianProgresHelper`
- Commit rujukan: `c7337d1` — `VisualTabunganImpian`, `ImpianProgresHelper`, `DetailImpianScreen`; `3b67d309` — `_TimerCravingView` (kini publik: `TimerCravingView` di `timer_craving_view.dart`), empty state diary craving (kini `EmptyStateView` bersama), `_ErrorRetry`/`_LoadingView` (sudah tidak ada di `lib/`); `02aa6b29` — `_HeaderPemulihan`; `e659574` — kartu SOS Craving & Alasan Berhenti di dashboard; `65abc0104fc8eec90cde9906c52d3f65cba13ba3` — `EmptyStateView` (menggantikan empty state custom per layar, lihat `empty-state-daftar`); `fbbb0906d08d2590caa8c7829595ea7fa4e513a5` — widget teknik SOS (`napas_478_view.dart`, dll.) sebagai `ConsumerStatefulWidget`
