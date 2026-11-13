# DAFTAR SEMUA FILE MODEL

Dikumpulkan pada: 2026-11-13 13:25:44

---

## 📄 File: lib/fitur/impian/model/impian_model.dart

**Jumlah baris:** 44

```dart
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_global_saya/core_shared.dart';

part 'impian_model.freezed.dart';

@freezed
abstract class ImpianModel with _$ImpianModel {
  const ImpianModel._();

  const factory ImpianModel({
    required String id,
    required String nama,
    required DateTime targetTanggal,
    required DateTime dibuat,
    required double jumlah,
  }) = _ImpianModel;

  /// Membuat [ImpianModel] dari baris database SQLite.
  factory ImpianModel.fromSqflite(Map<String, Object?> row) {
    return ImpianModel(
      id: ParserUtil.parseString(row[NamaKolom.id]),
      nama: ParserUtil.parseString(row[NamaKolom.nama]),
      targetTanggal:
          ParserUtil.parseDateTime(row[NamaKolom.targetTanggal])?.toLocal() ??
          DateTime.now(),
      dibuat:
          ParserUtil.parseDateTime(row[NamaKolom.dibuat])?.toLocal() ??
          DateTime.now(),
      jumlah: ParserUtil.parseDouble(row[NamaKolom.jumlah]),
    );
  }

  /// Mengonversi [ImpianModel] menjadi Map untuk disimpan ke SQLite.
  Map<String, Object?> toSqflite() {
    return <String, Object?>{
      NamaKolom.id: id,
      NamaKolom.nama: nama,
      NamaKolom.targetTanggal: targetTanggal.toUtc().toIso8601String(),
      NamaKolom.dibuat: dibuat.toUtc().toIso8601String(),
      NamaKolom.jumlah: jumlah,
    };
  }
}
```

---

## 📄 File: lib/fitur/diary_craving/model/diary_craving_model.dart

**Jumlah baris:** 80

```dart
import 'package:berhenti_merokok/fitur/diary_craving/enum/hasil_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/mood_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/pemicu_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/strategi_craving_enum.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_global_saya/core_shared.dart';

part 'diary_craving_model.freezed.dart';

@freezed
abstract class DiaryCravingModel with _$DiaryCravingModel {
  const DiaryCravingModel._();

  const factory DiaryCravingModel({
    required String id,
    required DateTime tanggal,
    required PemicuEnum pemicu,
    @Default(3) int intensitas,
    String? catatan,
    int? durasiMenit,
    MoodCravingEnum? mood,
    StrategiCravingEnum? strategi,
    HasilCravingEnum? hasil,
    required DateTime dibuat,
  }) = _DiaryCravingModel;

  /// Membuat [DiaryCravingModel] dari baris database SQLite.
  factory DiaryCravingModel.fromSqflite(Map<String, Object?> row) {
    return DiaryCravingModel(
      id: ParserUtil.parseString(row[NamaKolom.id]),
      tanggal:
          ParserUtil.parseDateTime(row[NamaKolom.tanggal])?.toLocal() ??
          DateTime.now(),
      pemicu:
          ParserUtil.safeParseEnum(
            PemicuEnum.values,
            ParserUtil.parseStringOrNull(row[NamaKolom.pemicu]),
          ) ??
          PemicuEnum.lainnya,
      intensitas: ParserUtil.parseInt(
        row[NamaKolom.intensitas],
        defaultValue: 3,
      ),
      catatan: ParserUtil.parseStringOrNull(row[NamaKolom.catatan]),
      durasiMenit: ParserUtil.parseIntOrNull(row[NamaKolom.durasiMenit]),
      mood: ParserUtil.safeParseEnum(
        MoodCravingEnum.values,
        ParserUtil.parseStringOrNull(row[NamaKolom.mood]),
      ),
      strategi: ParserUtil.safeParseEnum(
        StrategiCravingEnum.values,
        ParserUtil.parseStringOrNull(row[NamaKolom.strategi]),
      ),
      hasil: ParserUtil.safeParseEnum(
        HasilCravingEnum.values,
        ParserUtil.parseStringOrNull(row[NamaKolom.hasil]),
      ),
      dibuat:
          ParserUtil.parseDateTime(row[NamaKolom.dibuat])?.toLocal() ??
          DateTime.now(),
    );
  }

  /// Mengonversi [DiaryCravingModel] menjadi Map untuk disimpan ke SQLite.
  Map<String, Object?> toSqflite() {
    return <String, Object?>{
      NamaKolom.id: id,
      NamaKolom.tanggal: tanggal.toUtc().toIso8601String(),
      NamaKolom.pemicu: pemicu.name,
      NamaKolom.intensitas: intensitas,
      NamaKolom.catatan: catatan,
      NamaKolom.durasiMenit: durasiMenit,
      NamaKolom.mood: mood?.name,
      NamaKolom.strategi: strategi?.name,
      NamaKolom.hasil: hasil?.name,
      NamaKolom.dibuat: dibuat.toUtc().toIso8601String(),
    };
  }
}
```

---

## 📄 File: lib/fitur/toxin_pelacakan/model/toxin_model.dart

**Jumlah baris:** 23

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'toxin_model.freezed.dart';

/// Model data untuk satu entri toxin yang dihindari tubuh saat tidak merokok.
///
/// Data ini bersifat referensi statis, tidak disimpan ke SQLite, dan tidak
/// diubah oleh pengguna. Setiap entri mencakup nama toxin, jenis zat, faktor
/// konversi per batang rokok, efek singkat, serta sumber referensi umum
/// (WHO / CDC / AHA / ACS sebagai landasan, bukan klaim medis aplikasi).
@freezed
abstract class ToxinModel with _$ToxinModel {
  const ToxinModel._();

  const factory ToxinModel({
    required String nama,
    required String jenisZat,
    required double faktorPerBatang,
    required String efekSingkat,
    required String sumberReferensi,
    @Default(0.0) double kuantitasDiHindari,
  }) = _ToxinModel;
}
```

---

## 📄 File: lib/fitur/sos_craving/model/sos_intervensi_model.dart

**Jumlah baris:** 56

```dart
import 'package:berhenti_merokok/fitur/sos_craving/enum/hasil_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_global_saya/core_shared.dart';

part 'sos_intervensi_model.freezed.dart';

@freezed
abstract class SosIntervensiModel with _$SosIntervensiModel {
  const SosIntervensiModel._();

  const factory SosIntervensiModel({
    required String id,
    required JenisIntervensiSos jenisIntervensi,
    String? detail,
    HasilIntervensiSos? hasilIntervensi,
    String? diaryCravingId,
    required DateTime dibuat,
  }) = _SosIntervensiModel;

  /// Membuat [SosIntervensiModel] dari baris database SQLite.
  factory SosIntervensiModel.fromSqflite(Map<String, Object?> row) {
    return SosIntervensiModel(
      id: ParserUtil.parseString(row[NamaKolom.id]),
      jenisIntervensi:
          ParserUtil.safeParseEnum(
            JenisIntervensiSos.values,
            ParserUtil.parseStringOrNull(row[NamaKolom.jenisIntervensi]),
          ) ??
          // Fallback default ikut nama enum baru (lowerCamelCase).
          JenisIntervensiSos.napas478,
      detail: ParserUtil.parseStringOrNull(row[NamaKolom.detail]),
      hasilIntervensi: ParserUtil.safeParseEnum(
        HasilIntervensiSos.values,
        ParserUtil.parseStringOrNull(row[NamaKolom.hasilIntervensi]),
      ),
      diaryCravingId: ParserUtil.parseStringOrNull(row[NamaKolom.diaryCravingId]),
      dibuat:
          ParserUtil.parseDateTime(row[NamaKolom.dibuat])?.toLocal() ??
          DateTime.now(),
    );
  }

  /// Mengonversi [SosIntervensiModel] menjadi Map untuk disimpan ke SQLite.
  Map<String, Object?> toSqflite() {
    return <String, Object?>{
      NamaKolom.id: id,
      NamaKolom.jenisIntervensi: jenisIntervensi.name,
      NamaKolom.detail: detail,
      NamaKolom.hasilIntervensi: hasilIntervensi?.name,
      NamaKolom.diaryCravingId: diaryCravingId,
      NamaKolom.dibuat: dibuat.toUtc().toIso8601String(),
    };
  }
}
```

---

## 📄 File: lib/fitur/alasan_berhenti/model/alasan_berhenti_model.dart

**Jumlah baris:** 36

```dart
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_global_saya/core_shared.dart';

part 'alasan_berhenti_model.freezed.dart';

@freezed
abstract class AlasanBerhentiModel with _$AlasanBerhentiModel {
  const AlasanBerhentiModel._();

  const factory AlasanBerhentiModel({
    required String id,
    required String teks,
    required DateTime dibuat,
  }) = _AlasanBerhentiModel;

  /// Membuat [AlasanBerhentiModel] dari baris database SQLite.
  factory AlasanBerhentiModel.fromSqflite(Map<String, Object?> row) {
    return AlasanBerhentiModel(
      id: ParserUtil.parseString(row[NamaKolom.id]),
      teks: ParserUtil.parseString(row[NamaKolom.teks]),
      dibuat:
          ParserUtil.parseDateTime(row[NamaKolom.dibuat])?.toLocal() ??
          DateTime.now(),
    );
  }

  /// Mengonversi [AlasanBerhentiModel] menjadi Map untuk disimpan ke SQLite.
  Map<String, Object?> toSqflite() {
    return <String, Object?>{
      NamaKolom.id: id,
      NamaKolom.teks: teks,
      NamaKolom.dibuat: dibuat.toUtc().toIso8601String(),
    };
  }
}
```

---

## 📄 File: lib/fitur/biodata/model/biodata_model.dart

**Jumlah baris:** 158

```dart
import 'package:berhenti_merokok/fitur/biodata/enum/mode_berhenti.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_global_saya/core_shared.dart';

part 'biodata_model.freezed.dart';

@freezed
abstract class BiodataModel with _$BiodataModel {
  const BiodataModel._();

  const factory BiodataModel({
    required String id,
    required String nama,
    DateTime? tanggalLahir,
    @Default(10) int jumlahRokokPerHari,
    @Default(0.0) double hargaRokokPerBungkus,
    @Default(20.0) double batangPerBungkus,
    DateTime? tanggalMulaiMerokok,
    DateTime? tanggalMulaiBerhentiMerokok,
    @Default(ModeBerhenti.seketika) ModeBerhenti modeBerhenti,
    @Default(0) int penurunanPerMinggu,
    DateTime? tanggalMulaiTapering,
    int? targetSmokeFreeHari,
  }) = _BiodataModel;

  /// Membuat [BiodataModel] dari baris database SQLite.
  factory BiodataModel.fromSqflite(Map<String, Object?> row) {
    L.i('row=$row');
    return BiodataModel(
      id: ParserUtil.parseString(row[NamaKolom.id]),
      nama: ParserUtil.parseString(row[NamaKolom.nama]),
      tanggalLahir: ParserUtil.parseDateTime(row[NamaKolom.tanggalLahir])
          ?.toLocal(),
      jumlahRokokPerHari: ParserUtil.parseInt(
        row[NamaKolom.jumlahRokokPerHari],
        defaultValue: 10,
      ),
      hargaRokokPerBungkus: ParserUtil.parseDouble(
        row[NamaKolom.hargaRokokPerBungkus],
      ),
      batangPerBungkus: ParserUtil.parseDouble(
        row[NamaKolom.batangPerBungkus],
        defaultValue: 20.0,
      ),
      tanggalMulaiMerokok: ParserUtil.parseDateTime(
        row[NamaKolom.tanggalMulaiMerokok],
      )?.toLocal(),
      tanggalMulaiBerhentiMerokok: ParserUtil.parseDateTime(
        row[NamaKolom.tanggalMulaiBerhentiMerokok],
      )?.toLocal(),
      modeBerhenti:
          ParserUtil.safeParseEnum(
            ModeBerhenti.values,
            ParserUtil.parseString(row[NamaKolom.modeBerhenti]),
          ) ??
          ModeBerhenti.seketika,
      penurunanPerMinggu: ParserUtil.parseInt(
        row[NamaKolom.penurunanPerMinggu],
      ),
      tanggalMulaiTapering: ParserUtil.parseDateTime(
        row[NamaKolom.tanggalMulaiTapering],
      )?.toLocal(),
      targetSmokeFreeHari: ParserUtil.parseIntOrNull(
        row[NamaKolom.targetSmokeFreeHari],
      ),
    );
  }

  /// Mengonversi [BiodataModel] menjadi Map untuk disimpan ke SQLite.
  Map<String, Object?> toSqflite() {
    return <String, Object?>{
      NamaKolom.id: id,
      NamaKolom.nama: nama,
      NamaKolom.tanggalLahir: tanggalLahir?.toUtc().toIso8601String(),
      NamaKolom.jumlahRokokPerHari: jumlahRokokPerHari,
      NamaKolom.hargaRokokPerBungkus: hargaRokokPerBungkus,
      NamaKolom.batangPerBungkus: batangPerBungkus,
      NamaKolom.tanggalMulaiMerokok: tanggalMulaiMerokok
          ?.toUtc()
          .toIso8601String(),
      NamaKolom.tanggalMulaiBerhentiMerokok: tanggalMulaiBerhentiMerokok
          ?.toUtc()
          .toIso8601String(),
      NamaKolom.modeBerhenti: modeBerhenti.name,
      NamaKolom.penurunanPerMinggu: penurunanPerMinggu,
      NamaKolom.tanggalMulaiTapering: tanggalMulaiTapering
          ?.toUtc()
          .toIso8601String(),
      NamaKolom.targetSmokeFreeHari: targetSmokeFreeHari,
    };
  }
}

/// Ekstensi perhitungan turunan **baseline/estimasi** dari [BiodataModel].
///
/// Angka di sini murni dari biodata (`jumlahRokokPerHari × hariBerhenti` dan
/// turunannya), **bukan** dari catatan konsumsi aktual. Angka ini wajib
/// diberi label "estimasi" di UI dan bukan bukti bahwa pengguna tidak
/// merokok. Untuk metrik aktual berbasis catatan, gunakan
/// `MetrikBerhentiHelper` di `lib/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart`.
///
/// Perhitungan didelegasikan ke helper bersama melalui getter ini agar satu
/// definisi per metrik tetap terjaga. Hari ini, `hariBerhenti` adalah sumber
/// tunggal rumus hari smoke-free yang dipakai seluruh halaman (dashboard,
/// impian, badge).
extension BiodataModelPerhitungan on BiodataModel {
  /// Hari smoke-free (**baseline**), dinormalisasi agar tidak terpengaruh
  /// komponen waktu. Bukan bukti dari catatan konsumsi.
  int get hariBerhenti {
    final tanggalBerhenti = tanggalMulaiBerhentiMerokok;
    if (tanggalBerhenti == null) return 0;
    final sekarang = DateTime.now();
    final hariIniDate = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final tanggalBerhentiDate = DateTime(
      tanggalBerhenti.year,
      tanggalBerhenti.month,
      tanggalBerhenti.day,
    );
    final hari = hariIniDate.difference(tanggalBerhentiDate).inDays;
    return hari < 0 ? 0 : hari;
  }

  /// Jumlah rokok yang tidak dihisap selama periode smoke-free.
  ///
  /// **Estimasi baseline** dari biodata, bukan dari catatan konsumsi.
  int get rokokTidakDiHisap => jumlahRokokPerHari * hariBerhenti;

  /// Uang yang dihemat dari tidak merokok.
  ///
  /// **Estimasi baseline** dari biodata, bukan dari catatan konsumsi.
  double get uangDihemat {
    if (batangPerBungkus == 0) return 0;
    return (rokokTidakDiHisap / batangPerBungkus) * hargaRokokPerBungkus;
  }

  /// Apakah pengguna menggunakan mode berhenti bertahap (tapering).
  bool get sedangTapering => modeBerhenti == ModeBerhenti.bertahap;

  /// Target jumlah rokok per hari saat ini untuk mode tapering.
  ///
  /// Dihitung dari [jumlahRokokPerHari] dikurangi penurunan kumulatif
  /// berdasarkan minggu yang telah berlalu sejak [tanggalMulaiTapering].
  int get targetRokokHariIni {
    if (!sedangTapering) return jumlahRokokPerHari;
    final mulai = tanggalMulaiTapering ?? DateTime.now();
    final sekarang = DateTime.now();
    final mulaiDate = DateTime(mulai.year, mulai.month, mulai.day);
    final sekarangDate = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final hariBerlalu = sekarangDate.difference(mulaiDate).inDays;
    final mingguBerlalu = hariBerlalu < 0 ? 0 : hariBerlalu ~/ 7;
    final penurunan = penurunanPerMinggu * mingguBerlalu;
    final target = jumlahRokokPerHari - penurunan;
    if (target < 0) return 0;
    if (target > jumlahRokokPerHari) return jumlahRokokPerHari;
    return target;
  }
}
```

---

## 📄 File: lib/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart

**Jumlah baris:** 54

```dart
import 'package:berhenti_merokok/fitur/diary_craving/enum/pemicu_enum.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_global_saya/core_shared.dart';

part 'konsumsi_rokok_model.freezed.dart';

@freezed
abstract class KonsumsiRokokModel with _$KonsumsiRokokModel {
  const KonsumsiRokokModel._();

  const factory KonsumsiRokokModel({
    required String id,
    required DateTime tanggal,
    required int jumlah,
    @Default(false) bool isSlip,
    String? catatan,
    PemicuEnum? pemicu,
    required DateTime dibuat,
  }) = _KonsumsiRokokModel;

  /// Membuat [KonsumsiRokokModel] dari baris database SQLite.
  factory KonsumsiRokokModel.fromSqflite(Map<String, Object?> row) {
    final tanggalValue = ParserUtil.parseDateTime(row[NamaKolom.tanggal]);
    final dibuatValue = ParserUtil.parseDateTime(row[NamaKolom.dibuat]);
    return KonsumsiRokokModel(
      id: ParserUtil.parseString(row[NamaKolom.id]),
      tanggal: (tanggalValue ?? DateTime.now()).toLocal(),
      // jumlah non-nullable di Dart → pakai parseInt dengan defaultValue 1 saat DB null
      jumlah: ParserUtil.parseInt(row[NamaKolom.jumlah], defaultValue: 1),
      // isSlip non-nullable bool di Dart → pakai parseBool dengan defaultValue false saat DB null
      isSlip: ParserUtil.parseBool(row[NamaKolom.isSlip], defaultValue: false),
      catatan: ParserUtil.parseStringOrNull(row[NamaKolom.catatan]),
      pemicu: ParserUtil.safeParseEnum(
        PemicuEnum.values,
        ParserUtil.parseStringOrNull(row[NamaKolom.pemicu]),
      ),
      dibuat: (dibuatValue ?? DateTime.now()).toLocal(),
    );
  }

  /// Mengonversi [KonsumsiRokokModel] menjadi Map untuk disimpan ke SQLite.
  Map<String, Object?> toSqflite() {
    return <String, Object?>{
      NamaKolom.id: id,
      NamaKolom.tanggal: tanggal.toUtc().toIso8601String(),
      NamaKolom.jumlah: jumlah,
      NamaKolom.isSlip: isSlip ? 1 : 0,
      NamaKolom.catatan: catatan,
      NamaKolom.pemicu: pemicu?.name,
      NamaKolom.dibuat: dibuat.toUtc().toIso8601String(),
    };
  }
}
```

---

## 📄 File: lib/fitur/rencana_darurat/model/rencana_darurat_model.dart

**Jumlah baris:** 39

```dart
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_global_saya/core_shared.dart';

part 'rencana_darurat_model.freezed.dart';

@freezed
abstract class RencanaDaruratModel with _$RencanaDaruratModel {
  const RencanaDaruratModel._();

  const factory RencanaDaruratModel({
    required String id,
    required String jika,
    required String maka,
    required DateTime dibuat,
  }) = _RencanaDaruratModel;

  /// Membuat [RencanaDaruratModel] dari baris database SQLite.
  factory RencanaDaruratModel.fromSqflite(Map<String, Object?> row) {
    return RencanaDaruratModel(
      id: ParserUtil.parseString(row[NamaKolom.id]),
      jika: ParserUtil.parseString(row[NamaKolom.jika]),
      maka: ParserUtil.parseString(row[NamaKolom.maka]),
      dibuat:
          ParserUtil.parseDateTime(row[NamaKolom.dibuat])?.toLocal() ??
          DateTime.now(),
    );
  }

  /// Mengonversi [RencanaDaruratModel] menjadi Map untuk disimpan ke SQLite.
  Map<String, Object?> toSqflite() {
    return <String, Object?>{
      NamaKolom.id: id,
      NamaKolom.jika: jika,
      NamaKolom.maka: maka,
      NamaKolom.dibuat: dibuat.toUtc().toIso8601String(),
    };
  }
}
```

---


## 📊 STATISTIK

- **Total file model:** 8
- **Total baris kode:** 490
- **File output:** docs/model.md
