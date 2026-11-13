---
name: pola-ux
description: "Trigger: saat menerapkan pola UX Flutter | Indeks: konfirmasi-sebelum-simpan, empty-state-daftar, kartu-motivasi-pintasan-dashboard, validasi-form-sebelum-penyimpanan, penanganan-asyncvalue-berkali, penanganan-async-data-kosong."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Indeks Pola UX Standar

Skill ini berfungsi sebagai indeks/ringkasan yang merujuk ke skill spesifik untuk setiap pola UX. Jangan menduplikasi isi skill spesifik di sini. Semua pola UX yang tercantum di bawah ini sudah terimplementasi di proyek Flutter dan dapat digunakan sebagai referensi untuk pola serupa di proyek lain.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `Form`, `GlobalKey`, `SafeArea`, `Padding`, `FAB`, `Icon`, `Text`, `FilledButton`, `Scaffold`, `ShowDialog`), `package:flutter_riverpod` (class `AsyncValue`, `ref`, `ConsumerWidget`, `ConsumerState`), `package:shared_preferences` (class `SharedPreferences`)
- Class: `Form`, `GlobalKey<FormState>`, `AsyncValue`, `SharedPreferences`, `AppToast`, `L` (logging), `Nav` (navigasi)
- Properti: `isLoading`, `hasError`, `requireValue`, `asData?.value`, `isDestructiveAction`, `onRetry`
- Method: `Form.of()`, `GlobalKey.currentState?.validate()`, `ref.watch()`, `ref.refresh()`, `AsyncValue.requireValue()`, `SharedPreferences.setBool()`, `AppToast.sukses()`, `unawaited()`

## Aturan

1. Selalu minta konfirmasi dengan penjelasan konsekuensi sebelum aksi destruktif (hapus, export, reset).
2. Empty state wajib informatif dan memakai komponen bersama `EmptyStateView` (`lib/shared/widget/empty_state_view.dart`): ikon + judul + deskripsi + CTA opsional (`OutlinedButton`, bukan FAB wajib), sudah dibungkus `SafeArea` + padding — lihat `empty-state-daftar`.
3. Navigasi non-blocking wajib menggunakan `unawaited(Nav.to(...).catchError(...))`.
4. Akses data async opsional wajib menggunakan `asData?.value ?? fallback`, bukan `requireValue`.
5. Logging konsisten: log variabel UI dengan `L.i`/`L.w` per aturan logging.
6. Toast perayaan hanya sekali: `AppToast.sukses` + `SharedPreferences` penandaan + `unawaited()`.
7. Validasi form wajib menggunakan `Form` + `GlobalKey<FormState>` + `validate()` dengan validator aturan bisnis, bukan `?? 0` masking.
8. Multiple provider: loading gabungan, error terpisah per provider, `requireValue` terakhir setelah aman.
9. Early return pattern: setiap kondisi (loading, error, empty, incomplete) → early return.
10. Data tidak lengkap → tampilan terpisah + CTA, bukan menampilkan data parsial.

## Larangan

- DILARANG menyimpan data tanpa validasi form (lihat `validasi-form-sebelum-penyimpanan`).
- DILARANG `requireValue` pada data opsional/async tanpa cek loading/error (lihat `penanganan-async-data-kosong`, `penanganan-asyncvalue-berkali`, `kartu-motivasi-pintasan-dashboard`).
- DILARANG navigasi pintasan tanpa `.catchError()` pada `unawaited()` (lihat `kartu-motivasi-pintasan-dashboard`, `penanganan-error-unawaited`).
- DILARANG toast perayaan tanpa penandaan `SharedPreferences` (lihat `visualisasi-progres-impian`).
- DILARANG empty state tanpa ikon, judul, deskripsi, CTA (lihat `empty-state-daftar`).
- DILARANG konfirmasi destruktif tanpa `isDestructiveAction: true` dan penjelasan konsekuensi (lihat `konfirmasi-sebelum-simpan`, `ekspor-pemulihan-cadangan`).

## Contoh Benar

```dart
// Konfirmasi destruktif dengan isDestructiveAction: true
showOkCancelAlertDialog(
  context: context,
  title: 'Hapus Data?',
  message: 'Tindakan ini tidak dapat dibatalkan.',
  isDestructiveAction: true,
  onOk: () async {
    // Hanya jalankan jika OK ditekan
    await hapusData();
  },
);

// Validasi form sebelum simpan
final formKey = GlobalKey<FormState>();
if (formKey.currentState?.validate() ?? false) {
  formKey.currentState!.save();
  await simpanData();
}

// Akses data async opsional
final nilai = asyncValue.asData?.value ?? fallbackNilai;

// Navigasi aman dengan catchError
unawaited(Nav.to('/dashboard').catchError((e) => L.e('Navigasi gagal: $e')));

// Early return pattern
if (state.isLoading) return const _LoadingView();
if (state.hasError) return _ErrorRetry(onRetry: () => ref.refresh(provider));
if (state.value?.isEmpty ?? true) return const _EmptyState();
return _TampilkanData(state.requireValue);
```

## Contoh Salah

```dart
// DILARANG: Simpan tanpa validasi form
await simpanData(); // Tidak ada Form + validate()

// DILARANG: requireValue pada data opsional tanpa cek
final nilai = asyncValue.requireValue; // SALAH! Bisa throw jika loading/error

// DILARANG: Navigasi tanpa catchError
unawaited(Nav.to('/dashboard')); // SALAH! Tidak ada error handling

// DILARANG: Toast perayaan tanpa penandaan SharedPreferences
AppToast.sukses('Berhasil!'); // SALAH! Tidak ada penandaan, bisa muncul berulang

// DILARANG: Empty state tanpa CTA
return Center(child: Text('Kosong')); // SALAH! Tidak ada ikon, deskripsi, CTA
```

## Sumber Evaluasi

- File: `lib/fitur/diary_craving/screens/diary_craving_screen.dart`, `lib/fitur/pemulihan_cadangan/screens/pemulihan_cadangan_screen.dart`, `lib/fitur/dashboard/screens/dashboard_screen.dart`
- Class terkait: `Form`, `GlobalKey<FormState>`, `AsyncValue`, `SharedPreferences`, `AppToast`, `L`, `Nav`
- Commit rujukan: `3b67d309` — Konfirmasi simpan diary craving, Empty state diary craving; `338a021` — Konfirmasi pemulihan cadangan (destruktif); `1e7b71e` — Konfirmasi masukkan data dummy (mengganti biodata); `e659574` — Kartu SOS Craving dan Alasan Berhenti di dashboard; `c7337d1` — Perayaan pencapaian impian dengan SharedPreferences; `ceacc6a` — Validasi penurunan mingguan mode tapering; `19f43e5` — BadgeScreen multiple provider handling; `02aa6b29` — DashboardScreen async data handling; `65abc0104fc8eec90cde9906c52d3f65cba13ba3` — `EmptyStateView` sebagai empty state bersama (OutlinedButton, bukan FAB)
