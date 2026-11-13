---
name: validasi-tapering
description: "Trigger: saat memvalidasi mode berhenti bertahap (tapering) | Panduan enum ModeBerhenti, penurunanPerMinggu positif, tanggalMulaiTapering valid, targetRokokHariIni di ekstensi, normalisasi tanggal, guard pembagian nol, clamp 0."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Validasi dan Perhitungan Mode Berhenti Bertahap (Tapering)

Mode seketika pakai jumlahRokokPerHari sebagai target, tanpa penurunan. Mode bertahap wajib penurunanPerMinggu > 0, tanggalMulaiTapering valid, targetRokokHariIni di ekstensi.

## Cakupan yang Di-Cover

- Package: `package:flutter` (class `DateTime`, `TextEditingController`, `DropdownButton`, `TextFormField`), `package:flutter_riverpod` (class `ref`, `ConsumerStatefulWidget`)
- Class: `ModeBerhenti`, `BiodataModel`, `BiodataModelPerhitungan`, `TextEditingController`
- Enum: `ModeBerhenti.seketika`, `ModeBerhenti.bertahap`
- Properti: `penurunanPerMinggu`, `tanggalMulaiTapering`, `jumlahRokokPerHari`, `targetRokokHariIni`
- Method: `int.tryParse()`, `DateTime.normalize()`, `int.clamp()`

## Aturan

1. `ModeBerhenti.seketika` pakai `jumlahRokokPerHari` sebagai target, tanpa penurunan.
2. `ModeBerhenti.bertahap` wajib `penurunanPerMinggu` bilangan bulat positif.
3. Input penurunan mingguan tidak boleh kosong, nol, atau negatif saat mode bertahap.
4. Tanggal mulai tapering diinisialisasi saat aktifkan mode bertahap, divalidasi sebelum simpan.
5. Jika tanggal mulai di masa depan, minggu berlalu = 0 sampai tanggal tercapai.
6. Hitung minggu pakai tanggal dinormalisasi (sesuai aturan normalisasi-tanggal).
7. Target: `jumlahRokokPerHari - (penurunanPerMinggu * mingguBerlalu)`.
8. Target tidak boleh < 0 (clamp ke 0).
9. Target mode seketika = `jumlahRokokPerHari`.
10. Jangan duplikasi formula di layar. Pakai getter `targetRokokHariIni` dari ekstensi `BiodataModelPerhitungan`.
11. Pertahankan kompatibilitas data lama (fallback di fromSqflite).

## Larangan

- Jangan duplikasi formula target di layar.
- Jangan simpan mode bertahap tanpa `penurunanPerMinggu > 0` dan tanggal mulai valid.
- Jangan biarkan target negatif.
- Jangan hitung minggu dari tanggal tanpa normalisasi.

## Contoh Benar

```dart
// Ekstensi dengan targetRokokHariIni (didefinisikan sekali)
extension BiodataModelPerhitungan on BiodataModel {
  int get targetRokokHariIni {
    if (modeBerhenti != ModeBerhenti.bertahap || tanggalMulaiTapering == null) {
      return jumlahRokokPerHari;
    }
    final mulaiDate = DateTime(
      tanggalMulaiTapering!.year,
      tanggalMulaiTapering!.month,
      tanggalMulaiTapering!.day,
    );
    final sekarangDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final selisihHari = sekarangDate.difference(mulaiDate).inDays;
    final mingguBerlalu = selisihHari < 0 ? 0 : selisihHari ~/ 7;
    final target = jumlahRokokPerHari - (penurunanPerMinggu * mingguBerlalu);
    return target.clamp(0, jumlahRokokPerHari);
  }
}

// Form dengan validasi
final _formKey = GlobalKey<FormState>();
final _penurunanController = TextEditingController();

Future<void> _simpan() async {
  if (!(_formKey.currentState?.validate() ?? false)) return;

  if (_mode == ModeBerhenti.bertahap && _tanggalMulaiTapering == null) {
    _tanggalMulaiTapering = DateTime.now();
  }

  final penurunan = int.parse(_penurunanController.text.trim());
  await ref.read(biodataProvider.notifier).simpan(BiodataModel(
    modeBerhenti: _mode,
    penurunanPerMinggu: penurunan,
    tanggalMulaiTapering: _tanggalMulaiTapering,
  ));
}

TextFormField(
  controller: _penurunanController,
  keyboardType: TextInputType.number,
  validator: (v) {
    final n = int.tryParse(v ?? '');
    if (n == null || n <= 0) return 'Wajib bilangan bulat positif';
    return null;
  },
)
```

## Contoh Salah

```dart
// DILARANG: Parsing gagal diganti 0 tanpa validasi
final penurunan = int.tryParse(_penurunanController.text.trim()) ?? 0;

// DILARANG: Simpan mode bertahap tanpa validasi penurunan > 0
await ref.read(biodataProvider.notifier).simpan(BiodataModel(
  modeBerhenti: _mode,
  penurunanPerMinggu: penurunan, // bisa 0 atau negatif
));

// DILARANG: Duplikasi formula target di layar
final target = jumlahRokokPerHari - (penurunanPerMinggu * mingguBerlalu); // duplikat!
```

## Sumber Evaluasi

- File: `lib/fitur/biodata/enum/mode_berhenti.dart`, `lib/fitur/biodata/model/biodata_model.dart`, `lib/fitur/biodata/screens/form_biodata.dart`, `lib/shared/db/sqflite/sqflite.dart`, `lib/shared/konstanta/nama_kolom.dart`
- Class terkait: `ModeBerhenti`, `BiodataModel`, `BiodataModelPerhitungan`
- Commit rujukan: `ceacc6a1c388b24b7647a37ccde411d6c85ee01c` — Validasi penurunan mingguan mode tapering
