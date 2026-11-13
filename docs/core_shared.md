// ============================================================
// FILE: lib/shared/db/sqflite/sqflite.dart
// ============================================================

```dart
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Konfigurasi dan akses database SQLite untuk aplikasi berhenti_merokok.
///
/// Database menggunakan factory default sqflite yang didukung Android.
class AppDatabase {
  AppDatabase._();

  static Database? _database;

  /// Nama file database SQLite.
  static const String _namaDatabase = 'berhenti_merokok.db';

  /// Versi skema database.
  // Versi 12: migrasi nilai enum snake_case lama ke lowerCamelCase.
  // Versi 13: tabel rencana_darurat (if-then plan).
  // Versi 14: tambah kolom pemicu (TEXT, nullable) pada tabel konsumsi_rokok.
  // Versi 15: perbaikan bug — instalasi baru (onCreate) versi 14 tidak menyertakan
  // kolom pemicu; migrasi ini menambahkan kolom pemicu bila belum ada.
  static const int _versiDatabase = 15;

  /// Mengembalikan instance database, membuatnya jika belum tersedia.
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inisialisasiDatabase();
    return _database!;
  }

  /// Membuka dan menginisialisasi database SQLite.
  static Future<Database> _inisialisasiDatabase() async {
    final pathDatabase = await getDatabasesPath();
    final path = join(pathDatabase, _namaDatabase);

    return await openDatabase(
      path,
      version: _versiDatabase,
      onCreate: _buatTabel,
      onUpgrade: _onUpgrade,
    );
  }

  /// Membuat tabel-tabel saat database pertama kali dibuat.
  static Future<void> _buatTabel(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${NamaTabel.biodata}(
        ${NamaKolom.id} TEXT PRIMARY KEY,
        ${NamaKolom.nama} TEXT NOT NULL,
        ${NamaKolom.tanggalLahir} TEXT,
        ${NamaKolom.jumlahRokokPerHari} INTEGER,
        ${NamaKolom.hargaRokokPerBungkus} REAL,
        ${NamaKolom.batangPerBungkus} REAL,
        ${NamaKolom.tanggalMulaiMerokok} TEXT,
        ${NamaKolom.tanggalMulaiBerhentiMerokok} TEXT,
        ${NamaKolom.modeBerhenti} TEXT,
        ${NamaKolom.penurunanPerMinggu} INTEGER,
        ${NamaKolom.tanggalMulaiTapering} TEXT,
        ${NamaKolom.targetSmokeFreeHari} INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${NamaTabel.impian}(
        ${NamaKolom.id} TEXT PRIMARY KEY,
        ${NamaKolom.nama} TEXT NOT NULL,
        ${NamaKolom.targetTanggal} TEXT,
        ${NamaKolom.dibuat} TEXT,
        ${NamaKolom.jumlah} REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${NamaTabel.diaryCraving}(
        ${NamaKolom.id} TEXT PRIMARY KEY,
        ${NamaKolom.tanggal} TEXT,
        ${NamaKolom.pemicu} TEXT NOT NULL,
        ${NamaKolom.intensitas} INTEGER,
        ${NamaKolom.catatan} TEXT,
        ${NamaKolom.durasiMenit} INTEGER,
        ${NamaKolom.mood} TEXT,
        ${NamaKolom.strategi} TEXT,
        ${NamaKolom.hasil} TEXT,
        ${NamaKolom.dibuat} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${NamaTabel.alasanBerhenti}(
        ${NamaKolom.id} TEXT PRIMARY KEY,
        ${NamaKolom.teks} TEXT NOT NULL,
        ${NamaKolom.dibuat} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${NamaTabel.konsumsiRokok}(
        ${NamaKolom.id} TEXT PRIMARY KEY,
        ${NamaKolom.tanggal} TEXT NOT NULL,
        ${NamaKolom.jumlah} INTEGER NOT NULL DEFAULT 1,
        ${NamaKolom.isSlip} INTEGER NOT NULL DEFAULT 0,
        ${NamaKolom.catatan} TEXT,
        ${NamaKolom.pemicu} TEXT,
        ${NamaKolom.dibuat} TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_konsumsi_tanggal
      ON ${NamaTabel.konsumsiRokok}(${NamaKolom.tanggal})
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${NamaTabel.sosIntervensi}(
        ${NamaKolom.id} TEXT PRIMARY KEY,
        ${NamaKolom.jenisIntervensi} TEXT NOT NULL,
        ${NamaKolom.detail} TEXT,
        ${NamaKolom.hasilIntervensi} TEXT,
        ${NamaKolom.diaryCravingId} TEXT,
        ${NamaKolom.dibuat} TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${NamaTabel.rencanaDarurat}(
        ${NamaKolom.id} TEXT PRIMARY KEY,
        ${NamaKolom.jika} TEXT NOT NULL,
        ${NamaKolom.maka} TEXT NOT NULL,
        ${NamaKolom.dibuat} TEXT NOT NULL
      )
    ''');
  }

  /// Memperbarui skema database saat versi meningkat.
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (kDebugMode) {
      debugPrint('oldVersion=$oldVersion, newVersion=$newVersion');
    }
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${NamaTabel.impian}(
          ${NamaKolom.id} TEXT PRIMARY KEY,
          ${NamaKolom.nama} TEXT NOT NULL,
          ${NamaKolom.targetTanggal} TEXT,
          ${NamaKolom.dibuat} TEXT,
          ${NamaKolom.jumlah} REAL
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE ${NamaTabel.biodata} '
        'ADD COLUMN ${NamaKolom.tanggalMulaiBerhentiMerokok} TEXT',
      );
    }
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE ${NamaTabel.biodata} '
        'ADD COLUMN ${NamaKolom.batangPerBungkus} REAL',
      );
    }
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${NamaTabel.diaryCraving}(
          ${NamaKolom.id} TEXT PRIMARY KEY,
          ${NamaKolom.tanggal} TEXT,
          ${NamaKolom.pemicu} TEXT NOT NULL,
          ${NamaKolom.intensitas} INTEGER,
          ${NamaKolom.catatan} TEXT,
          ${NamaKolom.dibuat} TEXT
        )
      ''');
    }
    if (oldVersion < 6) {
      await db.execute(
        'ALTER TABLE ${NamaTabel.biodata} '
        'ADD COLUMN ${NamaKolom.modeBerhenti} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${NamaTabel.biodata} '
        'ADD COLUMN ${NamaKolom.penurunanPerMinggu} INTEGER',
      );
      await db.execute(
        'ALTER TABLE ${NamaTabel.biodata} '
        'ADD COLUMN ${NamaKolom.tanggalMulaiTapering} TEXT',
      );
    }
    if (oldVersion < 7) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${NamaTabel.alasanBerhenti}(
          ${NamaKolom.id} TEXT PRIMARY KEY,
          ${NamaKolom.teks} TEXT NOT NULL,
          ${NamaKolom.dibuat} TEXT
        )
      ''');
    }
    if (oldVersion < 8) {
      await db.execute(
        'ALTER TABLE ${NamaTabel.biodata} '
        'ADD COLUMN ${NamaKolom.targetSmokeFreeHari} INTEGER',
      );
    }
    // v9: tabel konsumsi_rokok. Tabel sos_intervensi dibuat di cabang v11 (lihat bawah)
    // agar setiap tabel didefinisikan tepat sekali pada kondisi versinya masing-masing.
    if (oldVersion < 9) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${NamaTabel.konsumsiRokok}(
          ${NamaKolom.id} TEXT PRIMARY KEY,
          ${NamaKolom.tanggal} TEXT NOT NULL,
          ${NamaKolom.jumlah} INTEGER NOT NULL DEFAULT 1,
          ${NamaKolom.isSlip} INTEGER NOT NULL DEFAULT 0,
          ${NamaKolom.catatan} TEXT,
          ${NamaKolom.dibuat} TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE INDEX IF NOT EXISTS idx_konsumsi_tanggal
        ON ${NamaTabel.konsumsiRokok}(${NamaKolom.tanggal})
      ''');
    }
    if (oldVersion < 10) {
      await db.execute(
        'ALTER TABLE ${NamaTabel.diaryCraving} '
        'ADD COLUMN ${NamaKolom.durasiMenit} INTEGER',
      );
      await db.execute(
        'ALTER TABLE ${NamaTabel.diaryCraving} '
        'ADD COLUMN ${NamaKolom.mood} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${NamaTabel.diaryCraving} '
        'ADD COLUMN ${NamaKolom.strategi} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${NamaTabel.diaryCraving} '
        'ADD COLUMN ${NamaKolom.hasil} TEXT',
      );
    }
    if (oldVersion < 11) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${NamaTabel.sosIntervensi}(
          ${NamaKolom.id} TEXT PRIMARY KEY,
          ${NamaKolom.jenisIntervensi} TEXT NOT NULL,
          ${NamaKolom.detail} TEXT,
          ${NamaKolom.hasilIntervensi} TEXT,
          ${NamaKolom.diaryCravingId} TEXT,
          ${NamaKolom.dibuat} TEXT NOT NULL
        )
      ''');
    }
    // v12: petakan nilai enum snake_case yang tersimpan ke lowerCamelCase.
    // Tanpa migrasi ini nilai lama tidak terparse oleh safeParseEnum.
    if (oldVersion < 12) {
      const pemetaanCraving = <String, String>{
        'napas_478': 'napas478',
        'minum_air': 'minumAir',
        'alih_aktivitas': 'alihAktivitas',
        'tunda_5_menit': 'tunda5Menit',
      };
      const pemetaanHasil = <String, String>{
        'berhasil_menahan': 'berhasilMenahan',
        'tetap_merokok': 'tetapMerokok',
        'belum_selesai': 'belumSelesai',
      };
      const pemetaanJenisIntervensi = <String, String>{
        'napas_478': 'napas478',
        'timer_3_menit': 'timer3Menit',
        'napas_box': 'napasBox',
        'napas_90_detik': 'napas90Detik',
        'grounding_54321': 'grounding54321',
        'urge_surfing': 'urgeSurfing',
        'timer_craving': 'timerCraving',
      };
      for (final entry in pemetaanCraving.entries) {
        await db.rawUpdate(
          'UPDATE ${NamaTabel.diaryCraving} '
          'SET ${NamaKolom.strategi} = ? '
          'WHERE ${NamaKolom.strategi} = ?',
          [entry.value, entry.key],
        );
      }
      for (final entry in pemetaanHasil.entries) {
        await db.rawUpdate(
          'UPDATE ${NamaTabel.diaryCraving} '
          'SET ${NamaKolom.hasil} = ? '
          'WHERE ${NamaKolom.hasil} = ?',
          [entry.value, entry.key],
        );
        await db.rawUpdate(
          'UPDATE ${NamaTabel.sosIntervensi} '
          'SET ${NamaKolom.hasilIntervensi} = ? '
          'WHERE ${NamaKolom.hasilIntervensi} = ?',
          [entry.value, entry.key],
        );
      }
      for (final entry in pemetaanJenisIntervensi.entries) {
        await db.rawUpdate(
          'UPDATE ${NamaTabel.sosIntervensi} '
          'SET ${NamaKolom.jenisIntervensi} = ? '
          'WHERE ${NamaKolom.jenisIntervensi} = ?',
          [entry.value, entry.key],
        );
      }
    }
    // v13: tabel rencana_darurat (if-then plan).
    if (oldVersion < 13) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ${NamaTabel.rencanaDarurat}(
          ${NamaKolom.id} TEXT PRIMARY KEY,
          ${NamaKolom.jika} TEXT NOT NULL,
          ${NamaKolom.maka} TEXT NOT NULL,
          ${NamaKolom.dibuat} TEXT NOT NULL
        )
      ''');
    }
    // v14: tambah kolom pemicu (TEXT, nullable) pada tabel konsumsi_rokok.
    if (oldVersion < 14) {
      await db.execute(
        'ALTER TABLE ${NamaTabel.konsumsiRokok} '
        'ADD COLUMN ${NamaKolom.pemicu} TEXT',
      );
    }
    // v15: perbaikan bug — database versi 14 yang dibuat melalui onCreate tidak
    // menyertakan kolom pemicu (hanya migrasi v14 yang menambahkannya).
    // Pemeriksaan PRAGMA table_info membuat migrasi ini aman untuk database
    // yang sudah memiliki kolom pemicu (hasil upgrade v13 → v14).
    if (oldVersion < 15) {
      final info = await db.rawQuery(
        'PRAGMA table_info(${NamaTabel.konsumsiRokok})',
      );
      final sudahAda = info.any((kolom) => kolom['name'] == NamaKolom.pemicu);
      if (!sudahAda) {
        await db.execute(
          'ALTER TABLE ${NamaTabel.konsumsiRokok} '
          'ADD COLUMN ${NamaKolom.pemicu} TEXT',
        );
      }
    }
  }

  /// Menutup database jika sedang terbuka.
  static Future<void> tutupDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
```


// ============================================================
// FILE: lib/shared/db/sqflite/sqflite_op.dart
// ============================================================

```dart
import 'package:berhenti_merokok/shared/db/sqflite/sqflite.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';

/// Operasi CRUD generik untuk database SQLite aplikasi.
///
/// Kelas ini membungkus akses ke [AppDatabase] dan menyediakan
/// metode standar untuk menambah, membaca, mengubah, dan menghapus
/// baris pada tabel yang ditentukan.
class SqfliteOp {
  const SqfliteOp();

  /// Menambahkan satu baris baru ke [tabel].
  ///
  /// Mengembalikan ID baris yang baru dimasukkan.
  Future<int> tambah(
    String tabel,
    Map<String, Object?> data, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    try {
      final db = await AppDatabase.database;
      final hasil = await db.insert(
        tabel,
        data,
        nullColumnHack: nullColumnHack,
        conflictAlgorithm: conflictAlgorithm,
      );
      L.s('Berhasil menambahkan data ke tabel $tabel');
      return hasil;
    } on Exception catch (e, s) {
      L.e('Gagal menambahkan data ke tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Mengambil seluruh baris dari [tabel].
  Future<List<Map<String, Object?>>> ambilSemua(
    String tabel, {
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await AppDatabase.database;
      return await db.query(
        tabel,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data dari tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Mengambil baris dari [tabel] dengan filter opsional.
  Future<List<Map<String, Object?>>> ambil(
    String tabel, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String>? columns,
    String? groupBy,
    String? having,
    bool? distinct,
  }) async {
    try {
      final db = await AppDatabase.database;
      return await db.query(
        tabel,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
        distinct: distinct,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data dari tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Mengambil satu baris pertama dari [tabel] dengan filter opsional.
  Future<Map<String, Object?>?> ambilSatu(
    String tabel, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    List<String>? columns,
  }) async {
    try {
      final db = await AppDatabase.database;
      final rows = await db.query(
        tabel,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: 1,
      );
      if (rows.isEmpty) {
        return null;
      }
      return rows.first;
    } on Exception catch (e, s) {
      L.e('Gagal mengambil satu data dari tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Mengubah baris pada [tabel] sesuai filter [where].
  ///
  /// Mengembalikan jumlah baris yang terpengaruh.
  Future<int> ubah(
    String tabel,
    Map<String, Object?> data, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    try {
      final db = await AppDatabase.database;
      final hasil = await db.update(
        tabel,
        data,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm,
      );
      L.s('Berhasil mengubah $hasil baris pada tabel $tabel');
      return hasil;
    } on Exception catch (e, s) {
      L.e('Gagal mengubah data pada tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Menghapus baris pada [tabel] sesuai filter [where].
  ///
  /// Mengembalikan jumlah baris yang terhapus.
  Future<int> hapus(
    String tabel, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await AppDatabase.database;
      final hasil = await db.delete(tabel, where: where, whereArgs: whereArgs);
      L.s('Berhasil menghapus $hasil baris pada tabel $tabel');
      return hasil;
    } on Exception catch (e, s) {
      L.e('Gagal menghapus data pada tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Menghitung jumlah baris pada [tabel] dengan filter opsional.
  Future<int> hitung(
    String tabel, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await AppDatabase.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) AS jumlah FROM $tabel'
        '${where == null ? '' : ' WHERE $where'}',
        whereArgs,
      );
      final jumlah = Sqflite.firstIntValue(result) ?? 0;
      return jumlah;
    } on Exception catch (e, s) {
      L.e('Gagal menghitung baris pada tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Menjalankan beberapa operasi dalam satu transaksi.
  Future<T> transaksi<T>(Future<T> Function(Transaction txn) aksi) async {
    try {
      final db = await AppDatabase.database;
      final hasil = await db.transaction(aksi);
      L.i('Transaksi pada database berhasil');
      return hasil;
    } on Exception catch (e, s) {
      L.e('Transaksi pada database gagal: $e $s');
      rethrow;
    }
  }

  /// Menjalankan SQL mentah (SELECT) dan mengembalikan hasilnya.
  Future<List<Map<String, Object?>>> queryRaw(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    try {
      final db = await AppDatabase.database;
      return await db.rawQuery(sql, arguments);
    } on Exception catch (e, s) {
      L.e('Gagal menjalankan query mentah: $e $s');
      rethrow;
    }
  }

  /// Menjalankan SQL mentah (INSERT/UPDATE/DELETE) dan mengembalikan
  /// jumlah baris yang terpengaruh.
  Future<int> executeRaw(String sql, [List<Object?>? arguments]) async {
    try {
      final db = await AppDatabase.database;
      return await db.rawUpdate(sql, arguments);
    } on Exception catch (e, s) {
      L.e('Gagal menjalankan perintah mentah: $e $s');
      rethrow;
    }
  }

  /// Menjalankan beberapa operasi dalam satu [Batch].
  ///
  /// Callback [isiBatch] digunakan untuk mengisi batch (insert/update/delete).
  /// Mengembalikan daftar hasil operasi.
  Future<List<Object?>> batch(
    void Function(Batch batch) isiBatch, {
    bool? noResult,
    bool? continueOnError,
  }) async {
    try {
      final db = await AppDatabase.database;
      final b = db.batch();
      isiBatch(b);
      final hasil = await b.commit(
        noResult: noResult,
        continueOnError: continueOnError,
      );
      L.i('Batch pada database berhasil dijalankan');
      return hasil;
    } on Exception catch (e, s) {
      L.e('Batch pada database gagal: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/shared/helper/shared_keys.dart
// ============================================================

```dart
/// Kunci penyimpanan yang digunakan bersama oleh aplikasi.
///
/// Kunci-kunci ini dipakai untuk mengakses nilai pada penyimpanan lokal
/// (misalnya `SharedPreferences`) secara konsisten di seluruh fitur.
class SharedKeys {
  SharedKeys._();

  /// Kunci untuk menyimpan preferensi tema aplikasi.
  static const String tema = 'tema';

  /// Kunci untuk menyimpan preferensi tema visual metafora impian.
  static const String temaVisualImpian = 'tema_visual_impian';

  /// Kunci untuk menyimpan status aktif pengingat harian.
  static const String notifikasiHarian = 'notifikasi_harian';

  /// Kunci untuk menyimpan jam pengingat harian.
  static const String notifikasiJam = 'notifikasi_jam';

  /// Kunci untuk menyimpan menit pengingat harian.
  static const String notifikasiMenit = 'notifikasi_menit';

  /// Kunci untuk menyimpan status aktif check-in pagi.
  static const String notifikasiCheckinPagi = 'notifikasi_checkin_pagi';

  /// Kunci untuk menyimpan jam check-in pagi.
  static const String notifikasiCheckinPagiJam = 'notifikasi_checkin_pagi_jam';

  /// Kunci untuk menyimpan menit check-in pagi.
  static const String notifikasiCheckinPagiMenit = 'notifikasi_checkin_pagi_menit';

  /// Kunci untuk menyimpan status aktif pengingat pola craving.
  static const String notifikasiPolaCraving = 'notifikasi_pola_craving';
}
```


// ============================================================
// FILE: lib/shared/konstanta/milestone_kesehatan.dart
// ============================================================

```dart
import 'package:berhenti_merokok/shared/konstanta/organ_pemulihan.dart';

/// Data satu milestone pemulihan kesehatan berdasarkan durasi smoke-free.
class MilestoneKesehatan {
  const MilestoneKesehatan({
    required this.target,
    required this.judul,
    required this.deskripsi,
    required this.organ,
  });

  final Duration target;
  final String judul;
  final String deskripsi;
  final OrganPemulihan organ;
}

/// Daftar milestone pemulihan kesehatan berdasarkan durasi smoke-free.
const List<MilestoneKesehatan> daftarMilestoneKesehatan = [
  MilestoneKesehatan(
    target: Duration(minutes: 20),
    judul: '20 Menit',
    deskripsi:
        'Tekanan darah dan denyut jantung mulai kembali ke tingkat normal.',
    organ: OrganPemulihan.jantung,
  ),
  MilestoneKesehatan(
    target: Duration(hours: 8),
    judul: '8 Jam',
    deskripsi:
        'Kadar karbon monoksida dalam darah turun ke tingkat normal, '
        'oksigen dalam darah meningkat.',
    organ: OrganPemulihan.sirkulasi,
  ),
  MilestoneKesehatan(
    target: Duration(hours: 24),
    judul: '24 Jam',
    deskripsi: 'Risiko serangan jantung mulai menurun.',
    organ: OrganPemulihan.jantung,
  ),
  MilestoneKesehatan(
    target: Duration(hours: 48),
    judul: '48 Jam',
    deskripsi:
        'Ujung saraf mulai tumbuh kembali, indra pengecapan dan '
        'penciuman membaik.',
    organ: OrganPemulihan.saraf,
  ),
  MilestoneKesehatan(
    target: Duration(hours: 72),
    judul: '72 Jam',
    deskripsi:
        'Bronkus rileks, kapasitas paru meningkat, energi tubuh bertambah.',
    organ: OrganPemulihan.paru,
  ),
  MilestoneKesehatan(
    target: Duration(days: 14),
    judul: '2 Minggu',
    deskripsi:
        'Sirkulasi darah membaik, fungsi paru meningkat, berjalan kaki '
        'menjadi lebih mudah.',
    organ: OrganPemulihan.sirkulasi,
  ),
  MilestoneKesehatan(
    target: Duration(days: 90),
    judul: '3 Bulan',
    deskripsi: 'Batuk dan sesak napas berkurang, paru-paru mulai pulih.',
    organ: OrganPemulihan.paru,
  ),
  MilestoneKesehatan(
    target: Duration(days: 270),
    judul: '9 Bulan',
    deskripsi:
        'Paru-paru telah pulih secara signifikan, energi dan stamina '
        'meningkat.',
    organ: OrganPemulihan.paru,
  ),
  MilestoneKesehatan(
    target: Duration(days: 365),
    judul: '1 Tahun',
    deskripsi:
        'Risiko penyakit jantung koroner turun setengah dibanding perokok.',
    organ: OrganPemulihan.jantung,
  ),
  MilestoneKesehatan(
    target: Duration(days: 1825),
    judul: '5 Tahun',
    deskripsi: 'Risiko stroke setara dengan orang yang tidak merokok.',
    organ: OrganPemulihan.sirkulasi,
  ),
  MilestoneKesehatan(
    target: Duration(days: 3650),
    judul: '10 Tahun',
    deskripsi: 'Risiko kanker paru turun setengah dibanding perokok aktif.',
    organ: OrganPemulihan.paru,
  ),
  MilestoneKesehatan(
    target: Duration(days: 5475),
    judul: '15 Tahun',
    deskripsi:
        'Risiko penyakit jantung koroner setara dengan orang yang tidak '
        'merokok.',
    organ: OrganPemulihan.jantung,
  ),
];

/// Mengembalikan milestone berikutnya yang belum tercapai berdasarkan durasi
/// smoke-free. Mengembalikan null jika semua milestone sudah tercapai.
MilestoneKesehatan? milestoneBerikutnya(Duration durasi) {
  for (final m in daftarMilestoneKesehatan) {
    if (durasi < m.target) return m;
  }
  return null;
}
```


// ============================================================
// FILE: lib/shared/konstanta/nama_kolom.dart
// ============================================================

```dart
/// Nama-nama kolom database SQLite aplikasi.
class NamaKolom {
  NamaKolom._();

  /// Kolom id biodata.
  static const String id = 'id';

  /// Kolom nama biodata.
  static const String nama = 'nama';

  /// Kolom tanggal lahir biodata.
  static const String tanggalLahir = 'tanggal_lahir';

  /// Kolom jumlah rokok per hari biodata.
  static const String jumlahRokokPerHari = 'jumlah_rokok_per_hari';

  /// Kolom harga rokok per bungkus biodata.
  static const String hargaRokokPerBungkus = 'harga_rokok_per_bungkus';

  /// Kolom batang rokok per bungkus biodata.
  static const String batangPerBungkus = 'batang_per_bungkus';

  /// Kolom tanggal mulai merokok biodata.
  static const String tanggalMulaiMerokok = 'tanggal_mulai_merokok';

  /// Kolom tanggal mulai berhenti merokok biodata.
  static const String tanggalMulaiBerhentiMerokok =
      'tanggal_mulai_berhenti_merokok';

  /// Kolom mode berhenti biodata (seketika/bertahap).
  static const String modeBerhenti = 'mode_berhenti';

  /// Kolom penurunan rokok per minggu untuk mode bertahap.
  static const String penurunanPerMinggu = 'penurunan_per_minggu';

  /// Kolom tanggal mulai rencana penurunan (tapering).
  static const String tanggalMulaiTapering = 'tanggal_mulai_tapering';

  /// Kolom target smoke-free (hari) pada biodata.
  static const String targetSmokeFreeHari = 'target_smoke_free_hari';

  // Kolom tabel impian.
  /// Kolom target tanggal impian.
  static const String targetTanggal = 'target_tanggal';

  /// Kolom tanggal dibuat impian.
  static const String dibuat = 'dibuat';

  /// Kolom jumlah impian.
  static const String jumlah = 'jumlah';

  // Kolom tabel diary craving.
  /// Kolom tanggal kejadian craving.
  static const String tanggal = 'tanggal';

  /// Kolom kategori pemicu craving.
  static const String pemicu = 'pemicu';

  /// Kolom intensitas craving (1-5).
  static const String intensitas = 'intensitas';

  /// Kolom catatan craving.
  static const String catatan = 'catatan';

  /// Kolom durasi craving dalam menit.
  static const String durasiMenit = 'durasi_menit';

  /// Kolom suasana hati saat craving.
  static const String mood = 'mood';

  /// Kolom strategi yang dicoba saat craving.
  static const String strategi = 'strategi';

  /// Kolom hasil dari craving.
  static const String hasil = 'hasil';

  /// Kolom teks alasan berhenti.
  static const String teks = 'teks';

  // Kolom tabel rencana_darurat.
  /// Kolom situasi pemicu (jika …) pada rencana darurat.
  static const String jika = 'jika';

  /// Kolom tindakan konkret (maka …) pada rencana darurat.
  static const String maka = 'maka';

  // Kolom tabel konsumsi_rokok.
  /// Kolom flag slip/relapse konsumsi rokok.
  static const String isSlip = 'is_slip';

  // Kolom tabel sos_intervensi.
  /// Kolom jenis intervensi SOS (napas478, timer3Menit, distraksi).
  static const String jenisIntervensi = 'jenis_intervensi';

  /// Kolom nama aktivitas distraksi yang dipilih (nullable).
  static const String detail = 'detail';

  /// Kolom hasil intervensi (berkurang, tetap, belumSelesai; nullable).
  static const String hasilIntervensi = 'hasil_intervensi';

  /// Kolom referensi entri diary craving (FK logis, nullable).
  static const String diaryCravingId = 'diary_craving_id';
}
```


// ============================================================
// FILE: lib/shared/konstanta/nama_tabel.dart
// ============================================================

```dart
/// Nama-nama tabel database SQLite aplikasi.
class NamaTabel {
  NamaTabel._();

  /// Tabel biodata.
  static const String biodata = 'biodata';

  /// Tabel impian.
  static const String impian = 'impian';

  /// Tabel diary craving (pemicu).
  static const String diaryCraving = 'diary_craving';

  /// Tabel catatan alasan berhenti (reasons vault).
  static const String alasanBerhenti = 'alasan_berhenti';

  /// Tabel pencatatan konsumsi rokok aktual.
  static const String konsumsiRokok = 'konsumsi_rokok';

  /// Tabel riwayat intervensi SOS Craving.
  static const String sosIntervensi = 'sos_intervensi';

  /// Tabel rencana darurat if-then (jika… maka…).
  static const String rencanaDarurat = 'rencana_darurat';
}
```


// ============================================================
// FILE: lib/shared/konstanta/organ_pemulihan.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

/// Sistem organ yang dipulihkan setelah berhenti merokok.
enum OrganPemulihan { jantung, paru, sirkulasi, saraf }

/// Extension label dan ikon untuk [OrganPemulihan].
extension OrganPemulihanExtension on OrganPemulihan {
  String get label {
    switch (this) {
      case OrganPemulihan.jantung:
        return 'Jantung';
      case OrganPemulihan.paru:
        return 'Paru-paru';
      case OrganPemulihan.sirkulasi:
        return 'Sirkulasi darah';
      case OrganPemulihan.saraf:
        return 'Saraf & indra';
    }
  }

  IconData get icon {
    switch (this) {
      case OrganPemulihan.jantung:
        return Icons.monitor_heart_outlined;
      case OrganPemulihan.paru:
        return Icons.air;
      case OrganPemulihan.sirkulasi:
        return Icons.water_drop_outlined;
      case OrganPemulihan.saraf:
        return Icons.psychology_alt_outlined;
    }
  }
}
```


// ============================================================
// FILE: lib/shared/notifikasi/notifikasi_service.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/home.dart';
import 'package:berhenti_merokok/shared/helper/shared_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Exception khusus ketika izin notifikasi tidak diberikan oleh sistem.
class IzinNotifikasiTidakDiberikanException implements Exception {
  const IzinNotifikasiTidakDiberikanException();
  @override
  String toString() => 'Izin notifikasi tidak diberikan';
}

/// Layanan notifikasi lokal untuk pengingat harian aplikasi.
class NotifikasiService {
  NotifikasiService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// ID notifikasi pengingat harian.
  static const int _idPengingatHarian = 1001;

  /// ID notifikasi uji coba (terpisah dari pengingat utama).
  static const int _idUjiCoba = 1002;

  /// ID notifikasi check-in pagi (terpisah dari pengingat harian).
  static const int _idCheckinPagi = 1003;

  /// ID notifikasi pengingat pola craving (terpisah dari pengingat harian).
  static const int _idPolaCraving = 1004;

  /// GlobalKey navigator untuk navigasi saat notifikasi ditekan.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Inisialisasi plugin notifikasi dan zona waktu.
  static Future<void> inisialisasi() async {
    L.i('NotifikasiService inisialisasi');
    // Bungkus inisialisasi database zona waktu dalam try/catch agar
    // kegagalan (termasuk Error/ArgumentError) tercatat dan tidak
    // menjadi unhandled error.
    try {
      tz.initializeTimeZones();
    } on Error catch (e, s) {
      L.e('Gagal inisialisasi zona waktu: $e $s');
    } on Exception catch (e, s) {
      L.e('Gagal inisialisasi zona waktu: $e $s');
    }
    // Deteksi zona waktu perangkat (WIB/WITA/WIT/dll.) agar pengingat
    // mengikuti waktu lokal pengguna. Package timezone tidak otomatis
    // mendeteksi zona waktu perangkat, sehingga gunakan flutter_timezone.
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      final identifier = info.identifier;
      L.i('zonaWaktuPerangkat=$identifier');
      // Validasi hasil sebelum penggunaan: identifier tidak boleh kosong.
      if (identifier.isEmpty) {
        throw ArgumentError('Identifier zona waktu kosong');
      }
      try {
        tz.setLocalLocation(tz.getLocation(identifier));
      } on Error catch (e, s) {
        L.w(
          'Identifier zona waktu tidak ditemukan di database tz, fallback Asia/Jakarta: $e $s',
        );
        try {
          tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
        } on Error catch (e2, s2) {
          L.w('Gagal set lokasi zona waktu fallback: $e2 $s2');
        } on Exception catch (e2, s2) {
          L.w('Gagal set lokasi zona waktu fallback: $e2 $s2');
        }
      } on Exception catch (e, s) {
        L.w(
          'Identifier zona waktu tidak ditemukan di database tz, fallback Asia/Jakarta: $e $s',
        );
        try {
          tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
        } on Error catch (e2, s2) {
          L.w('Gagal set lokasi zona waktu fallback: $e2 $s2');
        } on Exception catch (e2, s2) {
          L.w('Gagal set lokasi zona waktu fallback: $e2 $s2');
        }
      }
    } on Error catch (e, s) {
      L.w(
        'Gagal mendeteksi zona waktu perangkat, fallback Asia/Jakarta: $e $s',
      );
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      } on Error catch (e2, s2) {
        L.w('Gagal set lokasi zona waktu: $e2 $s2');
      } on Exception catch (e2, s2) {
        L.w('Gagal set lokasi zona waktu: $e2 $s2');
      }
    } on Exception catch (e, s) {
      L.w(
        'Gagal mendeteksi zona waktu perangkat, fallback Asia/Jakarta: $e $s',
      );
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      } on Error catch (e2, s2) {
        L.w('Gagal set lokasi zona waktu: $e2 $s2');
      } on Exception catch (e2, s2) {
        L.w('Gagal set lokasi zona waktu: $e2 $s2');
      }
    }

    const android = AndroidInitializationSettings('ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
    );
    const settings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin,
    );

    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: _onTapNotifikasi,
      );
      L.s('Plugin notifikasi berhasil diinisialisasi');
    } on UnsupportedError catch (e, s) {
      L.e('Platform tidak mendukung inisialisasi notifikasi: $e $s');
    } on Exception catch (e, s) {
      L.e('Gagal inisialisasi plugin notifikasi: $e $s');
      rethrow;
    }
  }

  static void _onTapNotifikasi(NotificationResponse response) {
    L.i('payload=${response.payload}');
    _navigasiDariPayload(response.payload);
  }

  /// Navigasi berdasarkan payload notifikasi (foreground/background).
  static void _navigasiDariPayload(String? payload, {int percobaan = 0}) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      if (percobaan < 3) {
        L.w('navigator null saat navigasi notifikasi, coba lagi');
        Future.delayed(const Duration(milliseconds: 100), () {
          _navigasiDariPayload(payload, percobaan: percobaan + 1);
        });
      } else {
        L.w('navigator null saat navigasi notifikasi, batalkan');
      }
      return;
    }

    String? kategori;
    String? id;
    if (payload != null) {
      for (final part in payload.split('&')) {
        final kv = part.split('=');
        if (kv.length == 2) {
          if (kv[0] == 'kategori') kategori = kv[1];
          if (kv[0] == 'id') id = kv[1];
        }
      }
    }
    L.i('kategori=$kategori, id=$id');

    final context = navigator.context;
    if (kategori == 'pengingat_harian' ||
        kategori == 'checkin_pagi' ||
        kategori == 'pola_craving') {
      unawaited(
        Nav.pushAndRemoveUntil(context, const Home()).catchError((
          Object e,
          StackTrace s,
        ) {
          L.e('Gagal navigasi dari notifikasi: $e $s');
          return null;
        }),
      );
    } else {
      L.w('kategori notifikasi tidak dikenal: $kategori');
    }
  }

  /// Menangani kondisi aplikasi diluncurkan dari keadaan terminated
  /// melalui notifikasi.
  static void cekNotifikasiSaatBuka() {
    // Platform yang tidak mendukung notifikasi terjadwal/launch details.
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      L.w('platform tidak mendukung cek notifikasi saat buka');
      return;
    }
    unawaited(
      Future(() async {
        try {
          final details = await _plugin.getNotificationAppLaunchDetails();
          if (details?.didNotificationLaunchApp ?? false) {
            final payload = details?.notificationResponse?.payload;
            if (payload != null && payload.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _navigasiDariPayload(payload);
              });
            }
          }
        } on UnsupportedError catch (e, s) {
          L.e('Platform tidak mendukung cek notifikasi saat buka: $e $s');
        } on Exception catch (e, s) {
          L.e('Gagal cek notifikasi saat buka: $e $s');
        }
      }).catchError((Object e, StackTrace s) {
        L.e('Gagal cek notifikasi saat buka: $e $s');
      }),
    );
  }

  /// Meminta izin notifikasi sesuai platform.
  /// Mengembalikan true jika izin diberikan.
  static Future<bool> mintaIzin() async {
    if (kIsWeb) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            WebFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return granted ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return granted ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    return true;
  }

  /// Menjadwalkan pengingat harian pada jam dan menit tertentu.
  static Future<void> jadwalkanPengingatHarian({
    required int jam,
    required int menit,
  }) async {
    L.i('jam=$jam, menit=$menit');
    // Platform yang tidak mendukung notifikasi terjadwal (Web, Linux, Windows).
    // macOS didukung plugin flutter_local_notifications v22.3.3 via zonedSchedule.
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      L.w('platform tidak mendukung penjadwalan terjadwal');
      throw UnsupportedError('Platform tidak mendukung notifikasi terjadwal');
    }
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      jam,
      menit,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pengingat_harian',
        'Pengingat Harian',
        channelDescription: 'Pengingat harian berhenti merokok',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        id: _idPengingatHarian,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: 'Berhenti Merokok',
        body: 'Jaga semangat! Cek progres smoke-free Anda hari ini.',
        payload: 'kategori=pengingat_harian&id=$_idPengingatHarian',
        matchDateTimeComponents: DateTimeComponents.time,
      );
      // Periksa izin sebelum menyimpan status aktif.
      final izinDiberikan = await _periksaIzinSistem();
      if (!izinDiberikan) {
        L.w('izin notifikasi tidak diberikan, batalkan penjadwalan');
        await _plugin.cancel(id: _idPengingatHarian);
        await setAktif(false);
        throw const IzinNotifikasiTidakDiberikanException();
      }
      // Simpan nilai lama untuk rollback bila penyimpanan gagal.
      final aktifLama = await aktif();
      final jamLama = await NotifikasiService.jam();
      final menitLama = await NotifikasiService.menit();
      // Urutan: setWaktu terlebih dahulu, lalu setAktif, agar status
      // aktif tidak tersimpan tanpa waktu yang sesuai. Bungkus keduanya
      // dengan rollback saat gagal agar preferensi tetap konsisten.
      try {
        await setWaktu(jam, menit);
        await setAktif(true);
      } on Exception catch (e, s) {
        L.e('Gagal menyimpan preferensi pengingat, rollback: $e $s');
        try {
          await setWaktu(jamLama, menitLama);
          await setAktif(aktifLama);
        } on Exception catch (e2, s2) {
          L.e('Gagal rollback preferensi pengingat: $e2 $s2');
        }
        // Batalkan jadwal sistem agar konsisten dengan preferensi.
        try {
          await _plugin.cancel(id: _idPengingatHarian);
        } on Exception catch (e2, s2) {
          L.e('Gagal membatalkan jadwal saat rollback: $e2 $s2');
        }
        rethrow;
      }
      L.s('Pengingat harian dijadwalkan jam=$jam:$menit');
    } on Exception catch (e, s) {
      L.e('Gagal menjadwalkan pengingat harian: $e $s');
      rethrow;
    }
  }

  /// Membatalkan pengingat harian.
  static Future<void> batalkanPengingatHarian() async {
    try {
      await _plugin.cancel(id: _idPengingatHarian);
      await setAktif(false);
      L.s('Pengingat harian dibatalkan');
    } on Exception catch (e, s) {
      L.e('Gagal membatalkan pengingat harian: $e $s');
      rethrow;
    }
  }

  /// Menjadwalkan check-in pagi pada jam dan menit tertentu.
  static Future<void> jadwalkanCheckinPagi({
    required int jam,
    required int menit,
  }) async {
    L.i('checkinPagi jam=$jam, menit=$menit');
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      L.w('platform tidak mendukung penjadwalan terjadwal');
      throw UnsupportedError('Platform tidak mendukung notifikasi terjadwal');
    }
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      jam,
      menit,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'checkin_pagi',
        'Check-in Pagi',
        channelDescription: 'Check-in pagi smoke-free',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        id: _idCheckinPagi,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: 'Check-in Pagi',
        body: 'Selamat pagi! Jaga komitmen smoke-free Anda hari ini.',
        payload: 'kategori=checkin_pagi&id=$_idCheckinPagi',
        matchDateTimeComponents: DateTimeComponents.time,
      );
      final izinDiberikan = await _periksaIzinSistem();
      if (!izinDiberikan) {
        L.w('izin notifikasi tidak diberikan, batalkan check-in pagi');
        await _plugin.cancel(id: _idCheckinPagi);
        await setAktifCheckinPagi(false);
        throw const IzinNotifikasiTidakDiberikanException();
      }
      final aktifLama = await aktifCheckinPagi();
      final jamLama = await jamCheckinPagi();
      final menitLama = await menitCheckinPagi();
      try {
        await setWaktuCheckinPagi(jam, menit);
        await setAktifCheckinPagi(true);
      } on Exception catch (e, s) {
        L.e('Gagal menyimpan preferensi check-in pagi, rollback: $e $s');
        try {
          await setWaktuCheckinPagi(jamLama, menitLama);
          await setAktifCheckinPagi(aktifLama);
        } on Exception catch (e2, s2) {
          L.e('Gagal rollback preferensi check-in pagi: $e2 $s2');
        }
        try {
          await _plugin.cancel(id: _idCheckinPagi);
        } on Exception catch (e2, s2) {
          L.e('Gagal membatalkan jadwal check-in pagi saat rollback: $e2 $s2');
        }
        rethrow;
      }
      L.s('Check-in pagi dijadwalkan jam=$jam:$menit');
    } on Exception catch (e, s) {
      L.e('Gagal menjadwalkan check-in pagi: $e $s');
      rethrow;
    }
  }

  /// Membatalkan check-in pagi.
  static Future<void> batalkanCheckinPagi() async {
    try {
      await _plugin.cancel(id: _idCheckinPagi);
      await setAktifCheckinPagi(false);
      L.s('Check-in pagi dibatalkan');
    } on Exception catch (e, s) {
      L.e('Gagal membatalkan check-in pagi: $e $s');
      rethrow;
    }
  }

  /// Menjadwalkan pengingat pola craving pada jam tertentu.
  static Future<void> jadwalkanPolaCraving(int jam) async {
    L.i('polaCraving jam=$jam');
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      L.w('platform tidak mendukung penjadwalan terjadwal');
      throw UnsupportedError('Platform tidak mendukung notifikasi terjadwal');
    }
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      jam,
      0,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pola_craving',
        'Pengingat Pola Craving',
        channelDescription: 'Pengingat berbasis pola jam craving',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        id: _idPolaCraving,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: 'Pengingat Pola Craving',
        body: 'Ini biasanya jam Anda mengalami craving. Tetap semangat!',
        payload: 'kategori=pola_craving&id=$_idPolaCraving',
        matchDateTimeComponents: DateTimeComponents.time,
      );
      final izinDiberikan = await _periksaIzinSistem();
      if (!izinDiberikan) {
        L.w('izin notifikasi tidak diberikan, batalkan pola craving');
        await _plugin.cancel(id: _idPolaCraving);
        await setAktifPolaCraving(false);
        throw const IzinNotifikasiTidakDiberikanException();
      }
      final aktifLama = await aktifPolaCraving();
      try {
        await setAktifPolaCraving(true);
      } on Exception catch (e, s) {
        L.e('Gagal menyimpan preferensi pola craving, rollback: $e $s');
        try {
          await setAktifPolaCraving(aktifLama);
        } on Exception catch (e2, s2) {
          L.e('Gagal rollback preferensi pola craving: $e2 $s2');
        }
        try {
          await _plugin.cancel(id: _idPolaCraving);
        } on Exception catch (e2, s2) {
          L.e('Gagal membatalkan jadwal pola craving saat rollback: $e2 $s2');
        }
        rethrow;
      }
      L.s('Pengingat pola craving dijadwalkan jam=$jam:00');
    } on Exception catch (e, s) {
      L.e('Gagal menjadwalkan pola craving: $e $s');
      rethrow;
    }
  }

  /// Membatalkan pengingat pola craving.
  static Future<void> batalkanPolaCraving() async {
    try {
      await _plugin.cancel(id: _idPolaCraving);
      await setAktifPolaCraving(false);
      L.s('Pengingat pola craving dibatalkan');
    } on Exception catch (e, s) {
      L.e('Gagal membatalkan pola craving: $e $s');
      rethrow;
    }
  }

  /// Menampilkan notifikasi langsung (untuk uji coba).
  static Future<void> tampilkanSekarang() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pengingat_harian',
        'Pengingat Harian',
        channelDescription: 'Pengingat harian berhenti merokok',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );
    try {
      await _plugin.show(
        id: _idUjiCoba,
        title: 'Berhenti Merokok',
        body: 'Jaga semangat! Cek progres smoke-free Anda hari ini.',
        notificationDetails: details,
        payload: 'kategori=pengingat_harian&id=$_idUjiCoba',
      );
      L.s('Notifikasi langsung ditampilkan');
    } on Exception catch (e, s) {
      L.e('Gagal menampilkan notifikasi: $e $s');
      rethrow;
    }
  }

  // --- Preferensi SharedPreferences ---

  static Future<bool> aktif() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedKeys.notifikasiHarian) ?? false;
  }

  static Future<void> setAktif(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedKeys.notifikasiHarian, value);
  }

  static Future<int> jam() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedKeys.notifikasiJam) ?? 8;
  }

  static Future<int> menit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedKeys.notifikasiMenit) ?? 0;
  }

  static Future<void> setWaktu(int jam, int menit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedKeys.notifikasiJam, jam);
    await prefs.setInt(SharedKeys.notifikasiMenit, menit);
  }

  // --- Preferensi Check-in Pagi ---

  static Future<bool> aktifCheckinPagi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedKeys.notifikasiCheckinPagi) ?? false;
  }

  static Future<void> setAktifCheckinPagi(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedKeys.notifikasiCheckinPagi, value);
  }

  static Future<int> jamCheckinPagi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedKeys.notifikasiCheckinPagiJam) ?? 7;
  }

  static Future<int> menitCheckinPagi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(SharedKeys.notifikasiCheckinPagiMenit) ?? 0;
  }

  static Future<void> setWaktuCheckinPagi(int jam, int menit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedKeys.notifikasiCheckinPagiJam, jam);
    await prefs.setInt(SharedKeys.notifikasiCheckinPagiMenit, menit);
  }

  // --- Preferensi Pola Craving ---

  static Future<bool> aktifPolaCraving() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedKeys.notifikasiPolaCraving) ?? false;
  }

  static Future<void> setAktifPolaCraving(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedKeys.notifikasiPolaCraving, value);
  }

  /// Jadwalkan ulang pengingat jika aktif (dipanggil saat app start).
  static Future<void> jadwalkanUlangJikaAktif() async {
    try {
      // Pengingat harian existing.
      final isAktif = await aktif();
      L.i('pengingatHarian isAktif=$isAktif');
      if (isAktif) {
        final izinDiberikan = await _periksaIzinSistem();
        if (!izinDiberikan) {
          L.w('izin notifikasi tidak diberikan, nonaktifkan pengingat harian');
          await setAktif(false);
        } else {
          final j = await jam();
          final m = await menit();
          await jadwalkanPengingatHarian(jam: j, menit: m);
        }
      }

      // Check-in pagi.
      final isCheckinPagiAktif = await aktifCheckinPagi();
      L.i('checkinPagi isAktif=$isCheckinPagiAktif');
      if (isCheckinPagiAktif) {
        final izinDiberikan = await _periksaIzinSistem();
        if (!izinDiberikan) {
          L.w('izin notifikasi tidak diberikan, nonaktifkan check-in pagi');
          await setAktifCheckinPagi(false);
        } else {
          final j = await jamCheckinPagi();
          final m = await menitCheckinPagi();
          await jadwalkanCheckinPagi(jam: j, menit: m);
        }
      }
    } on Exception catch (e, s) {
      L.e('Gagal menjadwalkan ulang pengingat harian/check-in pagi: $e $s');
    } on UnsupportedError catch (e, s) {
      L.e('Platform tidak mendukung penjadwalan ulang: $e $s');
    }
  }

  /// Memeriksa status izin notifikasi pada sistem tanpa meminta.
  static Future<bool> _periksaIzinSistem() async {
    if (kIsWeb) {
      // Web tidak mendukung pengecekan izin tanpa prompt; anggap tersedia.
      return true;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final impl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final enabled = await impl?.areNotificationsEnabled();
      return enabled ?? false;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final impl = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final settings = await impl?.checkPermissions();
      return settings?.isEnabled ?? false;
    }
    return true;
  }
}
```


// ============================================================
// FILE: lib/shared/widget/empty_state_view.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

/// Komponen empty state bersama: ikon + judul + deskripsi + CTA opsional.
///
/// Dipakai pada kondisi "belum ada data" di layar daftar maupun layar
/// non-daftar agar pola tampilan konsisten. Widget bersifat pure (tidak
/// membaca provider); pemanggil yang menyediakan teks dan aksi.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.ikon,
    required this.judul,
    required this.deskripsi,
    this.ctaLabel,
    this.onCta,
  }) : assert(
         (ctaLabel == null) == (onCta == null),
         'ctaLabel dan onCta harus diisi berpasangan atau keduanya null',
       );

  final IconData ikon;
  final String judul;
  final String deskripsi;

  /// Label tombol CTA. Wajib berpasangan dengan [onCta].
  final String? ctaLabel;

  /// Aksi tombol CTA, misalnya navigasi ke form tambah atau pemulihan data.
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Icon(
                ikon,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              Text(
                judul,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                deskripsi,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (ctaLabel != null && onCta != null)
                OutlinedButton(
                  onPressed: onCta,
                  child: Text(ctaLabel!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```


