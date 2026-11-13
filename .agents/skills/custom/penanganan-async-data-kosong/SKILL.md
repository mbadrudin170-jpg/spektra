---
name: penanganan-async-data-kosong
description: "Trigger: saat layar menangani state async atau data kosong | Panduan isLoading, hasError, requireValue, empty state, data tidak lengkap, early return, mounted check."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Penanganan State Asynchronous dan Data Kosong pada Layar

Layar async wajib handle isLoading → hasError → requireValue → empty state → data tidak lengkap, early return, mounted check.

## Aturan

1. Layar yang memuat data asynchronous wajib menangani status `isLoading` terlebih dahulu (tampilkan indikator loading).
2. Setelah itu, tangani status `hasError` (tampilkan pesan error dan tombol retry yang memanggil `ref.refresh(provider)`).
3. Setelah data tersedia (`requireValue`), tangani kondisi data kosong (empty state) dan kondisi data tidak lengkap (mis. biodata null, tanggal berhenti null) sebagai tampilan tersendiri dengan informasi dan call-to-action.
4. Gunakan early return (guard clause) untuk setiap kondisi tersebut agar alur build tetap linear dan mudah dibaca.
5. Gunakan `const SizedBox.shrink()` untuk widget kondisional yang disembunyikan.
6. Setelah `await`/operasi asynchronous, periksa `mounted` sebelum mengakses `context` atau memanggil `setState`.

## Larangan

- Jangan memanggil `requireValue` sebelum memastikan `isLoading` dan `hasError` sudah ditangani.
- Jangan menampilkan layar kosong tanpa informasi atau CTA ketika data kosong.
- Jangan menggabungkan penanganan loading, error, dan data kosong dalam satu blok yang sulit dibaca.

## Contoh Benar

```dart
final dataAsync = ref.watch(provider);

if (dataAsync.isLoading) {
  return const Scaffold(body: Center(child: CircularProgressIndicator()));
}
if (dataAsync.hasError) {
  return Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Gagal memuat data'), OutlinedButton(onPressed: () => ref.refresh(provider), child: const Text('Coba lagi'))])));
}

final state = dataAsync.requireValue;
if (state.list.isEmpty) {
  return Scaffold(
    body: EmptyStateView(
      ikon: CupertinoIcons.book,
      judul: 'Belum ada data',
      deskripsi: 'Tekan tombol + untuk menambah data pertama.',
      ctaLabel: 'Tambah',
      onCta: () => unawaited(
        Nav.to(context, const FormPage()).catchError((Object e, StackTrace s) {
          L.e('Gagal navigasi: $e $s');
          return null;
        }),
      ),
    ),
  );
}
return Scaffold(body: _Daftar(state.list));
```

## Contoh Salah

```dart
final state = dataAsync.requireValue;
return Scaffold(body: ListView(...));
```

## Sumber Evaluasi

- Commit: `3b67d3095dacc4e5c7ea78d7eb251809e3e9d981`, `02aa6b29b0669a4f5bf21651b09b43552f65d6f8`, `65abc0104fc8eec90cde9906c52d3f65cba13ba3` (`EmptyStateView` sebagai empty state bersama)
- File: `lib/fitur/diary_craving/screens/diary_craving_screen.dart`, `lib/fitur/pemulihan_kesehatan/screens/pemulihan_kesehatan_screen.dart`, `lib/fitur/dashboard/screens/dashboard_screen.dart`
