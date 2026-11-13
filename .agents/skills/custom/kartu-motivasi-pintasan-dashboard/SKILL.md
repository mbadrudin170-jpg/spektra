---
name: kartu-motivasi-pintasan-dashboard
description: "Trigger: saat membuat kartu motivasi atau pintasan aksi dashboard | Panduan dashboard dan SOS Craving: unawaited Nav.to dengan catchError, asData?.value bukan requireValue, log L.i/L.w, SizedBox.shrink untuk data kosong."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Kartu Motivasi dan Pintasan Aksi Cepat pada Dashboard dan SOS Craving

Pintasan Nav.to unawaited catchError, asData?.value untuk data opsional, log variabel UI, FilterChip logging, SizedBox.shrink data kosong.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `FilterChip`, `Column`, `Text`, `ElevatedButton`, `SizedBox`), `package:flutter_riverpod` (class `AsyncValue`, `ref`, `ConsumerWidget`), `package:berhenti_merokok/shared/utils/l` (class `L`)
- Class: `AsyncValue`, `FilterChip`, `ConsumerWidget`, `L`, `Nav`
- Properti: `AsyncValue.asData?.value`, `FilterChip.selected`, `FilterChip.onSelected`
- Method: `Nav.to()`, `unawaited()`, `catchError()`, `L.i()`, `L.w()`, `L.e()`

## Aturan

1. Pintasan navigasi (SOS Craving, Alasan Berhenti) pada dashboard wajib `unawaited(Nav.to(...).catchError(...))` dengan `L.e`.
2. Akses data async opsional (jumlah alasan, daftar terbaru) pakai `alasanAsync.asData?.value ?? fallback`, bukan `requireValue`.
3. Variabel relevan di method UI wajib log `L.i`/`L.w` per aturan logging.
4. FilterChip pilihan cepat form alasan berhenti wajib log `L.i('snippet=$snippet, terpilih=$terpilih')` dan `L.i('snippet dipilih=$snippet, dipilih=$dipilih')`.
5. Data opsional kosong → `const SizedBox.shrink()` dengan `L.w`, bukan error/crash.
6. Baris kartu ringkasan yang sejajar (`Row` + `crossAxisAlignment: CrossAxisAlignment.stretch`) wajib dibungkus `IntrinsicHeight` agar semua kartu memiliki tinggi yang sama meskipun isinya berbeda jumlah baris (caption panjang tak boleh membuat salah satu kartu lebih tinggi).
7. Caption ringkas di bawah blok metrik wajib dibungkus `Padding(vertical: 8)` (bukan `Text` telanjang) agar jarak terhadap kartu di atas/bawah serasi seperti kartu `Card`.

## Larangan

- Jangan `alasanAsync.requireValue` untuk data opsional.
- Jangan tampilkan kartu motivasi tanpa cek data kosong.
- Jangan navigasi pintasan tanpa `.catchError()` pada `unawaited()`.

## Contoh Benar

```dart
// Navigasi pintasan aman dengan unawaited + catchError
ElevatedButton(
  onPressed: () => unawaited(
    Nav.to(context, const SosCravingScreen()).catchError((e, s) {
      L.e('Gagal navigasi ke SOS Craving: $e $s');
      return null;
    }),
  ),
  child: const Text('SOS Craving'),
),

// Akses data async opsional dengan asData?.value
final jumlah = alasanAsync.asData?.value?.jumlahAlasan ?? 0;
L.i('jumlahAlasan=$jumlah');

// Log variabel FilterChip
L.i('snippet=$snippet, terpilih=$terpilih');
return FilterChip(
  label: Text(snippet), selected: terpilih,
  onSelected: (dipilih) {
    L.i('snippet dipilih=$snippet, dipilih=$dipilih');
    setState(() => _teksController.text = dipilih ? snippet : '');
  },
);

// Data opsional kosong → SizedBox.shrink
if (alasanAsync.asData?.value?.isEmpty ?? true) {
  L.w('data alasan kosong');
  return const SizedBox.shrink();
}
```

## Contoh Salah

```dart
// DILARANG: requireValue untuk data opsional
final jumlah = alasanAsync.requireValue.jumlahAlasan;

// DILARANG: Navigasi tanpa catchError
ElevatedButton(
  onPressed: () => unawaited(Nav.to(context, const SosCravingScreen())),
  child: const Text('SOS'),
);

// DILARANG: Tidak log variabel UI
return FilterChip(label: Text(snippet), selected: terpilih);

// DILARANG: Data kosong tanpa SizedBox.shrink / L.w
if (list.isEmpty) return const SizedBox.shrink(); // Tanpa L.w
```

## Sumber Evaluasi

- File: `lib/fitur/dashboard/screens/dashboard_screen.dart`, `lib/fitur/sos_craving/screens/sos_craving_screen.dart`, `lib/fitur/alasan_berhenti/screens/form_alasan_berhenti.dart`
- Class terkait: `AsyncValue`, `FilterChip`, `ConsumerWidget`, `L`, `Nav`
- Commit rujukan: `e6595744b3840998d840e398ca1782e7be7d50b4` — Kartu SOS Craving dan Alasan Berhenti di dashboard; `fbcfadac74a271a2425334916171adbea4439d11` — penyederhanaan tata letak dashboard (pola C1); `db5dd32f28e92346b9a8d3467fa9b2838e013a02` — caption "Dari catatan" dibungkus `Padding(vertical: 8)`; `117293d38f0aa2f139aefe5dc4412bd57473b90e` — `IntrinsicHeight` untuk menyamakan tinggi 3 kartu ringkasan
