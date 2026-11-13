---
name: ekspor-pemulihan-cadangan
description: "Trigger: saat mengelola ekspor atau pemulihan data cadangan lokal | Panduan: transaksi DB atomic, exception khusus, cek platform, flag double submit, unawaited catchError, mounted check, refresh provider, isDestructiveAction, hapus file parsial gagal."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Ekspor dan Pemulihan Data Cadangan Lokal

Pemulihan dalam transaksi atomic, exception khusus, cek platform, flag double submit, unawaited catchError, mounted check, refresh provider, konfirmasi destruktif, AppToast.

## Cakupan yang Di-Cover

- Package: `package:sqflite` (class `Database`, `Transaction`), `package:flutter_riverpod` (class `ref`, `ConsumerStatefulWidget`), `package:easyloading` (class `EasyLoading`, `EasyLoadingMaskType`), `package:shared_preferences` (class `SharedPreferences`), `package:adaptive_dialog` (class `showOkCancelAlertDialog`, `OkCancelResult`)
- Class: `SqfliteOp`, `BerkasCadanganTidakValidException`, `EasyLoading`, `AppToast`, `L`, `Nav`
- Method: `op.transaksi()`, `op.hapus()`, `ref.refresh()`, `EasyLoading.show()`, `EasyLoading.dismiss()`, `showOkCancelAlertDialog()`, `SharedPreferences.getInstance()`
- Properti: `_sedangMemproses`, `mounted`, `isDestructiveAction`

## Aturan

1. Pemulihan data wajib dalam satu transaksi DB (`op.transaksi`) hapus lama → masuk baru, atomik konsisten.
2. Berkas cadangan tidak valid → exception khusus (class implements `Exception`), bukan string matching.
3. Cek platform (`kIsWeb`, `defaultTargetPlatform`) sebelum operasi berkas. Platform tidak didukung → warning, tidak crash.
4. Operasi async berulang (ekspor/pemulihan) dilindungi flag `_sedangMemproses` dicek awal, dikembalikan `finally` termasuk error.
5. unawaited (EasyLoading show/dismiss, Nav.to) wajib `.catchError(...)` log via `L.e`.
6. Setelah `await` wajib cek `mounted` sebelum akses context/setState.
7. Setelah pemulihan berhasil, refresh SEMUA provider yang datanya ikut dipulihkan via `ref.refresh()`, masing-masing dalam try/catch `L.e` — bukan hanya sebagian. Daftar minimal saat ini: `biodataProvider`, `impianProvider`, `diaryCravingProvider`, `alasanBerhentiProvider`, `konsumsiRokokProvider`, `sosIntervensiProvider`, `rencanaDaruratProvider`. Bila menambah tabel ke `tabelCadangan`, provider-nya WAJIB ikut ditambahkan ke `_refreshProviderSetelahRestore` (cadangan_screen.dart) — menambah tabel cadangan tanpa refresh provider membuat UI menampilkan data usang setelah pemulihan.
7a. Ekspor (`CadanganHelper.eksporKePayload`) wajib menyertakan SELURUH tabel yang dideklarasikan di `tabelCadangan` (`biodata`, `impian`, `diaryCraving`, `alasanBerhenti`, `konsumsiRokok`, `sosIntervensi`, `rencanaDarurat`) beserta pencatatan jumlah baris tiap tabel di log (`L.i`). Tabel baru yang ditambahkan ke skema wajib dievaluasi apakah termasuk cadangan; bila ya, tambahkan ke `tabelCadangan` sekaligus ke refresh provider di aturan 7.
8. Operasi destruktif (pemulihan ganti data) wajib dialog konfirmasi `showOkCancelAlertDialog` dengan `isDestructiveAction: true`.
9. Feedback pakai `AppToast` (sukses/gagal/info), bukan `Fluttertoast` langsung.
10. Berkas parsial gagal ditulis wajib dihapus.

## Larangan

- Jangan pemulihan tanpa transaksi DB.
- Jangan string literal untuk nama exception deteksi.
- Jangan tampilkan kontrol ekspor/pemulihan di platform tidak mendukung.
- Jangan unawaited EasyLoading tanpa catchError.
- Jangan abaikan mounted check setelah await.
- Jangan simpan status berhasil sebelum operasi benar-benar selesai.

## Contoh Benar

```dart
class BerkasCadanganTidakValidException implements Exception {
  const BerkasCadanganTidakValidException(this.pesan);
  final String pesan;
  @override String toString() => 'Berkas cadangan tidak valid: $pesan';
}

class _CadanganBenarState extends ConsumerState<CadanganBenar> {
  bool _sedangMemproses = false;

  Future<void> _pulihkan() async {
    if (_sedangMemproses) return;
    setState(() => _sedangMemproses = true);

    try {
      await EasyLoading.show(status: 'Memproses...', maskType: EasyLoadingMaskType.black)
          .catchError((e, s) => L.e('Gagal loading: $e $s'));

      // Konfirmasi destruktif
      final konfirmasi = await showOkCancelAlertDialog(
        context: context, title: 'Pulihkan Cadangan',
        message: 'Data akan diganti. Lanjutkan?',
        okLabel: 'Pulihkan', cancelLabel: 'Batal',
        isDestructiveAction: true,
      );
      if (konfirmasi != OkCancelResult.ok) return;

      // Transaksi atomic
      final op = SqfliteOp();
      await op.transaksi((txn) async {
        for (final tabel in ['tabel1', 'tabel2']) {
          await txn.delete(tabel);
          L.i('Hapus data lama tabel $tabel');
        }
        // insert data baru...
      });

      // Refresh SEMUA provider yang datanya dipulihkan
      for (final provider in [biodataProvider, impianProvider, diaryCravingProvider, alasanBerhentiProvider, konsumsiRokokProvider, sosIntervensiProvider, rencanaDaruratProvider]) {
        try { ref.refresh(provider); } on Exception catch (e, s) { L.e('Gagal refresh provider: $e $s'); }
      }

      AppToast.sukses(context, 'Cadangan berhasil dipulihkan');
    } on BerkasCadanganTidakValidException catch (e) {
      AppToast.gagal(context, e.toString());
    } finally {
      unawaited(EasyLoading.dismiss().catchError((e, s) => L.e('Gagal dismiss: $e $s')));
      if (mounted) setState(() => _sedangMemproses = false);
    }
  }
}
```

## Contoh Salah

```dart
// DILARANG: Pemulihan tanpa transaksi atomic
final op = SqfliteOp();
for (final tabel in ['tabel1', 'tabel2']) {
  await op.hapusSemua(tabel);
  await op.tambah(tabel, {}); // Jika gagal di tengah, data rusak
}

// DILARANG: String matching untuk error
try {} catch (e) { if (e.toString().contains('invalid')) {} }

// DILARANG: unawaited tanpa catchError
unawaited(EasyLoading.show(status: 'Memproses...'));
unawaited(EasyLoading.dismiss());

// DILARANG: Tidak cek mounted setelah await
Navigator.pop(context);

// DILARANG: Tidak refresh provider setelah sukses
```

## Sumber Evaluasi

- File: `lib/fitur/cadangan/helper/cadangan_helper.dart`, `lib/fitur/cadangan/screens/cadangan_screen.dart`, `lib/fitur/pengaturan/screens/pengaturan_screen.dart`
- Class terkait: `SqfliteOp`, `BerkasCadanganTidakValidException`, `EasyLoading`, `AppToast`, `L`, `Nav`
- Commit rujukan: `338a0216257bb9f75617f144fd2fae0d7faf63d2` — Konfirmasi pemulihan cadangan (destruktif); `2462af81050e12b2933717f457a33a5b05d3719f` — ekspor seluruh tabel (konsumsi_rokok, sos_intervensi, rencana_darurat); `50c1be708e595449fa2fd18e3491d4418943c565` — refresh provider konsumsiRokok/sosIntervensi/rencanaDarurat setelah restore
