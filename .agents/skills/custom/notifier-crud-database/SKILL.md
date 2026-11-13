---
name: notifier-crud-database
description: "Trigger: saat membuat Notifier CRUD database | Panduan pola Notifier CRUD Riverpod: keepAlive, build memanggil _ambilSemua, CRUD update state setelah DB berhasil, catch Exception rethrow."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Pola Notifier CRUD pada Database

Notifier database wajib menggunakan `@Riverpod(keepAlive: true)`, method `build()` memanggil `_ambilSemua()`, CRUD update state setelah operasi DB berhasil.

## Aturan

1. Notifier database wajib menggunakan `@Riverpod(keepAlive: true)` agar state tidak hilang saat tidak ada listener.
2. Method `build()` wajib memanggil `_ambilSemua()` yang mengambil seluruh data dari database dan memetakan ke model.
3. Setiap method CRUD (`tambah`, `ubah`, `hapus`) wajib:
   a. Mencatat parameter/log awal dengan `L.i`.
   b. Mengambil state lama melalui `await future`.
   c. Menjalankan operasi database terlebih dahulu.
   d. Memperbarui `state` dengan `AsyncValue.data(...)` setelah operasi database berhasil.
   e. Mencatat keberhasilan dengan `L.s`.
   f. Menangkap `Exception` dengan `on Exception catch (e, s)`, mencatat dengan `L.e`, lalu `rethrow`.
4. Gunakan `SqfliteOp` sebagai lapisan akses database; jangan memanggil `openDatabase` langsung di notifier.
5. Operasi batch (banyak data) wajib menggunakan `op.batch(...)` agar atomik dan efisien.
6. Untuk entitas baru yang dibuat dari form, notifier boleh menyimpan satu baris langsung dengan `op.tambah(...)` menghasilkan `id` via `Uuid().v4()` dan `dibuat` via `DateTime.now().toUtc()`; state diperbarui dengan prepend model baru ke `list...` dan menaikkan counter (`jumlah... + 1`) setelah DB berhasil — jangan menulis dua jalur penyimpanan (model-by-model vs map) di notifier yang sama.
7. Update parsial satu kolom (mis. menautkan `diaryCravingId`) wajib memakai `op.ubah(... where: 'id = ?', whereArgs: [...])` lalu memetakan model lama dengan `copyWith` untuk membentuk state baru; jangan menulis ulang seluruh baris dengan `toSqflite()` hanya untuk mengubah satu kolom.
8. Konflik insert wajib eksplisit: `conflictAlgorithm: ConflictAlgorithm.abort` untuk insert baru (gagal bila id bentrok) — `replace` hanya bila memang upsert disengaja.
9. Setelah `await future` di dalam method CRUD, jangan akses provider lain yang bisa memicu rebuild tidak perlu; state diperbarui murni dari `dataLama` + model baru.

## Larangan

- Jangan memperbarui `state` sebelum operasi database selesai (kecuali mengikuti pola optimistic update pada aturan Riverpod #9).
- Jangan menelan exception; wajib `rethrow` agar UI dapat menangani.
- Jangan membuat instance database baru di notifier.
- Jangan persistenkan `id` yang tidak di-generate (mis. dari input pengguna) tanpa keputusan eksplisit.

## Contoh Benar

```dart
@Riverpod(keepAlive: true)
class DiaryCravingNotifier extends _$DiaryCravingNotifier {
  @override
  Future<DiaryCravingState> build() async {
    return _ambilSemua();
  }

  Future<DiaryCravingState> _ambilSemua() async {
    final op = const SqfliteOp();
    final rows = await op.ambilSemua(NamaTabel.diaryCraving);
    return DiaryCravingState(
      listCraving: rows.map((r) => DiaryCravingModel.fromSqflite(r)).toList(),
      jumlahCraving: rows.length,
    );
  }

  Future<void> tambah(DiaryCravingModel craving) async {
    L.i('craving.id=${craving.id}');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.tambah(NamaTabel.diaryCraving, craving.toSqflite(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      state = AsyncValue.data(
        DiaryCravingState(
          listCraving: [craving, ...dataLama.listCraving],
          jumlahCraving: dataLama.jumlahCraving + 1,
        ),
      );
      L.s('Diary craving berhasil disimpan');
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan diary craving: $e $s');
      rethrow;
    }
  }
}
```

## Contoh Salah

```dart
// Memperbarui state sebelum operasi database selesai.
state = AsyncValue.data(DiaryCravingState(listCraving: [craving, ...list]));
await op.tambah(NamaTabel.diaryCraving, craving.toSqflite()); // jika gagal, state sudah berubah
```

## Sumber Evaluasi

- Commit: `3b67d3095dacc4e5c7ea78d7eb251809e3e9d981`, `a15acd9603fe5d1251afa4acc3817e7e9c1607b1` (SosIntervensiNotifier: simpan + ubahDiaryCravingId), `2462af81050e12b2933717f457a33a5b05d3719f` (RencanaDaruratNotifier)
- File: `lib/fitur/diary_craving/notifier/diary_craving_notifier.dart`, `lib/fitur/impian/notifier/impian_notifier.dart`, `lib/fitur/sos_craving/notifier/sos_intervensi_notifier.dart`, `lib/fitur/rencana_darurat/notifier/rencana_darurat_notifier.dart`
