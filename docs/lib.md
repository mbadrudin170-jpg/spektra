// ============================================================
// FILE: lib/app.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/screens/form_biodata.dart';
import 'package:berhenti_merokok/fitur/tema/enum/tema_enum.dart';
import 'package:berhenti_merokok/fitur/tema/notifier/tema_notifier.dart';
import 'package:berhenti_merokok/home.dart';
import 'package:berhenti_merokok/shared/notifikasi/notifikasi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' as mui;
import 'package:share_global_saya/core_shared.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    L.init(ref.container);
    unawaited(
      NotifikasiService.jadwalkanUlangJikaAktif().catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        L.e('Gagal menjadwalkan ulang notifikasi: $error $stackTrace');
      }),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final temaAsync = ref.watch(temaProvider);
    final tema = temaAsync.asData?.value ?? TemaEnum.sistem;

    final themeMode = switch (tema) {
      TemaEnum.terang => ThemeMode.light,
      TemaEnum.gelap => ThemeMode.dark,
      TemaEnum.sistem => ThemeMode.system,
    };

    final biodataAsync = ref.watch(biodataProvider);

    Widget home;
    if (biodataAsync.isLoading) {
      home = const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (biodataAsync.hasError) {
      home = Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Gagal memuat data'),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  final _ = ref.refresh(biodataProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    } else {
      final biodata = biodataAsync.asData?.value;
      home = biodata == null
          ? const FormBiodata(buatPertama: true)
          : const Home();
    }

    final brightness = switch (themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };
    final materialUiTheme = mui.ThemeData.from(
      colorScheme: mui.ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      ),
    );

    return mui.Theme(
      data: materialUiTheme,
      child: MaterialApp(
        navigatorKey: NotifikasiService.navigatorKey,
        title: 'Berhenti Merokok',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        themeMode: themeMode,
        supportedLocales: const [Locale('id', 'ID')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          _MaterialUiLocalizationsDelegate(),
        ],
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        darkTheme: ThemeData(
          colorScheme: .fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        home: PengelolaOverlayLogDebug(child: home),
      ),
    );
  }
}

// Delegate khusus untuk material_ui.MaterialLocalizations agar adaptive_dialog
// dapat memperoleh instance non-null pada locale 'id' (delegate bawaan
// material_ui hanya mendukung locale 'en').
class _MaterialUiLocalizationsDelegate
    extends LocalizationsDelegate<mui.MaterialLocalizations> {
  const _MaterialUiLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<mui.MaterialLocalizations> load(Locale locale) =>
      mui.DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<mui.MaterialLocalizations> old,
  ) => false;
}
```


// ============================================================
// FILE: lib/fitur/alasan_berhenti/model/alasan_berhenti_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/alasan_berhenti/notifier/alasan_berhenti_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/alasan_berhenti/model/alasan_berhenti_model.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/state/alasan_berhenti_state.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'alasan_berhenti_notifier.g.dart';

@Riverpod(keepAlive: true)
class AlasanBerhentiNotifier extends _$AlasanBerhentiNotifier {
  @override
  Future<AlasanBerhentiState> build() async {
    return await _ambilSemua();
  }

  Future<AlasanBerhentiState> _ambilSemua() async {
    try {
      final op = const SqfliteOp();
      final rows = await op.ambilSemua(
        NamaTabel.alasanBerhenti,
        orderBy: '${NamaKolom.dibuat} DESC',
      );
      final daftar = rows.map(AlasanBerhentiModel.fromSqflite).toList();
      L.i('daftar.length=${daftar.length}');
      return AlasanBerhentiState(
        listAlasan: daftar,
        jumlahAlasan: daftar.length,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data alasan berhenti: $e $s');
      rethrow;
    }
  }

  Future<void> tambah(String teks) async {
    L.i('teks=$teks');
    try {
      final dataLama = await future;
      final model = AlasanBerhentiModel(
        id: const Uuid().v4(),
        teks: teks,
        dibuat: DateTime.now(),
      );
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.alasanBerhenti,
        model.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      state = AsyncValue.data(
        AlasanBerhentiState(
          listAlasan: [model, ...dataLama.listAlasan],
          jumlahAlasan: dataLama.jumlahAlasan + 1,
        ),
      );
      L.s('Alasan berhenti berhasil disimpan');
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan alasan berhenti: $e $s');
      rethrow;
    }
  }

  Future<void> ubah(AlasanBerhentiModel model) async {
    L.i('model=$model');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.ubah(
        NamaTabel.alasanBerhenti,
        model.toSqflite(),
        where: '${NamaKolom.id} = ?',
        whereArgs: [model.id],
      );
      final baru = dataLama.listAlasan
          .map((e) => e.id == model.id ? model : e)
          .toList();
      state = AsyncValue.data(
        AlasanBerhentiState(listAlasan: baru, jumlahAlasan: baru.length),
      );
      L.s('Alasan berhenti berhasil diubah');
    } on Exception catch (e, s) {
      L.e('Gagal mengubah alasan berhenti: $e $s');
      rethrow;
    }
  }

  Future<void> hapus(String id) async {
    L.i('id=$id');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.hapus(
        NamaTabel.alasanBerhenti,
        where: '${NamaKolom.id} = ?',
        whereArgs: [id],
      );
      final baru = dataLama.listAlasan.where((e) => e.id != id).toList();
      state = AsyncValue.data(
        AlasanBerhentiState(listAlasan: baru, jumlahAlasan: baru.length),
      );
      L.s('Alasan berhenti berhasil dihapus');
    } on Exception catch (e, s) {
      L.e('Gagal menghapus alasan berhenti: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/alasan_berhenti/screens/alasan_berhenti_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/model/alasan_berhenti_model.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/notifier/alasan_berhenti_notifier.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/screens/form_alasan_berhenti.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

class AlasanBerhentiScreen extends ConsumerStatefulWidget {
  const AlasanBerhentiScreen({super.key});

  @override
  ConsumerState<AlasanBerhentiScreen> createState() =>
      _AlasanBerhentiScreenState();
}

class _AlasanBerhentiScreenState extends ConsumerState<AlasanBerhentiScreen> {
  @override
  void initState() {
    super.initState();
    L.i('AlasanBerhentiScreen initState');
  }

  @override
  void dispose() {
    L.i('AlasanBerhentiScreen dispose');
    super.dispose();
  }

  void _navigasiKeForm() {
    unawaited(
      Nav.to(context, const FormAlasanBerhenti()).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Form Alasan Berhenti: $e $s');
        return null;
      }),
    );
  }

  Future<void> _hapus(AlasanBerhentiModel item) async {
    L.i('item.id=${item.id}');
    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Alasan',
      message: 'Apakah Anda yakin ingin menghapus alasan berhenti ini?',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      return;
    }
    if (!mounted) return;
    try {
      await ref.read(alasanBerhentiProvider.notifier).hapus(item.id);
      if (mounted) {
        AppToast.sukses(context, 'Alasan berhenti berhasil dihapus');
      }
    } on Exception catch (e, s) {
      L.e('Gagal menghapus alasan berhenti: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menghapus alasan berhenti');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final alasanAsync = ref.watch(alasanBerhentiProvider);
    L.i(
      'alasanAsync.isLoading=${alasanAsync.isLoading}, hasError=${alasanAsync.hasError}',
    );

    if (alasanAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (alasanAsync.hasError) {
      L.w('alasanBerhentiProvider error=${alasanAsync.error}');
      return Scaffold(
        appBar: AppBar(title: const Text('Alasan Berhenti')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              const Text('Gagal memuat data alasan berhenti'),
              OutlinedButton(
                onPressed: () {
                  final _ = ref.refresh(alasanBerhentiProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final state = alasanAsync.requireValue;
    final list = state.listAlasan;
    L.i('list.length=${list.length}');

    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Alasan Berhenti')),
        body: EmptyStateView(
          ikon: CupertinoIcons.heart,
          judul: 'Belum ada alasan berhenti',
          deskripsi:
              'Catat alasan kamu ingin berhenti agar mudah diingat saat '
              'dorongan merokok muncul.',
          ctaLabel: 'Tambah Alasan',
          onCta: _navigasiKeForm,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigasiKeForm,
          child: const Icon(CupertinoIcons.add),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Alasan Berhenti')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              L.i('item.id=${item.id}, item.teks=${item.teks}');
              return Card(
                key: ValueKey(item.id),
                child: ListTile(
                  title: Text(item.teks),
                  subtitle: Text(FormatWaktuLengkap.formatSingkat(item.dibuat)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Hapus',
                    onPressed: () => unawaited(_hapus(item)),
                  ),
                  onTap: () => unawaited(
                    Nav.to(context, FormAlasanBerhenti(alasan: item)),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigasiKeForm,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}


```


// ============================================================
// FILE: lib/fitur/alasan_berhenti/screens/form_alasan_berhenti.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/model/alasan_berhenti_model.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/notifier/alasan_berhenti_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Daftar pilihan cepat alasan umum (snippet) yang dapat dipilih pengguna.
const List<String> _snippetAlasan = [
  'Menjaga kesehatan paru-paru dan jantung',
  'Menghemat uang untuk kebutuhan keluarga',
  'Memberi contoh baik bagi anak/keluarga',
  'Menghindari bau rokok dan gigi kuning',
  'Meningkatkan stamina dan kebugaran',
  'Menepati janji pada diri sendiri',
  'Mengurangi risiko penyakit serius',
  'Hidup lebih lama dan berkualitas',
];

class FormAlasanBerhenti extends ConsumerStatefulWidget {
  final AlasanBerhentiModel? alasan;
  const FormAlasanBerhenti({super.key, this.alasan});

  @override
  ConsumerState<FormAlasanBerhenti> createState() => _FormAlasanBerhentiState();
}

class _FormAlasanBerhentiState extends ConsumerState<FormAlasanBerhenti> {
  final _formKey = GlobalKey<FormState>();
  final _teksController = TextEditingController();
  final _teksFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final alasan = widget.alasan;
    L.i('alasan=$alasan');
    if (alasan != null) {
      _teksController.text = alasan.teks;
      L.i('_teksController.text=${_teksController.text}');
    }
  }

  @override
  void dispose() {
    _teksController.dispose();
    _teksFocusNode.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (_isLoading) {
      L.w('Form alasan berhenti masih loading, simpan diabaikan');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      L.w('validasi form gagal');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Simpan Alasan',
      message: 'Apakah Anda yakin ingin menyimpan alasan berhenti ini?',
      okLabel: 'Simpan',
      cancelLabel: 'Batal',
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      L.w('konfirmasi bukan ok');
      return;
    }
    if (!mounted) return;

    setState(() => _isLoading = true);
    L.i('_isLoading=$_isLoading');
    unawaited(
      EasyLoading.show(
        status: 'Menyimpan...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
        return null;
      }),
    );
    try {
      final teks = _teksController.text.trim();
      L.i('teks=$teks');
      if (widget.alasan == null) {
        L.i('alasan null, tambah');
        await ref.read(alasanBerhentiProvider.notifier).tambah(teks);
      } else {
        L.i('alasan tidak null, ubah');
        final model = AlasanBerhentiModel(
          id: widget.alasan!.id,
          teks: teks,
          dibuat: widget.alasan!.dibuat,
        );
        await ref.read(alasanBerhentiProvider.notifier).ubah(model);
      }
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Nav.pop(context);
      }
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan alasan berhenti: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menyimpan alasan berhenti');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
          return null;
        }),
      );
      if (mounted) {
        setState(() => _isLoading = false);
        L.i('_isLoading=$_isLoading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alasan == null ? 'Tambah Alasan' : 'Ubah Alasan'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Text(
                  'Pilihan cepat (opsional)',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _snippetAlasan.map((snippet) {
                    final terpilih = _teksController.text.trim() == snippet;
                    L.i('snippet=$snippet, terpilih=$terpilih');
                    return FilterChip(
                      label: Text(snippet),
                      selected: terpilih,
                      onSelected: (dipilih) {
                        L.i('snippet dipilih=$snippet, dipilih=$dipilih');
                        setState(() {
                          _teksController.text = dipilih ? snippet : '';
                        });
                      },
                    );
                  }).toList(),
                ),
                InputTeks(
                  controller: _teksController,
                  label: 'Alasan berhenti',
                  hintText: 'Tulis alasan Anda berhenti merokok',
                  focusNode: _teksFocusNode,
                  wajib: true,
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _simpan, child: const Text('Simpan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/alasan_berhenti/state/alasan_berhenti_state.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/alasan_berhenti/model/alasan_berhenti_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alasan_berhenti_state.freezed.dart';

@freezed
abstract class AlasanBerhentiState with _$AlasanBerhentiState {
  const AlasanBerhentiState._();

  const factory AlasanBerhentiState({
    @Default([]) List<AlasanBerhentiModel> listAlasan,
    @Default(0) int jumlahAlasan,
  }) = _AlasanBerhentiState;
}
```


// ============================================================
// FILE: lib/fitur/badge/helper/badge_helper.dart
// ============================================================

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Representasi satu badge/pencapaian pengguna.
class BadgePencapaian {
  const BadgePencapaian({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.icon,
    required this.tercapai,
  });

  final String id;
  final String nama;
  final String deskripsi;
  final IconData icon;
  final bool tercapai;
}

/// Nama key SharedPreferences untuk badge yang pernah tercapai.
///
/// Badge yang pernah tercapai **tidak pernah dicoret** dari pencapaian
/// pengguna hanya karena slip berikutnya; nilainya digabungkan kembali saat
/// daftar badge dihitung.
const String keyBadgeTercapaiHistoris = 'badge_tercapai_historis';

/// Menghitung daftar badge berdasarkan progres smoke-free pengguna.
///
/// Metrik **durasi** ([hariSmokeFree]) memakai baseline kumulatif dan tidak
/// direset slip. Metrik **rokok/uang** memakai aktual dari catatan konsumsi
/// ([rokokDihindariAktual]/[uangDihematAktual]) bila ada hari tercatat
/// ([hariTercatat] > 0), fallback ke baseline
/// ([rokokTidakDiHisapEstimasi]/[uangDihematEstimasi]) bila belum ada;
/// labelnya tercermin pada deskripsi badge ("dari catatan" / "estimasi").
///
/// Badge yang pernah tercapai tidak hilang dari daftar pencapaian, meskipun
/// metrik aktual turun karena slip berikutnya: [badgeTercapaiHistoris]
/// berisi id badge yang pernah tercapai (disimpan di SharedPreferences) dan
/// digabungkan ke status `tercapai` badge yang bersangkutan.
///
/// Badge baru bersifat **additif dan non-pemalukan**: streak bebas rokok
/// ([streakHariIni]), konsistensi pencatatan ([streakPencatatan]), dan
/// target tapering per minggu ([taperingTercapai]). Tidak ada badge
/// "gagal", "slip", atau "kembali ke nol".
///
/// [taperingTercapai] berisi 4 bool; elemen ke-`i` menyatakan tercapainya
/// target tapering minggu ke-`i + 1` (sudah melewati/berjalan di minggu
/// tersebut dan konsumsi hari ini ≤ target minggu tersebut).
List<BadgePencapaian> hitungBadge({
  required int hariSmokeFree,
  required int rokokDihindariAktual,
  required int rokokTidakDiHisapEstimasi,
  required double uangDihematAktual,
  required double uangDihematEstimasi,
  required int impianTercapai,
  required int streakHariIni,
  required int streakPencatatan,
  required int hariTercatat,
  required bool sedangTapering,
  required List<bool> taperingTercapai,
  Set<String> badgeTercapaiHistoris = const <String>{},
}) {
  final pakaiAktual = hariTercatat > 0;
  final rokokUntukBadge = pakaiAktual
      ? rokokDihindariAktual
      : rokokTidakDiHisapEstimasi;
  final uangUntukBadge = pakaiAktual ? uangDihematAktual : uangDihematEstimasi;
  final labelRokok = pakaiAktual ? 'dari catatan' : 'estimasi';
  final labelUang = pakaiAktual ? 'dari catatan' : 'estimasi';

  BadgePencapaian badge({
    required String id,
    required String nama,
    required String deskripsi,
    required IconData icon,
    required bool tercapai,
  }) {
    return BadgePencapaian(
      id: id,
      nama: nama,
      deskripsi: deskripsi,
      icon: icon,
      tercapai: tercapai || badgeTercapaiHistoris.contains(id),
    );
  }

  final List<BadgePencapaian> daftar = <BadgePencapaian>[
    // Badge berbasis durasi smoke-free (baseline kumulatif, tidak direset slip).
    badge(
      id: 'smoke_1',
      nama: 'Langkah Pertama',
      deskripsi: 'Berhasil berhenti merokok selama 1 hari.',
      icon: CupertinoIcons.flame,
      tercapai: hariSmokeFree >= 1,
    ),
    badge(
      id: 'smoke_3',
      nama: '3 Hari Kuat',
      deskripsi: 'Berhasil berhenti merokok selama 3 hari.',
      icon: CupertinoIcons.flame_fill,
      tercapai: hariSmokeFree >= 3,
    ),
    badge(
      id: 'smoke_7',
      nama: 'Satu Minggu',
      deskripsi: 'Berhasil berhenti merokok selama 7 hari.',
      icon: CupertinoIcons.star,
      tercapai: hariSmokeFree >= 7,
    ),
    badge(
      id: 'smoke_14',
      nama: 'Dua Minggu',
      deskripsi: 'Berhasil berhenti merokok selama 14 hari.',
      icon: CupertinoIcons.star_fill,
      tercapai: hariSmokeFree >= 14,
    ),
    badge(
      id: 'smoke_30',
      nama: 'Satu Bulan',
      deskripsi: 'Berhasil berhenti merokok selama 30 hari.',
      icon: Icons.workspace_premium,
      tercapai: hariSmokeFree >= 30,
    ),
    badge(
      id: 'smoke_90',
      nama: 'Tiga Bulan',
      deskripsi: 'Berhasil berhenti merokok selama 90 hari.',
      icon: CupertinoIcons.rosette,
      tercapai: hariSmokeFree >= 90,
    ),
    badge(
      id: 'smoke_180',
      nama: 'Enam Bulan',
      deskripsi: 'Berhasil berhenti merokok selama 180 hari.',
      icon: CupertinoIcons.rosette,
      tercapai: hariSmokeFree >= 180,
    ),
    badge(
      id: 'smoke_365',
      nama: 'Satu Tahun',
      deskripsi: 'Berhasil berhenti merokok selama 1 tahun.',
      icon: Icons.emoji_events,
      tercapai: hariSmokeFree >= 365,
    ),
    // Badge berbasis rokok terhindar (aktual bila ada catatan, fallback estimasi).
    badge(
      id: 'rokok_100',
      nama: '100 Batang Terhindar',
      deskripsi: 'Berhasil menghindari 100 batang rokok ($labelRokok).',
      icon: CupertinoIcons.nosign,
      tercapai: rokokUntukBadge >= 100,
    ),
    badge(
      id: 'rokok_500',
      nama: '500 Batang Terhindar',
      deskripsi: 'Berhasil menghindari 500 batang rokok ($labelRokok).',
      icon: CupertinoIcons.nosign,
      tercapai: rokokUntukBadge >= 500,
    ),
    badge(
      id: 'rokok_1000',
      nama: '1000 Batang Terhindar',
      deskripsi: 'Berhasil menghindari 1000 batang rokok ($labelRokok).',
      icon: CupertinoIcons.shield,
      tercapai: rokokUntukBadge >= 1000,
    ),
    // Badge berbasis uang dihemat (aktual bila ada catatan, fallback estimasi).
    badge(
      id: 'uang_100k',
      nama: 'Tabungan 100 Ribu',
      deskripsi: 'Berhasil menghemat Rp100.000 ($labelUang).',
      icon: CupertinoIcons.money_dollar,
      tercapai: uangUntukBadge >= 100000,
    ),
    badge(
      id: 'uang_500k',
      nama: 'Tabungan 500 Ribu',
      deskripsi: 'Berhasil menghemat Rp500.000 ($labelUang).',
      icon: CupertinoIcons.money_dollar,
      tercapai: uangUntukBadge >= 500000,
    ),
    badge(
      id: 'uang_1jt',
      nama: 'Tabungan 1 Juta',
      deskripsi: 'Berhasil menghemat Rp1.000.000 ($labelUang).',
      icon: CupertinoIcons.money_dollar_circle,
      tercapai: uangUntukBadge >= 1000000,
    ),
    // Badge berbasis impian tercapai.
    badge(
      id: 'impian_1',
      nama: 'Impian Pertama Tercapai',
      deskripsi: 'Berhasil mencapai 1 impian.',
      icon: CupertinoIcons.heart,
      tercapai: impianTercapai >= 1,
    ),
    badge(
      id: 'impian_3',
      nama: '3 Impian Tercapai',
      deskripsi: 'Berhasil mencapai 3 impian.',
      icon: CupertinoIcons.heart_fill,
      tercapai: impianTercapai >= 3,
    ),
    // BARU: Badge streak bebas rokok (dari catatan, reset saat slip).
    badge(
      id: 'streak_7',
      nama: 'Streak 7 Hari',
      deskripsi: '7 hari berturut-turut tanpa rokok (dari catatan).',
      icon: CupertinoIcons.flame_fill,
      tercapai: streakHariIni >= 7,
    ),
    badge(
      id: 'streak_30',
      nama: 'Streak 30 Hari',
      deskripsi: '30 hari berturut-turut tanpa rokok (dari catatan).',
      icon: CupertinoIcons.star_fill,
      tercapai: streakHariIni >= 30,
    ),
    badge(
      id: 'streak_90',
      nama: 'Streak 90 Hari',
      deskripsi: '90 hari berturut-turut tanpa rokok (dari catatan).',
      icon: CupertinoIcons.rosette,
      tercapai: streakHariIni >= 90,
    ),
    // BARU: Badge konsistensi pencatatan (menghargai kebiasaan mencatat).
    badge(
      id: 'catat_7',
      nama: 'Pencatat 7 Hari',
      deskripsi: 'Mencatat konsumsi 7 hari berturut-turut.',
      icon: CupertinoIcons.doc_on_clipboard,
      tercapai: streakPencatatan >= 7,
    ),
    badge(
      id: 'catat_30',
      nama: 'Pencatat 30 Hari',
      deskripsi: 'Mencatat konsumsi 30 hari berturut-turut.',
      icon: CupertinoIcons.doc_on_clipboard,
      tercapai: streakPencatatan >= 30,
    ),
    badge(
      id: 'catat_90',
      nama: 'Pencatat 90 Hari',
      deskripsi: 'Mencatat konsumsi 90 hari berturut-turut.',
      icon: CupertinoIcons.doc_on_clipboard_fill,
      tercapai: streakPencatatan >= 90,
    ),
    // BARU: Badge target tapering tercapai (additif, hanya mode bertahap;
    // tetap ditampilkan bila pernah tercapai agar historis tidak hilang).
    if (sedangTapering ||
        _adaBadgeTaperingHistoris(badgeTercapaiHistoris)) ...<BadgePencapaian>[
      badge(
        id: 'tapering_1',
        nama: 'Target Minggu 1 Tercapai',
        deskripsi: 'Konsumsi hari ini ≤ target tapering minggu pertama.',
        icon: CupertinoIcons.arrow_down_circle,
        tercapai: _taperingTercapaiKe(taperingTercapai, 0),
      ),
      badge(
        id: 'tapering_2',
        nama: 'Target Minggu 2 Tercapai',
        deskripsi: 'Konsumsi hari ini ≤ target tapering minggu kedua.',
        icon: CupertinoIcons.arrow_down_circle,
        tercapai: _taperingTercapaiKe(taperingTercapai, 1),
      ),
      badge(
        id: 'tapering_3',
        nama: 'Target Minggu 3 Tercapai',
        deskripsi: 'Konsumsi hari ini ≤ target tapering minggu ketiga.',
        icon: CupertinoIcons.arrow_down_circle,
        tercapai: _taperingTercapaiKe(taperingTercapai, 2),
      ),
      badge(
        id: 'tapering_4',
        nama: 'Target Minggu 4 Tercapai',
        deskripsi: 'Konsumsi hari ini ≤ target tapering minggu keempat.',
        icon: CupertinoIcons.arrow_down_circle_fill,
        tercapai: _taperingTercapaiKe(taperingTercapai, 3),
      ),
    ],
  ];
  return daftar;
}

/// Mengambil status tercapai target tapering minggu ke-[index] (0-based)
/// dari [taperingTercapai]. Indeks di luar daftar → false.
bool _taperingTercapaiKe(List<bool> taperingTercapai, int index) =>
    index >= 0 && index < taperingTercapai.length && taperingTercapai[index];

/// Apakah ada badge tapering ('tapering_1'..'tapering_4') yang pernah
/// tercapai dan tersimpan di [badgeTercapaiHistoris].
bool _adaBadgeTaperingHistoris(Set<String> badgeTercapaiHistoris) =>
    badgeTercapaiHistoris.any((id) => id.startsWith('tapering_'));
```


// ============================================================
// FILE: lib/fitur/badge/screens/badge_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/badge/helper/badge_helper.dart';
import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/screens/konsumsi_rokok_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeScreen extends ConsumerStatefulWidget {
  const BadgeScreen({super.key});

  @override
  ConsumerState<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends ConsumerState<BadgeScreen> {
  /// Id badge yang pernah tercapai (disimpan di SharedPreferences).
  /// Badge historis tidak pernah dicoret dari pencapaian pengguna karena slip.
  Set<String> _badgeHistoris = <String>{};
  bool _historisDimuat = false;

  /// Flag dedup pendaftaran post-frame callback: mencegah callback terdaftar
  /// berulang pada setiap rebuild sebelum callback berjalan.
  bool _simpanTerjadwal = false;

  @override
  void initState() {
    super.initState();
    L.i('BadgeScreen initState');
    unawaited(
      _muatBadgeHistoris().catchError((Object e, StackTrace s) {
        L.e('Gagal memuat badge historis: $e $s');
      }),
    );
  }

  @override
  void dispose() {
    L.i('BadgeScreen dispose');
    super.dispose();
  }

  Future<void> _muatBadgeHistoris() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final daftar =
          prefs.getStringList(keyBadgeTercapaiHistoris) ?? <String>[];
      if (mounted) {
        setState(() {
          _badgeHistoris = daftar.toSet();
          _historisDimuat = true;
        });
      }
    } catch (e, s) {
      L.e('Gagal memuat SharedPreferences $keyBadgeTercapaiHistoris: $e $s');
      if (mounted) {
        setState(() => _historisDimuat = true);
      }
    }
  }

  Future<void> _simpanBadgeHistoris(Set<String> baru) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(keyBadgeTercapaiHistoris, baru.toList());
      if (mounted) {
        setState(() => _badgeHistoris = baru);
      }
    } catch (e, s) {
      L.e('Gagal menyimpan badge historis: $e $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(biodataProvider);
    final impianAsync = ref.watch(impianProvider);
    final konsumsiAsync = ref.watch(konsumsiRokokProvider);

    if (biodataAsync.isLoading ||
        impianAsync.isLoading ||
        konsumsiAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (biodataAsync.hasError) {
      L.e(
        'biodataAsync error: ${biodataAsync.error} ${biodataAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Pencapaian')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(biodataProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (impianAsync.hasError) {
      L.e('impianAsync error: ${impianAsync.error} ${impianAsync.stackTrace}');
      return Scaffold(
        appBar: AppBar(title: const Text('Pencapaian')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data impian'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(impianProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (konsumsiAsync.hasError) {
      L.e(
        'konsumsiAsync error: ${konsumsiAsync.error} ${konsumsiAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Pencapaian')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data konsumsi'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(konsumsiRokokProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final biodata = biodataAsync.requireValue;
    final impianState = impianAsync.requireValue;
    final konsumsiList = konsumsiAsync.requireValue.listKonsumsi;

    if (biodata == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pencapaian')),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Lengkapi biodata terlebih dahulu untuk melihat pencapaian.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    // Hitung progres smoke-free.
    // Badge berbasis hari tetap baseline; badge berbasis rokok/uang memakai
    // aktual bila ada catatan konsumsi, fallback ke baseline bila belum ada.
    final hariSmokeFree = MetrikBerhentiHelper.hitungHariBerhenti(biodata);
    final hariTercatat = MetrikBerhentiHelper.hitungJumlahHariTercatat(
      konsumsiList,
    );
    final pakaiAktual = hariTercatat > 0;
    final rokokDihindariAktual =
        MetrikBerhentiHelper.hitungRokokDihindariAktual(biodata, konsumsiList);
    final rokokTidakDiHisapEstimasi =
        MetrikBerhentiHelper.hitungRokokTidakDiHisapEstimasi(biodata);
    final uangDihematAktual = MetrikBerhentiHelper.hitungUangDihematAktual(
      biodata,
      konsumsiList,
    );
    final uangDihematEstimasi = MetrikBerhentiHelper.hitungUangDihematEstimasi(
      biodata,
    );
    final streakHariIni = MetrikBerhentiHelper.hitungStreak(konsumsiList);
    final streakPencatatan = MetrikBerhentiHelper.hitungStreakPencatatan(
      konsumsiList,
    );
    final sedangTapering = biodata.sedangTapering;
    final mingguTaperingBerjalan =
        MetrikBerhentiHelper.hitungMingguTaperingBerjalan(biodata);
    final konsumsiHariIni = KonsumsiHitungHelper.konsumsiHariIni(konsumsiList);
    final taperingTercapai = sedangTapering
        ? List<bool>.generate(4, (index) {
            final mingguKe = index + 1;
            return mingguTaperingBerjalan >= mingguKe &&
                konsumsiHariIni <=
                    MetrikBerhentiHelper.hitungTargetTaperingMingguKe(
                      biodata,
                      mingguKe,
                    );
          })
        : const <bool>[false, false, false, false];
    L.i(
      'hariSmokeFree=$hariSmokeFree, hariTercatat=$hariTercatat, '
      'rokokDihindariAktual=$rokokDihindariAktual, '
      'rokokTidakDiHisapEstimasi=$rokokTidakDiHisapEstimasi, '
      'uangDihematAktual=$uangDihematAktual, '
      'uangDihematEstimasi=$uangDihematEstimasi, '
      'streakHariIni=$streakHariIni, streakPencatatan=$streakPencatatan, '
      'sedangTapering=$sedangTapering, '
      'mingguTaperingBerjalan=$mingguTaperingBerjalan, '
      'konsumsiHariIni=$konsumsiHariIni, taperingTercapai=$taperingTercapai',
    );

    // Saldo untuk menghitung impian tercapai: aktual bila ada catatan,
    // fallback estimasi bila belum ada catatan sama sekali.
    final saldoUntukImpian = pakaiAktual
        ? uangDihematAktual
        : uangDihematEstimasi;
    int impianTercapai = 0;
    for (final impian in impianState.listImpian) {
      if (saldoUntukImpian >= impian.jumlah) {
        impianTercapai++;
      }
    }

    final daftarBadge = hitungBadge(
      hariSmokeFree: hariSmokeFree,
      rokokDihindariAktual: rokokDihindariAktual,
      rokokTidakDiHisapEstimasi: rokokTidakDiHisapEstimasi,
      uangDihematAktual: uangDihematAktual,
      uangDihematEstimasi: uangDihematEstimasi,
      impianTercapai: impianTercapai,
      streakHariIni: streakHariIni,
      streakPencatatan: streakPencatatan,
      hariTercatat: hariTercatat,
      sedangTapering: sedangTapering,
      taperingTercapai: taperingTercapai,
      badgeTercapaiHistoris: _badgeHistoris,
    );
    final jumlahTercapai = daftarBadge.where((b) => b.tercapai).length;

    // Simpan badge yang baru tercapai ke SharedPreferences agar tidak hilang
    // dari tampilan pencapaian bila metrik aktual turun karena slip berikutnya.
    // Post-frame callback didaftarkan hanya bila ada badge baru yang kurang
    // dan belum ada callback terjadwal, agar tidak terdaftar berulang per rebuild.
    final kurang = daftarBadge
        .where((b) => b.tercapai)
        .map((b) => b.id)
        .toSet()
        .difference(_badgeHistoris);
    if (kurang.isNotEmpty && !_simpanTerjadwal) {
      _simpanTerjadwal = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Reset flag lebih dulu agar perubahan berikutnya bisa dijadwalkan lagi.
        _simpanTerjadwal = false;
        if (!mounted || !_historisDimuat) return;
        unawaited(
          _simpanBadgeHistoris({..._badgeHistoris, ...kurang}).catchError((
            Object e,
            StackTrace s,
          ) {
            L.e('Gagal menyimpan badge historis: $e $s');
          }),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pencapaian')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                '$jumlahTercapai dari ${daftarBadge.length} badge tercapai',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (!pakaiAktual) ...[
                Text(
                  'Belum ada catatan konsumsi. Badge rokok/uang memakai '
                  'estimasi dari biodata. Badge yang pernah tercapai tetap '
                  'tersimpan meskipun Anda slip.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => unawaited(
                      Nav.to(
                        context,
                        const KonsumsiRokokScreen(),
                      ).catchError((Object e, StackTrace s) {
                        L.e('Gagal navigasi ke Konsumsi Rokok: $e $s');
                        return null;
                      }),
                    ),
                    child: const Text('Catat Konsumsi'),
                  ),
                ),
              ] else
                Text(
                  'Badge rokok/uang dihitung dari $hariTercatat hari '
                  'tercatat; badge lainnya dari baseline biodata. Badge yang '
                  'pernah tercapai tetap tersimpan meskipun Anda slip.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: daftarBadge.length,
                  itemBuilder: (context, index) {
                    final badge = daftarBadge[index];
                    return _BadgeCard(key: ValueKey(badge.id), badge: badge);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({super.key, required this.badge});

  final BadgePencapaian badge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tercapai = badge.tercapai;
    return Card(
      color: tercapai
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(
              badge.icon,
              size: 32,
              color: tercapai
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            Text(
              badge.nama,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: tercapai
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              badge.deskripsi,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: tercapai
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/biodata/enum/mode_berhenti.dart
// ============================================================

```dart
/// Mode berhenti merokok: seketika atau bertahap (tapering).
enum ModeBerhenti { seketika, bertahap }

/// Extension yang menyediakan label untuk [ModeBerhenti].
extension ModeBerhentiExtension on ModeBerhenti {
  String get label {
    switch (this) {
      case ModeBerhenti.seketika:
        return 'Seketika';
      case ModeBerhenti.bertahap:
        return 'Bertahap (tapering)';
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/biodata/model/biodata_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/biodata/notifier/biodata_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'biodata_notifier.g.dart';

@Riverpod(keepAlive: true)
class BiodataNotifier extends _$BiodataNotifier {
  @override
  Future<BiodataModel?> build() async {
    return await _ambilSemua();
  }

  Future<BiodataModel?> _ambilSemua() async {
    try {
      final op = const SqfliteOp();
      final row = await op.ambilSatu(NamaTabel.biodata);
      L.i('row=$row');
      if (row == null) {
        return null;
      }
      return BiodataModel.fromSqflite(row);
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data biodata: $e $s');
      rethrow;
    }
  }

  Future<void> simpan(BiodataModel biodata) async {
    L.i('biodata=$biodata');
    try {
      final existing = await future;
      L.i('existing=$existing');
      final model = biodata.id.isEmpty
          ? biodata.copyWith(id: existing?.id ?? const Uuid().v4())
          : biodata;
      L.i('model=$model');
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.biodata,
        model.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      state = AsyncValue.data(model);
      L.s('Biodata berhasil disimpan');
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan biodata: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/biodata/screens/biodata_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/enum/mode_berhenti.dart';
import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/screens/form_biodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

class BiodataScreen extends ConsumerStatefulWidget {
  const BiodataScreen({super.key});

  @override
  ConsumerState<BiodataScreen> createState() => _BiodataScreenState();
}

class _BiodataScreenState extends ConsumerState<BiodataScreen> {
  @override
  void initState() {
    super.initState();
    L.i('BiodataScreen initState');
  }

  @override
  void dispose() {
    L.i('BiodataScreen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(biodataProvider);
    L.i('biodataAsync=$biodataAsync');

    if (biodataAsync.isLoading) {
      L.w('biodataAsync loading');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (biodataAsync.hasError) {
      L.e(
        'biodataAsync error: ${biodataAsync.error} ${biodataAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Biodata')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Gagal memuat data'),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  final _ = ref.refresh(biodataProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final biodata = biodataAsync.requireValue;
    L.i('biodata=$biodata');

    // Salin field nullable ke variabel lokal agar type promotion berlaku
    // (menghindari penggunaan operator `!`).
    final tanggalLahir = biodata?.tanggalLahir;
    final tanggalMulaiMerokok = biodata?.tanggalMulaiMerokok;
    final tanggalMulaiBerhentiMerokok = biodata?.tanggalMulaiBerhentiMerokok;
    final tanggalMulaiTapering = biodata?.tanggalMulaiTapering;
    final targetSmokeFreeHari = biodata?.targetSmokeFreeHari;
    L.i('targetSmokeFreeHari=$targetSmokeFreeHari');

    return Scaffold(
      appBar: AppBar(title: const Text('Biodata')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: biodata == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      const Text('Belum ada data biodata'),
                      OutlinedButton(
                        onPressed: () => unawaited(
                          Nav.to(
                            context,
                            const FormBiodata(buatPertama: false),
                          ).catchError((Object e, StackTrace s) {
                            L.e('Gagal navigasi ke Form Biodata: $e $s');
                            return null;
                          }),
                        ),
                        child: const Text('Isi Biodata'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      _buildItem('Nama', biodata.nama),
                      _buildItem(
                        'Tanggal lahir',
                        tanggalLahir == null
                            ? 'Belum dipilih'
                            : FormatTanggal.formatDasar(tanggalLahir),
                      ),
                      _buildItem(
                        'Jumlah rokok per hari',
                        biodata.jumlahRokokPerHari.toString(),
                      ),
                      _buildItem(
                        'Harga rokok per bungkus',
                        biodata.hargaRokokPerBungkus.toString(),
                      ),
                      _buildItem(
                        'Batang per bungkus',
                        biodata.batangPerBungkus.toString(),
                      ),
                      _buildItem(
                        'Tanggal mulai merokok',
                        tanggalMulaiMerokok == null
                            ? 'Belum dipilih'
                            : FormatTanggal.formatDasar(tanggalMulaiMerokok),
                      ),
                      _buildItem(
                        'Tanggal mulai berhenti merokok',
                        tanggalMulaiBerhentiMerokok == null
                            ? 'Belum dipilih'
                            : FormatTanggal.formatDasar(
                                tanggalMulaiBerhentiMerokok,
                              ),
                      ),
                      _buildItem('Mode berhenti', biodata.modeBerhenti.label),
                      _buildItem(
                        'Penurunan per minggu',
                        biodata.penurunanPerMinggu.toString(),
                      ),
                      _buildItem(
                        'Target rokok per hari (saat ini)',
                        biodata.targetRokokHariIni.toString(),
                      ),
                      _buildItem(
                        'Tanggal mulai penurunan',
                        tanggalMulaiTapering == null
                            ? 'Belum dipilih'
                            : FormatTanggal.formatDasar(tanggalMulaiTapering),
                      ),
                      if (targetSmokeFreeHari != null)
                        ..._buildProgresTarget(biodata, targetSmokeFreeHari),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => unawaited(
                          Nav.to(
                            context,
                            FormBiodata(
                              buatPertama: false,
                              biodataModel: biodata,
                            ),
                          ).catchError((Object e, StackTrace s) {
                            L.e('Gagal navigasi ke Form Biodata: $e $s');
                            return null;
                          }),
                        ),
                        child: const Text('Ubah Biodata'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildItem(String label, String nilai) {
    L.i('label=$label, nilai=$nilai');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(nilai, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  /// Daftar widget tampilan progres target smoke-free "X dari N hari".
  List<Widget> _buildProgresTarget(BiodataModel biodata, int target) {
    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    if (tanggalBerhenti == null) {
      return [
        _buildItem('Target smoke-free', 'Target: $target hari'),
        _buildItem(
          'Progres',
          'Belum dapat dihitung (tanggal berhenti belum dipilih)',
        ),
      ];
    }
    final hariBerhenti = biodata.hariBerhenti;
    final n = target;
    final teksProgres = hariBerhenti >= n
        ? '$n dari $n hari — Target tercapai'
        : '$hariBerhenti dari $n hari';
    return [
      _buildItem('Target smoke-free', '$target hari'),
      _buildItem('Progres', teksProgres),
    ];
  }
}
```


// ============================================================
// FILE: lib/fitur/biodata/screens/form_biodata.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/biodata/enum/mode_berhenti.dart';
import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

class FormBiodata extends ConsumerStatefulWidget {
  final bool buatPertama;
  final BiodataModel? biodataModel;
  const FormBiodata({super.key, required this.buatPertama, this.biodataModel});

  @override
  ConsumerState<FormBiodata> createState() => _BiodataScreenState();
}

class _BiodataScreenState extends ConsumerState<FormBiodata> {
  final _namaController = TextEditingController();
  final _jumlahRokokController = TextEditingController();
  final _hargaRokokController = TextEditingController();
  final _batangPerBungkusController = TextEditingController();
  final _penurunanPerMingguController = TextEditingController();
  final _targetSmokeFreeController = TextEditingController();

  final _namaFocusNode = FocusNode();
  final _jumlahRokokFocusNode = FocusNode();
  final _hargaRokokFocusNode = FocusNode();
  final _batangPerBungkusFocusNode = FocusNode();
  final _penurunanPerMingguFocusNode = FocusNode();
  final _targetSmokeFreeFocusNode = FocusNode();

  DateTime? _tanggalLahir;
  DateTime? _tanggalMulaiMerokok;
  DateTime? _tanggalMulaiBerhentiMerokok;
  DateTime? _tanggalMulaiTapering;

  ModeBerhenti _modeBerhenti = ModeBerhenti.seketika;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _sudahDiisi = false;

  ProviderSubscription<AsyncValue<BiodataModel?>>? _biodataSubscription;

  @override
  void initState() {
    super.initState();
    L.i('FormBiodata initState, buatPertama=${widget.buatPertama}');
    final modelAwal = widget.biodataModel;
    if (modelAwal != null) {
      _isiDariModel(modelAwal);
    }
    if (widget.buatPertama && _tanggalMulaiMerokok == null) {
      _tanggalMulaiMerokok = DateTime.now();
    }
    _biodataSubscription = ref.listenManual(biodataProvider, (previous, next) {
      next.whenData((biodata) {
        if (biodata != null && !_sudahDiisi && mounted) {
          _isiDariModel(biodata);
        }
      });
    });
  }

  void _isiDariModel(BiodataModel model) {
    _sudahDiisi = true;
    _namaController.text = model.nama;
    _jumlahRokokController.text = model.jumlahRokokPerHari.toString();
    _hargaRokokController.text = model.hargaRokokPerBungkus.toString();
    _batangPerBungkusController.text = model.batangPerBungkus.toString();
    _tanggalLahir = model.tanggalLahir;
    _tanggalMulaiMerokok = model.tanggalMulaiMerokok;
    _tanggalMulaiBerhentiMerokok = model.tanggalMulaiBerhentiMerokok;
    _modeBerhenti = model.modeBerhenti;
    _penurunanPerMingguController.text = model.penurunanPerMinggu.toString();
    _targetSmokeFreeController.text = (model.targetSmokeFreeHari ?? '')
        .toString();
    _tanggalMulaiTapering = model.tanggalMulaiTapering;
    L.i(
      'modeBerhenti=$_modeBerhenti, '
      'penurunanPerMinggu=${_penurunanPerMingguController.text}, '
      'tanggalMulaiTapering=$_tanggalMulaiTapering, '
      'targetSmokeFreeHari=${_targetSmokeFreeController.text}',
    );
  }

  @override
  void dispose() {
    _biodataSubscription?.close();
    _namaController.dispose();
    _jumlahRokokController.dispose();
    _hargaRokokController.dispose();
    _batangPerBungkusController.dispose();
    _penurunanPerMingguController.dispose();
    _namaFocusNode.dispose();
    _jumlahRokokFocusNode.dispose();
    _hargaRokokFocusNode.dispose();
    _batangPerBungkusFocusNode.dispose();
    _penurunanPerMingguFocusNode.dispose();
    _targetSmokeFreeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggalLahir() async {
    final awal = _tanggalLahir ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _tanggalLahir = picked);
    }
  }

  Future<void> _pilihTanggalMulaiMerokok() async {
    final awal = _tanggalMulaiMerokok ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _tanggalMulaiMerokok = picked);
    }
  }

  Future<void> _pilihTanggalMulaiBerhentiMerokok() async {
    final awal = _tanggalMulaiBerhentiMerokok ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _tanggalMulaiBerhentiMerokok = picked);
    }
  }

  Future<void> _pilihTanggalMulaiTapering() async {
    final awal = _tanggalMulaiTapering ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      L.i('tanggalMulaiTapering=$picked');
      setState(() => _tanggalMulaiTapering = picked);
    }
  }

  Future<void> _simpan() async {
    if (_isLoading) {
      L.w('Form biodata masih loading, simpan diabaikan');
      return;
    }
    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Simpan Biodata',
      message: 'Apakah Anda yakin ingin menyimpan data biodata ini?',
      okLabel: 'Simpan',
      cancelLabel: 'Batal',
    );
    if (konfirmasi != OkCancelResult.ok) {
      return;
    }
    if (!mounted) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_modeBerhenti == ModeBerhenti.bertahap &&
        _tanggalMulaiTapering == null) {
      AppToast.gagal(context, 'Tanggal mulai penurunan wajib dipilih');
      return;
    }
    final tanggalMulaiMerokok = _tanggalMulaiMerokok;
    final tanggalMulaiBerhenti = _tanggalMulaiBerhentiMerokok;
    if (tanggalMulaiMerokok != null && tanggalMulaiBerhenti != null) {
      final mulaiDate = DateTime(
        tanggalMulaiMerokok.year,
        tanggalMulaiMerokok.month,
        tanggalMulaiMerokok.day,
      );
      final berhentiDate = DateTime(
        tanggalMulaiBerhenti.year,
        tanggalMulaiBerhenti.month,
        tanggalMulaiBerhenti.day,
      );
      if (berhentiDate.isBefore(mulaiDate)) {
        AppToast.gagal(
          context,
          'Tanggal mulai berhenti merokok tidak boleh sebelum tanggal mulai merokok',
        );
        return;
      }
    }
    setState(() => _isLoading = true);
    unawaited(
      EasyLoading.show(
        status: 'Menyimpan...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
        return null;
      }),
    );
    try {
      final jumlahRokokPerHari = int.tryParse(
        _jumlahRokokController.text.trim(),
      );
      if (jumlahRokokPerHari == null || jumlahRokokPerHari <= 0) {
        AppToast.gagal(context, 'Jumlah rokok per hari tidak valid');
        return;
      }
      final batangPerBungkus = double.tryParse(
        _batangPerBungkusController.text.trim(),
      );
      if (batangPerBungkus == null || batangPerBungkus <= 0) {
        AppToast.gagal(context, 'Batang per bungkus tidak valid');
        return;
      }
      int penurunanPerMinggu = 0;
      if (_modeBerhenti == ModeBerhenti.bertahap) {
        final parsedPenurunan = int.tryParse(
          _penurunanPerMingguController.text.trim(),
        );
        if (parsedPenurunan == null || parsedPenurunan <= 0) {
          AppToast.gagal(context, 'Penurunan per minggu tidak valid');
          return;
        }
        penurunanPerMinggu = parsedPenurunan;
      }
      int? targetSmokeFreeHari;
      final targetText = _targetSmokeFreeController.text.trim();
      if (targetText.isNotEmpty) {
        final parsedTarget = int.tryParse(targetText);
        if (parsedTarget == null || parsedTarget <= 0) {
          AppToast.gagal(
            context,
            'Target smoke-free harus bilangan bulat lebih dari 0',
          );
          return;
        }
        targetSmokeFreeHari = parsedTarget;
      }
      final model = BiodataModel(
        id: widget.biodataModel?.id ?? '',
        nama: _namaController.text.trim(),
        tanggalLahir: _tanggalLahir,
        jumlahRokokPerHari: jumlahRokokPerHari,
        hargaRokokPerBungkus: _hargaRokokController.text.trim().isEmpty
            ? 0.0
            : InputRupiah.parse(_hargaRokokController.text),
        batangPerBungkus: batangPerBungkus,
        tanggalMulaiMerokok: _tanggalMulaiMerokok,
        tanggalMulaiBerhentiMerokok: _tanggalMulaiBerhentiMerokok,
        modeBerhenti: _modeBerhenti,
        penurunanPerMinggu: penurunanPerMinggu,
        tanggalMulaiTapering: _tanggalMulaiTapering,
        targetSmokeFreeHari: targetSmokeFreeHari,
      );
      L.i('model=$model, targetSmokeFreeHari=$targetSmokeFreeHari');
      await ref.read(biodataProvider.notifier).simpan(model);
      if (!mounted) return;
      if (widget.buatPertama) {
        unawaited(
          Nav.pushAndRemoveUntil(context, const Home()).catchError((
            Object e,
            StackTrace s,
          ) {
            L.e('Gagal navigasi ke Home: $e $s');
            return null;
          }),
        );
      } else if (Navigator.of(context).canPop()) {
        Nav.pop(context);
      }
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan biodata: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menyimpan biodata');
      }
    } finally {
      if (mounted) {
        unawaited(
          EasyLoading.dismiss().catchError((Object e, StackTrace s) {
            L.e('Gagal menutup loading: $e $s');
            return null;
          }),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(biodataProvider);

    if (biodataAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (biodataAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Biodata')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Gagal memuat data'),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  final _ = ref.refresh(biodataProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Biodata')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                InputTeks(
                  controller: _namaController,
                  label: 'Nama',
                  hintText: 'Masukkan nama',
                  focusNode: _namaFocusNode,
                  nextFocusNode: _jumlahRokokFocusNode,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                InputAngka(
                  controller: _jumlahRokokController,
                  label: 'Jumlah rokok per hari',
                  hintText: 'Masukkan jumlah rokok per hari',
                  focusNode: _jumlahRokokFocusNode,
                  nextFocusNode: _hargaRokokFocusNode,
                  validator: (value) {
                    final cleaned = (value ?? '').replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );
                    final n = int.tryParse(cleaned);
                    if (n == null || n <= 0) {
                      return 'Wajib bilangan bulat positif';
                    }
                    return null;
                  },
                ),
                InputRupiah(
                  controller: _hargaRokokController,
                  label: 'Harga rokok per bungkus',
                  hintText: 'Masukkan harga rokok per bungkus',
                  focusNode: _hargaRokokFocusNode,
                ),
                InputAngka(
                  controller: _batangPerBungkusController,
                  label: 'Batang per bungkus',
                  hintText: 'Masukkan jumlah batang per bungkus',
                  focusNode: _batangPerBungkusFocusNode,
                  validator: (value) {
                    final cleaned = (value ?? '').replaceAll(
                      RegExp(r'[^0-9.]'),
                      '',
                    );
                    final n = double.tryParse(cleaned);
                    if (n == null || n <= 0) {
                      return 'Wajib bilangan positif';
                    }
                    return null;
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.cake_outlined),
                  title: const Text('Tanggal lahir'),
                  subtitle: Text(
                    _tanggalLahir == null
                        ? 'Belum dipilih'
                        : FormatTanggal.formatDasar(_tanggalLahir!),
                  ),
                  trailing: TextButton(
                    onPressed: _pilihTanggalLahir,
                    child: const Text('Pilih'),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.smoking_rooms_outlined),
                  title: const Text('Tanggal mulai merokok'),
                  subtitle: Text(
                    _tanggalMulaiMerokok == null
                        ? 'Belum dipilih'
                        : FormatTanggal.formatDasar(_tanggalMulaiMerokok!),
                  ),
                  trailing: TextButton(
                    onPressed: _pilihTanggalMulaiMerokok,
                    child: const Text('Pilih'),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_available_outlined),
                  title: const Text('Tanggal mulai berhenti merokok'),
                  subtitle: Text(
                    _tanggalMulaiBerhentiMerokok == null
                        ? 'Belum dipilih'
                        : FormatTanggal.formatDasar(
                            _tanggalMulaiBerhentiMerokok!,
                          ),
                  ),
                  trailing: TextButton(
                    onPressed: _pilihTanggalMulaiBerhentiMerokok,
                    child: const Text('Pilih'),
                  ),
                ),
                // Mode berhenti: seketika atau bertahap (tapering).
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Berhenti bertahap (tapering)'),
                  subtitle: const Text(
                    'Kurangi jumlah rokok per hari secara bertahap.',
                  ),
                  value: _modeBerhenti == ModeBerhenti.bertahap,
                  onChanged: (value) {
                    setState(() {
                      _modeBerhenti = value
                          ? ModeBerhenti.bertahap
                          : ModeBerhenti.seketika;
                      if (value && _tanggalMulaiTapering == null) {
                        _tanggalMulaiTapering = DateTime.now();
                      }
                    });
                  },
                ),
                if (_modeBerhenti == ModeBerhenti.bertahap) ...[
                  InputAngka(
                    controller: _penurunanPerMingguController,
                    label: 'Penurunan per minggu (batang)',
                    hintText: 'Masukkan jumlah penurunan per minggu',
                    focusNode: _penurunanPerMingguFocusNode,
                    validator: (value) {
                      final cleaned = (value ?? '').replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      );
                      final n = int.tryParse(cleaned);
                      if (n == null || n <= 0) {
                        return 'Wajib bilangan bulat positif';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Tanggal mulai penurunan'),
                    subtitle: Text(
                      _tanggalMulaiTapering == null
                          ? 'Belum dipilih'
                          : FormatTanggal.formatDasar(_tanggalMulaiTapering!),
                    ),
                    trailing: TextButton(
                      onPressed: _pilihTanggalMulaiTapering,
                      child: const Text('Pilih'),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                InputAngka(
                  controller: _targetSmokeFreeController,
                  label: 'Target smoke-free (hari)',
                  hintText: 'Masukkan target hari bebas rokok',
                  focusNode: _targetSmokeFreeFocusNode,
                  validator: (value) {
                    final cleaned = (value ?? '').trim();
                    if (cleaned.isEmpty) return null;
                    final n = int.tryParse(cleaned);
                    if (n == null || n <= 0) {
                      return 'Wajib bilangan bulat lebih dari 0';
                    }
                    return null;
                  },
                ),
                OutlinedButton(onPressed: _simpan, child: const Text('Simpan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/cadangan/helper/cadangan_helper.dart
// ============================================================

```dart
import 'dart:convert';
import 'dart:io';

import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:csv/csv.dart';
import 'package:share_global_saya/core_shared.dart';

/// Versi format berkas cadangan JSON.
const int versiCadangan = 1;

/// Kunci tabel pada payload cadangan.
const List<String> tabelCadangan = <String>[
  NamaTabel.biodata,
  NamaTabel.impian,
  NamaTabel.diaryCraving,
  NamaTabel.alasanBerhenti,
  NamaTabel.konsumsiRokok,
  NamaTabel.sosIntervensi,
  NamaTabel.rencanaDarurat,
];

/// Exception ketika berkas cadangan tidak valid.
class BerkasCadanganTidakValidException implements Exception {
  /// Membuat exception dengan [pesan].
  const BerkasCadanganTidakValidException(this.pesan);

  /// Pesan kesalahan.
  final String pesan;

  @override
  String toString() => 'Berkas cadangan tidak valid: $pesan';
}

/// Logika ekspor dan pemulihan data cadangan lokal.
class CadanganHelper {
  CadanganHelper._();

  /// Mengumpulkan seluruh data tabel menjadi payload JSON.
  static Future<String> buatCadanganJson() async {
    L.i('buatCadanganJson mulai');
    try {
      final op = const SqfliteOp();
      final biodata = await op.ambilSemua(NamaTabel.biodata);
      final impian = await op.ambilSemua(NamaTabel.impian);
      final diary = await op.ambilSemua(NamaTabel.diaryCraving);
      final alasan = await op.ambilSemua(NamaTabel.alasanBerhenti);
      final konsumsi = await op.ambilSemua(NamaTabel.konsumsiRokok);
      final sosIntervensi = await op.ambilSemua(NamaTabel.sosIntervensi);
      final rencanaDarurat = await op.ambilSemua(NamaTabel.rencanaDarurat);
      L.i(
        'biodata=${biodata.length}, impian=${impian.length}, '
        'diary=${diary.length}, alasan=${alasan.length}, '
        'konsumsi=${konsumsi.length}, sosIntervensi=${sosIntervensi.length}, '
        'rencanaDarurat=${rencanaDarurat.length}',
      );

      final payload = <String, Object?>{
        'versi': versiCadangan,
        'dibuatPada': DateTime.now().toUtc().toIso8601String(),
        NamaTabel.biodata: biodata,
        NamaTabel.impian: impian,
        NamaTabel.diaryCraving: diary,
        NamaTabel.alasanBerhenti: alasan,
        NamaTabel.konsumsiRokok: konsumsi,
        NamaTabel.sosIntervensi: sosIntervensi,
        NamaTabel.rencanaDarurat: rencanaDarurat,
      };
      final json = jsonEncode(payload);
      L.s('Cadangan JSON berhasil dibuat');
      return json;
    } on Exception catch (e, s) {
      L.e('Gagal membuat cadangan JSON: $e $s');
      rethrow;
    }
  }

  /// Menulis [isi] ke [path] sebagai UTF-8. Menghapus berkas parsial saat
  /// gagal.
  static Future<void> _tulisBerkas(String path, String isi, String jenis) async {
    L.i('tulis berkas $jenis path=$path');
    final file = File(path);
    try {
      await file.writeAsString(isi, flush: true);
      L.s('Berkas $jenis berhasil ditulis');
    } on Exception catch (e, s) {
      L.e('Gagal menulis berkas $jenis: $e $s');
      try {
        if (await file.exists()) {
          await file.delete();
          L.w('Berkas $jenis parsial dihapus');
        }
      } on Exception catch (e2, s2) {
        L.e('Gagal menghapus berkas $jenis parsial: $e2 $s2');
      }
      rethrow;
    }
  }

  /// Menulis cadangan ke [path]. Menghapus berkas parsial saat gagal.
  static Future<void> tulisCadanganKeBerkas(String path, String json) {
    return _tulisBerkas(path, json, 'cadangan');
  }

  /// Membaca dan memvalidasi berkas cadangan dari [path].
  static Future<Map<String, dynamic>> bacaDanValidasiBerkas(String path) async {
    L.i('bacaDanValidasiBerkas path=$path');
    try {
      final file = File(path);
      if (!await file.exists()) {
        throw const BerkasCadanganTidakValidException('Berkas tidak ditemukan');
      }
      final json = await file.readAsString();
      return validasiPayload(json);
    } on BerkasCadanganTidakValidException catch (e, s) {
      L.e('Berkas cadangan tidak valid: $e $s');
      rethrow;
    } on Exception catch (e, s) {
      L.e('Gagal membaca berkas cadangan: $e $s');
      throw BerkasCadanganTidakValidException('Gagal membaca berkas: $e');
    }
  }

  /// Memvalidasi [json] cadangan dan mengembalikan payload.
  static Map<String, dynamic> validasiPayload(String json) {
    L.i('validasiPayload mulai');
    Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException catch (e, s) {
      L.e('Format JSON cadangan tidak valid: $e $s');
      throw const BerkasCadanganTidakValidException('Format JSON tidak valid');
    }
    if (decoded is! Map<String, dynamic>) {
      L.w('Payload cadangan bukan objek');
      throw const BerkasCadanganTidakValidException(
        'Payload harus berupa objek JSON',
      );
    }
    final versi = decoded['versi'];
    if (versi is! int || versi < 1 || versi > versiCadangan) {
      L.w('Versi cadangan tidak didukung: $versi');
      throw BerkasCadanganTidakValidException(
        'Versi cadangan tidak didukung: $versi',
      );
    }
    for (final tabel in tabelCadangan) {
      final nilai = decoded[tabel];
      if (nilai == null) {
        L.w('Tabel $tabel tidak ada pada cadangan, dianggap kosong');
        continue;
      }
      if (nilai is! List) {
        L.w('Data tabel $tabel bukan list');
        throw BerkasCadanganTidakValidException(
          'Data tabel $tabel tidak valid',
        );
      }
      for (final row in nilai) {
        if (row is! Map) {
          L.w('Baris tabel $tabel bukan objek');
          throw BerkasCadanganTidakValidException(
            'Baris tabel $tabel tidak valid',
          );
        }
      }
    }
    L.s('Payload cadangan valid');
    return decoded;
  }

  /// Mengambil daftar nama kolom [tabel] dari skema database, sesuai urutan
  /// definisi tabel.
  static Future<List<String>> kolomTabel(String tabel) async {
    L.i('kolomTabel tabel=$tabel');
    if (!tabelCadangan.contains(tabel)) {
      L.w('Tabel tidak dikenal: $tabel');
      throw ArgumentError.value(tabel, 'tabel', 'Tabel tidak terdaftar di tabelCadangan');
    }
    try {
      final rows = await const SqfliteOp().queryRaw('PRAGMA table_info($tabel)');
      final kolom = rows
          .map((baris) => baris['name'] as String)
          .toList(growable: false);
      L.i('kolomTabel tabel=$tabel jumlahKolom=${kolom.length}');
      return kolom;
    } on Exception catch (e, s) {
      L.e('Gagal mengambil kolom tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Mengonversi [rows] menjadi string CSV dengan [header] memakai paket
  /// `csv` (`ListToCsvConverter`). Nilai null ditulis sebagai string kosong.
  static String buatCsvDariBaris(
    List<String> header,
    List<Map<String, Object?>> rows,
  ) {
    L.i('buatCsvDariBaris header=${header.length} baris=${rows.length}');
    final data = <List<dynamic>>[
      header,
      for (final baris in rows)
        header
            .map((kolom) => baris[kolom]?.toString() ?? '')
            .toList(growable: false),
    ];
    return const ListToCsvConverter().convert(data);
  }

  /// Membuat string CSV untuk [tabel]: header nama kolom + seluruh baris.
  static Future<String> buatCsvTabel(String tabel) async {
    L.i('buatCsvTabel tabel=$tabel');
    try {
      final header = await kolomTabel(tabel);
      final rows = await const SqfliteOp().ambilSemua(tabel);
      L.i('buatCsvTabel tabel=$tabel baris=${rows.length}');
      return buatCsvDariBaris(header, rows);
    } on Exception catch (e, s) {
      L.e('Gagal membuat CSV tabel $tabel: $e $s');
      rethrow;
    }
  }

  /// Nama berkas CSV untuk [tabel] dengan pola `<nama_tabel>_<timestamp>.csv`.
  static String namaBerkasCsv(String tabel, {int? timestamp}) {
    final ts = timestamp ?? DateTime.now().millisecondsSinceEpoch;
    return '${tabel}_$ts.csv';
  }

  /// Memvalidasi [header] CSV terhadap kolom yang diizinkan untuk tabel
  /// target. Mengembalikan `true` jika semua kolom dikenal dan header tidak
  /// kosong.
  static bool validasiHeaderCsv(
    List<String> header,
    List<String> kolomDiizinkan,
  ) {
    if (header.isEmpty) {
      L.w('Header CSV kosong');
      return false;
    }
    final valid = header.every(kolomDiizinkan.contains);
    if (!valid) {
      L.w('Header CSV memuat kolom tidak dikenal: $header');
    }
    return valid;
  }

  /// Memvalidasi setiap baris CSV memiliki jumlah kolom yang sama dengan
  /// [header]. Mengembalikan `true` jika semua baris valid.
  static bool validasiBarisCsv(
    List<String> header,
    List<List<dynamic>> baris,
  ) {
    if (header.isEmpty) {
      L.w('Header CSV kosong, baris tidak dapat divalidasi');
      return false;
    }
    final valid = baris.every((b) => b.length == header.length);
    if (!valid) {
      L.w('Ada baris CSV dengan jumlah kolom tidak sama dengan header');
    }
    return valid;
  }

  /// Memvalidasi teks CSV untuk [tabel] terhadap [kolomDiizinkan] dan
  /// mengembalikan daftar baris data (tanpa header) yang sudah tervalidasi.
  ///
  /// Melempar [BerkasCadanganTidakValidException] jika berkas kosong, format
  /// tidak valid, header tidak cocok, atau ada baris dengan jumlah kolom
  /// yang tidak sama dengan header.
  static List<List<dynamic>> validasiTeksCsv({
    required String tabel,
    required String teks,
    required List<String> kolomDiizinkan,
  }) {
    L.i('validasiTeksCsv tabel=$tabel panjang=${teks.length}');
    if (teks.trim().isEmpty) {
      L.w('Berkas CSV tabel $tabel kosong');
      throw const BerkasCadanganTidakValidException('Berkas CSV kosong');
    }
    final dinormalisasi = teks.replaceAll('\r\n', '\n');
    final List<List<dynamic>> rows;
    try {
      rows = const CsvToListConverter(
        eol: '\n',
        shouldParseNumbers: false,
      ).convert(dinormalisasi);
    } on Exception catch (e, s) {
      L.e('Gagal mem-parse CSV tabel $tabel: $e $s');
      throw const BerkasCadanganTidakValidException('Format CSV tidak valid');
    }
    if (rows.isEmpty) {
      L.w('Berkas CSV tabel $tabel tidak memiliki baris');
      throw const BerkasCadanganTidakValidException('Berkas CSV kosong');
    }
    final header = rows.first.map((e) => e.toString()).toList();
    if (!validasiHeaderCsv(header, kolomDiizinkan)) {
      throw BerkasCadanganTidakValidException(
        'Header CSV tabel $tabel tidak valid',
      );
    }
    final baris = rows.skip(1).toList(growable: false);
    if (!validasiBarisCsv(header, baris)) {
      throw BerkasCadanganTidakValidException(
        'Baris CSV tabel $tabel tidak valid',
      );
    }
    L.s('CSV tabel $tabel valid (${baris.length} baris)');
    return baris;
  }

  /// Memulihkan data dari [payload] yang sudah divalidasi secara atomik.
  static Future<void> pulihkanDariPayload(Map<String, dynamic> payload) async {
    L.i('pulihkanDariPayload mulai');
    try {
      final op = const SqfliteOp();
      await op.transaksi((txn) async {
        for (final tabel in tabelCadangan) {
          await txn.delete(tabel);
          L.i('Hapus data lama tabel $tabel');
        }
        for (final tabel in tabelCadangan) {
          final rows = payload[tabel];
          if (rows is! List) continue;
          for (final row in rows) {
            if (row is! Map) continue;
            await txn.insert(tabel, Map<String, Object?>.from(row));
          }
          L.i('Pulihkan ${rows.length} baris tabel $tabel');
        }
      });
      L.s('Pemulihan data cadangan berhasil');
    } on Exception catch (e, s) {
      L.e('Gagal memulihkan data cadangan: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/cadangan/screens/cadangan_screen.dart
// ============================================================

```dart
import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/notifier/alasan_berhenti_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/cadangan/helper/cadangan_helper.dart';
import 'package:berhenti_merokok/fitur/diary_craving/notifier/diary_craving_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
// Provider refresh tambahan: tabel konsumsi_rokok, sos_intervensi, dan
// rencana_darurat ikut dipulihkan CadanganHelper, jadi providernya juga
// harus disegarkan agar UI tidak menampilkan data lama.
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/notifier/rencana_darurat_notifier.dart';
import 'package:berhenti_merokok/fitur/sos_craving/notifier/sos_intervensi_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_global_saya/core_shared.dart';

/// Layar khusus cadangan dan ekspor data lokal.
class CadanganScreen extends ConsumerStatefulWidget {
  /// Membuat layar cadangan.
  const CadanganScreen({super.key});

  @override
  ConsumerState<CadanganScreen> createState() => _CadanganScreenState();
}

class _CadanganScreenState extends ConsumerState<CadanganScreen> {
  bool _sedangMemproses = false;

  bool get _platformDidukung {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows;
  }

  Future<void> _eksporData() async {
    if (_sedangMemproses) return;
    L.i('CadanganScreen eksporData');
    if (!_platformDidukung) {
      L.w('Platform tidak mendukung cadangan berkas');
      if (!mounted) return;
      AppToast.gagal(context, 'Platform tidak mendukung ekspor berkas');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Ekspor Data',
      message:
          'Cadangan akan memuat biodata, impian, diary craving, dan alasan '
          'berhenti. Lanjutkan ekspor?',
      okLabel: 'Ekspor',
      cancelLabel: 'Batal',
    );
    if (!mounted) return;
    if (konfirmasi != OkCancelResult.ok) {
      L.w('Ekspor dibatalkan pengguna');
      return;
    }

    setState(() {
      _sedangMemproses = true;
    });
    unawaited(
      EasyLoading.show(
        status: 'Mengekspor data...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading ekspor: $e $s');
      }),
    );
    try {
      final json = await CadanganHelper.buatCadanganJson();
      final namaBerkas =
          'berhenti_merokok_cadangan_${DateTime.now().millisecondsSinceEpoch}.json';
      final bytes = Uint8List.fromList(utf8.encode(json));
      final mime = 'application/json';

      String? pathSimpan;
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        final direktori = await getApplicationDocumentsDirectory();
        pathSimpan = '${direktori.path}/$namaBerkas';
        await CadanganHelper.tulisCadanganKeBerkas(pathSimpan, json);
      } else {
        final uri = await FilePicker.saveFile(
          dialogTitle: 'Simpan cadangan',
          fileName: namaBerkas,
          bytes: bytes,
          mimeType: mime,
          initialDirectory: (await getApplicationDocumentsDirectory()).path,
        );
        if (uri == null) {
          L.w('Pengguna membatalkan pemilihan lokasi simpan');
          if (!mounted) return;
          AppToast.info(context, 'Ekspor dibatalkan');
          return;
        }
        pathSimpan = uri.toFilePath();
        // saveFile menulis bytes pada sebagian platform; pastikan isi sama.
        try {
          await CadanganHelper.tulisCadanganKeBerkas(pathSimpan, json);
        } on Exception catch (e, s) {
          L.w('Tulis ulang cadangan ke path terpilih gagal: $e $s');
        }
      }
      L.i('pathSimpan=$pathSimpan');
      if (!mounted) return;
      AppToast.sukses(context, 'Cadangan berhasil disimpan');
    } on Exception catch (e, s) {
      L.e('Gagal mengekspor data: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, 'Gagal mengekspor data');
    } on UnsupportedError catch (e, s) {
      L.e('Ekspor tidak didukung: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, 'Platform tidak mendukung ekspor');
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading ekspor: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  Future<void> _eksporCsv() async {
    if (_sedangMemproses) return;
    L.i('CadanganScreen eksporCsv');
    if (!_platformDidukung) {
      L.w('Platform tidak mendukung cadangan berkas');
      if (!mounted) return;
      AppToast.gagal(context, 'Platform tidak mendukung ekspor berkas');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Ekspor CSV',
      message:
          'Ekspor ${tabelCadangan.length} berkas CSV (satu berkas per tabel). '
          'Lokasi penyimpanan dipilih satu per berkas. Lanjutkan ekspor?',
      okLabel: 'Ekspor',
      cancelLabel: 'Batal',
    );
    if (!mounted) return;
    if (konfirmasi != OkCancelResult.ok) {
      L.w('Ekspor CSV dibatalkan pengguna');
      return;
    }

    setState(() {
      _sedangMemproses = true;
    });
    unawaited(
      EasyLoading.show(
        status: 'Mengekspor CSV...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading ekspor CSV: $e $s');
      }),
    );
    try {
      var jumlahBerkas = 0;
      for (final tabel in tabelCadangan) {
        final csv = await CadanganHelper.buatCsvTabel(tabel);
        final namaBerkas = CadanganHelper.namaBerkasCsv(tabel);
        final bytes = Uint8List.fromList(utf8.encode(csv));

        final uri = await FilePicker.saveFile(
          dialogTitle: 'Simpan CSV $tabel',
          fileName: namaBerkas,
          bytes: bytes,
          mimeType: 'text/csv',
          initialDirectory: (await getApplicationDocumentsDirectory()).path,
        );
        if (uri == null) {
          L.w('Pengguna membatalkan penyimpanan CSV tabel $tabel');
          if (!mounted) return;
          AppToast.info(context, 'Ekspor CSV dibatalkan');
          return;
        }
        // saveFile sudah menulis bytes ke lokasi terpilih; tidak perlu
        // tulis ulang (mencegah berkas terhapus saat tulis ulang gagal).
        jumlahBerkas++;
        L.i('CSV tabel $tabel disimpan ke $uri');
      }
      if (!mounted) return;
      AppToast.sukses(context, 'Ekspor CSV berhasil ($jumlahBerkas berkas)');
    } on UnsupportedError catch (e, s) {
      L.e('Ekspor CSV tidak didukung: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, 'Platform tidak mendukung ekspor CSV');
    } on Exception catch (e, s) {
      L.e('Gagal mengekspor CSV: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, 'Gagal mengekspor CSV');
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading ekspor CSV: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  Future<void> _pulihkanData() async {
    if (_sedangMemproses) return;
    L.i('CadanganScreen pulihkanData');
    if (!_platformDidukung) {
      L.w('Platform tidak mendukung cadangan berkas');
      if (!mounted) return;
      AppToast.gagal(context, 'Platform tidak mendukung pemulihan berkas');
      return;
    }

    final konfirmasiPilih = await showOkCancelAlertDialog(
      context: context,
      title: 'Pulihkan Data',
      message:
          'Pilih berkas cadangan JSON. Data saat ini akan diganti dengan data '
          'dari cadangan.',
      okLabel: 'Pilih berkas',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    if (!mounted) return;
    if (konfirmasiPilih != OkCancelResult.ok) {
      L.w('Pemulihan dibatalkan pengguna');
      return;
    }

    setState(() {
      _sedangMemproses = true;
    });
    unawaited(
      EasyLoading.show(
        status: 'Memulihkan data...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading pulihkan: $e $s');
      }),
    );
    try {
      final files = await FilePicker.pickFiles(
        dialogTitle: 'Pilih cadangan',
        type: FileType.custom,
        allowedExtensions: const <String>['json'],
      );
      if (!mounted) return;
      if (files.isEmpty) {
        L.w('Pengguna tidak memilih berkas cadangan');
        AppToast.info(context, 'Pemulihan dibatalkan');
        return;
      }
      final picked = files.single;
      final path = picked.path;
      L.i('pathCadangan=$path, nama=${picked.name}');
      Map<String, dynamic> payload;
      if (path != null && path.isNotEmpty) {
        payload = await CadanganHelper.bacaDanValidasiBerkas(path);
      } else {
        final bytes = await picked.readAsBytes();
        payload = CadanganHelper.validasiPayload(utf8.decode(bytes));
      }
      if (!mounted) return;

      final konfirmasiRestore = await showOkCancelAlertDialog(
        context: context,
        title: 'Konfirmasi Pemulihan',
        message:
            'Data lama akan diganti. Tindakan ini tidak dapat dibatalkan. '
            'Lanjutkan pemulihan?',
        okLabel: 'Pulihkan',
        cancelLabel: 'Batal',
        isDestructiveAction: true,
      );
      if (!mounted) return;
      if (konfirmasiRestore != OkCancelResult.ok) {
        L.w('Konfirmasi pemulihan dibatalkan');
        AppToast.info(context, 'Pemulihan dibatalkan');
        return;
      }

      await CadanganHelper.pulihkanDariPayload(payload);
      _refreshProviderSetelahRestore();
      if (!mounted) return;
      AppToast.sukses(context, 'Data berhasil dipulihkan');
    } on BerkasCadanganTidakValidException catch (e, s) {
      L.e('Berkas cadangan tidak valid: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, e.pesan);
    } on Exception catch (e, s) {
      L.e('Gagal memulihkan data: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, 'Gagal memulihkan data');
    } on UnsupportedError catch (e, s) {
      L.e('Pemulihan tidak didukung: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, 'Platform tidak mendukung pemulihan');
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading pulihkan: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  void _refreshProviderSetelahRestore() {
    L.i('Refresh provider setelah restore');
    try {
      final _ = ref.refresh(biodataProvider);
    } on Exception catch (e, s) {
      L.e('Gagal refresh biodataProvider: $e $s');
    }
    try {
      final _ = ref.refresh(impianProvider);
    } on Exception catch (e, s) {
      L.e('Gagal refresh impianProvider: $e $s');
    }
    try {
      final _ = ref.refresh(diaryCravingProvider);
    } on Exception catch (e, s) {
      L.e('Gagal refresh diaryCravingProvider: $e $s');
    }
    try {
      final _ = ref.refresh(alasanBerhentiProvider);
    } on Exception catch (e, s) {
      L.e('Gagal refresh alasanBerhentiProvider: $e $s');
    }
    // Tabel-tabel ini juga ikut dipulihkan dari cadangan, tetapi sebelumnya
    // providernya tidak disegarkan sehingga layar menampilkan data usang.
    try {
      final _ = ref.refresh(konsumsiRokokProvider);
    } on Exception catch (e, s) {
      L.e('Gagal refresh konsumsiRokokProvider: $e $s');
    }
    try {
      final _ = ref.refresh(sosIntervensiProvider);
    } on Exception catch (e, s) {
      L.e('Gagal refresh sosIntervensiProvider: $e $s');
    }
    try {
      final _ = ref.refresh(rencanaDaruratProvider);
    } on Exception catch (e, s) {
      L.e('Gagal refresh rencanaDaruratProvider: $e $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    L.i('CadanganScreen build _sedangMemproses=$_sedangMemproses');
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Cadangan & Ekspor Data')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: !_platformDidukung
              ? Center(
                  child: Text(
                    'Cadangan berkas tidak didukung pada platform ini.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  children: [
                    Text(
                      'Lindungi data biodata, impian, diary craving, dan alasan '
                      'berhenti dengan cadangan lokal.',
                      style: textTheme.bodyMedium,
                    ),
                    FilledButton(
                      onPressed: _sedangMemproses
                          ? null
                          : () {
                              unawaited(_eksporData());
                            },
                      child: const Text('Ekspor data'),
                    ),
                    FilledButton(
                      onPressed: _sedangMemproses
                          ? null
                          : () {
                              unawaited(_eksporCsv());
                            },
                      child: const Text('Ekspor CSV'),
                    ),
                    OutlinedButton(
                      onPressed: _sedangMemproses
                          ? null
                          : () {
                              unawaited(_pulihkanData());
                            },
                      child: const Text('Pulihkan data'),
                    ),
                    Text(
                      'Pemulihan akan mengganti data saat ini dengan data dari '
                      'berkas cadangan.',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/dashboard/notifier/dashboard_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/dashboard/state/dashboard_state.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_notifier.g.dart';

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  Future<DashboardState> build() async {
    return await _muatData();
  }

  Future<DashboardState> _muatData() async {
    await ref.watch(biodataProvider.future);
    await ref.watch(impianProvider.future);
    return DashboardState();
  }
}
```


// ============================================================
// FILE: lib/fitur/dashboard/screens/dashboard_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/alasan_berhenti/notifier/alasan_berhenti_notifier.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/screens/alasan_berhenti_screen.dart';
import 'package:berhenti_merokok/fitur/badge/screens/badge_screen.dart';
import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/screens/form_biodata.dart';
import 'package:berhenti_merokok/fitur/impian/helper/impian_progres_helper.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/screens/impian_screen.dart';
import 'package:berhenti_merokok/fitur/impian/state/impian_state.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/state/konsumsi_rokok_state.dart';
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/screens/pemulihan_kesehatan_screen.dart';
import 'package:berhenti_merokok/fitur/sos_craving/screens/sos_craving_screen.dart';
import 'package:berhenti_merokok/shared/konstanta/milestone_kesehatan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    L.i('DashboardScreen initState');
  }

  @override
  void dispose() {
    L.i('DashboardScreen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(biodataProvider);
    L.i('biodataAsync=$biodataAsync');

    if (biodataAsync.isLoading) {
      L.w('biodataAsync loading');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (biodataAsync.hasError) {
      L.e(
        'biodataAsync error: ${biodataAsync.error} ${biodataAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(biodataProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final biodata = biodataAsync.requireValue;
    L.i('biodata=$biodata');
    if (biodata == null) {
      return _buildBiodataNull();
    }
    final konsumsiAsync = ref.watch(konsumsiRokokProvider);
    final impianAsync = ref.watch(impianProvider);
    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    final nama = biodata.nama;
    L.i('tanggalBerhenti=$tanggalBerhenti, nama=$nama');

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), scrolledUnderElevation: 2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  _CounterSmokeFreeBesar(biodata: biodata),
                  if (tanggalBerhenti != null)
                    Text(
                      'Sejak ${FormatTanggal.formatDasar(tanggalBerhenti)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (nama.isNotEmpty)
                    Text(
                      'Halo, $nama',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRingkasan(biodata),
              _buildCaptionDariCatatan(biodata, konsumsiAsync),
              _buildCardSosCraving(),
              _buildCardKonsumsiHariIni(biodata, konsumsiAsync),
              _buildCardTargetSmokeFree(biodata),
              _buildCardRingkasanImpian(biodata, impianAsync),
              _buildCardAlasanBerhenti(),
              _buildCardBadge(),
              _buildInfoKerugian(biodata),
            ],
          ),
        ),
      ),
    );
  }

  /// Kartu motivasi progres target smoke-free "X dari N hari".
  Widget _buildCardTargetSmokeFree(BiodataModel biodata) {
    final target = biodata.targetSmokeFreeHari;
    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    final hariBerhenti = biodata.hariBerhenti;

    if (target == null) return const SizedBox.shrink();

    String teksProgres;
    if (tanggalBerhenti == null) {
      teksProgres = 'Target: $target hari';
    } else if (hariBerhenti >= target) {
      teksProgres = '$target dari $target hari — Target tercapai';
    } else {
      teksProgres = '$hariBerhenti dari $target hari';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              'Target Smoke-Free',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              teksProgres,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun kartu ringkasan impian (jumlah total dan tercapai) untuk dashboard.
  Widget _buildCardRingkasanImpian(
    BiodataModel biodata,
    AsyncValue<ImpianState> impianAsync,
  ) {
    final uangDihemat = biodata.uangDihemat;
    String subtitle;
    if (impianAsync.isLoading) {
      subtitle = 'Memuat data impian...';
      L.i('ringkasan impian: loading, uangDihemat=$uangDihemat');
    } else if (impianAsync.hasError) {
      subtitle = 'Gagal memuat data impian';
      L.w(
        'ringkasan impian error=${impianAsync.error}, uangDihemat=$uangDihemat',
      );
    } else {
      final impianState = impianAsync.requireValue;
      final listImpian = impianState.listImpian;
      final total = impianState.jumlahImpian;
      final tercapai = listImpian
          .where(
            (item) => ImpianProgresHelper.tercapai(uangDihemat, item.jumlah),
          )
          .length;
      L.i(
        'ringkasan impian: total=$total, tercapai=$tercapai, uangDihemat=$uangDihemat',
      );
      if (total == 0) {
        subtitle = 'Belum ada impian';
      } else {
        subtitle = '$tercapai dari $total impian tercapai';
      }
    }

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => unawaited(
          Nav.to(context, const ImpianScreen()).catchError((
            Object e,
            StackTrace s,
          ) {
            L.e('Gagal navigasi ke Impian: $e $s');
            return null;
          }),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                CupertinoIcons.star_fill,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      'Impian',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  /// Baris 3 kartu ringkasan seragam: uang dihemat (estimasi), rokok
  /// tidak dihisap (estimasi), dan milestone kesehatan berikutnya (tap →
  /// `PemulihanKesehatanScreen`). Bobot visual ketiganya seragam.
  Widget _buildRingkasan(BiodataModel biodata) {
    final rokokEstimasi = MetrikBerhentiHelper.hitungRokokTidakDiHisapEstimasi(
      biodata,
    );
    final uangEstimasi = MetrikBerhentiHelper.hitungUangDihematEstimasi(
      biodata,
    );

    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    final durasi = tanggalBerhenti == null
        ? Duration.zero
        : DateTime.now().difference(tanggalBerhenti);
    final aman = durasi.isNegative ? Duration.zero : durasi;
    final berikutnya = milestoneBerikutnya(aman);
    final sisa = berikutnya == null ? null : berikutnya.target - aman;
    L.i(
      'milestoneBerikutnya=${berikutnya?.judul}, rokokEstimasi=$rokokEstimasi, uangEstimasi=$uangEstimasi',
    );

    return IntrinsicHeight(
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _KartuRingkasan(
              judul: 'Uang dihemat (estimasi)',
              nilai: FormatUang.formatRupiah(uangEstimasi),
            ),
          ),
          Expanded(
            child: _KartuRingkasan(
              judul: 'Rokok dihindari (estimasi)',
              nilai: '$rokokEstimasi batang',
            ),
          ),
          Expanded(
            child: _KartuRingkasan(
              judul: 'Milestone berikutnya',
              nilai: berikutnya?.judul ?? 'Semua tercapai',
              keterangan: sisa == null
                  ? null
                  : 'Tersisa ${_formatDurasiSingkat(sisa)}',
              onTap: () => unawaited(
                Nav.to(context, const PemulihanKesehatanScreen()).catchError((
                  Object e,
                  StackTrace s,
                ) {
                  L.e('Gagal navigasi ke Pemulihan Kesehatan: $e $s');
                  return null;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Caption satu baris "Dari catatan": aktual dari catatan konsumsi
  /// ditampilkan ringkas (bukan blok besar). Loading/error/kosong ditangani
  /// dengan pesan singkat ber-bodySmall.
  ///
  /// Dibungkus [Padding] vertikal agar caption punya jarak serasi terhadap
  /// kartu ringkasan di atasnya dan kartu SOS Craving di bawahnya (Text
  /// telanjang tidak punya margin seperti Card).
  Widget _buildCaptionDariCatatan(
    BiodataModel biodata,
    AsyncValue<KonsumsiRokokState> konsumsiAsync,
  ) {
    final style = Theme.of(context).textTheme.bodySmall;

    final Widget isi;
    if (konsumsiAsync.isLoading) {
      isi = Text('Menghitung dari catatan…', style: style);
    } else if (konsumsiAsync.hasError) {
      L.e(
        'konsumsiAsync error: ${konsumsiAsync.error} ${konsumsiAsync.stackTrace}',
      );
      isi = Text(
        'Catatan konsumsi gagal dimuat; menampilkan estimasi.',
        style: style,
      );
    } else {
      final konsumsiList = konsumsiAsync.asData?.value.listKonsumsi;
      final adaCatatan = konsumsiList != null && konsumsiList.isNotEmpty;
      if (!adaCatatan) {
        isi = Text(
          'Belum ada catatan konsumsi — aktual tersedia setelah Anda mencatat.',
          style: style,
        );
      } else {
        final hariTercatat = MetrikBerhentiHelper.hitungJumlahHariTercatat(
          konsumsiList,
        );
        final rokokAktual = MetrikBerhentiHelper.hitungRokokDihindariAktual(
          biodata,
          konsumsiList,
        );
        final uangAktual = MetrikBerhentiHelper.hitungUangDihematAktual(
          biodata,
          konsumsiList,
        );
        L.i(
          'hariTercatat=$hariTercatat, rokokAktual=$rokokAktual, uangAktual=$uangAktual',
        );

        isi = Text(
          'Dari catatan ($hariTercatat hari tercatat): '
          '${FormatUang.formatRupiah(uangAktual)} · $rokokAktual batang',
          style: style,
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: isi,
    );
  }

  /// Kartu konsumsi rokok aktual hari ini dibandingkan target tapering.
  ///
  /// Jika sedang tapering: tampilkan "X / Y batang" dengan progress bar dan
  /// warna kondisional (hijau jika dalam target, oranye jika melebihi).
  /// Jika tidak tapering: tampilkan "Hari Ini: X batang".
  Widget _buildCardKonsumsiHariIni(
    BiodataModel biodata,
    AsyncValue<KonsumsiRokokState> konsumsiAsync,
  ) {
    final konsumsiHariIni = konsumsiAsync.asData != null
        ? KonsumsiHitungHelper.konsumsiHariIni(
            konsumsiAsync.asData!.value.listKonsumsi,
          )
        : 0;
    final sedangTapering = biodata.sedangTapering;
    final targetHariIni = biodata.targetRokokHariIni;
    final melebihiTarget = konsumsiHariIni > targetHariIni;
    final warnaProgres = melebihiTarget
        ? const Color(0xFFFF9800)
        : const Color(0xFF4CAF50);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              'Konsumsi Hari Ini',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (sedangTapering) ...[
              Text(
                '$konsumsiHariIni / $targetHariIni batang',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: warnaProgres,
                ),
              ),
              LinearProgressIndicator(
                value: targetHariIni > 0
                    ? (konsumsiHariIni / targetHariIni).clamp(0.0, 1.0)
                    : 0,
                color: warnaProgres,
                backgroundColor: warnaProgres.withValues(alpha: 0.2),
              ),
            ] else ...[
              Text(
                'Hari Ini: $konsumsiHariIni batang',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardSosCraving() {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => unawaited(
          Nav.to(context, const SosCravingScreen()).catchError((
            Object e,
            StackTrace s,
          ) {
            L.e('Gagal navigasi ke SOS Craving: $e $s');
            return null;
          }),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                Icons.sos,
                size: 32,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      'SOS Craving',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                    Text(
                      'Butuh bantuan saat craving? Tekan untuk bantuan cepat.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Membangun kartu pintasan alasan berhenti dengan jumlah alasan tersimpan.
  Widget _buildCardAlasanBerhenti() {
    return Consumer(
      builder: (context, ref, _) {
        final alasanAsync = ref.watch(alasanBerhentiProvider);
        final jumlah = alasanAsync.asData?.value.jumlahAlasan ?? 0;
        L.i('jumlahAlasan=$jumlah');
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => unawaited(
              Nav.to(context, const AlasanBerhentiScreen()).catchError((
                Object e,
                StackTrace s,
              ) {
                L.e('Gagal navigasi ke Alasan Berhenti: $e $s');
                return null;
              }),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                spacing: 12,
                children: [
                  const Icon(CupertinoIcons.heart_fill, size: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          'Alasan Berhenti',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$jumlah alasan tersimpan',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatHariHilang(double hariHilang) {
    if (hariHilang <= 365) {
      return '${hariHilang.toStringAsFixed(1)} hari';
    }
    final totalHari = hariHilang.round();
    final tahun = totalHari ~/ 365;
    final sisaTahun = totalHari % 365;
    final bulan = sisaTahun ~/ 30;
    final hari = sisaTahun % 30;
    return '$tahun'
        'T $bulan'
        'B $hari'
        'H';
  }

  String _formatDurasiSingkat(Duration d) {
    if (d.inDays > 0) {
      final hari = d.inDays;
      final jam = d.inHours % 24;
      if (jam > 0) return '$hari hari $jam jam';
      return '$hari hari';
    }
    if (d.inHours > 0) {
      final jam = d.inHours;
      final menit = d.inMinutes % 60;
      if (menit > 0) return '$jam jam $menit menit';
      return '$jam jam';
    }
    final menit = d.inMinutes;
    final detik = d.inSeconds % 60;
    if (menit > 0) return '$menit menit $detik detik';
    return '$detik detik';
  }

  Widget _buildCardBadge() {
    return Card(
      child: InkWell(
        onTap: () => unawaited(
          Nav.to(context, const BadgeScreen()).catchError((
            Object e,
            StackTrace s,
          ) {
            L.e('Gagal navigasi ke Badge: $e $s');
            return null;
          }),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              const Icon(CupertinoIcons.rosette, size: 32, color: Colors.amber),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      'Pencapaian',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Lihat badge yang telah tercapai',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoKerugian(BiodataModel biodata) {
    final jumlahRokokPerHari = biodata.jumlahRokokPerHari;
    final hargaPerBungkus = biodata.hargaRokokPerBungkus;
    final tanggalMulaiMerokok = biodata.tanggalMulaiMerokok;
    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;

    int totalHariMerokok = 0;
    if (tanggalMulaiMerokok != null && tanggalBerhenti != null) {
      final mulaiDate = DateTime(
        tanggalMulaiMerokok.year,
        tanggalMulaiMerokok.month,
        tanggalMulaiMerokok.day,
      );
      final berhentiDate = DateTime(
        tanggalBerhenti.year,
        tanggalBerhenti.month,
        tanggalBerhenti.day,
      );
      totalHariMerokok = berhentiDate.difference(mulaiDate).inDays;
      if (totalHariMerokok < 0) {
        totalHariMerokok = 0;
      }
    }

    final rokokDihisap = jumlahRokokPerHari * totalHariMerokok;
    final uangTerbuang = biodata.batangPerBungkus == 0
        ? 0.0
        : (rokokDihisap / biodata.batangPerBungkus) * hargaPerBungkus;
    final menitHilang = (rokokDihisap * 11).round();
    final hariHilang = menitHilang / (24 * 60);
    L.i(
      'totalHariMerokok=$totalHariMerokok, rokokDihisap=$rokokDihisap, uangTerbuang=$uangTerbuang, menitHilang=$menitHilang, hariHilang=$hariHilang',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              'Kerugian saat merokok',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            _buildInfoKerugianKustom(
              CupertinoIcons.smoke,
              '$rokokDihisap batang',
              'Total rokok yang dihisap',
            ),
            _buildInfoKerugianKustom(
              CupertinoIcons.money_dollar,
              FormatUang.formatRupiah(uangTerbuang),
              'uang yang terbuang',
            ),
            _buildInfoKerugianKustom(
              CupertinoIcons.heart,
              _formatHariHilang(hariHilang),
              'hidup yang hilang',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoKerugianKustom(
    IconData icon,
    String title,
    String subtitle,
  ) {
    L.i('icon=$icon, title=$title, subtitle=$subtitle');
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildBiodataNull() {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                const Text('Belum ada data biodata'),
                OutlinedButton(
                  onPressed: () => unawaited(
                    Nav.to(
                      context,
                      const FormBiodata(buatPertama: false),
                    ).catchError((Object e, StackTrace s) {
                      L.e('Gagal navigasi ke Form Biodata: $e $s');
                      return null;
                    }),
                  ),
                  child: const Text('Isi Biodata'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget terisolasi yang menampilkan counter smoke-free besar (hari + jam)
/// di bagian atas Dashboard. Timer per detik hanya membangun ulang widget
/// ini, bukan seluruh halaman.
class _CounterSmokeFreeBesar extends StatefulWidget {
  const _CounterSmokeFreeBesar({required this.biodata});

  final BiodataModel biodata;

  @override
  State<_CounterSmokeFreeBesar> createState() => _CounterSmokeFreeBesarState();
}

class _CounterSmokeFreeBesarState extends State<_CounterSmokeFreeBesar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teks = _formatCounterSmokeFreeBesar(widget.biodata);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        teks,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// Menghitung teks counter smoke-free besar "X hari Y jam" dari [biodata].
/// Menggunakan [BiodataModel.hariBerhenti] dari ekstensi perhitungan dan
/// menghitung sisa jam dari selisih waktu dengan normalisasi dan klamping.
String _formatCounterSmokeFreeBesar(BiodataModel biodata) {
  final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
  final hariBerhenti = biodata.hariBerhenti;

  int jamSisa = 0;
  if (tanggalBerhenti != null) {
    final selisih = DateTime.now().difference(tanggalBerhenti);
    final totalJam = selisih.inHours;
    jamSisa = totalJam < 0 ? 0 : totalJam % 24;
  }

  return '$hariBerhenti hari $jamSisa jam';
}

/// Kartu ringkasan seragam untuk baris 3 metrik pendukung di Dashboard.
/// StatelessWidget, pure, aman untuk tema; label "(estimasi)" ditulis di
/// judul oleh pemanggil. Bila [onTap] diisi, kartu menjadi tappable.
class _KartuRingkasan extends StatelessWidget {
  const _KartuRingkasan({
    required this.judul,
    required this.nilai,
    this.keterangan,
    this.onTap,
  });

  final String judul;
  final String nilai;
  final String? keterangan;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isi = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Text(
            judul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nilai,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          if (keterangan != null)
            Text(
              keterangan!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
        ],
      ),
    );

    if (onTap == null) {
      return Card(child: isi);
    }
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: isi,
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/dashboard/state/dashboard_state.dart
// ============================================================

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState({
    @Default(0) double totalDiHemat,
    @Default(0) double totalBatangDiAbaikan,
  }) = _DashboardState;
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/enum/hasil_craving_enum.dart
// ============================================================

```dart
/// Hasil akhir dari craving.
// Enum value di-lowerCamelCase sesuai konvensi penamaan proyek (sebelumnya
// snake_case yang ikut tersimpan ke kolom database).
enum HasilCravingEnum {
  berhasilMenahan,
  tetapMerokok,
  belumSelesai,
}

/// Extension yang menyediakan label untuk [HasilCravingEnum].
extension HasilCravingEnumExtension on HasilCravingEnum {
  String get label {
    switch (this) {
      case HasilCravingEnum.berhasilMenahan:
        return 'Berhasil menahan';
      case HasilCravingEnum.tetapMerokok:
        return 'Tetap merokok';
      case HasilCravingEnum.belumSelesai:
        return 'Belum selesai';
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/enum/mood_craving_enum.dart
// ============================================================

```dart
/// Suasana hati saat craving menyerang.
enum MoodCravingEnum {
  senang,
  netral,
  sedih,
  cemas,
  marah,
  stres,
}

/// Extension yang menyediakan label untuk [MoodCravingEnum].
extension MoodCravingEnumExtension on MoodCravingEnum {
  String get label {
    switch (this) {
      case MoodCravingEnum.senang:
        return 'Senang';
      case MoodCravingEnum.netral:
        return 'Netral';
      case MoodCravingEnum.sedih:
        return 'Sedih';
      case MoodCravingEnum.cemas:
        return 'Cemas';
      case MoodCravingEnum.marah:
        return 'Marah';
      case MoodCravingEnum.stres:
        return 'Stres';
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/enum/pemicu_enum.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

/// Kategori pemicu craving.
enum PemicuEnum {
  stres,
  kopi,
  alkohol,
  sosial,
  bauRokok,
  emosi,
  lapar,
  lelah,
  lainnya,
}

/// Extension yang menyediakan label dan ikon untuk [PemicuEnum].
extension PemicuEnumExtension on PemicuEnum {
  String get label {
    switch (this) {
      case PemicuEnum.stres:
        return 'Stres';
      case PemicuEnum.kopi:
        return 'Kopi';
      case PemicuEnum.alkohol:
        return 'Alkohol';
      case PemicuEnum.sosial:
        return 'Sosial';
      case PemicuEnum.bauRokok:
        return 'Bau rokok';
      case PemicuEnum.emosi:
        return 'Emosi';
      case PemicuEnum.lapar:
        return 'Lapar';
      case PemicuEnum.lelah:
        return 'Lelah';
      case PemicuEnum.lainnya:
        return 'Lainnya';
    }
  }

  IconData get icon {
    switch (this) {
      case PemicuEnum.stres:
        return Icons.psychology_alt_outlined;
      case PemicuEnum.kopi:
        return Icons.coffee_outlined;
      case PemicuEnum.alkohol:
        return Icons.local_bar_outlined;
      case PemicuEnum.sosial:
        return Icons.people_outline;
      case PemicuEnum.bauRokok:
        return Icons.smoking_rooms_outlined;
      case PemicuEnum.emosi:
        return Icons.mood_outlined;
      case PemicuEnum.lapar:
        return Icons.restaurant_outlined;
      case PemicuEnum.lelah:
        return Icons.bedtime_outlined;
      case PemicuEnum.lainnya:
        return Icons.more_horiz;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/enum/strategi_craving_enum.dart
// ============================================================

```dart
/// Strategi yang dicoba untuk menahan craving.
// Enum value di-lowerCamelCase sesuai konvensi penamaan proyek (sebelumnya
// snake_case yang ikut tersimpan ke kolom database).
enum StrategiCravingEnum {
  napas478,
  minumAir,
  jalan,
  alihAktivitas,
  tunda5Menit,
  lainnya,
}

/// Extension yang menyediakan label untuk [StrategiCravingEnum].
extension StrategiCravingEnumExtension on StrategiCravingEnum {
  String get label {
    switch (this) {
      case StrategiCravingEnum.napas478:
        return 'Napas 4-7-8';
      case StrategiCravingEnum.minumAir:
        return 'Minum air';
      case StrategiCravingEnum.jalan:
        return 'Jalan';
      case StrategiCravingEnum.alihAktivitas:
        return 'Alih aktivitas';
      case StrategiCravingEnum.tunda5Menit:
        return 'Tunda 5 menit';
      case StrategiCravingEnum.lainnya:
        return 'Lainnya';
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/helper/pola_craving_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/diary_craving/enum/hasil_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/pemicu_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/strategi_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/model/diary_craving_model.dart';
import 'package:share_global_saya/core_shared.dart';

/// Helper murni untuk menghitung pola dan wawasan dari data Diary Craving.
class PolaCravingHelper {
  const PolaCravingHelper._();

  /// Jumlah entri minimum sebelum wawasan dapat ditampilkan.
  static const int minimumEntri = 3;

  /// Jumlah entri minimum per strategi sebelum rasio berhasil dihitung.
  static const int minimumEntriStrategi = 3;

  /// Normalisasi [waktu] ke komponen tanggal saja (tahun, bulan, hari).
  static DateTime _tanggalSaja(DateTime waktu) {
    return DateTime(waktu.year, waktu.month, waktu.day);
  }

  /// Menyaring [daftar] menjadi entri yang terjadi dalam [jumlahHari] hari
  /// terakhir (termasuk hari ini). Perbandingan dilakukan pada komponen
  /// tanggal saja.
  static List<DiaryCravingModel> filterNHari(
    List<DiaryCravingModel> daftar,
    int jumlahHari, {
    DateTime? sekarang,
  }) {
    final hariIni = _tanggalSaja(sekarang ?? DateTime.now());
    final batasAwal = hariIni.subtract(Duration(days: jumlahHari - 1));
    L.i('jumlahHari=$jumlahHari, batasAwal=$batasAwal, hariIni=$hariIni');
    return daftar.where((c) {
      final tanggal = _tanggalSaja(c.tanggal);
      return !tanggal.isBefore(batasAwal) && !tanggal.isAfter(hariIni);
    }).toList();
  }

  /// Entri dalam 7 hari terakhir (termasuk hari ini).
  static List<DiaryCravingModel> pola7Hari(
    List<DiaryCravingModel> daftar, {
    DateTime? sekarang,
  }) {
    return filterNHari(daftar, 7, sekarang: sekarang);
  }

  /// Entri dalam 30 hari terakhir (termasuk hari ini).
  static List<DiaryCravingModel> pola30Hari(
    List<DiaryCravingModel> daftar, {
    DateTime? sekarang,
  }) {
    return filterNHari(daftar, 30, sekarang: sekarang);
  }

  /// Rata-rata intensitas dari [daftar], atau `null` bila daftar kosong.
  static double? rataRataIntensitas(List<DiaryCravingModel> daftar) {
    if (daftar.isEmpty) {
      return null;
    }
    final total = daftar.fold<int>(0, (acc, c) => acc + c.intensitas);
    final rataRata = total / daftar.length;
    L.i('daftar.length=${daftar.length}, rataRata=$rataRata');
    return rataRata;
  }

  /// Mengembalikan jam lokal (0-23) yang paling sering muncul dalam [daftar],
  /// atau `null` jika jumlah entri kurang dari [minimumEntri].
  ///
  /// Perhitungan bersifat murni dan hanya membaca data; tidak menulis database.
  static int? jamTeratas(List<DiaryCravingModel> daftar) {
    L.i('daftar.length=${daftar.length}');
    if (daftar.length < minimumEntri) {
      return null;
    }

    final Map<int, int> freq = {};
    for (final c in daftar) {
      final jam = c.tanggal.hour;
      freq[jam] = (freq[jam] ?? 0) + 1;
    }

    int? jamTeratas;
    int jumlahTerbesar = 0;
    freq.forEach((jam, jumlah) {
      if (jumlah > jumlahTerbesar) {
        jumlahTerbesar = jumlah;
        jamTeratas = jam;
      }
    });

    L.i('jamTeratas=$jamTeratas, jumlah=$jumlahTerbesar');
    return jamTeratas;
  }

  /// Pemicu yang muncul minimal [minimumEntri] kali, diurutkan dari yang
  /// paling sering. Tie-breaker deterministik berdasarkan index enum.
  static List<MapEntry<PemicuEnum, int>> pemicuBerulang(
    List<DiaryCravingModel> daftar, {
    int minimumEntri = minimumEntri,
  }) {
    L.i('daftar.length=${daftar.length}, minimumEntri=$minimumEntri');
    final Map<PemicuEnum, int> freq = {};
    for (final c in daftar) {
      freq[c.pemicu] = (freq[c.pemicu] ?? 0) + 1;
    }

    final hasil = freq.entries
        .where((e) => e.value >= minimumEntri)
        .toList()
      ..sort((a, b) {
        final cmp = b.value.compareTo(a.value);
        if (cmp != 0) return cmp;
        return a.key.index.compareTo(b.key.index);
      });
    L.i('pemicuBerulang=$hasil');
    return hasil;
  }

  /// Strategi dengan rasio `berhasilMenahan` tertinggi, minimal
  /// [minimumEntri] entri per strategi. `null` bila tidak ada strategi
  /// yang memadai.
  static StrategiCravingEnum? strategiPalingMembantu(
    List<DiaryCravingModel> daftar, {
    int minimumEntri = minimumEntriStrategi,
  }) {
    L.i('daftar.length=${daftar.length}, minimumEntri=$minimumEntri');
    final Map<StrategiCravingEnum, List<DiaryCravingModel>> grup = {};
    for (final c in daftar) {
      final s = c.strategi;
      if (s != null) {
        grup.putIfAbsent(s, () => []).add(c);
      }
    }

    StrategiCravingEnum? terbaik;
    var rasioTerbaik = -1.0;
    grup.forEach((s, entries) {
      if (entries.length < minimumEntri) return;
      final sukses = entries
          .where((e) => e.hasil == HasilCravingEnum.berhasilMenahan)
          .length;
      final rasio = sukses / entries.length;
      if (rasio > rasioTerbaik) {
        rasioTerbaik = rasio;
        terbaik = s;
      }
    });

    L.i('strategiPalingMembantu=$terbaik, rasio=$rasioTerbaik');
    return terbaik;
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/model/diary_craving_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/diary_craving/notifier/diary_craving_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/diary_craving/model/diary_craving_model.dart';
import 'package:berhenti_merokok/fitur/diary_craving/state/diary_craving_state.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';

part 'diary_craving_notifier.g.dart';

@Riverpod(keepAlive: true)
class DiaryCravingNotifier extends _$DiaryCravingNotifier {
  @override
  Future<DiaryCravingState> build() async {
    return await _ambilSemua();
  }

  Future<DiaryCravingState> _ambilSemua() async {
    try {
      final op = const SqfliteOp();
      final rows = await op.ambilSemua(
        NamaTabel.diaryCraving,
        orderBy: '${NamaKolom.tanggal} DESC',
      );
      final daftar = rows.map(DiaryCravingModel.fromSqflite).toList();
      L.i('daftar.length=${daftar.length}');
      return DiaryCravingState(
        listCraving: daftar,
        jumlahCraving: daftar.length,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data diary craving: $e $s');
      rethrow;
    }
  }

  Future<void> tambah(DiaryCravingModel craving) async {
    L.i('craving=$craving');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.diaryCraving,
        craving.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
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

  Future<void> ubah(DiaryCravingModel craving) async {
    L.i('craving=$craving');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.ubah(
        NamaTabel.diaryCraving,
        craving.toSqflite(),
        where: '${NamaKolom.id} = ?',
        whereArgs: [craving.id],
      );
      final baru = dataLama.listCraving
          .map((e) => e.id == craving.id ? craving : e)
          .toList();
      state = AsyncValue.data(
        DiaryCravingState(listCraving: baru, jumlahCraving: baru.length),
      );
      L.s('Diary craving berhasil diubah');
    } on Exception catch (e, s) {
      L.e('Gagal mengubah diary craving: $e $s');
      rethrow;
    }
  }

  Future<void> hapus(String id) async {
    L.i('id=$id');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.hapus(
        NamaTabel.diaryCraving,
        where: '${NamaKolom.id} = ?',
        whereArgs: [id],
      );
      final baru = dataLama.listCraving.where((e) => e.id != id).toList();
      state = AsyncValue.data(
        DiaryCravingState(listCraving: baru, jumlahCraving: baru.length),
      );
      L.s('Diary craving berhasil dihapus');
    } on Exception catch (e, s) {
      L.e('Gagal menghapus diary craving: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/screens/diary_craving_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/hasil_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/mood_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/pemicu_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/strategi_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/helper/pola_craving_helper.dart';
import 'package:berhenti_merokok/fitur/diary_craving/model/diary_craving_model.dart';
import 'package:berhenti_merokok/fitur/diary_craving/notifier/diary_craving_notifier.dart';
import 'package:berhenti_merokok/fitur/diary_craving/screens/form_diary_craving.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

class DiaryCravingScreen extends ConsumerStatefulWidget {
  const DiaryCravingScreen({super.key});

  @override
  ConsumerState<DiaryCravingScreen> createState() => _DiaryCravingScreenState();
}

class _DiaryCravingScreenState extends ConsumerState<DiaryCravingScreen> {
  @override
  void initState() {
    super.initState();
    L.i('DiaryCravingScreen initState');
  }

  @override
  void dispose() {
    L.i('DiaryCravingScreen dispose');
    super.dispose();
  }

  void _navigasiKeForm() {
    unawaited(
      Nav.to(context, const FormDiaryCraving()).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Form Diary Craving: $e $s');
        return null;
      }),
    );
  }

  Future<void> _hapus(DiaryCravingModel item) async {
    L.i('item.id=${item.id}');
    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Catatan',
      message:
          'Apakah Anda yakin ingin menghapus catatan craving ini '
          '(${item.pemicu.label})?',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      return;
    }
    if (!mounted) return;
    try {
      await ref.read(diaryCravingProvider.notifier).hapus(item.id);
      if (mounted) {
        AppToast.sukses(context, 'Catatan craving berhasil dihapus');
      }
    } on Exception catch (e, s) {
      L.e('Gagal menghapus diary craving: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menghapus catatan craving');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cravingAsync = ref.watch(diaryCravingProvider);

    if (cravingAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (cravingAsync.hasError) {
      L.w('diaryCravingProvider error=${cravingAsync.error}');
      return Scaffold(
        appBar: AppBar(title: const Text('Diary Craving')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              const Text('Gagal memuat data diary craving'),
              OutlinedButton(
                onPressed: () {
                  final _ = ref.refresh(diaryCravingProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final state = cravingAsync.requireValue;
    final list = state.listCraving;

    // Hitung frekuensi pemicu untuk ringkasan analisis pemicu.
    final Map<PemicuEnum, int> freqPemicu = {};
    for (final c in list) {
      freqPemicu[c.pemicu] = (freqPemicu[c.pemicu] ?? 0) + 1;
    }
    final entriPemicu = freqPemicu.entries.toList()
      ..sort((a, b) {
        final cmp = b.value.compareTo(a.value);
        if (cmp != 0) return cmp;
        // Tie-breaker deterministik: urutkan berdasarkan index enum saat jumlah sama,
        // agar topPemicu dan agregat konsisten di seluruh rebuild (List.sort tidak stabil).
        return a.key.index.compareTo(b.key.index);
      });
    final topPemicu = entriPemicu.take(3).toList();
    final jumlahLainnya = entriPemicu.skip(3).fold<int>(
      0,
      (total, e) => total + e.value,
    );

    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Diary Craving')),
        body: EmptyStateView(
          ikon: CupertinoIcons.book,
          judul: 'Belum ada catatan craving',
          deskripsi:
              'Catat setiap dorongan merokok untuk memahami pemicu dan '
              'strategi yang paling membantu.',
          ctaLabel: 'Catat Craving',
          onCta: _navigasiKeForm,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigasiKeForm,
          child: const Icon(CupertinoIcons.add),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Diary Craving')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              if (topPemicu.isNotEmpty)
                _RingkasanPemicu(
                  topPemicu: topPemicu,
                  jumlahLainnya: jumlahLainnya,
                ),
              if (list.length >= PolaCravingHelper.minimumEntri)
                _RingkasanWawasan(list: list)
              else
                const _PlaceholderWawasan(),
              Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final mood = item.mood;
                    final hasil = item.hasil;
                    return Card(
                      key: ValueKey(item.id),
                      child: ListTile(
                        leading: Icon(item.pemicu.icon),
                        title: Text(item.pemicu.label),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              'Intensitas: ${item.intensitas}/5  •  ${FormatWaktuLengkap.formatSingkat(item.tanggal)}',
                            ),
                            if (item.catatan != null && item.catatan!.isNotEmpty)
                              Text(item.catatan!),
                            if (mood != null || hasil != null)
                              Row(
                                spacing: 8,
                                children: [
                                  if (mood != null)
                                    _PenandaDetail(
                                      icon: Icons.mood_outlined,
                                      label: mood.label,
                                    ),
                                  if (hasil != null)
                                    _PenandaDetail(
                                      icon: hasil ==
                                              HasilCravingEnum.berhasilMenahan
                                          ? Icons.check_circle_outline
                                          : Icons.radio_button_unchecked,
                                      label: hasil.label,
                                    ),
                                ],
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Hapus',
                          onPressed: () => unawaited(_hapus(item)),
                        ),
                        onTap: () => unawaited(
                          Nav.to(context, FormDiaryCraving(craving: item)).catchError((
                            Object e,
                            StackTrace s,
                          ) {
                            L.e('Gagal navigasi ke Form Diary Craving: $e $s');
                            return null;
                          }),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigasiKeForm,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}

/// Ringkasan analisis pemicu: menampilkan 3 pemicu teratas beserta jumlahnya,
/// ditambah label "Lainnya" dengan jumlah sisa jika ada pemicu di luar top 3.
class _RingkasanPemicu extends StatelessWidget {
  const _RingkasanPemicu({
    required this.topPemicu,
    required this.jumlahLainnya,
  });

  final List<MapEntry<PemicuEnum, int>> topPemicu;
  final int jumlahLainnya;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              'Pemicu Teratas',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ...topPemicu.map(
              (e) => _BarisPemicu(
                icon: e.key.icon,
                label: e.key.label,
                jumlah: e.value,
              ),
            ),
                if (jumlahLainnya > 0)
              _BarisPemicu(
                icon: Icons.more_horiz,
                label: 'Kategori lain',
                jumlah: jumlahLainnya,
              ),
          ],
        ),
      ),
    );
  }
}

/// Satu baris ringkasan pemicu: ikon, label, dan jumlah kemunculan.
class _BarisPemicu extends StatelessWidget {
  const _BarisPemicu({
    required this.icon,
    required this.label,
    required this.jumlah,
  });

  final IconData icon;
  final String label;
  final int jumlah;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      spacing: 8,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$jumlah',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Ringkasan wawasan craving: rata-rata intensitas 7/30 hari, jam rawan,
/// dan strategi paling membantu (bila data memadai).
class _RingkasanWawasan extends StatelessWidget {
  const _RingkasanWawasan({required this.list});

  final List<DiaryCravingModel> list;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sekarang = DateTime.now();
    L.i('list.length=${list.length}, sekarang=$sekarang');
    final rataRata7 = PolaCravingHelper.rataRataIntensitas(
      PolaCravingHelper.pola7Hari(list, sekarang: sekarang),
    );
    final rataRata30 = PolaCravingHelper.rataRataIntensitas(
      PolaCravingHelper.pola30Hari(list, sekarang: sekarang),
    );
    final jamRawan = PolaCravingHelper.jamTeratas(list);
    final strategi = PolaCravingHelper.strategiPalingMembantu(list);
    L.i(
      'rataRata7=$rataRata7, rataRata30=$rataRata30, jamRawan=$jamRawan, strategi=$strategi',
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              'Wawasan',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _BarisWawasan(
              label: 'Rata-rata intensitas 7 hari',
              nilai: rataRata7 == null
                  ? '-'
                  : '${rataRata7.toStringAsFixed(1)}/5',
            ),
            _BarisWawasan(
              label: 'Rata-rata intensitas 30 hari',
              nilai: rataRata30 == null
                  ? '-'
                  : '${rataRata30.toStringAsFixed(1)}/5',
            ),
            _BarisWawasan(
              label: 'Jam rawan',
              nilai: jamRawan == null
                  ? '-'
                  : '${jamRawan.toString().padLeft(2, '0')}.00',
            ),
            if (strategi != null)
              _BarisWawasan(
                label: 'Strategi paling membantu',
                nilai: strategi.label,
              ),
          ],
        ),
      ),
    );
  }
}

/// Satu baris ringkasan wawasan: label dan nilai.
class _BarisWawasan extends StatelessWidget {
  const _BarisWawasan({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          nilai,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Placeholder kecil yang ditampilkan saat entri belum cukup untuk wawasan.
class _PlaceholderWawasan extends StatelessWidget {
  const _PlaceholderWawasan();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          spacing: 8,
          children: [
            Icon(
              CupertinoIcons.info_circle,
              size: 18,
              color: colorScheme.primary,
            ),
            Expanded(
              child: Text(
                'Catat minimal 3 craving untuk melihat wawasan',
                style: textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Penanda kecil untuk menampilkan mood/hasil pada item daftar craving.
class _PenandaDetail extends StatelessWidget {
  const _PenandaDetail({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(icon, size: 14, color: colorScheme.primary),
        Flexible(
          child: Text(
            label,
            style: textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/screens/form_diary_craving.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/hasil_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/mood_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/pemicu_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/strategi_craving_enum.dart';
import 'package:berhenti_merokok/fitur/diary_craving/model/diary_craving_model.dart';
import 'package:berhenti_merokok/fitur/diary_craving/notifier/diary_craving_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:uuid/uuid.dart';

class FormDiaryCraving extends ConsumerStatefulWidget {
  final DiaryCravingModel? craving;
  const FormDiaryCraving({super.key, this.craving});

  @override
  ConsumerState<FormDiaryCraving> createState() => _FormDiaryCravingState();
}

class _FormDiaryCravingState extends ConsumerState<FormDiaryCraving> {
  final _formKey = GlobalKey<FormState>();
  final _catatanController = TextEditingController();
  final _catatanFocusNode = FocusNode();
  final _durasiController = TextEditingController();

  PemicuEnum _pemicu = PemicuEnum.stres;
  int _intensitas = 3;
  DateTime _tanggal = DateTime.now();
  MoodCravingEnum? _mood;
  StrategiCravingEnum? _strategi;
  HasilCravingEnum? _hasil;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final craving = widget.craving;
    L.i('craving=$craving');
    if (craving != null) {
      _pemicu = craving.pemicu;
      _intensitas = craving.intensitas;
      _tanggal = craving.tanggal;
      _catatanController.text = craving.catatan ?? '';
      _durasiController.text = craving.durasiMenit?.toString() ?? '';
      _mood = craving.mood;
      _strategi = craving.strategi;
      _hasil = craving.hasil;
      L.i(
        '_pemicu=$_pemicu, _intensitas=$_intensitas, _tanggal=$_tanggal, _catatanController.text=${_catatanController.text}, _durasiController.text=${_durasiController.text}, _mood=$_mood, _strategi=$_strategi, _hasil=$_hasil',
      );
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    _catatanFocusNode.dispose();
    _durasiController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final awal = _tanggal;
    L.i('awal=$awal, _tanggal=$_tanggal');
    final picked = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    L.i('picked=$picked');
    if (picked != null && mounted) {
      // Gabungkan tanggal yang dipilih dengan waktu saat ini.
      final now = DateTime.now();
      setState(() {
        _tanggal = DateTime(
          picked.year,
          picked.month,
          picked.day,
          now.hour,
          now.minute,
        );
      });
      L.i('_tanggal=$_tanggal');
    }
  }

  Future<void> _pilihWaktu() async {
    final awal = TimeOfDay.fromDateTime(_tanggal);
    L.i('awal=$awal');
    final picked = await showTimePicker(context: context, initialTime: awal);
    L.i('picked=$picked');
    if (picked != null && mounted) {
      setState(() {
        _tanggal = DateTime(
          _tanggal.year,
          _tanggal.month,
          _tanggal.day,
          picked.hour,
          picked.minute,
        );
      });
      L.i('_tanggal=$_tanggal');
    }
  }

  Future<void> _simpan() async {
    if (_isLoading) {
      L.w('Form diary craving masih loading, simpan diabaikan');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      L.w('validasi form gagal');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Simpan Craving',
      message: 'Apakah Anda yakin ingin menyimpan catatan craving ini?',
      okLabel: 'Simpan',
      cancelLabel: 'Batal',
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      L.w('konfirmasi bukan ok');
      return;
    }
    if (!mounted) return;
    final durasiText = _durasiController.text.trim();
    L.i('durasiText=$durasiText');
    final durasiMenit = durasiText.isEmpty ? null : int.parse(durasiText);

    setState(() => _isLoading = true);
    L.i('_isLoading=$_isLoading');
    unawaited(
      EasyLoading.show(
        status: 'Menyimpan...',
        maskType: EasyLoadingMaskType.black,
      ),
    );
    try {
      final model = DiaryCravingModel(
        id: widget.craving?.id ?? const Uuid().v4(),
        tanggal: _tanggal,
        pemicu: _pemicu,
        intensitas: _intensitas,
        catatan: _catatanController.text.trim().isEmpty
            ? null
            : _catatanController.text.trim(),
        durasiMenit: durasiMenit,
        mood: _mood,
        strategi: _strategi,
        hasil: _hasil,
        dibuat: widget.craving?.dibuat ?? DateTime.now(),
      );
      L.i('model=$model');
      if (widget.craving == null) {
        L.i('widget.craving null, tambah');
        await ref.read(diaryCravingProvider.notifier).tambah(model);
      } else {
        L.i('widget.craving tidak null, ubah');
        await ref.read(diaryCravingProvider.notifier).ubah(model);
      }
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Nav.pop(context);
      }
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan diary craving: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menyimpan catatan craving');
      }
    } finally {
      unawaited(EasyLoading.dismiss());
      if (mounted) {
        setState(() => _isLoading = false);
        L.i('_isLoading=$_isLoading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.craving == null ? 'Catat Craving' : 'Ubah Catatan Craving',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                InputDropdown<PemicuEnum>(
                  value: _pemicu,
                  label: 'Pemicu',
                  items: PemicuEnum.values,
                  displayString: (item) => item.label,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _pemicu = value);
                      L.i('_pemicu=$_pemicu');
                    }
                  },
                ),
                InputDropdown<int>(
                  value: _intensitas,
                  label: 'Intensitas (1-5)',
                  items: const [1, 2, 3, 4, 5],
                  displayString: (item) => '$item',
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _intensitas = value);
                      L.i('_intensitas=$_intensitas');
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Tanggal'),
                  subtitle: Text(FormatWaktuLengkap.formatSingkat(_tanggal)),
                  trailing: TextButton(
                    onPressed: _pilihTanggal,
                    child: const Text('Pilih'),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time_outlined),
                  title: const Text('Waktu'),
                  subtitle: Text(FormatJam.formatJamMenit(_tanggal)),
                  trailing: TextButton(
                    onPressed: _pilihWaktu,
                    child: const Text('Pilih'),
                  ),
                ),
                InputTeks(
                  controller: _catatanController,
                  label: 'Catatan',
                  hintText: 'Catatan tambahan (opsional)',
                  focusNode: _catatanFocusNode,
                  wajib: false,
                  minLines: 2,
                  maxLines: 4,
                ),
                ExpansionTile(
                  title: const Text('Detail tambahan (opsional)'),
                  tilePadding: EdgeInsets.zero,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12,
                      children: [
                        InputTeks(
                          controller: _durasiController,
                          label: 'Durasi (menit)',
                          hintText: 'Contoh: 15',
                          wajib: false,
                          suffixText: 'menit',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            final angka = int.tryParse(value.trim());
                            if (angka == null || angka < 0) {
                              return 'Durasi harus berupa angka 0 atau lebih';
                            }
                            return null;
                          },
                        ),
                        InputDropdown<MoodCravingEnum?>(
                          value: _mood,
                          label: 'Suasana hati',
                          items: const [null, ...MoodCravingEnum.values],
                          displayString: (item) => item?.label ?? 'Tidak diisi',
                          wajib: false,
                          onChanged: (value) {
                            setState(() => _mood = value);
                            L.i('_mood=$_mood');
                          },
                        ),
                        InputDropdown<StrategiCravingEnum?>(
                          value: _strategi,
                          label: 'Strategi yang dicoba',
                          items: const [null, ...StrategiCravingEnum.values],
                          displayString: (item) => item?.label ?? 'Tidak diisi',
                          wajib: false,
                          onChanged: (value) {
                            setState(() => _strategi = value);
                            L.i('_strategi=$_strategi');
                          },
                        ),
                        InputDropdown<HasilCravingEnum?>(
                          value: _hasil,
                          label: 'Hasil',
                          items: const [null, ...HasilCravingEnum.values],
                          displayString: (item) => item?.label ?? 'Tidak diisi',
                          wajib: false,
                          onChanged: (value) {
                            setState(() => _hasil = value);
                            L.i('_hasil=$_hasil');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _simpan, child: const Text('Simpan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/diary_craving/state/diary_craving_state.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/diary_craving/model/diary_craving_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_craving_state.freezed.dart';

@freezed
abstract class DiaryCravingState with _$DiaryCravingState {
  const DiaryCravingState._();

  const factory DiaryCravingState({
    @Default([]) List<DiaryCravingModel> listCraving,
    @Default(0) int jumlahCraving,
  }) = _DiaryCravingState;
}
```


// ============================================================
// FILE: lib/fitur/dummy/dummy_data/dummy_biodata.dart
// ============================================================

```dart
// lib/fitur/dummy/dummy_data/dummy_biodata.dart

import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';

/// ID dummy untuk data biodata.
class BiodataIdDummy {
  /// ID dummy item 1.
  static const String item1 = '00000000-0000-0000-0001-000000000001';
}

/// Daftar data dummy biodata.
final List<BiodataModel> dummyBiodata = [
  BiodataModel(
    id: BiodataIdDummy.item1,
    nama: 'Budi Santoso',
    tanggalLahir: DateTime.now().subtract(const Duration(days: 365 * 36)),
    jumlahRokokPerHari: 12,
    hargaRokokPerBungkus: 35000.0,
    batangPerBungkus: 20.0,
    tanggalMulaiMerokok: DateTime.now().subtract(
      const Duration(days: 365 * 16),
    ),
    tanggalMulaiBerhentiMerokok: DateTime.now().subtract(
      const Duration(days: 30, hours: 7, minutes: 30),
    ),
  ),
];
```


// ============================================================
// FILE: lib/fitur/dummy/dummy_data/dummy_impian.dart
// ============================================================

```dart
// lib/fitur/dummy/dummy_data/dummy_impian.dart

import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';

/// ID dummy untuk data impian.
class ImpianIdDummy {
  /// ID dummy item 1.
  static const String item1 = '00000000-0000-0000-0006-000000000001';

  /// ID dummy item 2.
  static const String item2 = '00000000-0000-0000-0006-000000000002';

  /// ID dummy item 3.
  static const String item3 = '00000000-0000-0000-0006-000000000003';

  /// ID dummy item 4.
  static const String item4 = '00000000-0000-0000-0006-000000000004';

  /// ID dummy item 5.
  static const String item5 = '00000000-0000-0000-0006-000000000005';

  /// ID dummy item 6.
  static const String item6 = '00000000-0000-0000-0006-000000000006';
}

/// Daftar data dummy impian.
final List<ImpianModel> dummyImpian = [
  ImpianModel(
    id: ImpianIdDummy.item1,
    nama: 'Beli ban baru',
    targetTanggal: DateTime.now().add(const Duration(days: 10)),
    dibuat: DateTime.now().subtract(const Duration(days: 5)),
    jumlah: 2000000.0,
  ),
  ImpianModel(
    id: ImpianIdDummy.item2,
    nama: 'Service AC mobil',
    targetTanggal: DateTime.now().add(const Duration(days: 15)),
    dibuat: DateTime.now().subtract(const Duration(days: 8)),
    jumlah: 1500000.0,
  ),
  ImpianModel(
    id: ImpianIdDummy.item3,
    nama: 'Ganti knalpot racing',
    targetTanggal: DateTime.now().add(const Duration(days: 20)),
    dibuat: DateTime.now().subtract(const Duration(days: 3)),
    jumlah: 1000000.0,
  ),
  ImpianModel(
    id: ImpianIdDummy.item4,
    nama: 'Beli helm baru',
    targetTanggal: DateTime.now().add(const Duration(days: 5)),
    dibuat: DateTime.now().subtract(const Duration(days: 6)),
    jumlah: 500000.0,
  ),
  ImpianModel(
    id: ImpianIdDummy.item5,
    nama: 'Ganti oli gardan',
    targetTanggal: DateTime.now().add(const Duration(days: 12)),
    dibuat: DateTime.now().subtract(const Duration(days: 2)),
    jumlah: 800000.0,
  ),
  ImpianModel(
    id: ImpianIdDummy.item6,
    nama: 'Pasang roof rack',
    targetTanggal: DateTime.now().add(const Duration(days: 25)),
    dibuat: DateTime.now().subtract(const Duration(days: 4)),
    jumlah: 3000000.0,
  ),
];
```


// ============================================================
// FILE: lib/fitur/dummy/helper/dummy_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/dummy/dummy_data/dummy_biodata.dart';
import 'package:berhenti_merokok/fitur/dummy/dummy_data/dummy_impian.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';

/// Helper untuk mengelola data dummy aplikasi.
class DummyHelper {
  /// Memasukkan seluruh data dummy ke database SQLite.
  static Future<void> insert() async {
    L.i('tes');
    L.i(
      'dummyImpian.length=${dummyImpian.length}, dummyBiodata.length=${dummyBiodata.length}',
    );
    try {
      final op = const SqfliteOp();
      await op.transaksi((txn) async {
        for (final impian in dummyImpian) {
          await txn.insert(
            NamaTabel.impian,
            impian.toSqflite(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        // Hapus biodata yang ada agar data dummy menjadi satu-satunya biodata
        // yang terbaca aplikasi (ambilSatu mengembalikan baris pertama).
        await txn.delete(NamaTabel.biodata);
        for (final biodata in dummyBiodata) {
          await txn.insert(
            NamaTabel.biodata,
            biodata.toSqflite(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      L.i('insert selesai');
    } on Exception catch (e, s) {
      L.e('Gagal memasukkan data dummy: $e $s');
      rethrow;
    }
  }

  /// Menghapus seluruh data dummy dari database SQLite.
  static Future<void> delete() async {
    L.i(
      'dummyImpian.length=${dummyImpian.length}, dummyBiodata.length=${dummyBiodata.length}',
    );
    try {
      final op = const SqfliteOp();
      await op.transaksi((txn) async {
        for (final impian in dummyImpian) {
          await txn.delete(
            NamaTabel.impian,
            where: 'id = ?',
            whereArgs: [impian.id],
          );
        }
        for (final biodata in dummyBiodata) {
          await txn.delete(
            NamaTabel.biodata,
            where: 'id = ?',
            whereArgs: [biodata.id],
          );
        }
      });
      L.i('delete selesai');
    } on Exception catch (e, s) {
      L.e('Gagal menghapus data dummy: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/dummy/screens/dummy_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/dummy/helper/dummy_helper.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

class DummyScreen extends ConsumerStatefulWidget {
  const DummyScreen({super.key});

  @override
  ConsumerState<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends ConsumerState<DummyScreen> {
  bool _sedangMemuat = false;

  Future<void> _masukkanDummy(BuildContext context) async {
    L.i('_masukkanDummy _sedangMemuat=$_sedangMemuat');
    if (_sedangMemuat) {
      L.w('Dummy masih diproses, aksi diabaikan');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Masukkan Dummy',
      message:
          'Apakah Anda yakin ingin memasukkan data dummy? '
          'Biodata yang ada akan diganti dengan data dummy.',
      okLabel: 'Masukkan',
      cancelLabel: 'Batal',
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      return;
    }
    if (!context.mounted) return;

    setState(() => _sedangMemuat = true);
    unawaited(
      EasyLoading.show(
        status: 'Menyimpan...',
        maskType: EasyLoadingMaskType.black,
      ),
    );
    try {
      await DummyHelper.insert();
      await _refreshProvider();
      if (context.mounted) {
        AppToast.sukses(context, 'Dummy berhasil dimasukkan');
      }
    } on Exception catch (e, s) {
      L.e('Gagal memasukkan dummy: $e $s');
      if (context.mounted) {
        AppToast.gagal(context, 'Gagal memasukkan dummy');
      }
    } finally {
      if (mounted) {
        unawaited(EasyLoading.dismiss());
        setState(() => _sedangMemuat = false);
      }
    }
  }

  Future<void> _hapusDummy(BuildContext context) async {
    L.i('_hapusDummy _sedangMemuat=$_sedangMemuat');
    if (_sedangMemuat) {
      L.w('Dummy masih diproses, aksi diabaikan');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Dummy',
      message: 'Apakah Anda yakin ingin menghapus data dummy?',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      return;
    }
    if (!context.mounted) return;

    setState(() => _sedangMemuat = true);
    unawaited(
      EasyLoading.show(
        status: 'Menghapus...',
        maskType: EasyLoadingMaskType.black,
      ),
    );
    try {
      await DummyHelper.delete();
      await _refreshProvider();
      if (context.mounted) {
        AppToast.sukses(context, 'Dummy berhasil dihapus');
      }
    } on Exception catch (e, s) {
      L.e('Gagal menghapus dummy: $e $s');
      if (context.mounted) {
        AppToast.gagal(context, 'Gagal menghapus dummy');
      }
    } finally {
      if (mounted) {
        unawaited(EasyLoading.dismiss());
        setState(() => _sedangMemuat = false);
      }
    }
  }

  Future<void> _reset(BuildContext context) async {
    L.i('_reset _sedangMemuat=$_sedangMemuat');
    if (_sedangMemuat) {
      L.w('Dummy masih diproses, aksi diabaikan');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Reset Dummy',
      message: 'Apakah Anda yakin ingin mereset data dummy? Data dummy akan dihapus lalu dimasukkan ulang.',
      okLabel: 'Reset',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      return;
    }
    if (!context.mounted) return;

    setState(() => _sedangMemuat = true);
    unawaited(
      EasyLoading.show(
        status: 'Memproses...',
        maskType: EasyLoadingMaskType.black,
      ),
    );
    try {
      await DummyHelper.delete();
      await DummyHelper.insert();
      await _refreshProvider();
      if (context.mounted) {
        AppToast.sukses(context, 'Dummy berhasil direset');
      }
    } on Exception catch (e, s) {
      L.e('Gagal mereset dummy: $e $s');
      if (context.mounted) {
        AppToast.gagal(context, 'Gagal mereset dummy');
      }
    } finally {
      if (mounted) {
        unawaited(EasyLoading.dismiss());
        setState(() => _sedangMemuat = false);
      }
    }
  }

  Future<void> _refreshProvider() async {
    // Perbarui state agar UI memuat data dummy terbaru.
    L.i('_refreshProvider');
    final _ = ref.refresh(impianProvider);
    final _ = ref.refresh(biodataProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dummy')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            _buildTombolCustom(
              () => unawaited(_masukkanDummy(context)),
              'insert',
              Colors.green,
            ),
            _buildTombolCustom(
              () => unawaited(_hapusDummy(context)),
              'hapus',
              Colors.red,
            ),
            _buildTombolCustom(
              () => unawaited(_reset(context)),
              'reset',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTombolCustom(
    void Function() onPressed,
    String value,
    Color backgroundColor,
  ) {
    L.i('value=$value, backgroundColor=$backgroundColor');
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(value),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/enum/sort_impian.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

/// Opsi pengurutan daftar impian.
enum SortImpian {
  namaAz,
  namaZa,
  jumlahAz,
  jumlahZa,
  mendekatiTerkumpulAz,
  mendekatiTerkumpulZa,
}

/// Extension yang menyediakan label dan ikon untuk [SortImpian].
extension SortImpianExtension on SortImpian {
  String get label {
    switch (this) {
      case SortImpian.namaAz:
        return 'Nama A-Z';
      case SortImpian.namaZa:
        return 'Nama Z-A';
      case SortImpian.jumlahAz:
        return 'Jumlah terkecil';
      case SortImpian.jumlahZa:
        return 'Jumlah terbesar';
      case SortImpian.mendekatiTerkumpulAz:
        return 'Paling mendekati terkumpul (kecil)';
      case SortImpian.mendekatiTerkumpulZa:
        return 'Sisa terbesar';
    }
  }

  IconData get icon {
    switch (this) {
      case SortImpian.namaAz:
        return Icons.arrow_upward;
      case SortImpian.namaZa:
        return Icons.arrow_downward;
      case SortImpian.jumlahAz:
        return Icons.arrow_upward;
      case SortImpian.jumlahZa:
        return Icons.arrow_downward;
      case SortImpian.mendekatiTerkumpulAz:
        return Icons.arrow_upward;
      case SortImpian.mendekatiTerkumpulZa:
        return Icons.arrow_downward;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/enum/tema_visual_impian.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

/// Tema visual metafora impian (objek yang tumbuh mengikuti progres tabungan).
///
/// Disimpan di penyimpanan lokal (`SharedPreferences`) dan langsung
/// diterapkan tanpa restart aplikasi. Tema tidak mengubah data numerik
/// maupun perhitungan progres.
enum TemaVisualImpian { toples, pohon }

/// Extension yang menyediakan label dan ikon untuk [TemaVisualImpian].
extension TemaVisualImpianExtension on TemaVisualImpian {
  String get label {
    switch (this) {
      case TemaVisualImpian.toples:
        return 'Toples';
      case TemaVisualImpian.pohon:
        return 'Pohon';
    }
  }

  IconData get icon {
    switch (this) {
      case TemaVisualImpian.toples:
        return Icons.cookie_outlined;
      case TemaVisualImpian.pohon:
        return Icons.park_outlined;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/helper/impian_progres_helper.dart
// ============================================================

```dart
/// Helper murni untuk perhitungan progres impian.
/// Tanpa ketergantungan pada BuildContext atau provider.
class ImpianProgresHelper {
  const ImpianProgresHelper._();

  /// Menghitung rasio progres (0.0 - 1.0).
  static double rasio(double saldo, double target) {
    if (target <= 0) return 0.0;
    return (saldo / target).clamp(0.0, 1.0);
  }

  /// Menghitung sisa dana untuk mencapai target.
  static double sisa(double saldo, double target) {
    final nilai = target - saldo;
    return nilai < 0 ? 0.0 : nilai;
  }

  /// Mengecek apakah impian sudah tercapai.
  static bool tercapai(double saldo, double target) {
    if (target <= 0) return false;
    return saldo >= target;
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/helper/riwayat_tabungan_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';

/// Entri riwayat penghematan per hari (aktual dari catatan konsumsi).
class RiwayatTabunganEntry {
  const RiwayatTabunganEntry({
    required this.tanggal,
    required this.rokokDihindari,
    required this.nilai,
    required this.saldoSetelah,
  });

  /// Tanggal hari tersebut (komponen tanggal saja, waktu lokal).
  final DateTime tanggal;

  /// Jumlah rokok yang dihindari hari itu (clamp minimal 0).
  final int rokokDihindari;

  /// Nilai uang yang dihemat hari itu (rupiah).
  final double nilai;

  /// Saldo kumulatif dari hari terlama hingga hari entri ini (rupiah).
  final double saldoSetelah;
}

/// Helper murni untuk riwayat penghematan tabungan impian.
///
/// Tidak bergantung pada `BuildContext` atau provider. Rumus per hari
/// konsisten dengan `MetrikBerhentiHelper.hitungUangDihematAktual`:
/// `terhindar = max(0, targetRokokHariIni − konsumsiHarian)` dan
/// `nilai = terhindar / batangPerBungkus × hargaRokokPerBungkus`.
class RiwayatTabunganHelper {
  const RiwayatTabunganHelper._();

  /// Riwayat penghematan per hari yang **punya catatan** konsumsi,
  /// diurutkan dari tanggal terbaru dahulu.
  ///
  /// Hari tanpa catatan dikecualikan (bukan bukti pengguna tidak merokok).
  /// Mengembalikan daftar kosong bila tidak ada catatan atau
  /// `batangPerBungkus <= 0`.
  static List<RiwayatTabunganEntry> dariKonsumsi(
    BiodataModel biodata,
    List<KonsumsiRokokModel> list,
  ) {
    if (biodata.batangPerBungkus <= 0) return const [];
    final ringkasan = KonsumsiHitungHelper.ringkasanHarian(list);
    if (ringkasan.isEmpty) return const [];
    final target = biodata.targetRokokHariIni;
    final entriAscending = <RiwayatTabunganEntry>[];
    var saldo = 0.0;
    final kunciUrut = ringkasan.keys.toList()..sort();
    for (final kunci in kunciUrut) {
      final bagian = kunci.split('-');
      if (bagian.length != 3) continue;
      final tahun = int.tryParse(bagian[0]);
      final bulan = int.tryParse(bagian[1]);
      final hari = int.tryParse(bagian[2]);
      if (tahun == null || bulan == null || hari == null) continue;
      final terhindar = target - (ringkasan[kunci] ?? 0);
      final rokokDihindari = terhindar > 0 ? terhindar : 0;
      final nilai =
          (rokokDihindari / biodata.batangPerBungkus) *
          biodata.hargaRokokPerBungkus;
      saldo += nilai;
      entriAscending.add(
        RiwayatTabunganEntry(
          tanggal: DateTime(tahun, bulan, hari),
          rokokDihindari: rokokDihindari,
          nilai: nilai,
          saldoSetelah: saldo,
        ),
      );
    }
    return entriAscending.reversed.toList();
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/model/impian_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/impian/notifier/impian_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';
import 'package:berhenti_merokok/fitur/impian/state/impian_state.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';

part 'impian_notifier.g.dart';

@Riverpod(keepAlive: true)
class ImpianNotifier extends _$ImpianNotifier {
  @override
  Future<ImpianState> build() async {
    return await _ambilSemua();
  }

  Future<ImpianState> _ambilSemua() async {
    try {
      final op = const SqfliteOp();
      final rows = await op.ambilSemua(NamaTabel.impian);
      final daftar = rows.map(ImpianModel.fromSqflite).toList();
      final totalJumlah = daftar.fold<double>(
        0,
        (previousValue, element) => previousValue + element.jumlah,
      );
      L.i('daftar.length=${daftar.length}, totalJumlah=$totalJumlah');
      return ImpianState(
        listImpian: daftar,
        jumlahImpian: daftar.length,
        totalJumlah: totalJumlah,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data impian: $e $s');
      rethrow;
    }
  }

  Future<void> tambah(ImpianModel impian) async {
    L.i(
      'impian.id=${impian.id}, impian.nama=${impian.nama}, impian.jumlah=${impian.jumlah}',
    );
    try {
      final dataLama = await future;
      L.i(
        'dataLama.jumlahImpian=${dataLama.jumlahImpian}, dataLama.totalJumlah=${dataLama.totalJumlah}',
      );
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.impian,
        impian.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      state = AsyncValue.data(
        ImpianState(
          listImpian: [...dataLama.listImpian, impian],
          jumlahImpian: dataLama.jumlahImpian + 1,
          totalJumlah: dataLama.totalJumlah + impian.jumlah,
        ),
      );
      L.s('Impian berhasil disimpan');
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan impian: $e $s');
      rethrow;
    }
  }

  /// Menambahkan banyak impian sekaligus menggunakan operasi batch.
  Future<void> tambahBanyak(List<ImpianModel> daftarImpian) async {
    L.i('daftarImpian.length=${daftarImpian.length}');
    try {
      final dataLama = await future;
      L.i(
        'dataLama.jumlahImpian=${dataLama.jumlahImpian}, dataLama.totalJumlah=${dataLama.totalJumlah}',
      );
      final op = const SqfliteOp();
      await op.batch((batch) {
        for (final impian in daftarImpian) {
          batch.insert(
            NamaTabel.impian,
            impian.toSqflite(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      final tambahanJumlah = daftarImpian.fold<double>(
        0,
        (previousValue, element) => previousValue + element.jumlah,
      );
      state = AsyncValue.data(
        ImpianState(
          listImpian: [...dataLama.listImpian, ...daftarImpian],
          jumlahImpian: dataLama.jumlahImpian + daftarImpian.length,
          totalJumlah: dataLama.totalJumlah + tambahanJumlah,
        ),
      );
      L.s('Impian berhasil disimpan (batch)');
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan impian (batch): $e $s');
      rethrow;
    }
  }

  Future<void> ubah(ImpianModel impian) async {
    L.i(
      'impian.id=${impian.id}, impian.nama=${impian.nama}, impian.jumlah=${impian.jumlah}',
    );
    try {
      final dataLama = await future;
      L.i(
        'dataLama.jumlahImpian=${dataLama.jumlahImpian}, dataLama.totalJumlah=${dataLama.totalJumlah}',
      );
      final op = const SqfliteOp();
      await op.ubah(
        NamaTabel.impian,
        impian.toSqflite(),
        where: '${NamaKolom.id} = ?',
        whereArgs: [impian.id],
      );
      final baru = dataLama.listImpian
          .map((e) => e.id == impian.id ? impian : e)
          .toList();
      final totalJumlah = baru.fold<double>(
        0,
        (previousValue, element) => previousValue + element.jumlah,
      );
      state = AsyncValue.data(
        ImpianState(
          listImpian: baru,
          jumlahImpian: baru.length,
          totalJumlah: totalJumlah,
        ),
      );
      L.s('Impian berhasil diubah');
    } on Exception catch (e, s) {
      L.e('Gagal mengubah impian: $e $s');
      rethrow;
    }
  }

  Future<void> hapus(String id) async {
    L.i('id=$id');
    try {
      final dataLama = await future;
      L.i(
        'dataLama.jumlahImpian=${dataLama.jumlahImpian}, dataLama.totalJumlah=${dataLama.totalJumlah}',
      );
      final op = const SqfliteOp();
      await op.hapus(
        NamaTabel.impian,
        where: '${NamaKolom.id} = ?',
        whereArgs: [id],
      );
      final baru = dataLama.listImpian.where((e) => e.id != id).toList();
      final totalJumlah = baru.fold<double>(
        0,
        (previousValue, element) => previousValue + element.jumlah,
      );
      state = AsyncValue.data(
        ImpianState(
          listImpian: baru,
          jumlahImpian: baru.length,
          totalJumlah: totalJumlah,
        ),
      );
      L.s('Impian berhasil dihapus');
    } on Exception catch (e, s) {
      L.e('Gagal menghapus impian: $e $s');
      rethrow;
    }
  }

  /// Menghapus banyak impian sekaligus menggunakan operasi batch.
  Future<void> hapusBanyak(List<String> daftarId) async {
    L.i('daftarId.length=${daftarId.length}');
    try {
      final dataLama = await future;
      L.i(
        'dataLama.jumlahImpian=${dataLama.jumlahImpian}, dataLama.totalJumlah=${dataLama.totalJumlah}',
      );
      final op = const SqfliteOp();
      await op.batch((batch) {
        for (final id in daftarId) {
          batch.delete(
            NamaTabel.impian,
            where: '${NamaKolom.id} = ?',
            whereArgs: [id],
          );
        }
      });
      final baru = dataLama.listImpian
          .where((e) => !daftarId.contains(e.id))
          .toList();
      final totalJumlah = baru.fold<double>(
        0,
        (previousValue, element) => previousValue + element.jumlah,
      );
      state = AsyncValue.data(
        ImpianState(
          listImpian: baru,
          jumlahImpian: baru.length,
          totalJumlah: totalJumlah,
        ),
      );
      L.s('Impian berhasil dihapus (batch)');
    } on Exception catch (e, s) {
      L.e('Gagal menghapus impian (batch): $e $s');
      rethrow;
    }
  }

  /// Mengubah banyak impian sekaligus menggunakan operasi batch.
  Future<void> ubahBanyak(List<ImpianModel> daftarImpian) async {
    L.i('daftarImpian.length=${daftarImpian.length}');
    try {
      final dataLama = await future;
      L.i(
        'dataLama.jumlahImpian=${dataLama.jumlahImpian}, dataLama.totalJumlah=${dataLama.totalJumlah}',
      );
      final op = const SqfliteOp();
      await op.batch((batch) {
        for (final impian in daftarImpian) {
          batch.update(
            NamaTabel.impian,
            impian.toSqflite(),
            where: '${NamaKolom.id} = ?',
            whereArgs: [impian.id],
          );
        }
      });
      final baru = dataLama.listImpian.map((e) {
        final pengganti = daftarImpian.firstWhereOrNull(
          (item) => item.id == e.id,
        );
        return pengganti ?? e;
      }).toList();
      final totalJumlah = baru.fold<double>(
        0,
        (previousValue, element) => previousValue + element.jumlah,
      );
      state = AsyncValue.data(
        ImpianState(
          listImpian: baru,
          jumlahImpian: baru.length,
          totalJumlah: totalJumlah,
        ),
      );
      L.s('Impian berhasil diubah (batch)');
    } on Exception catch (e, s) {
      L.e('Gagal mengubah impian (batch): $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/notifier/tema_visual_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/impian/enum/tema_visual_impian.dart';
import 'package:berhenti_merokok/shared/helper/shared_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tema_visual_notifier.g.dart';

// State hanya menyimpan satu nilai enum TemaVisualImpian, sehingga tidak
// memerlukan state Freezed tersendiri, konsisten dengan TemaNotifier.
@Riverpod(keepAlive: true)
class TemaVisualNotifier extends _$TemaVisualNotifier {
  @override
  Future<TemaVisualImpian> build() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(SharedKeys.temaVisualImpian);
    return TemaVisualImpian.values.firstWhere(
      (e) => e.name == value,
      // Tema tidak valid/tidak tersimpan → tema default pertama.
      orElse: () => TemaVisualImpian.toples,
    );
  }

  Future<void> set([TemaVisualImpian? tema]) async {
    final nilai = tema ?? state.asData?.value ?? TemaVisualImpian.toples;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedKeys.temaVisualImpian, nilai.name);
    state = AsyncValue.data(nilai);
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/screens/detail_impian_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/enum/tema_visual_impian.dart';
import 'package:berhenti_merokok/fitur/impian/helper/impian_progres_helper.dart';
import 'package:berhenti_merokok/fitur/impian/helper/riwayat_tabungan_helper.dart';
import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';
// Urutan paket alfabetis: notifier diurutkan sebelum screens, sesuai aturan import ordering.
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/tema_visual_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/screens/form_impian.dart';
import 'package:berhenti_merokok/fitur/impian/widget/visual_tabungan_impian.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

class DetailImpianScreen extends ConsumerWidget {
  final String id;
  const DetailImpianScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final impianAsync = ref.watch(impianProvider);
    final biodataAsync = ref.watch(biodataProvider);
    final konsumsiAsync = ref.watch(konsumsiRokokProvider);
    // Tema visual metafora impian: bila gagal dimuat/invalid, gunakan
    // tema default pertama.
    final temaVisualAsync = ref.watch(temaVisualProvider);
    final temaVisual = temaVisualAsync.asData?.value ?? TemaVisualImpian.toples;
    L.i('temaVisual=$temaVisual');

    if (impianAsync.isLoading ||
        biodataAsync.isLoading ||
        konsumsiAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (impianAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Impian')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data impian'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(impianProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (biodataAsync.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Impian')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data biodata'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(biodataProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (konsumsiAsync.hasError) {
      L.e('konsumsiAsync error: ${konsumsiAsync.error}');
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Impian')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data konsumsi'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(konsumsiRokokProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final impianState = impianAsync.requireValue;
    final ImpianModel? impian = impianState.listImpian.firstWhereOrNull(
      (item) => item.id == id,
    );

    if (impian == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Impian')),
        body: EmptyStateView(
          ikon: CupertinoIcons.question_circle,
          judul: 'Impian tidak ditemukan',
          deskripsi:
              'Impian ini mungkin sudah dihapus atau tidak tersedia lagi.',
          ctaLabel: 'Kembali',
          onCta: () => Nav.pop(context),
        ),
      );
    }

    final BiodataModel? biodata = biodataAsync.requireValue;
    final konsumsiList = konsumsiAsync.requireValue.listKonsumsi;
    final uangEstimasi = biodata == null
        ? 0.0
        : MetrikBerhentiHelper.hitungUangDihematEstimasi(biodata);
    final uangAktual = biodata == null
        ? 0.0
        : MetrikBerhentiHelper.hitungUangDihematAktual(biodata, konsumsiList);
    final hariTercatat = MetrikBerhentiHelper.hitungJumlahHariTercatat(
      konsumsiList,
    );
    final pakaiAktual = hariTercatat > 0;
    // Progres impian: aktual bila ada catatan, fallback estimasi.
    final saldoUntukProgres = pakaiAktual ? uangAktual : uangEstimasi;
    // Riwayat penghematan per hari (aktual) dari catatan konsumsi.
    final riwayatEntries = biodata == null
        ? const <RiwayatTabunganEntry>[]
        : RiwayatTabunganHelper.dariKonsumsi(biodata, konsumsiList);
    L.i(
      'uangEstimasi=$uangEstimasi, uangAktual=$uangAktual, hariTercatat=$hariTercatat, pakaiAktual=$pakaiAktual, saldoUntukProgres=$saldoUntukProgres, riwayatEntries.length=${riwayatEntries.length}',
    );
    final rasio = ImpianProgresHelper.rasio(saldoUntukProgres, impian.jumlah);
    final sudahTercapai = ImpianProgresHelper.tercapai(
      saldoUntukProgres,
      impian.jumlah,
    );
    final sisa = ImpianProgresHelper.sisa(saldoUntukProgres, impian.jumlah);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Impian'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.pencil),
            onPressed: () => unawaited(
              Nav.to(context, FormImpian(impian: impian)).catchError((
                Object e,
                StackTrace s,
              ) {
                L.e('Gagal navigasi ke Form Impian: $e $s');
                return null;
              }),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                if (impian.jumlah <= 0)
                  Text(
                    'Atur target impian terlebih dahulu',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                VisualTabunganImpian(
                  rasio: rasio,
                  tercapai: sudahTercapai,
                  tema: temaVisual,
                  pakaiAktual: pakaiAktual,
                  labelSaldo: pakaiAktual
                      ? 'Progres dari catatan (berdasarkan $hariTercatat hari tercatat)'
                      : 'Progres estimasi dari biodata',
                ),
                Row(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildItem(
                        context,
                        'Estimasi',
                        FormatUang.formatRupiah(uangEstimasi),
                      ),
                    ),
                    Expanded(
                      child: _buildItem(
                        context,
                        'Dari catatan',
                        pakaiAktual
                            ? FormatUang.formatRupiah(uangAktual)
                            : 'Belum ada catatan',
                      ),
                    ),
                  ],
                ),
                Text(
                  pakaiAktual
                      ? 'Aktual berdasarkan $hariTercatat hari tercatat. Estimasi dari kebiasaan harian biodata.'
                      : 'Belum ada catatan konsumsi. Menampilkan estimasi dari kebiasaan harian biodata.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                _buildItem(context, 'Nama', impian.nama),
                _buildItem(
                  context,
                  'Jumlah',
                  FormatUang.formatRupiah(impian.jumlah),
                ),
                _buildItem(
                  context,
                  'Target tanggal',
                  FormatTanggal.formatDasar(impian.targetTanggal),
                ),
                _buildItem(
                  context,
                  'Dibuat',
                  FormatTanggal.formatDasar(impian.dibuat),
                ),
                _buildItem(
                  context,
                  'Status',
                  sudahTercapai ? 'Tercapai' : 'Belum tercapai',
                ),
                _buildItem(
                  context,
                  pakaiAktual ? 'Progres' : 'Progres (estimasi)',
                  '${(rasio * 100).toStringAsFixed(0)}%',
                ),
                _buildItem(
                  context,
                  'Sumber progres',
                  pakaiAktual
                      ? 'Dari catatan ($hariTercatat hari tercatat)'
                      : 'Estimasi (belum ada catatan)',
                ),
                _buildItem(
                  context,
                  pakaiAktual ? 'Sisa' : 'Sisa (estimasi)',
                  FormatUang.formatRupiah(sisa),
                ),
                _buildSectionTitle(context, 'Tema visual'),
                RadioGroup<TemaVisualImpian>(
                  groupValue: temaVisual,
                  onChanged: (TemaVisualImpian? nilai) {
                    if (nilai == null) {
                      L.w('tema visual yang dipilih null');
                      return;
                    }
                    L.i('temaVisual dipilih=$nilai');
                    unawaited(
                      ref
                          .read(temaVisualProvider.notifier)
                          .set(nilai)
                          .catchError((Object e, StackTrace s) {
                            L.e('Gagal menyimpan tema visual impian: $e $s');
                          }),
                    );
                  },
                  child: Column(
                    spacing: 0,
                    children: [
                      for (final tema in TemaVisualImpian.values)
                        RadioListTile<TemaVisualImpian>(
                          value: tema,
                          title: Text(tema.label),
                          secondary: Icon(tema.icon),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                    ],
                  ),
                ),
                _buildSectionTitle(context, 'Riwayat penghematan (dari catatan)'),
                _buildRiwayat(context, riwayatEntries),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String teks) {
    return Text(
      teks,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRiwayat(BuildContext context, List<RiwayatTabunganEntry> entri) {
    if (entri.isEmpty) {
      return const EmptyStateView(
        ikon: CupertinoIcons.money_dollar_circle,
        judul: 'Belum ada riwayat',
        deskripsi:
            'Riwayat penghematan per hari akan muncul di sini setelah Anda '
            'mencatat konsumsi.',
      );
    }
    const tabular = <FontFeature>[FontFeature.tabularFigures()];
    return Column(
      spacing: 8,
      children: [
        for (var i = 0; i < entri.length; i++) ...[
          if (i > 0) const Divider(height: 1, thickness: 1),
          _buildRiwayatItem(context, entri[i], tabular),
        ],
      ],
    );
  }

  Widget _buildRiwayatItem(
    BuildContext context,
    RiwayatTabunganEntry entri,
    List<FontFeature> tabular,
  ) {
    final labelTanggal = FormatTanggal.formatDasar(entri.tanggal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 2,
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Text(
                labelTanggal,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              '+${FormatUang.formatRupiah(entri.nilai)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFeatures: tabular,
              ),
            ),
          ],
        ),
        Text(
          '${entri.rokokDihindari} batang dihindari · Saldo ${FormatUang.formatRupiah(entri.saldoSetelah)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontFeatures: tabular,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, String label, String nilai) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(nilai, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/screens/form_impian.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:uuid/uuid.dart';

class FormImpian extends ConsumerStatefulWidget {
  final ImpianModel? impian;
  const FormImpian({super.key, this.impian});

  @override
  ConsumerState<FormImpian> createState() => _FormImpianState();
}

class _FormImpianState extends ConsumerState<FormImpian> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();

  final _namaFocusNode = FocusNode();
  final _jumlahFocusNode = FocusNode();

  DateTime? _targetTanggal;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final impian = widget.impian;
    L.i('impian=$impian');
    if (impian != null) {
      _namaController.text = impian.nama;
      _jumlahController.text = FormatUang.formatRupiah(impian.jumlah);
      _targetTanggal = impian.targetTanggal;
      L.i(
        '_namaController.text=${_namaController.text}, _jumlahController.text=${_jumlahController.text}, _targetTanggal=$_targetTanggal',
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _namaFocusNode.dispose();
    _jumlahFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pilihTargetTanggal() async {
    final awal = _targetTanggal ?? DateTime.now();
    L.i('awal=$awal, _targetTanggal=$_targetTanggal');
    final picked = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    L.i('picked=$picked');
    if (picked != null && mounted) {
      setState(() => _targetTanggal = picked);
      L.i('_targetTanggal=$_targetTanggal');
    }
  }

  Future<void> _simpan() async {
    if (_isLoading) {
      L.w('Form impian masih loading, simpan diabaikan');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      L.w('validasi form gagal');
      return;
    }
    if (_namaController.text.trim().isEmpty) {
      L.w('nama impian kosong');
      if (mounted) {
        AppToast.gagal(context, 'Nama impian wajib diisi');
      }
      return;
    }
    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Simpan Impian',
      message: 'Apakah Anda yakin ingin menyimpan data impian ini?',
      okLabel: 'Simpan',
      cancelLabel: 'Batal',
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      L.w('konfirmasi bukan ok');
      return;
    }
    if (!mounted) return;
    setState(() => _isLoading = true);
    L.i('_isLoading=$_isLoading');
    unawaited(
      EasyLoading.show(
        status: 'Menyimpan...',
        maskType: EasyLoadingMaskType.black,
      ),
    );
    try {
      final jumlah = InputRupiah.parse(_jumlahController.text);
      L.i('jumlah=$jumlah');
      if (jumlah <= 0) {
        L.w('jumlah <= 0');
        if (mounted) {
          AppToast.gagal(context, 'Jumlah harus lebih dari 0');
        }
        return;
      }
      final model = ImpianModel(
        id: widget.impian?.id ?? const Uuid().v4(),
        nama: _namaController.text.trim(),
        targetTanggal: _targetTanggal ?? DateTime.now(),
        dibuat: widget.impian?.dibuat ?? DateTime.now(),
        jumlah: jumlah,
      );
      L.i('model=$model');
      if (widget.impian == null) {
        L.i('widget.impian null, tambah');
        await ref.read(impianProvider.notifier).tambah(model);
      } else {
        L.i('widget.impian tidak null, ubah');
        await ref.read(impianProvider.notifier).ubah(model);
      }
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Nav.pop(context);
      }
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan impian: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menyimpan impian');
      }
    } finally {
      unawaited(EasyLoading.dismiss());
      if (mounted) {
        setState(() => _isLoading = false);
        L.i('_isLoading=$_isLoading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.impian == null ? 'Form Impian' : 'Ubah Impian'),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                InputTeks(
                  controller: _namaController,
                  label: 'Nama Impian',
                  hintText: 'Masukkan nama impian',
                  focusNode: _namaFocusNode,
                  nextFocusNode: _jumlahFocusNode,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama impian wajib diisi';
                    }
                    return null;
                  },
                ),
                InputRupiah(
                  controller: _jumlahController,
                  label: 'Jumlah',
                  hintText: 'Masukkan jumlah',
                  focusNode: _jumlahFocusNode,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Target tanggal'),
                  subtitle: Text(
                    _targetTanggal == null
                        ? 'Belum dipilih'
                        : FormatTanggal.formatDasar(_targetTanggal!),
                  ),
                  trailing: TextButton(
                    onPressed: _pilihTargetTanggal,
                    child: const Text('Pilih'),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(onPressed: _simpan, child: const Text('Simpan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/impian/screens/impian_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/enum/sort_impian.dart';
import 'package:berhenti_merokok/fitur/impian/enum/tema_visual_impian.dart';
import 'package:berhenti_merokok/fitur/impian/helper/impian_progres_helper.dart';
import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/impian_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/notifier/tema_visual_notifier.dart';
import 'package:berhenti_merokok/fitur/impian/screens/detail_impian_screen.dart';
import 'package:berhenti_merokok/fitur/impian/screens/form_impian.dart';
import 'package:berhenti_merokok/fitur/impian/widget/visual_tabungan_impian.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImpianScreen extends ConsumerStatefulWidget {
  const ImpianScreen({super.key});

  @override
  ConsumerState<ImpianScreen> createState() => _ImpianScreenState();
}

class _ImpianScreenState extends ConsumerState<ImpianScreen> {
  SortImpian _sortImpian = SortImpian.mendekatiTerkumpulAz;
  final Set<String> _sudahDiraikan = <String>{};

  @override
  void initState() {
    super.initState();
    _muatSudahDiraikan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _muatSudahDiraikan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final daftar = prefs.getStringList('impian_diraikan') ?? <String>[];
      if (mounted) {
        setState(() {
          _sudahDiraikan.addAll(daftar);
        });
      }
    } catch (e, s) {
      L.e('Gagal memuat daftar impian diraikan: $e $s');
    }
  }

  Future<void> _tandaiSudahDiraikan(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final daftar = prefs.getStringList('impian_diraikan') ?? <String>[];
      if (!daftar.contains(id)) {
        daftar.add(id);
        await prefs.setStringList('impian_diraikan', daftar);
      }
    } catch (e, s) {
      L.e('Gagal menyimpan impian diraikan: $e $s');
    }
  }

  void _showModalSort() {
    L.i('sortImpian=$_sortImpian');
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Text(
                  'Urutkan',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                ...SortImpian.values.map((sort) {
                  return ListTile(
                    leading: Icon(sort.icon),
                    title: Text(sort.label),
                    trailing: _sortImpian == sort
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      setState(() => _sortImpian = sort);
                      Nav.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final impianAsync = ref.watch(impianProvider);
    final biodataAsync = ref.watch(biodataProvider);
    final konsumsiAsync = ref.watch(konsumsiRokokProvider);
    // Tema visual metafora impian: bila gagal dimuat/invalid, gunakan
    // tema default pertama.
    final temaVisualAsync = ref.watch(temaVisualProvider);
    final temaVisual = temaVisualAsync.asData?.value ?? TemaVisualImpian.toples;
    L.i('temaVisual=$temaVisual');
    L.i(
      'impianAsync.isLoading=${impianAsync.isLoading}, hasError=${impianAsync.hasError}, konsumsiAsync.isLoading=${konsumsiAsync.isLoading}, hasError=${konsumsiAsync.hasError}',
    );

    if (impianAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (impianAsync.hasError) {
      L.w('impianProvider error=${impianAsync.error}');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Gagal memuat data impian'),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  final _ = ref.refresh(impianProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final impianState = impianAsync.requireValue;
    final List<ImpianModel> listImpianAsli = impianState.listImpian;
    L.i(
      'listImpian.length=${listImpianAsli.length}, totalJumlah=${impianState.totalJumlah}',
    );

    // Catatan konsumsi dipakai untuk saldo aktual ("dari catatan"). Bila belum
    // ada (atau gagal dimuat), progress memakai estimasi baseline biodata.
    var konsumsiList = const <KonsumsiRokokModel>[];
    if (konsumsiAsync.isLoading) {
      L.w('konsumsiAsync loading');
    } else if (konsumsiAsync.hasError) {
      L.w('konsumsiAsync error=${konsumsiAsync.error}');
    } else {
      konsumsiList = konsumsiAsync.requireValue.listKonsumsi;
    }

    // Saldo terkumpul: estimasi dari biodata dan aktual dari catatan konsumsi.
    BiodataModel? biodata;
    if (biodataAsync.isLoading) {
      L.w('biodataAsync loading');
    } else if (biodataAsync.hasError) {
      L.w('biodataAsync error=${biodataAsync.error}');
    } else {
      biodata = biodataAsync.requireValue;
    }
    final uangEstimasi = biodata == null
        ? 0.0
        : MetrikBerhentiHelper.hitungUangDihematEstimasi(biodata);
    final uangAktual = biodata == null
        ? 0.0
        : MetrikBerhentiHelper.hitungUangDihematAktual(biodata, konsumsiList);
    final hariTercatat = MetrikBerhentiHelper.hitungJumlahHariTercatat(
      konsumsiList,
    );
    final pakaiAktual = hariTercatat > 0;
    // Progres impian: aktual bila ada catatan, fallback estimasi.
    final saldoUntukProgres = pakaiAktual ? uangAktual : uangEstimasi;
    L.i(
      'uangEstimasi=$uangEstimasi, uangAktual=$uangAktual, hariTercatat=$hariTercatat, pakaiAktual=$pakaiAktual, saldoUntukProgres=$saldoUntukProgres',
    );

    final List<ImpianModel> listImpian = listImpianAsli.sorted((a, b) {
      switch (_sortImpian) {
        case SortImpian.namaAz:
          return a.nama.compareTo(b.nama);
        case SortImpian.namaZa:
          return b.nama.compareTo(a.nama);
        case SortImpian.jumlahAz:
          return a.jumlah.compareTo(b.jumlah);
        case SortImpian.jumlahZa:
          return b.jumlah.compareTo(a.jumlah);
        case SortImpian.mendekatiTerkumpulAz:
          final sisaA = ImpianProgresHelper.sisa(saldoUntukProgres, a.jumlah);
          final sisaB = ImpianProgresHelper.sisa(saldoUntukProgres, b.jumlah);
          return sisaA.compareTo(sisaB);
        case SortImpian.mendekatiTerkumpulZa:
          final sisaA = ImpianProgresHelper.sisa(saldoUntukProgres, a.jumlah);
          final sisaB = ImpianProgresHelper.sisa(saldoUntukProgres, b.jumlah);
          return sisaB.compareTo(sisaA);
      }
    });
    final jumlahTercapai = listImpian
        .where(
          (item) =>
              ImpianProgresHelper.tercapai(saldoUntukProgres, item.jumlah),
        )
        .length;
    L.i('jumlahTercapai=$jumlahTercapai/${listImpian.length}');

    // Cek impian yang baru tercapai. Toast dan penandaan dijadwalkan
    // setelah build selesai agar AppToast (FToast.showToast) tidak memanggil
    // setState/insert Overlay selama fase build, dan agar _sudahDiraikan
    // terupdate sehingga toast tidak muncul berulang pada setiap rebuild.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final item in listImpian) {
        final sudahTercapai = ImpianProgresHelper.tercapai(
          saldoUntukProgres,
          item.jumlah,
        );
        if (sudahTercapai && !_sudahDiraikan.contains(item.id)) {
          L.i('impianTercapai=${item.nama}, id=${item.id}');
          AppToast.sukses(
            context,
            'Selamat! Impian "${item.nama}" telah tercapai!',
          );
          unawaited(_tandaiSudahDiraikan(item.id));
          setState(() {
            _sudahDiraikan.add(item.id);
          });
        }
      }
    });

    if (listImpian.isEmpty) {
      L.w('listImpian kosong');
      return Scaffold(
        appBar: AppBar(title: const Text('Impian'), scrolledUnderElevation: 2),
        body: EmptyStateView(
          ikon: CupertinoIcons.star,
          judul: 'Belum ada impian',
          deskripsi:
              'Catat impian yang ingin kamu capai dengan uang yang dihemat '
              'dari berhenti merokok.',
          ctaLabel: 'Tambah Impian',
          onCta: () => unawaited(
            Nav.to(context, const FormImpian()).catchError((
              Object e,
              StackTrace s,
            ) {
              L.e('Gagal navigasi ke Form Impian: $e $s');
              return null;
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => unawaited(
            Nav.to(context, const FormImpian()).catchError((
              Object e,
              StackTrace s,
            ) {
              L.e('Gagal navigasi ke Form Impian: $e $s');
              return null;
            }),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impian'),
        scrolledUnderElevation: 2,
        actions: [
          IconButton(
            tooltip: 'Urutkan',
            icon: const Icon(CupertinoIcons.sort_up),
            onPressed: () => _showModalSort(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            children: [
              _buildSaldoTerkumpul(
                uangEstimasi,
                uangAktual,
                pakaiAktual,
                hariTercatat,
              ),
              Text(
                '$jumlahTercapai dari ${listImpian.length} impian tercapai',
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: listImpian.length,
                  itemBuilder: (context, index) {
                    final ImpianModel item = listImpian[index];
                    L.i(
                      'item.id=${item.id}, item.nama=${item.nama}, item.jumlah=${item.jumlah}',
                    );
                    final rasio = ImpianProgresHelper.rasio(
                      saldoUntukProgres,
                      item.jumlah,
                    );
                    final sudahTercapai = ImpianProgresHelper.tercapai(
                      saldoUntukProgres,
                      item.jumlah,
                    );
                    final sisa = ImpianProgresHelper.sisa(
                      saldoUntukProgres,
                      item.jumlah,
                    );
                    return Card(
                      key: ValueKey(item.id),
                      child: ListTile(
                        onTap: () => unawaited(
                          Nav.to(context, DetailImpianScreen(id: item.id)),
                        ),
                        title: Text(item.nama),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            if (item.jumlah <= 0)
                              Text(
                                'Atur target impian terlebih dahulu',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            VisualTabunganImpian(
                              rasio: rasio,
                              tercapai: sudahTercapai,
                              tema: temaVisual,
                              pakaiAktual: pakaiAktual,
                              labelSaldo: pakaiAktual
                                  ? 'Progres dari catatan (berdasarkan $hariTercatat hari tercatat)'
                                  : 'Progres estimasi dari biodata',
                            ),
                            if (sudahTercapai)
                              Text(
                                'Tercapai',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            // Bungkus Text dengan Flexible agar tidak overflow pada layar sempit.
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Sisa: ${FormatUang.formatRupiah(sisa)}',
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Target: ${FormatUang.formatRupiah(item.jumlah)}',
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: indentasi Nav.to diselaraskan dengan dua
      // pemanggilan unawaited() lain di file ini (baris 251 dan 261).
      floatingActionButton: FloatingActionButton(
        onPressed: () => unawaited(
          Nav.to(context, const FormImpian()).catchError((
            Object e,
            StackTrace s,
          ) {
            L.e('Gagal navigasi ke Form Impian: $e $s');
            return null;
          }),
        ),
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  Widget _buildSaldoTerkumpul(
    double estimasi,
    double aktual,
    bool pakaiAktual,
    int hariTercatat,
  ) {
    L.i(
      'estimasi=$estimasi, aktual=$aktual, pakaiAktual=$pakaiAktual, hariTercatat=$hariTercatat',
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        // Jarak seragam antar-anak Row diatur dengan properti spacing
        // (optimasi_ui.md #4), bukan SizedBox individual.
        child: Column(
          spacing: 8,
          children: [
            Text(
              'Saldo terkumpul',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                const Icon(Icons.savings_outlined),
                _SaldoItem(
                  label: 'Estimasi',
                  nilai: FormatUang.formatRupiah(estimasi),
                ),
                _SaldoItem(
                  label: 'Dari catatan',
                  nilai: pakaiAktual
                      ? FormatUang.formatRupiah(aktual)
                      : 'Belum ada catatan',
                ),
              ],
            ),
            Text(
              pakaiAktual
                  ? 'Aktual berdasarkan $hariTercatat hari tercatat. Estimasi dari kebiasaan harian biodata.'
                  : 'Belum ada catatan konsumsi. Menampilkan estimasi dari kebiasaan harian biodata.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Item saldo dengan label sumber angka ("Estimasi" / "Dari catatan").
class _SaldoItem extends StatelessWidget {
  const _SaldoItem({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        Text(
          nilai,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}


```


// ============================================================
// FILE: lib/fitur/impian/state/impian_state.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/impian/model/impian_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'impian_state.freezed.dart';

@freezed
abstract class ImpianState with _$ImpianState {
  const ImpianState._();

  const factory ImpianState({
    @Default([]) List<ImpianModel> listImpian,
    @Default(0) int jumlahImpian,
    @Default(0) double totalJumlah,
  }) = _ImpianState;
}
```


// ============================================================
// FILE: lib/fitur/impian/widget/visual_tabungan_impian.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/impian/enum/tema_visual_impian.dart';
import 'package:flutter/material.dart';

/// Widget visual tabungan impian: objek visual (sesuai [tema]) yang tumbuh
/// proporsional terhadap rasio progres, dengan `LinearProgressIndicator`
/// di bawahnya sebagai indikator utama.
///
/// Menggunakan komponen Flutter bawaan tanpa Lottie/aset gambar baru.
/// Objek visual tidak menggantikan data numerik aktual; angka progres
/// tetap ditampilkan oleh pemanggil.
class VisualTabunganImpian extends StatelessWidget {
  const VisualTabunganImpian({
    super.key,
    required this.rasio,
    required this.tercapai,
    required this.tema,
    this.pakaiAktual = false,
    this.labelSaldo,
  });

  /// Rasio progres (0.0 - 1.0).
  final double rasio;

  /// Apakah impian sudah tercapai.
  final bool tercapai;

  /// Tema visual metafora impian (objek yang ditampilkan).
  final TemaVisualImpian tema;

  /// Apakah progres dihitung dari saldo aktual ("dari catatan"); false berarti
  /// dari estimasi baseline. Menentukan label aksesibilitas/tooltip.
  final bool pakaiAktual;

  /// Label sumber saldo untuk tooltip, aksesibilitas, dan caption di bawah
  /// progress bar. Bila kosong, diturunkan dari [pakaiAktual].
  final String? labelSaldo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final aman = rasio.clamp(0.0, 1.0);
    // Objek visual tumbuh proporsional terhadap rasio progres (0-1).
    final ukuranIkon = 20.0 + (28.0 * aman);
    final tooltip =
        labelSaldo ??
        (pakaiAktual
            ? 'Progres tabungan dari catatan konsumsi'
            : 'Progres tabungan estimasi dari biodata');
    return Tooltip(
      message: tooltip,
      child: Semantics(
        label: tooltip,
        container: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(
              tema.icon,
              size: ukuranIkon,
              color: tercapai ? cs.primary : cs.secondary,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: aman,
                minHeight: 12,
                backgroundColor: cs.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  tercapai ? cs.primary : cs.secondary,
                ),
              ),
            ),
            Text(
              tooltip,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/kalender_smoke_free/screens/kalender_smoke_free_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/screens/form_biodata.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Status kalender per tanggal, diturunkan dari log konsumsi yang ada.
///
/// Hari tanpa catatan tidak pernah dianggap bebas rokok; status di bawah
/// adalah cerminan apa adanya dari data konsumsi.
enum StatusKalender {
  adaKonsumsi,
  slip,
  tanpaCatatan,
  belumMulai,
  mendatang,
}

/// Kunci tanggal `yyyy-MM-dd` (waktu lokal).
///
/// Format sama dengan `KonsumsiHitungHelper.ringkasanHarian` agar konsisten.
String _keyTanggal(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Menentukan status kalender untuk satu [tanggal].
StatusKalender _statusTanggal({
  required DateTime tanggal,
  required DateTime tanggalBerhenti,
  required DateTime hariIni,
  required Map<String, int> ringkasan,
  required Map<String, int> slipPerTanggal,
}) {
  if (tanggal.isBefore(tanggalBerhenti)) return StatusKalender.belumMulai;
  if (tanggal.isAfter(hariIni)) return StatusKalender.mendatang;
  final key = _keyTanggal(tanggal);
  if (slipPerTanggal.containsKey(key)) return StatusKalender.slip;
  if ((ringkasan[key] ?? 0) > 0) return StatusKalender.adaKonsumsi;
  return StatusKalender.tanpaCatatan;
}

// Streak dihitung lewat MetrikBerhentiHelper.hitungStreak (helper bersama)
// agar logika tidak ditulis dua kali di layar ini.

/// Halaman kalender smoke-free.
///
/// Menampilkan kalender bulanan yang jujur terhadap log konsumsi: hari
/// tanpa catatan tampil netral (bukan bebas rokok), hari dengan catatan
/// konsumsi/slip diberi warna sesuai status, dan progres kumulatif
/// dipisahkan dari streak saat ini.
class KalenderSmokeFreeScreen extends ConsumerStatefulWidget {
  const KalenderSmokeFreeScreen({super.key});

  @override
  ConsumerState<KalenderSmokeFreeScreen> createState() =>
      _KalenderSmokeFreeScreenState();
}

class _KalenderSmokeFreeScreenState
    extends ConsumerState<KalenderSmokeFreeScreen> {
  DateTime _bulanDitampilkan = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  static const List<String> _namaHari = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  @override
  void initState() {
    super.initState();
    L.i('KalenderSmokeFreeScreen initState');
  }

  @override
  void dispose() {
    L.i('KalenderSmokeFreeScreen dispose');
    super.dispose();
  }

  void _bulanSebelumnya() {
    setState(() {
      _bulanDitampilkan = DateTime(
        _bulanDitampilkan.year,
        _bulanDitampilkan.month - 1,
      );
    });
  }

  void _bulanBerikutnya() {
    setState(() {
      _bulanDitampilkan = DateTime(
        _bulanDitampilkan.year,
        _bulanDitampilkan.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(biodataProvider);
    final konsumsiAsync = ref.watch(konsumsiRokokProvider);

    if (biodataAsync.isLoading || konsumsiAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (biodataAsync.hasError) {
      L.e(
        'biodataAsync error: ${biodataAsync.error} ${biodataAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Kalender Smoke-Free')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(biodataProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (konsumsiAsync.hasError) {
      L.e(
        'konsumsiAsync error: ${konsumsiAsync.error} ${konsumsiAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Kalender Smoke-Free')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data konsumsi'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(konsumsiRokokProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final biodata = biodataAsync.requireValue;
    final konsumsiState = konsumsiAsync.requireValue;
    if (biodata == null) {
      return _buildBiodataNull();
    }

    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    if (tanggalBerhenti == null) {
      return _buildBelumBerhenti();
    }

    final hariIni = DateTime.now();
    final hariIniDate = DateTime(hariIni.year, hariIni.month, hariIni.day);
    final tanggalBerhentiDate = DateTime(
      tanggalBerhenti.year,
      tanggalBerhenti.month,
      tanggalBerhenti.day,
    );

    // Kelompokkan catatan konsumsi per tanggal lokal, sekali untuk seluruh grid.
    final ringkasan = konsumsiState.ringkasanHarian;
    final catatanPerTanggal = <String, List<KonsumsiRokokModel>>{};
    final slipPerTanggal = <String, int>{};
    for (final m in konsumsiState.listKonsumsi) {
      final lokal = m.tanggal.toLocal();
      final key = _keyTanggal(lokal);
      catatanPerTanggal.putIfAbsent(key, () => []).add(m);
      if (m.isSlip) {
        slipPerTanggal[key] = (slipPerTanggal[key] ?? 0) + m.jumlah;
      }
    }

    final totalSmokeFree =
        hariIniDate.difference(tanggalBerhentiDate).inDays + 1;
    final totalSmokeFreeAman = totalSmokeFree < 0 ? 0 : totalSmokeFree;
    final streak = MetrikBerhentiHelper.hitungStreak(konsumsiState.listKonsumsi);
    L.i(
      'streak=$streak, totalSmokeFree=$totalSmokeFreeAman, '
      'ringkasan.length=${ringkasan.length}',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Kalender Smoke-Free')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RingkasanSmokeFree(
                tanggalBerhenti: tanggalBerhentiDate,
                totalSmokeFree: totalSmokeFreeAman,
                streak: streak,
              ),
              _NavigasiBulan(
                bulan: _bulanDitampilkan,
                onSebelumnya: _bulanSebelumnya,
                onBerikutnya: _bulanBerikutnya,
              ),
              _HeaderHari(namaHari: _namaHari),
              Expanded(
                child: _GridKalender(
                  bulan: _bulanDitampilkan,
                  tanggalBerhenti: tanggalBerhentiDate,
                  hariIni: hariIniDate,
                  biodata: biodata,
                  ringkasan: ringkasan,
                  slipPerTanggal: slipPerTanggal,
                  catatanPerTanggal: catatanPerTanggal,
                ),
              ),
              const _Legenda(),
              Text(
                'Hari tanpa catatan tidak dihitung sebagai bebas rokok. '
                'Catat konsumsi agar kalender akurat.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiodataNull() {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalender Smoke-Free')),
      body: EmptyStateView(
        ikon: CupertinoIcons.person,
        judul: 'Belum ada data biodata',
        deskripsi:
            'Kalender smoke-free membutuhkan biodata untuk mengetahui '
            'kebiasaan merokokmu sebelum berhenti.',
        ctaLabel: 'Isi Biodata',
        onCta: _bukaFormBiodata,
      ),
    );
  }

  Widget _buildBelumBerhenti() {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalender Smoke-Free')),
      body: EmptyStateView(
        ikon: CupertinoIcons.calendar,
        judul: 'Belum ada tanggal mulai berhenti',
        deskripsi:
            'Isi tanggal mulai berhenti pada biodata untuk melihat '
            'kalender smoke-free.',
        ctaLabel: 'Isi Biodata',
        onCta: _bukaFormBiodata,
      ),
    );
  }

  void _bukaFormBiodata() {
    unawaited(
      Nav.to(context, const FormBiodata(buatPertama: false)).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Form Biodata: $e $s');
        return null;
      }),
    );
  }
}

class _RingkasanSmokeFree extends StatelessWidget {
  const _RingkasanSmokeFree({
    required this.tanggalBerhenti,
    required this.totalSmokeFree,
    required this.streak,
  });

  final DateTime tanggalBerhenti;
  final int totalSmokeFree;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              'Streak saat ini',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$streak hari',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              'Hari berturut-turut tanpa catatan konsumsi/slip sampai hari ini',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(),
            Text(
              'Total hari sejak berhenti',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$totalSmokeFree hari',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sejak ${FormatTanggal.formatDasar(tanggalBerhenti)}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigasiBulan extends StatelessWidget {
  const _NavigasiBulan({
    required this.bulan,
    required this.onSebelumnya,
    required this.onBerikutnya,
  });

  final DateTime bulan;
  final VoidCallback onSebelumnya;
  final VoidCallback onBerikutnya;

  static const List<String> _namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onSebelumnya,
          icon: const Icon(CupertinoIcons.chevron_left),
          tooltip: 'Bulan sebelumnya',
        ),
        Text(
          '${_namaBulan[bulan.month - 1]} ${bulan.year}',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onBerikutnya,
          icon: const Icon(CupertinoIcons.chevron_right),
          tooltip: 'Bulan berikutnya',
        ),
      ],
    );
  }
}

class _HeaderHari extends StatelessWidget {
  const _HeaderHari({required this.namaHari});

  final List<String> namaHari;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final h in namaHari)
          Expanded(
            child: Center(
              child: Text(
                h,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}

class _GridKalender extends StatelessWidget {
  const _GridKalender({
    required this.bulan,
    required this.tanggalBerhenti,
    required this.hariIni,
    required this.biodata,
    required this.ringkasan,
    required this.slipPerTanggal,
    required this.catatanPerTanggal,
  });

  final DateTime bulan;
  final DateTime tanggalBerhenti;
  final DateTime hariIni;
  final BiodataModel biodata;
  final Map<String, int> ringkasan;
  final Map<String, int> slipPerTanggal;
  final Map<String, List<KonsumsiRokokModel>> catatanPerTanggal;

  @override
  Widget build(BuildContext context) {
    final tahun = bulan.year;
    final bulanIndex = bulan.month;
    final hariPertama = DateTime(tahun, bulanIndex, 1);
    // Monday=1..Sunday=7. Grid Monday-first.
    final offset = (hariPertama.weekday - 1) % 7;
    final jumlahHari = DateTime(tahun, bulanIndex + 1, 0).day;

    final cells = <Widget>[];
    for (int i = 0; i < offset; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int hari = 1; hari <= jumlahHari; hari++) {
      final tanggal = DateTime(tahun, bulanIndex, hari);
      cells.add(
        _SelHari(
          tanggal: tanggal,
          tanggalBerhenti: tanggalBerhenti,
          hariIni: hariIni,
          biodata: biodata,
          ringkasan: ringkasan,
          slipPerTanggal: slipPerTanggal,
          catatanPerTanggal: catatanPerTanggal,
        ),
      );
    }
    // Pad to multiple of 7.
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    return GridView.count(
      crossAxisCount: 7,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      physics: const NeverScrollableScrollPhysics(),
      children: cells,
    );
  }
}

class _SelHari extends StatelessWidget {
  const _SelHari({
    required this.tanggal,
    required this.tanggalBerhenti,
    required this.hariIni,
    required this.biodata,
    required this.ringkasan,
    required this.slipPerTanggal,
    required this.catatanPerTanggal,
  });

  final DateTime tanggal;
  final DateTime tanggalBerhenti;
  final DateTime hariIni;
  final BiodataModel biodata;
  final Map<String, int> ringkasan;
  final Map<String, int> slipPerTanggal;
  final Map<String, List<KonsumsiRokokModel>> catatanPerTanggal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final hariIniFlag = tanggal == hariIni;
    final key = _keyTanggal(tanggal);
    final status = _statusTanggal(
      tanggal: tanggal,
      tanggalBerhenti: tanggalBerhenti,
      hariIni: hariIni,
      ringkasan: ringkasan,
      slipPerTanggal: slipPerTanggal,
    );
    final slipBatang = slipPerTanggal[key] ?? 0;
    final catatan = catatanPerTanggal[key] ?? const <KonsumsiRokokModel>[];
    final sedangTapering =
        biodata.sedangTapering && biodata.targetRokokHariIni > 0;

    Color? warnaLatar;
    switch (status) {
      case StatusKalender.adaKonsumsi:
        warnaLatar = Colors.orange.withValues(alpha: 0.25);
      case StatusKalender.slip:
        warnaLatar = Colors.red.withValues(alpha: 0.25);
      case StatusKalender.tanpaCatatan:
        warnaLatar = colorScheme.surfaceContainerHighest;
      case StatusKalender.belumMulai:
      case StatusKalender.mendatang:
        warnaLatar = null;
    }

    Border? border;
    if (hariIniFlag) {
      border = Border.all(color: colorScheme.primary, width: 2);
    } else if (sedangTapering &&
        status != StatusKalender.belumMulai &&
        status != StatusKalender.mendatang) {
      border = Border.all(color: colorScheme.tertiary, width: 1.5);
    }

    final Color warnaTeks;
    switch (status) {
      case StatusKalender.adaKonsumsi:
        warnaTeks = Colors.orange.shade900;
      case StatusKalender.slip:
        warnaTeks = Colors.red.shade800;
      case StatusKalender.tanpaCatatan:
        warnaTeks = colorScheme.onSurface;
      case StatusKalender.belumMulai:
      case StatusKalender.mendatang:
        warnaTeks = Theme.of(context).disabledColor;
    }

    final sel = Container(
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(8),
        border: border,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${tanggal.day}',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: hariIniFlag ? FontWeight.bold : FontWeight.normal,
              color: warnaTeks,
            ),
          ),
          if (status == StatusKalender.slip)
            Text(
              '$slipBatang btg',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade800,
              ),
            ),
        ],
      ),
    );

    final bisaKetuk = status != StatusKalender.belumMulai &&
        status != StatusKalender.mendatang;
    if (!bisaKetuk) {
      return sel;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => unawaited(
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => _DetailTanggal(
              tanggal: tanggal,
              status: status,
              catatan: catatan,
              biodata: biodata,
            ),
          ).catchError((Object e, StackTrace s) {
            L.e('Gagal membuka detail tanggal: $e $s');
            return null;
          }),
        ),
        child: sel,
      ),
    );
  }
}

class _DetailTanggal extends StatelessWidget {
  const _DetailTanggal({
    required this.tanggal,
    required this.status,
    required this.catatan,
    required this.biodata,
  });

  final DateTime tanggal;
  final StatusKalender status;
  final List<KonsumsiRokokModel> catatan;
  final BiodataModel biodata;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final (String statusLabel, Color statusWarna) = switch (status) {
      StatusKalender.adaKonsumsi => (
          'Ada konsumsi tercatat',
          Colors.orange.shade900,
        ),
      StatusKalender.slip => (
          'Slip (kekambuhan) tercatat',
          Colors.red.shade800,
        ),
      StatusKalender.tanpaCatatan => (
          'Tanpa catatan',
          colorScheme.onSurfaceVariant,
        ),
      StatusKalender.belumMulai => (
          'Belum mulai',
          colorScheme.onSurfaceVariant,
        ),
      StatusKalender.mendatang => (
          'Mendatang',
          colorScheme.onSurfaceVariant,
        ),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              FormatTanggal.formatSingkat(tanggal),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              spacing: 8,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusWarna,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  statusLabel,
                  style: textTheme.bodyMedium?.copyWith(
                    color: statusWarna,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (catatan.isEmpty)
              Text(
                'Tidak ada catatan konsumsi pada tanggal ini.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else ...[
              Text(
                'Catatan (${catatan.length})',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              for (final m in catatan) _BarisCatatan(konsumsi: m),
            ],
            if (biodata.sedangTapering)
              Text(
                'Target tapering saat ini: ${biodata.targetRokokHariIni} batang',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BarisCatatan extends StatelessWidget {
  const _BarisCatatan({required this.konsumsi});

  final KonsumsiRokokModel konsumsi;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isSlip = konsumsi.isSlip;
    final catatanTeks = konsumsi.catatan;

    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.smoking_rooms,
          size: 20,
          color: isSlip ? Colors.red.shade800 : colorScheme.onSurfaceVariant,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                '${konsumsi.jumlah} batang${isSlip ? '  •  SLIP' : ''}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: isSlip ? FontWeight.bold : FontWeight.normal,
                  color: isSlip ? Colors.red.shade800 : null,
                ),
              ),
              if (catatanTeks != null && catatanTeks.isNotEmpty)
                Text(
                  catatanTeks,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              Text(
                FormatWaktuLengkap.formatSingkat(konsumsi.tanggal.toLocal()),
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _ItemLegenda(
          warna: Colors.orange.withValues(alpha: 0.25),
          label: 'Ada konsumsi',
          textTheme: textTheme,
        ),
        _ItemLegenda(
          warna: Colors.red.withValues(alpha: 0.25),
          label: 'Slip',
          textTheme: textTheme,
        ),
        _ItemLegenda(
          warna: colorScheme.surfaceContainerHighest,
          label: 'Tanpa catatan',
          textTheme: textTheme,
          border: true,
        ),
        _ItemLegenda(
          warna: null,
          label: 'Tapering',
          textTheme: textTheme,
          borderColor: colorScheme.tertiary,
        ),
      ],
    );
  }
}

class _ItemLegenda extends StatelessWidget {
  const _ItemLegenda({
    required this.warna,
    required this.label,
    required this.textTheme,
    this.border = false,
    this.borderColor,
  });

  final Color? warna;
  final String label;
  final TextTheme textTheme;
  final bool border;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final warnaBorder = borderColor ??
        (border ? Theme.of(context).disabledColor : null);
    return Row(
      spacing: 6,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: warna,
            borderRadius: BorderRadius.circular(4),
            border: warnaBorder != null
                ? Border.all(color: warnaBorder)
                : null,
          ),
        ),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:share_global_saya/core_shared.dart';

/// Helper murni untuk perhitungan turunan konsumsi rokok.
///
/// Tidak bergantung pada [BuildContext] atau provider. Semua method
/// memegang guard pada list kosong dan mengembalikan nilai default.
class KonsumsiHitungHelper {
  const KonsumsiHitungHelper._();

  /// Mengelompokkan konsumsi per hari (key `yyyy-MM-dd`, waktu lokal).
  static Map<String, int> ringkasanHarian(List<KonsumsiRokokModel> list) {
    L.i('list.length=${list.length}');
    if (list.isEmpty) return const {};
    final map = <String, int>{};
    for (final m in list) {
      final key = kunciTanggal(m.tanggal);
      map[key] = (map[key] ?? 0) + m.jumlah;
    }
    return map;
  }

  /// Kunci tanggal `yyyy-MM-dd` dari [tanggal] (waktu lokal).
  static String kunciTanggal(DateTime tanggal) {
    final lokal = tanggal.toLocal();
    return '${lokal.year}-${lokal.month.toString().padLeft(2, '0')}-${lokal.day.toString().padLeft(2, '0')}';
  }

  /// Total seluruh konsumsi batang rokok.
  static int totalKonsumsi(List<KonsumsiRokokModel> list) {
    if (list.isEmpty) return 0;
    return list.fold(0, (sum, m) => sum + m.jumlah);
  }

  /// Rata-rata konsumsi per hari atas [hari] hari kalender terakhir.
  ///
  /// Hari tanpa catatan dihitung 0. Ini menggantikan perhitungan lama yang
  /// hanya merata-ratakan hari yang punya catatan.
  static double rataRataHarian(List<KonsumsiRokokModel> list, {int hari = 7}) =>
      rataRataKalender(list, hari: hari);

  /// Rata-rata konsumsi per hari atas [hari] hari kalender terakhir.
  ///
  /// Hari tanpa catatan dihitung 0. Mengembalikan 0.0 bila [hari] <= 0.
  static double rataRataKalender(
    List<KonsumsiRokokModel> list, {
    int hari = 7,
  }) {
    if (hari <= 0) return 0.0;
    final ringkasan = ringkasanHarian(list);
    final now = DateTime.now();
    final hariIni = DateTime(now.year, now.month, now.day);
    var total = 0;
    for (var i = 0; i < hari; i++) {
      final d = hariIni.subtract(Duration(days: i));
      total += ringkasan[kunciTanggal(d)] ?? 0;
    }
    return total / hari;
  }

  /// Jumlah hari yang punya catatan dalam [hari] hari kalender terakhir.
  /// Mengembalikan 0 bila [hari] <= 0.
  static int jumlahHariTercatat(List<KonsumsiRokokModel> list, {int hari = 7}) {
    if (hari <= 0) return 0;
    final ringkasan = ringkasanHarian(list);
    final now = DateTime.now();
    final hariIni = DateTime(now.year, now.month, now.day);
    var jumlah = 0;
    for (var i = 0; i < hari; i++) {
      final d = hariIni.subtract(Duration(days: i));
      if (ringkasan.containsKey(kunciTanggal(d))) jumlah += 1;
    }
    return jumlah;
  }

  /// Rentang UTC hari ini untuk query langsung ke database.
  static Map<String, Object?> rangeHariIniUtc() {
    final hariIni = DateTime.now();
    final awalHari = DateTime(hariIni.year, hariIni.month, hariIni.day).toUtc();
    final akhirHari = awalHari.add(const Duration(days: 1));
    return {
      'awal': awalHari.toIso8601String(),
      'akhir': akhirHari.toIso8601String(),
    };
  }

  /// Konsumsi hari ini berdasarkan waktu lokal perangkat.
  static int konsumsiHariIni(List<KonsumsiRokokModel> list) =>
      ringkasanHarian(list)[kunciTanggal(DateTime.now())] ?? 0;

  /// Konsumsi pada [tanggal] tertentu berdasarkan waktu lokal.
  static int konsumsiTanggal(List<KonsumsiRokokModel> list, DateTime tanggal) =>
      ringkasanHarian(list)[kunciTanggal(tanggal)] ?? 0;
}
```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/biodata/model/biodata_model.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';

/// Helper murni metrik berhenti: baseline (estimasi dari biodata) dan aktual
/// (dari catatan konsumsi).
///
/// Tidak bergantung pada `BuildContext` atau provider. Semua perhitungan
/// berbasis tanggal dinormalisasi ke komponen tanggal saja (tahun, bulan,
/// hari) dengan clamp nilai negatif ke nol dan guard pembagian nol.
///
/// Aturan hari tanpa catatan: hari kalender tanpa catatan konsumsi
/// **dikecualikan** dari perhitungan aktual; hari tersebut bukan bukti
/// pengguna tidak merokok. Metrik aktual wajib diberi label
/// "berdasarkan n hari tercatat" di UI.
class MetrikBerhentiHelper {
  const MetrikBerhentiHelper._();

  /// Hari sejak [BiodataModel.tanggalMulaiBerhentiMerokok], dinormalisasi
  /// ke komponen tanggal saja, clamp >= 0.
  ///
  /// Ini metrik **baseline** (kumulatif), bukan berbasis catatan konsumsi.
  static int hitungHariBerhenti(BiodataModel biodata) => biodata.hariBerhenti;

  /// Estimasi rokok yang tidak dihisap selama periode smoke-free.
  ///
  /// Baseline dari biodata (`jumlahRokokPerHari × hariBerhenti`), bukan dari
  /// catatan konsumsi. Beri label "estimasi" di UI.
  static int hitungRokokTidakDiHisapEstimasi(BiodataModel biodata) =>
      biodata.rokokTidakDiHisap;

  /// Estimasi uang yang tidak dibelanjakan selama periode smoke-free.
  ///
  /// Baseline dari biodata. Beri label "estimasi" di UI.
  static double hitungUangDihematEstimasi(BiodataModel biodata) =>
      biodata.uangDihemat;

  /// Rokok yang dihindari secara aktual.
  ///
  /// `Σ max(0, targetRokokHariIni − konsumsi)` per hari yang **punya
  /// catatan**, memakai target tapering (`targetRokokHariIni`) sebagai
  /// pembanding. Hari tanpa catatan dikecualikan.
  static int hitungRokokDihindariAktual(
    BiodataModel biodata,
    List<KonsumsiRokokModel> list,
  ) {
    if (list.isEmpty) return 0;
    final target = biodata.targetRokokHariIni;
    var total = 0;
    for (final jumlah in KonsumsiHitungHelper.ringkasanHarian(list).values) {
      final terhindar = target - jumlah;
      if (terhindar > 0) total += terhindar;
    }
    return total;
  }

  /// Uang yang tidak dibelanjakan secara aktual (dari catatan konsumsi).
  static double hitungUangDihematAktual(
    BiodataModel biodata,
    List<KonsumsiRokokModel> list,
  ) {
    if (biodata.batangPerBungkus == 0) return 0.0;
    final dihindari = hitungRokokDihindariAktual(biodata, list);
    return (dihindari / biodata.batangPerBungkus) *
        biodata.hargaRokokPerBungkus;
  }

  /// Jumlah hari unik yang punya catatan konsumsi (seluruh riwayat).
  static int hitungJumlahHariTercatat(List<KonsumsiRokokModel> list) =>
      KonsumsiHitungHelper.ringkasanHarian(list).length;

  /// Streak pencatatan: hari kalender berturut-turut yang punya catatan
  /// konsumsi, dihitung mundur dari hari ini. Bila hari ini belum punya
  /// catatan, perhitungan dimulai dari kemarin agar streak tidak putus hanya
  /// karena pengguna belum sempat mencatat hari ini. Belum ada catatan → 0.
  static int hitungStreakPencatatan(List<KonsumsiRokokModel> list) {
    final ringkasan = KonsumsiHitungHelper.ringkasanHarian(list);
    if (ringkasan.isEmpty) return 0;
    final sekarang = DateTime.now();
    var kursor = DateTime(sekarang.year, sekarang.month, sekarang.day);
    if (!ringkasan.containsKey(KonsumsiHitungHelper.kunciTanggal(kursor))) {
      kursor = kursor.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (ringkasan.containsKey(KonsumsiHitungHelper.kunciTanggal(kursor))) {
      streak += 1;
      kursor = kursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Streak: hari kalender berturut-turut tanpa catatan konsumsi/slip sampai
  /// hari ini. Catatan konsumsi (termasuk slip) mereset streak; progres
  /// kumulatif tidak direset. Belum ada catatan → 0 (bukan bukti bebas rokok).
  static int hitungStreak(List<KonsumsiRokokModel> list) {
    DateTime? terakhir;
    for (final m in list) {
      final t = m.tanggal.toLocal();
      final d = DateTime(t.year, t.month, t.day);
      if (terakhir == null || d.isAfter(terakhir)) terakhir = d;
    }
    if (terakhir == null) return 0;

    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final selisih = hariIni.difference(terakhir).inDays;
    return selisih < 0 ? 0 : selisih;
  }

  /// Minggu tapering berjalan untuk [biodata] (mode bertahap), 1-based dan
  /// minimal 1. Bukan mode bertahap atau tanggal mulai kosong → 1.
  ///
  /// Tanggal dinormalisasi ke komponen tanggal saja agar selisih hari tidak
  /// terpengaruh komponen waktu; hasil negatif klamp ke nol.
  static int hitungMingguTaperingBerjalan(BiodataModel biodata) {
    if (!biodata.sedangTapering) return 1;
    final mulai = biodata.tanggalMulaiTapering ?? DateTime.now();
    final sekarang = DateTime.now();
    final mulaiDate = DateTime(mulai.year, mulai.month, mulai.day);
    final sekarangDate = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final hariBerlalu = sekarangDate.difference(mulaiDate).inDays;
    final mingguBerlalu = hariBerlalu < 0 ? 0 : hariBerlalu ~/ 7;
    return mingguBerlalu + 1;
  }

  /// Target konsumsi rokok untuk minggu ke-[mingguKe] (1-based) mode tapering.
  ///
  /// Memakai formula yang sama dengan getter `targetRokokHariIni`
  /// (`jumlahRokokPerHari - penurunanPerMinggu * (mingguKe - 1)`) dengan
  /// clamp 0..jumlahRokokPerHari. Minggu sebelum tapering dimulai dianggap
  /// minggu pertama.
  static int hitungTargetTaperingMingguKe(BiodataModel biodata, int mingguKe) {
    final penurunan = biodata.penurunanPerMinggu * (mingguKe - 1);
    final target = biodata.jumlahRokokPerHari - penurunan;
    if (target < 0) return 0;
    if (target > biodata.jumlahRokokPerHari) return biodata.jumlahRokokPerHari;
    return target;
  }

  /// Rata-rata konsumsi per hari atas [hari] hari kalender terakhir.
  /// Hari tanpa catatan dihitung 0.
  static double hitungRataRataKalender(
    List<KonsumsiRokokModel> list, {
    int hari = 7,
  }) => KonsumsiHitungHelper.rataRataKalender(list, hari: hari);

  /// Jumlah hari yang punya catatan dalam [hari] hari kalender terakhir.
  static int hitungHariTercatatKalender(
    List<KonsumsiRokokModel> list, {
    int hari = 7,
  }) => KonsumsiHitungHelper.jumlahHariTercatat(list, hari: hari);
}
```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/helper/puncak_konsumsi_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/diary_craving/enum/pemicu_enum.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:share_global_saya/core_shared.dart';

/// Helper murni untuk analisis puncak konsumsi rokok.
///
/// Tidak bergantung pada [BuildContext] atau provider. Semua method
/// memegang guard pada list kosong dan mengembalikan nilai default.
class PuncakKonsumsiHelper {
  const PuncakKonsumsiHelper._();

  /// Jumlah total batang per jam (0-23) berdasarkan waktu lokal.
  static Map<int, int> distribusiJam(List<KonsumsiRokokModel> list) {
    L.i('list.length=${list.length}');
    if (list.isEmpty) return const {};
    final map = <int, int>{};
    for (final m in list) {
      final jam = m.tanggal.toLocal().hour;
      map[jam] = (map[jam] ?? 0) + m.jumlah;
    }
    return map;
  }

  /// Jumlah total batang per hari dalam seminggu (Minggu=0 .. Sabtu=6).
  static Map<int, int> distribusiHari(List<KonsumsiRokokModel> list) {
    L.i('list.length=${list.length}');
    if (list.isEmpty) return const {};
    final map = <int, int>{};
    for (final m in list) {
      final hari = m.tanggal.toLocal().weekday % 7; // Minggu=0, Senin=1, ..., Sabtu=6
      map[hari] = (map[hari] ?? 0) + m.jumlah;
    }
    return map;
  }

  /// Jumlah entri konsumsi per [PemicuEnum] (hanya entri yang punya pemicu).
  static Map<PemicuEnum, int> distribusiPemicu(List<KonsumsiRokokModel> list) {
    L.i('list.length=${list.length}');
    if (list.isEmpty) return const {};
    final map = <PemicuEnum, int>{};
    for (final m in list) {
      if (m.pemicu != null) {
        map[m.pemicu!] = (map[m.pemicu!] ?? 0) + 1;
      }
    }
    return map;
  }

  /// Jumlah hari distinct yang punya catatan konsumsi (berdasarkan waktu lokal).
  static int _jumlahHariTercatat(List<KonsumsiRokokModel> list) {
    final hariSet = <String>{};
    for (final m in list) {
      final lokal = m.tanggal.toLocal();
      hariSet.add(
        '${lokal.year}-${lokal.month.toString().padLeft(2, '0')}-${lokal.day.toString().padLeft(2, '0')}',
      );
    }
    return hariSet.length;
  }

  /// Ringkasan teks analisis puncak untuk ditampilkan di UI.
  ///
  /// Jika data < 7 hari, mengembalikan pesan data tidak cukup.
  static String ringkasanTeks(List<KonsumsiRokokModel> list) {
    if (list.isEmpty) {
      return 'Data belum cukup untuk analisis puncak. Catat konsumsi minimal 7 hari.';
    }
    final jumlahHari = _jumlahHariTercatat(list);
    if (jumlahHari < 7) {
      return 'Data belum cukup untuk analisis puncak. Catat konsumsi minimal 7 hari.';
    }

    final jamDist = distribusiJam(list);
    final hariDist = distribusiHari(list);
    final pemicuDist = distribusiPemicu(list);

    // Jam puncak
    String jamPuncak = '-';
    if (jamDist.isNotEmpty) {
      final jamTertinggi = jamDist.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      final jam = jamTertinggi.key;
      final rataRata = (jamTertinggi.value / jumlahHari).round();
      jamPuncak =
          '${jam.toString().padLeft(2, '0')}:00–${(jam + 1).toString().padLeft(2, '0')}:00 (rata-rata $rataRata batang/hari)';
    }

    // Hari puncak
    const namaHari = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    String hariPuncak = '-';
    if (hariDist.isNotEmpty) {
      final hariTertinggi = hariDist.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      final hariIdx = hariTertinggi.key;
      final minggu = (jumlahHari / 7).ceil();
      final rataRata = (hariTertinggi.value / minggu).round();
      hariPuncak = '${namaHari[hariIdx]} (rata-rata $rataRata batang/minggu)';
    }

    // Pemicu paling umum (top 3)
    String pemicuPalingUmum = '-';
    if (pemicuDist.isNotEmpty) {
      final totalPemicu = pemicuDist.values.fold(0, (a, b) => a + b);
      final urutan = pemicuDist.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top3 = urutan.take(3).map((e) {
        final pct = (e.value / totalPemicu * 100).round();
        return '${e.key.label} ($pct%)';
      }).join(', ');
      pemicuPalingUmum = top3;
    }

    return 'Jam puncak: $jamPuncak\nHari puncak: $hariPuncak\nPemicu paling umum: $pemicuPalingUmum';
  }
}
```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/konsumsi_hitung_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/state/konsumsi_rokok_state.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'konsumsi_rokok_notifier.g.dart';

@Riverpod(keepAlive: true)
class KonsumsiRokokNotifier extends _$KonsumsiRokokNotifier {
  @override
  Future<KonsumsiRokokState> build() async {
    return await _ambilSemua();
  }

  Future<KonsumsiRokokState> _ambilSemua() async {
    try {
      final op = const SqfliteOp();
      final rows = await op.ambilSemua(
        NamaTabel.konsumsiRokok,
        orderBy: '${NamaKolom.tanggal} DESC, ${NamaKolom.dibuat} DESC',
      );
      final daftar = rows.map(KonsumsiRokokModel.fromSqflite).toList();
      final ringkasan = KonsumsiHitungHelper.ringkasanHarian(daftar);
      final total = KonsumsiHitungHelper.totalKonsumsi(daftar);
      L.i('daftar.length=${daftar.length}, total=$total');
      return KonsumsiRokokState(
        listKonsumsi: daftar,
        jumlahTotal: total,
        ringkasanHarian: ringkasan,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data konsumsi rokok: $e $s');
      rethrow;
    }
  }

  /// Catat satu batang rokok pada hari ini (quick log, tanpa form).
  /// Mengembalikan model entri yang baru dibuat untuk keperluan undo.
  Future<KonsumsiRokokModel> catatCepat({bool isSlip = false, String? catatan}) async {
    final sekarang = DateTime.now().toUtc();
    final model = KonsumsiRokokModel(
      id: const Uuid().v4(),
      tanggal: sekarang,
      jumlah: 1,
      isSlip: isSlip,
      catatan: catatan,
      dibuat: DateTime.now().toUtc(),
    );
    L.i('catatCepat jumlah=1, isSlip=$isSlip');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.konsumsiRokok,
        model.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final baru = [model, ...dataLama.listKonsumsi];
      state = AsyncValue.data(
        KonsumsiRokokState(
          listKonsumsi: baru,
          jumlahTotal: dataLama.jumlahTotal + 1,
          ringkasanHarian: KonsumsiHitungHelper.ringkasanHarian(baru),
        ),
      );
      L.s('Konsumsi cepat berhasil dicatat');
      return model;
    } on Exception catch (e, s) {
      L.e('Gagal catat cepat konsumsi: $e $s');
      rethrow;
    }
  }

  Future<void> tambah(KonsumsiRokokModel konsumsi) async {
    L.i('konsumsi=$konsumsi');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.konsumsiRokok,
        konsumsi.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final baru = [konsumsi, ...dataLama.listKonsumsi];
      state = AsyncValue.data(
        KonsumsiRokokState(
          listKonsumsi: baru,
          jumlahTotal: dataLama.jumlahTotal + konsumsi.jumlah,
          ringkasanHarian: KonsumsiHitungHelper.ringkasanHarian(baru),
        ),
      );
      L.s('Konsumsi berhasil disimpan');
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan konsumsi: $e $s');
      rethrow;
    }
  }

  Future<void> ubah(KonsumsiRokokModel konsumsi) async {
    L.i('konsumsi=$konsumsi');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.ubah(
        NamaTabel.konsumsiRokok,
        konsumsi.toSqflite(),
        where: '${NamaKolom.id} = ?',
        whereArgs: [konsumsi.id],
      );
      final baru = dataLama.listKonsumsi
          .map((e) => e.id == konsumsi.id ? konsumsi : e)
          .toList();
      state = AsyncValue.data(
        KonsumsiRokokState(
          listKonsumsi: baru,
          jumlahTotal: KonsumsiHitungHelper.totalKonsumsi(baru),
          ringkasanHarian: KonsumsiHitungHelper.ringkasanHarian(baru),
        ),
      );
      L.s('Konsumsi berhasil diubah');
    } on Exception catch (e, s) {
      L.e('Gagal mengubah konsumsi: $e $s');
      rethrow;
    }
  }

  Future<void> hapus(String id) async {
    L.i('id=$id');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.hapus(
        NamaTabel.konsumsiRokok,
        where: '${NamaKolom.id} = ?',
        whereArgs: [id],
      );
      final baru = dataLama.listKonsumsi.where((e) => e.id != id).toList();
      state = AsyncValue.data(
        KonsumsiRokokState(
          listKonsumsi: baru,
          jumlahTotal: KonsumsiHitungHelper.totalKonsumsi(baru),
          ringkasanHarian: KonsumsiHitungHelper.ringkasanHarian(baru),
        ),
      );
      L.s('Konsumsi berhasil dihapus');
    } on Exception catch (e, s) {
      L.e('Gagal menghapus konsumsi: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/screens/daftar_entri_konsumsi_sheet.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/screens/form_konsumsi_rokok.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Bottom sheet daftar entri konsumsi untuk tanggal tertentu.
/// Mendukung edit (ketuk entri) dan hapus dengan undo (U3, U4, U2).
class DaftarEntriKonsumsiSheet extends ConsumerStatefulWidget {
  const DaftarEntriKonsumsiSheet({
    super.key,
    required this.tanggal,
    required this.entriHari,
  });

  final DateTime tanggal;
  final List<KonsumsiRokokModel> entriHari;

  @override
  ConsumerState<DaftarEntriKonsumsiSheet> createState() =>
      _DaftarEntriKonsumsiSheetState();
}

class _DaftarEntriKonsumsiSheetState
    extends ConsumerState<DaftarEntriKonsumsiSheet> {
  late List<KonsumsiRokokModel> _entri;

  @override
  void initState() {
    super.initState();
    _entri = List.from(widget.entriHari);
    // Urutkan: terbaru di atas (berdasarkan dibuat desc)
    _entri.sort((a, b) => b.dibuat.compareTo(a.dibuat));
  }

  String _formatJam(DateTime dt) {
    final lokal = dt.toLocal();
    return '${lokal.hour.toString().padLeft(2, '0')}:${lokal.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _editEntri(KonsumsiRokokModel entri) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FormKonsumsiRokok(konsumsi: entri),
    );
    if (result == true && mounted) {
      // Form mengembalikan true saat berhasil simpan
      await _refreshDariDb();
    }
  }

  Future<void> _hapusEntri(KonsumsiRokokModel entri) async {
    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Catatan',
      message:
          'Metrik uang dihemat, rokok tidak dihisap, dan target tapering akan ikut menyesuaikan. Lanjutkan hapus?',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    if (konfirmasi != OkCancelResult.ok) {
      L.w('konfirmasi hapus bukan ok');
      return;
    }
    if (!mounted) return;

    // Simpan salinan untuk undo (U2)
    final salinan = entri;
    try {
      await ref.read(konsumsiRokokProvider.notifier).hapus(salinan.id);
      if (!mounted) return;
      await _refreshDariDb();

      // Tampilkan Snackbar undo (U2)
      _tampilkanUndoHapus(salinan);
    } on Exception catch (e, s) {
      L.e('Gagal hapus entri: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menghapus catatan');
      }
    }
  }

  void _tampilkanUndoHapus(KonsumsiRokokModel entri) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Catatan dihapus'),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () => unawaited(
            ref
                .read(konsumsiRokokProvider.notifier)
                .tambah(entri)
                .catchError((Object e, StackTrace s) {
              L.e('Gagal undo hapus: $e $s');
              if (context.mounted) {
                AppToast.gagal(context, 'Gagal membatalkan hapus');
              }
            }),
          ),
        ),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  Future<void> _refreshDariDb() async {
    try {
      final state = await ref.read(konsumsiRokokProvider.future);
      final entriBaru = state.listKonsumsi.where((e) {
        final lokal = e.tanggal.toLocal();
        final key =
            '${lokal.year}-${lokal.month.toString().padLeft(2, '0')}-${lokal.day.toString().padLeft(2, '0')}';
        final keyWidget =
            '${widget.tanggal.year}-${widget.tanggal.month.toString().padLeft(2, '0')}-${widget.tanggal.day.toString().padLeft(2, '0')}';
        return key == keyWidget;
      }).toList();
      if (mounted) {
        setState(() {
          _entri = entriBaru;
          _entri.sort((a, b) => b.dibuat.compareTo(a.dibuat));
        });
      }
    } on Exception catch (e, s) {
      L.e('Gagal refresh entri: $e $s');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tanggalStr = FormatTanggal.formatDasar(widget.tanggal);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Text(
              'Catatan $tanggalStr',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (_entri.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Tidak ada catatan untuk tanggal ini',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _entri.length,
                  itemBuilder: (context, index) {
                    final entri = _entri[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            '${entri.jumlah}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        title: Text(
                          '${entri.jumlah} batang${entri.isSlip ? ' • SLIP' : ''}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        subtitle: Text(
                          '${_formatJam(entri.dibuat)}${entri.catatan != null ? ' — ${entri.catatan}' : ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () => _editEntri(entri),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: Icon(
                                CupertinoIcons.trash,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              onPressed: () => _hapusEntri(entri),
                              tooltip: 'Hapus',
                            ),
                          ],
                        ),
                        onTap: () => _editEntri(entri),
                      ),
                    );
                  },
                ),
              ),
            FilledButton(
              onPressed: () => Nav.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/screens/form_konsumsi_rokok.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/diary_craving/enum/pemicu_enum.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:uuid/uuid.dart';

/// Bottom sheet form untuk koreksi atau pencatatan konsumsi rokok harian.
class FormKonsumsiRokok extends ConsumerStatefulWidget {
  final KonsumsiRokokModel? konsumsi;
  const FormKonsumsiRokok({super.key, this.konsumsi});

  @override
  ConsumerState<FormKonsumsiRokok> createState() => _FormKonsumsiRokokState();
}

class _FormKonsumsiRokokState extends ConsumerState<FormKonsumsiRokok> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();

  DateTime _tanggal = DateTime.now();
  bool _isSlip = false;
  PemicuEnum? _pemicu;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final konsumsi = widget.konsumsi;
    L.i('konsumsi=$konsumsi');
    if (konsumsi != null) {
      _tanggal = konsumsi.tanggal;
      _isSlip = konsumsi.isSlip;
      _jumlahController.text = konsumsi.jumlah.toString();
      _catatanController.text = konsumsi.catatan ?? '';
      _pemicu = konsumsi.pemicu;
    }
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    L.i('picked=$picked');
    if (picked != null && mounted) {
      setState(() {
        _tanggal = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _tanggal.hour,
          _tanggal.minute,
        );
      });
      L.i('_tanggal=$_tanggal');
    }
  }

  int _jumlahDariController(String teks) {
    final bersih = teks.replaceAll(RegExp(r'[^0-9\-]'), '');
    return int.tryParse(bersih) ?? 0;
  }

  Future<void> _simpan() async {
    if (_isLoading) {
      L.w('Form konsumsi masih loading, simpan diabaikan');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      L.w('validasi form gagal');
      return;
    }

    final jumlah = _jumlahDariController(_jumlahController.text);
    if (jumlah < 0) {
      L.w('jumlah negatif: $jumlah');
      return;
    }

    // U5: Konfirmasi khusus saat jumlah berubah (edit entri existing)
    if (widget.konsumsi != null && jumlah != widget.konsumsi!.jumlah) {
      final konfirmasi = await showOkCancelAlertDialog(
        context: context,
        title: 'Ubah Jumlah',
        message: 'Metrik uang dihemat, rokok tidak dihisap, dan target tapering akan ikut menyesuaikan. Lanjutkan simpan?',
        okLabel: 'Simpan',
        cancelLabel: 'Batal',
      );
      L.i('konfirmasi ubah jumlah=$konfirmasi');
      if (konfirmasi != OkCancelResult.ok) {
        L.w('konfirmasi ubah jumlah bukan ok');
        return;
      }
      if (!mounted) return;
    } else {
      // Konfirmasi generik untuk entri baru atau perubahan non-jumlah
      final konfirmasi = await showOkCancelAlertDialog(
        context: context,
        title: 'Simpan Konsumsi',
        message: 'Apakah Anda yakin ingin menyimpan catatan konsumsi ini?',
        okLabel: 'Simpan',
        cancelLabel: 'Batal',
      );
      L.i('konfirmasi=$konfirmasi');
      if (konfirmasi != OkCancelResult.ok) {
        L.w('konfirmasi bukan ok');
        return;
      }
      if (!mounted) return;
    }

    setState(() => _isLoading = true);
    unawaited(
      EasyLoading.show(
        status: 'Menyimpan...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((e, s) => L.e('Gagal menampilkan loading: $e $s')),
    );
    try {
      final model = KonsumsiRokokModel(
        id: widget.konsumsi?.id ?? const Uuid().v4(),
        tanggal: _tanggal,
        jumlah: jumlah,
        isSlip: _isSlip,
        catatan: _catatanController.text.trim().isEmpty
            ? null
            : _catatanController.text.trim(),
        pemicu: _pemicu,
        dibuat: widget.konsumsi?.dibuat ?? DateTime.now(),
      );
      L.i('model=$model');
      if (widget.konsumsi == null) {
        await ref.read(konsumsiRokokProvider.notifier).tambah(model);
      } else {
        await ref.read(konsumsiRokokProvider.notifier).ubah(model);
      }
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Nav.pop(context, true); // Kembalikan true untuk menandakan sukses
      }
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan konsumsi: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menyimpan konsumsi');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError(
          (e, s) => L.e('Gagal menutup loading: $e $s'),
        ),
      );
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.konsumsi == null ? 'Catat Konsumsi' : 'Ubah Konsumsi',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                InputAngka(
                  controller: _jumlahController,
                  label: 'Jumlah Batang',
                  hintText: 'Masukkan jumlah batang',
                  wajib: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Jumlah wajib diisi';
                    }
                    final n = _jumlahDariController(value);
                    if (n < 0) {
                      return 'Jumlah tidak boleh negatif';
                    }
                    return null;
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Tanggal'),
                  subtitle: Text(FormatWaktuLengkap.formatSingkat(_tanggal)),
                  trailing: TextButton(
                    onPressed: _pilihTanggal,
                    child: const Text('Pilih'),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Ini slip/relapse?'),
                  subtitle: const Text(
                    'Tandai jika ini adalah relapse (slip). Streak smoke-free akan direset dari tanggal slip.',
                  ),
                  value: _isSlip,
                  onChanged: (value) {
                    setState(() => _isSlip = value);
                    L.i('_isSlip=$_isSlip');
                  },
                ),
                DropdownButtonFormField<PemicuEnum>(
                  decoration: const InputDecoration(
                    labelText: 'Pemicu',
                    hintText: 'Pilih pemicu (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  // initialValue dipakai menggantikan `value` yang deprecated sejak Flutter 3.33 agar `flutter analyze` bersih.
                  initialValue: _pemicu,
                  items: PemicuEnum.values.map((pemicu) {
                    return DropdownMenuItem<PemicuEnum>(
                      value: pemicu,
                      child: Row(
                        children: [
                          Icon(pemicu.icon, size: 20),
                          const SizedBox(width: 8),
                          Text(pemicu.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _pemicu = value);
                    L.i('_pemicu=$value');
                  },
                ),
                InputTeks(
                  controller: _catatanController,
                  label: 'Catatan',
                  hintText: 'Catatan tambahan (opsional)',
                  wajib: false,
                  minLines: 2,
                  maxLines: 4,
                ),
                FilledButton(onPressed: _simpan, child: const Text('Simpan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/screens/konsumsi_rokok_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/puncak_konsumsi_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/screens/daftar_entri_konsumsi_sheet.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/state/konsumsi_rokok_state.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Layar daftar riwayat konsumsi rokok harian dengan FAB quick log (+1).
class KonsumsiRokokScreen extends ConsumerStatefulWidget {
  const KonsumsiRokokScreen({super.key});

  @override
  ConsumerState<KonsumsiRokokScreen> createState() =>
      _KonsumsiRokokScreenState();
}

class _KonsumsiRokokScreenState extends ConsumerState<KonsumsiRokokScreen> {
  void _catatCepat() {
    unawaited(
      ref
          .read(konsumsiRokokProvider.notifier)
          .catatCepat()
          .then((entri) {
            if (!mounted) return;
            // Tampilkan Snackbar dengan aksi "Urungkan" (U1)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Rokok dicatat (+1)'),
                action: SnackBarAction(
                  label: 'Urungkan',
                  onPressed: () => unawaited(
                    ref
                        .read(konsumsiRokokProvider.notifier)
                        .hapus(entri.id)
                        .catchError((Object e, StackTrace s) {
                      L.e('Gagal undo quick log: $e $s');
                      if (context.mounted) {
                        AppToast.gagal(context, 'Gagal membatalkan catatan');
                      }
                    }),
                  ),
                ),
                duration: const Duration(seconds: 10),
              ),
            );
          })
          .catchError((Object e, StackTrace s) {
            L.e('Gagal catat cepat konsumsi: $e $s');
            if (mounted) {
              AppToast.gagal(context, 'Gagal mencatat rokok');
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final konsumsiAsync = ref.watch(konsumsiRokokProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Konsumsi Rokok')),
      body: konsumsiAsync.when(
        data: (state) {
          if (state.listKonsumsi.isEmpty) {
            return EmptyStateView(
              ikon: CupertinoIcons.smoke,
              judul: 'Belum ada catatan konsumsi',
              deskripsi:
                  'Catat setiap batang rokok agar metrik berhenti '
                  'merokok akurat.',
              ctaLabel: 'Catat Rokok (+1)',
              onCta: _catatCepat,
            );
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        PuncakKonsumsiHelper.ringkasanTeks(state.listKonsumsi),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  _DaftarKonsumsi(state: state),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) {
          L.e('KonsumsiRokokScreen error: $e $s');
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    const Text('Gagal memuat data konsumsi'),
                    OutlinedButton(
                      onPressed: () {
                        final _ = ref.refresh(konsumsiRokokProvider);
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _catatCepat,
        child: const Icon(CupertinoIcons.add),
        tooltip: 'Catat Rokok (+1)',
      ),
    );
  }
}

/// Widget terisolasi yang menampilkan daftar kartu konsumsi per tanggal.
class _DaftarKonsumsi extends StatelessWidget {
  const _DaftarKonsumsi({required this.state});

  final KonsumsiRokokState state;

  @override
  Widget build(BuildContext context) {
    final ringkasan = state.ringkasanHarian;
    final tanggalUrut = ringkasan.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: tanggalUrut.length,
      itemBuilder: (context, index) {
        final tanggalKey = tanggalUrut[index];
        final total = ringkasan[tanggalKey] ?? 0;
        final entriHari = state.listKonsumsi.where((e) {
          final lokal = e.tanggal.toLocal();
          final key =
              '${lokal.year}-${lokal.month.toString().padLeft(2, '0')}-${lokal.day.toString().padLeft(2, '0')}';
          return key == tanggalKey;
        }).toList();
        final adaSlip = entriHari.any((e) => e.isSlip);
        final tanggalContoh = entriHari.isNotEmpty
            ? entriHari.first.tanggal
            : null;

        // Parse tanggalKey untuk dibawa ke bottom sheet
        final parts = tanggalKey.split('-');
        final tanggalWidget = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );

        return Card(
          key: ValueKey(tanggalKey),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                tanggalContoh != null ? '${tanggalContoh.day}' : '?',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            title: Text(
              tanggalContoh != null
                  ? FormatTanggal.formatSingkat(tanggalContoh)
                  : tanggalKey,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '$total batang${adaSlip ? '  •  SLIP' : ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: adaSlip
                        ? const Color(0xFFEF5350)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: adaSlip ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            trailing: adaSlip
                ? const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFEF5350),
                  )
                : const Icon(CupertinoIcons.chevron_right),
            onTap: () => unawaited(
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => DaftarEntriKonsumsiSheet(
                  tanggal: tanggalWidget,
                  entriHari: entriHari,
                ),
              ).catchError((Object e, StackTrace s) {
                L.e('Gagal membuka daftar entri konsumsi: $e $s');
                return null;
              }),
            ),
          ),
        );
      },
    );
  }
}


```


// ============================================================
// FILE: lib/fitur/konsumsi_rokok/state/konsumsi_rokok_state.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/konsumsi_rokok/model/konsumsi_rokok_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'konsumsi_rokok_state.freezed.dart';

@freezed
abstract class KonsumsiRokokState with _$KonsumsiRokokState {
  const KonsumsiRokokState._();

  const factory KonsumsiRokokState({
    @Default([]) List<KonsumsiRokokModel> listKonsumsi,
    @Default(0) int jumlahTotal,
    @Default({}) Map<String, int> ringkasanHarian,
  }) = _KonsumsiRokokState;
}
```


// ============================================================
// FILE: lib/fitur/pemulihan_kesehatan/helper/progres_milestone_helper.dart
// ============================================================

```dart
/// Helper murni untuk perhitungan progres milestone pemulihan kesehatan.
///
/// Tidak bergantung pada [BuildContext] atau provider. Digunakan oleh layar
/// Pemulihan Kesehatan untuk menampilkan progres per milestone.
class ProgresMilestoneHelper {
  const ProgresMilestoneHelper._();

  /// Mengembalikan rasio progres durasi smoke-free terhadap [target] milestone.
  ///
  /// Nilai diklem ke rentang 0.0–1.0. Jika [target] bernilai nol detik atau
  /// lebih kecil, mengembalikan 1.0 (milestone dianggap tercapai). Durasi
  /// negatif diperlakukan sebagai nol.
  static double rasio(Duration durasi, Duration target) {
    if (target.inSeconds <= 0) return 1.0;
    final detikDurasi = durasi.isNegative ? 0 : durasi.inSeconds;
    final nilai = detikDurasi / target.inSeconds;
    return nilai.clamp(0.0, 1.0);
  }

  /// Mengembalikan persentase progres (0–100) yang dibulatkan ke bilangan bulat.
  static int persentase(Duration durasi, Duration target) {
    return (rasio(durasi, target) * 100).round().clamp(0, 100);
  }

  /// Mengembalikan `true` jika [durasi] sudah mencapai atau melampaui [target].
  static bool tercapai(Duration durasi, Duration target) {
    if (target.inSeconds <= 0) return true;
    final aman = durasi.isNegative ? Duration.zero : durasi;
    return aman >= target;
  }

  /// Mengembalikan sisa durasi menuju [target].
  ///
  /// Jika sudah tercapai atau sisa negatif, mengembalikan [Duration.zero].
  static Duration sisaWaktu(Duration durasi, Duration target) {
    final aman = durasi.isNegative ? Duration.zero : durasi;
    final sisa = target - aman;
    return sisa.isNegative ? Duration.zero : sisa;
  }
}
```


// ============================================================
// FILE: lib/fitur/pemulihan_kesehatan/helper/progres_organ_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/helper/progres_milestone_helper.dart';
import 'package:berhenti_merokok/shared/konstanta/milestone_kesehatan.dart';
import 'package:berhenti_merokok/shared/konstanta/organ_pemulihan.dart';

/// Helper murni untuk agregasi status pemulihan per organ.
///
/// Tidak bergantung pada [BuildContext] atau provider. Digunakan oleh layar
/// Pemulihan Kesehatan dan halaman detail organ untuk menampilkan ringkasan
/// per organ berdasarkan durasi smoke-free.
class ProgresOrganHelper {
  const ProgresOrganHelper._();

  /// Mengembalikan seluruh milestone milik [organ], urut kronologis.
  static List<MilestoneKesehatan> milestoneOrgan(OrganPemulihan organ) {
    return daftarMilestoneKesehatan.where((m) => m.organ == organ).toList();
  }

  /// Mengembalikan rasio pemulihan organ (0.0–1.0) berdasarkan milestone
  /// terakhir organ tersebut. Durasi negatif diperlakukan sebagai nol.
  static double rasioOrgan(Duration durasi, OrganPemulihan organ) {
    final list = milestoneOrgan(organ);
    if (list.isEmpty) return 0.0;
    final aman = durasi.isNegative ? Duration.zero : durasi;
    return ProgresMilestoneHelper.rasio(aman, list.last.target);
  }

  /// Mengembalikan persentase pemulihan organ (0–100) dibulatkan.
  static int persentaseOrgan(Duration durasi, OrganPemulihan organ) {
    return (rasioOrgan(durasi, organ) * 100).round().clamp(0, 100);
  }

  /// Mengembalikan `true` jika seluruh milestone [organ] tercapai.
  static bool organSelesai(Duration durasi, OrganPemulihan organ) {
    final list = milestoneOrgan(organ);
    if (list.isEmpty) return false;
    final aman = durasi.isNegative ? Duration.zero : durasi;
    return list.every((m) => aman >= m.target);
  }

  /// Mengembalikan milestone [organ] pertama yang belum tercapai, atau null
  /// jika seluruhnya sudah tercapai.
  static MilestoneKesehatan? milestoneBerikutnyaOrgan(
    Duration durasi,
    OrganPemulihan organ,
  ) {
    final aman = durasi.isNegative ? Duration.zero : durasi;
    for (final m in milestoneOrgan(organ)) {
      if (aman < m.target) return m;
    }
    return null;
  }

  /// Mengembalikan ringkasan status organ:
  /// `"Selesai"`, `"Berjalan"`, atau `"Belum dimulai"`.
  static String ringkasanStatus(Duration durasi, OrganPemulihan organ) {
    if (organSelesai(durasi, organ)) return 'Selesai';
    final list = milestoneOrgan(organ);
    if (list.isEmpty) return 'Belum dimulai';
    final aman = durasi.isNegative ? Duration.zero : durasi;
    if (aman < list.first.target) return 'Belum dimulai';
    return 'Berjalan';
  }

  /// Mengembalikan format durasi lengkap (mis. `2 hari 4 jam 30 menit`).
  static String formatDurasi(Duration d) {
    if (d.inDays > 0) {
      final hari = d.inDays;
      final jam = d.inHours % 24;
      final menit = d.inMinutes % 60;
      final bagian = <String>['$hari hari'];
      if (jam > 0) bagian.add('$jam jam');
      if (menit > 0) bagian.add('$menit menit');
      return bagian.join(' ');
    }
    if (d.inHours > 0) {
      final jam = d.inHours;
      final menit = d.inMinutes % 60;
      final detik = d.inSeconds % 60;
      final bagian = <String>['$jam jam'];
      if (menit > 0) bagian.add('$menit menit');
      bagian.add('$detik detik');
      return bagian.join(' ');
    }
    final menit = d.inMinutes;
    final detik = d.inSeconds % 60;
    if (menit > 0) return '$menit menit $detik detik';
    return '$detik detik';
  }

  /// Mengembalikan format singkat durasi target milestone (mis. `1 minggu`,
  /// `3 bulan`, `1 tahun`).
  static String formatTarget(Duration d) {
    if (d.inDays >= 365) {
      final tahun = (d.inDays / 365).round();
      if (tahun == 1) return '1 tahun';
      return '$tahun tahun';
    }
    if (d.inDays >= 30) {
      final bulan = (d.inDays / 30).round();
      if (bulan == 1) return '1 bulan';
      return '$bulan bulan';
    }
    if (d.inDays >= 7) {
      final minggu = (d.inDays / 7).round();
      if (minggu == 1) return '1 minggu';
      return '$minggu minggu';
    }
    if (d.inDays >= 1) {
      if (d.inDays == 1) return '1 hari';
      return '${d.inDays} hari';
    }
    if (d.inHours >= 1) {
      if (d.inHours == 1) return '1 jam';
      return '${d.inHours} jam';
    }
    return '${d.inMinutes} menit';
  }
}
```


// ============================================================
// FILE: lib/fitur/pemulihan_kesehatan/screens/detail_organ_pemulihan_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/screens/form_biodata.dart';
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/helper/progres_milestone_helper.dart';
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/helper/progres_organ_helper.dart';
import 'package:berhenti_merokok/shared/konstanta/organ_pemulihan.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Halaman detail pemulihan kesehatan untuk satu sistem organ.
///
/// Menampilkan nama organ, persentase pemulihan, milestone berikutnya beserta
/// sisa waktu, lalu seluruh milestone milik organ tersebut dengan status
/// tercapai/belum.
class DetailOrganPemulihanScreen extends ConsumerWidget {
  const DetailOrganPemulihanScreen({required this.organ, super.key});

  final OrganPemulihan organ;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodataAsync = ref.watch(biodataProvider);
    final textTheme = Theme.of(context).textTheme;
    final judul = 'Pemulihan ${organ.label}';

    if (biodataAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(judul)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (biodataAsync.hasError) {
      L.e(
        'biodataAsync error: ${biodataAsync.error} ${biodataAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: Text(judul)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(biodataProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final biodata = biodataAsync.requireValue;
    if (biodata == null) {
      return Scaffold(
        appBar: AppBar(title: Text(judul)),
        body: EmptyStateView(
          ikon: CupertinoIcons.person,
          judul: 'Belum ada data biodata',
          deskripsi:
              'Detail pemulihan per organ membutuhkan biodata untuk '
              'menghitung progres.',
          ctaLabel: 'Isi Biodata',
          onCta: () => _bukaFormBiodata(context),
        ),
      );
    }

    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    if (tanggalBerhenti == null) {
      return Scaffold(
        appBar: AppBar(title: Text(judul)),
        body: EmptyStateView(
          ikon: CupertinoIcons.heart,
          judul: 'Belum ada tanggal mulai berhenti',
          deskripsi:
              'Isi tanggal mulai berhenti pada biodata untuk melihat '
              'detail pemulihan organ.',
          ctaLabel: 'Isi Biodata',
          onCta: () => _bukaFormBiodata(context),
        ),
      );
    }

    final durasiKotor = DateTime.now().difference(tanggalBerhenti);
    final durasi = durasiKotor.isNegative ? Duration.zero : durasiKotor;
    final persen = ProgresOrganHelper.persentaseOrgan(durasi, organ);
    final selesai = ProgresOrganHelper.organSelesai(durasi, organ);
    final berikutnya = ProgresOrganHelper.milestoneBerikutnyaOrgan(
      durasi,
      organ,
    );
    final daftar = ProgresOrganHelper.milestoneOrgan(organ);

    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  Icon(
                    organ.icon,
                    size: 40,
                    color: selesai ? Colors.green : null,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          organ.label,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Pemulihan $persen%',
                          style: textTheme.bodyMedium?.copyWith(
                            color: selesai ? Colors.green : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: persen / 100,
                minHeight: 8,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                color: selesai ? Colors.green : null,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      if (berikutnya != null) ...[
                        Text(
                          'Milestone berikutnya: ${berikutnya.judul}',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Tersisa '
                          '${ProgresOrganHelper.formatDurasi(ProgresMilestoneHelper.sisaWaktu(durasi, berikutnya.target))}',
                          style: textTheme.bodySmall,
                        ),
                      ] else
                        Text(
                          'Semua milestone organ tercapai. Selamat!',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: daftar.length,
                  itemBuilder: (context, index) {
                    final m = daftar[index];
                    final tercapai = ProgresMilestoneHelper.tercapai(
                      durasi,
                      m.target,
                    );
                    final rasio = ProgresMilestoneHelper.rasio(
                      durasi,
                      m.target,
                    );
                    final persenItem = ProgresMilestoneHelper.persentase(
                      durasi,
                      m.target,
                    );
                    final sisa = ProgresMilestoneHelper.sisaWaktu(
                      durasi,
                      m.target,
                    );
                    final labelProgres = tercapai
                        ? 'Tercapai · 100%'
                        : '$persenItem% · Tersisa ${ProgresOrganHelper.formatDurasi(sisa)}';
                    return Card(
                      key: ValueKey(m.judul),
                      child: ListTile(
                        isThreeLine: true,
                        leading: Icon(
                          tercapai
                              ? CupertinoIcons.check_mark_circled_solid
                              : CupertinoIcons.clock,
                          color: tercapai ? Colors.green : null,
                        ),
                        title: Text(
                          m.judul,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: tercapai ? Colors.green : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(m.deskripsi),
                            Text(
                              'Target: ${ProgresOrganHelper.formatTarget(m.target)}',
                              style: textTheme.bodySmall,
                            ),
                            LinearProgressIndicator(
                              value: rasio,
                              minHeight: 6,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              color: tercapai ? Colors.green : null,
                            ),
                            Text(
                              labelProgres,
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: tercapai ? Colors.green : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _bukaFormBiodata(BuildContext context) {
    unawaited(
      Nav.to(context, const FormBiodata(buatPertama: false)).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Form Biodata: $e $s');
        return null;
      }),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/pemulihan_kesehatan/screens/pemulihan_kesehatan_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/screens/form_biodata.dart';
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/helper/progres_milestone_helper.dart';
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/helper/progres_organ_helper.dart';
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/screens/detail_organ_pemulihan_screen.dart';
import 'package:berhenti_merokok/shared/konstanta/milestone_kesehatan.dart';
import 'package:berhenti_merokok/shared/konstanta/organ_pemulihan.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Halaman pemulihan kesehatan (milestone) berdasarkan durasi smoke-free.
///
/// Menampilkan daftar milestone kesehatan yang dicapai seiring waktu tanpa
/// rokok, beserta status tercapai/belum.
class PemulihanKesehatanScreen extends ConsumerStatefulWidget {
  const PemulihanKesehatanScreen({super.key});

  @override
  ConsumerState<PemulihanKesehatanScreen> createState() =>
      _PemulihanKesehatanScreenState();
}

class _PemulihanKesehatanScreenState
    extends ConsumerState<PemulihanKesehatanScreen> {
  @override
  void initState() {
    super.initState();
    L.i('PemulihanKesehatanScreen initState');
  }

  @override
  void dispose() {
    L.i('PemulihanKesehatanScreen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(biodataProvider);

    if (biodataAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (biodataAsync.hasError) {
      L.e(
        'biodataAsync error: ${biodataAsync.error} ${biodataAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Pemulihan Kesehatan')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const Text('Gagal memuat data'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(biodataProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final biodata = biodataAsync.requireValue;
    if (biodata == null) {
      return _buildBiodataNull();
    }

    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    if (tanggalBerhenti == null) {
      return _buildBelumBerhenti();
    }

    final durasiKotor = DateTime.now().difference(tanggalBerhenti);
    final durasi = durasiKotor.isNegative ? Duration.zero : durasiKotor;

    return Scaffold(
      appBar: AppBar(title: const Text('Pemulihan Kesehatan')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderPemulihan(tanggalBerhenti: tanggalBerhenti),
              _buildRingkasanOrgan(context, durasi),
              Expanded(
                child: ListView.separated(
                  itemCount: daftarMilestoneKesehatan.length,
                  itemBuilder: (context, index) {
                    final m = daftarMilestoneKesehatan[index];
                    final durasi = DateTime.now().difference(tanggalBerhenti);
                    final aman = durasi.isNegative ? Duration.zero : durasi;
                    final tercapai = ProgresMilestoneHelper.tercapai(
                      aman,
                      m.target,
                    );
                    final rasio = ProgresMilestoneHelper.rasio(aman, m.target);
                    final persen = ProgresMilestoneHelper.persentase(
                      aman,
                      m.target,
                    );
                    final sisa = ProgresMilestoneHelper.sisaWaktu(
                      aman,
                      m.target,
                    );
                    final labelProgres = tercapai
                        ? 'Tercapai · 100%'
                        : '$persen% · Tersisa ${ProgresOrganHelper.formatDurasi(sisa)}';
                    return Card(
                      key: ValueKey(m.judul),
                      child: ListTile(
                        isThreeLine: true,
                        leading: Icon(
                          tercapai
                              ? CupertinoIcons.check_mark_circled_solid
                              : CupertinoIcons.clock,
                          color: tercapai ? Colors.green : null,
                        ),
                        title: Text(
                          m.judul,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: tercapai ? Colors.green : null,
                              ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(m.deskripsi),
                            Text(
                              'Target: ${ProgresOrganHelper.formatTarget(m.target)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            LinearProgressIndicator(
                              value: rasio,
                              minHeight: 6,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              color: tercapai ? Colors.green : null,
                            ),
                            Text(
                              labelProgres,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: tercapai ? Colors.green : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ),
              Text(
                'Ilustrasi umum, bukan kondisi medis Anda.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRingkasanOrgan(BuildContext context, Duration durasi) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: OrganPemulihan.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final organ = OrganPemulihan.values[index];
          final persen = ProgresOrganHelper.persentaseOrgan(durasi, organ);
          final selesai = ProgresOrganHelper.organSelesai(durasi, organ);
          return SizedBox(
            width: 140,
            child: Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _bukaDetailOrgan(context, organ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Icon(organ.icon, color: selesai ? Colors.green : null),
                      Text(organ.label, style: textTheme.titleSmall),
                      Text(
                        ProgresOrganHelper.ringkasanStatus(durasi, organ),
                        style: textTheme.bodySmall,
                      ),
                      LinearProgressIndicator(
                        value: persen / 100,
                        minHeight: 6,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        color: selesai ? Colors.green : null,
                      ),
                      Text('$persen%', style: textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _bukaDetailOrgan(BuildContext context, OrganPemulihan organ) {
    unawaited(
      Nav.to(context, DetailOrganPemulihanScreen(organ: organ)).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal membuka detail organ $organ: $e $s');
        return null;
      }),
    );
  }

  Widget _buildBiodataNull() {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemulihan Kesehatan')),
      body: EmptyStateView(
        ikon: CupertinoIcons.person,
        judul: 'Belum ada data biodata',
        deskripsi:
            'Pemulihan kesehatan membutuhkan biodata untuk menghitung '
            'milestone berdasarkan kebiasaan merokokmu.',
        ctaLabel: 'Isi Biodata',
        onCta: _bukaFormBiodata,
      ),
    );
  }

  Widget _buildBelumBerhenti() {
    return Scaffold(
      appBar: AppBar(title: const Text('Pemulihan Kesehatan')),
      body: EmptyStateView(
        ikon: CupertinoIcons.heart,
        judul: 'Belum ada tanggal mulai berhenti',
        deskripsi:
            'Isi tanggal mulai berhenti pada biodata untuk melihat '
            'pemulihan kesehatan.',
        ctaLabel: 'Isi Biodata',
        onCta: _bukaFormBiodata,
      ),
    );
  }

  void _bukaFormBiodata() {
    unawaited(
      Nav.to(context, const FormBiodata(buatPertama: false)).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Form Biodata: $e $s');
        return null;
      }),
    );
  }
}

/// Widget header yang menampilkan durasi smoke-free dan milestone berikutnya.
///
/// Menggunakan [Timer] sendiri agar hanya widget ini yang rebuild setiap detik,
/// bukan seluruh halaman.
class _HeaderPemulihan extends StatefulWidget {
  const _HeaderPemulihan({required this.tanggalBerhenti});

  final DateTime tanggalBerhenti;

  @override
  State<_HeaderPemulihan> createState() => _HeaderPemulihanState();
}

class _HeaderPemulihanState extends State<_HeaderPemulihan> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    L.i('HeaderPemulihan initState');
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    L.i('HeaderPemulihan dispose');
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durasiSmokeFree = DateTime.now().difference(widget.tanggalBerhenti);
    final durasi = durasiSmokeFree.isNegative ? Duration.zero : durasiSmokeFree;
    final berikutnya = milestoneBerikutnya(durasi);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              'Lama smoke-free',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ProgresOrganHelper.formatDurasi(durasi),
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sejak ${FormatTanggal.formatDasar(widget.tanggalBerhenti)}',
              style: textTheme.bodySmall,
            ),
            if (berikutnya != null) ...[
              const SizedBox(height: 4),
              Text(
                'Milestone berikutnya: ${berikutnya.judul}',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tersisa ${ProgresOrganHelper.formatDurasi(berikutnya.target - durasi)}',
                style: textTheme.bodySmall,
              ),
            ] else
              Text(
                'Semua milestone tercapai. Selamat!',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/pengaturan/screens/pengaturan_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/cadangan/screens/cadangan_screen.dart';
import 'package:berhenti_merokok/fitur/diary_craving/helper/pola_craving_helper.dart';
import 'package:berhenti_merokok/fitur/diary_craving/model/diary_craving_model.dart';
import 'package:berhenti_merokok/fitur/diary_craving/notifier/diary_craving_notifier.dart';
import 'package:berhenti_merokok/fitur/tema/enum/tema_enum.dart';
import 'package:berhenti_merokok/fitur/tema/notifier/tema_notifier.dart';
import 'package:berhenti_merokok/shared/notifikasi/notifikasi_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Halaman pengaturan aplikasi, termasuk pilihan tema dan notifikasi.
class PengaturanScreen extends ConsumerStatefulWidget {
  const PengaturanScreen({super.key});

  @override
  ConsumerState<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends ConsumerState<PengaturanScreen> {
  bool _notifikasiAktif = false;
  int _jam = 8;
  int _menit = 0;
  bool _memuatNotifikasi = true;
  bool _sedangMemproses = false;

  // Check-in pagi.
  bool _checkinPagiAktif = false;
  int _checkinPagiJam = 7;
  int _checkinPagiMenit = 0;

  // Pengingat pola craving.
  bool _polaCravingAktif = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      Future.microtask(_muatPreferensiNotifikasi)
          .catchError((Object e, StackTrace s) {
            L.e('Gagal memuat preferensi notifikasi: $e $s');
          }),
    );
  }

  Future<void> _muatPreferensiNotifikasi() async {
    L.i('PengaturanScreen initState notifikasi');
    try {
      final aktif = await NotifikasiService.aktif();
      final jam = await NotifikasiService.jam();
      final menit = await NotifikasiService.menit();
      final checkinPagiAktif = await NotifikasiService.aktifCheckinPagi();
      final checkinPagiJam = await NotifikasiService.jamCheckinPagi();
      final checkinPagiMenit = await NotifikasiService.menitCheckinPagi();
      final polaCravingAktif = await NotifikasiService.aktifPolaCraving();
      if (!mounted) return;
      setState(() {
        _notifikasiAktif = aktif;
        _jam = jam;
        _menit = menit;
        _checkinPagiAktif = checkinPagiAktif;
        _checkinPagiJam = checkinPagiJam;
        _checkinPagiMenit = checkinPagiMenit;
        _polaCravingAktif = polaCravingAktif;
        _memuatNotifikasi = false;
      });
      L.i(
        'aktif=$aktif, jam=$jam, menit=$menit, checkinPagi=$checkinPagiAktif, polaCraving=$polaCravingAktif',
      );
    } on Exception catch (e, s) {
      L.e('Gagal memuat preferensi notifikasi: $e $s');
      if (mounted) {
        setState(() {
          _memuatNotifikasi = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _ubahTema(TemaEnum tema) async {
    L.i('tema=$tema');
    try {
      await ref.read(temaProvider.notifier).set(tema);
    } on Exception catch (e, s) {
      L.e('Gagal mengubah tema: $e $s');
    }
  }

  Future<void> _ubahNotifikasi(bool value) async {
    if (_sedangMemproses) return;
    L.i('value=$value');
    setState(() {
      _sedangMemproses = true;
      _notifikasiAktif = value;
    });
    unawaited(
      EasyLoading.show(
        status: 'Memproses...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
      }),
    );
    try {
      if (value) {
        final izin = await NotifikasiService.mintaIzin();
        if (!mounted) return;
        if (!izin) {
          setState(() {
            _notifikasiAktif = false;
          });
          AppToast.gagal(context, 'Izin notifikasi tidak diberikan');
          return;
        }
        await NotifikasiService.jadwalkanPengingatHarian(
          jam: _jam,
          menit: _menit,
        );
        if (!mounted) return;
        AppToast.sukses(context, 'Pengingat harian diaktifkan');
      } else {
        await NotifikasiService.batalkanPengingatHarian();
        if (!mounted) return;
        AppToast.info(context, 'Pengingat harian dinonaktifkan');
      }
    } on Exception catch (e, s) {
      L.e('Gagal mengubah notifikasi: $e $s');
      if (mounted) {
        final isIzin = e is IzinNotifikasiTidakDiberikanException;
        try {
          final aktifSekarang = await NotifikasiService.aktif();
          if (!mounted) return;
          setState(() {
            _notifikasiAktif = aktifSekarang;
          });
        } on Exception catch (e2, s2) {
          L.e('Gagal membaca status aktif notifikasi: $e2 $s2');
        }
        if (isIzin) {
          if (mounted) {
            AppToast.gagal(context, 'Izin notifikasi tidak tersedia');
          }
          try {
            await _muatPreferensiNotifikasi();
          } on Exception catch (e2, s2) {
            L.e('Gagal memuat preferensi notifikasi: $e2 $s2');
          }
          if (!mounted) return;
        } else if (mounted) {
          AppToast.gagal(context, 'Gagal mengubah pengingat harian');
        }
      }
    } on UnsupportedError catch (e, s) {
      L.e('Platform tidak mendukung notifikasi: $e $s');
      if (mounted) {
        setState(() {
          _notifikasiAktif = false;
        });
        AppToast.gagal(context, 'Platform tidak mendukung pengingat harian');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  Future<void> _pilihWaktu() async {
    if (_sedangMemproses) return;
    L.i('jam=$_jam, menit=$_menit');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _jam, minute: _menit),
    );
    if (!mounted) return;
    if (picked == null) return;
    L.i('picked=${picked.hour}:${picked.minute}');
    final jamLama = _jam;
    final menitLama = _menit;
    final jamBaru = picked.hour;
    final menitBaru = picked.minute;
    setState(() {
      _sedangMemproses = true;
    });
    unawaited(
      EasyLoading.show(
        status: 'Memproses...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
      }),
    );
    try {
      if (_notifikasiAktif) {
        await NotifikasiService.jadwalkanPengingatHarian(
          jam: jamBaru,
          menit: menitBaru,
        );
        if (!mounted) return;
        setState(() {
          _jam = jamBaru;
          _menit = menitBaru;
        });
        AppToast.sukses(context, 'Waktu pengingat diperbarui');
      } else {
        await NotifikasiService.setWaktu(jamBaru, menitBaru);
        if (!mounted) return;
        setState(() {
          _jam = jamBaru;
          _menit = menitBaru;
        });
      }
    } on Exception catch (e, s) {
      L.e('Gagal memperbarui waktu pengingat: $e $s');
      if (mounted) {
        setState(() {
          _jam = jamLama;
          _menit = menitLama;
        });
        AppToast.gagal(context, 'Gagal memperbarui waktu pengingat');
      }
    } on UnsupportedError catch (e, s) {
      L.e('Platform tidak mendukung notifikasi: $e $s');
      if (mounted) {
        setState(() {
          _jam = jamLama;
          _menit = menitLama;
        });
        AppToast.gagal(context, 'Platform tidak mendukung pengingat harian');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  Future<void> _ubahCheckinPagi(bool value) async {
    if (_sedangMemproses) return;
    L.i('checkinPagi value=$value');
    setState(() {
      _sedangMemproses = true;
      _checkinPagiAktif = value;
    });
    unawaited(
      EasyLoading.show(
        status: 'Memproses...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
      }),
    );
    try {
      if (value) {
        final izin = await NotifikasiService.mintaIzin();
        if (!mounted) return;
        if (!izin) {
          setState(() {
            _checkinPagiAktif = false;
          });
          AppToast.gagal(context, 'Izin notifikasi tidak diberikan');
          return;
        }
        await NotifikasiService.jadwalkanCheckinPagi(
          jam: _checkinPagiJam,
          menit: _checkinPagiMenit,
        );
        if (!mounted) return;
        AppToast.sukses(context, 'Check-in pagi diaktifkan');
      } else {
        await NotifikasiService.batalkanCheckinPagi();
        if (!mounted) return;
        AppToast.info(context, 'Check-in pagi dinonaktifkan');
      }
    } on Exception catch (e, s) {
      L.e('Gagal mengubah check-in pagi: $e $s');
      if (mounted) {
        final isIzin = e is IzinNotifikasiTidakDiberikanException;
        try {
          final aktifSekarang = await NotifikasiService.aktifCheckinPagi();
          if (!mounted) return;
          setState(() {
            _checkinPagiAktif = aktifSekarang;
          });
        } on Exception catch (e2, s2) {
          L.e('Gagal membaca status aktif check-in pagi: $e2 $s2');
        }
        if (isIzin) {
          if (mounted) {
            AppToast.gagal(context, 'Izin notifikasi tidak tersedia');
          }
          try {
            await _muatPreferensiNotifikasi();
          } on Exception catch (e2, s2) {
            L.e('Gagal memuat preferensi notifikasi: $e2 $s2');
          }
          if (!mounted) return;
        } else if (mounted) {
          AppToast.gagal(context, 'Gagal mengubah check-in pagi');
        }
      }
    } on UnsupportedError catch (e, s) {
      L.e('Platform tidak mendukung notifikasi: $e $s');
      if (mounted) {
        setState(() {
          _checkinPagiAktif = false;
        });
        AppToast.gagal(context, 'Platform tidak mendukung check-in pagi');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  Future<void> _pilihWaktuCheckinPagi() async {
    if (_sedangMemproses) return;
    L.i('checkinPagi jam=$_checkinPagiJam, menit=$_checkinPagiMenit');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _checkinPagiJam, minute: _checkinPagiMenit),
    );
    if (!mounted) return;
    if (picked == null) return;
    L.i('picked=${picked.hour}:${picked.minute}');
    final jamLama = _checkinPagiJam;
    final menitLama = _checkinPagiMenit;
    final jamBaru = picked.hour;
    final menitBaru = picked.minute;
    setState(() {
      _sedangMemproses = true;
    });
    unawaited(
      EasyLoading.show(
        status: 'Memproses...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
      }),
    );
    try {
      if (_checkinPagiAktif) {
        await NotifikasiService.jadwalkanCheckinPagi(
          jam: jamBaru,
          menit: menitBaru,
        );
        if (!mounted) return;
        setState(() {
          _checkinPagiJam = jamBaru;
          _checkinPagiMenit = menitBaru;
        });
        AppToast.sukses(context, 'Waktu check-in pagi diperbarui');
      } else {
        await NotifikasiService.setWaktuCheckinPagi(jamBaru, menitBaru);
        if (!mounted) return;
        setState(() {
          _checkinPagiJam = jamBaru;
          _checkinPagiMenit = menitBaru;
        });
      }
    } on Exception catch (e, s) {
      L.e('Gagal memperbarui waktu check-in pagi: $e $s');
      if (mounted) {
        setState(() {
          _checkinPagiJam = jamLama;
          _checkinPagiMenit = menitLama;
        });
        AppToast.gagal(context, 'Gagal memperbarui waktu check-in pagi');
      }
    } on UnsupportedError catch (e, s) {
      L.e('Platform tidak mendukung notifikasi: $e $s');
      if (mounted) {
        setState(() {
          _checkinPagiJam = jamLama;
          _checkinPagiMenit = menitLama;
        });
        AppToast.gagal(context, 'Platform tidak mendukung check-in pagi');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  Future<void> _ubahPolaCraving(bool value) async {
    if (_sedangMemproses) return;
    L.i('polaCraving value=$value');
    setState(() {
      _sedangMemproses = true;
      _polaCravingAktif = value;
    });
    unawaited(
      EasyLoading.show(
        status: 'Memproses...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
      }),
    );
    try {
      if (value) {
        final izin = await NotifikasiService.mintaIzin();
        if (!mounted) return;
        if (!izin) {
          setState(() {
            _polaCravingAktif = false;
          });
          AppToast.gagal(context, 'Izin notifikasi tidak diberikan');
          return;
        }
        // Baca data diary craving untuk menghitung jam teratas.
        final diaryAsync = ref.read(diaryCravingProvider);
        final daftar = diaryAsync.asData?.value.listCraving ?? <DiaryCravingModel>[];
        final jam = PolaCravingHelper.jamTeratas(daftar);
        if (jam == null) {
          // Data belum cukup, simpan preferensi aktif tanpa jadwal.
          await NotifikasiService.setAktifPolaCraving(true);
          if (!mounted) return;
          AppToast.info(context, 'Pengingat pola craving aktif (data craving belum cukup)');
        } else {
          await NotifikasiService.jadwalkanPolaCraving(jam);
          if (!mounted) return;
          AppToast.sukses(context, 'Pengingat pola craving diaktifkan (jam $jam:00)');
        }
      } else {
        await NotifikasiService.batalkanPolaCraving();
        if (!mounted) return;
        AppToast.info(context, 'Pengingat pola craving dinonaktifkan');
      }
    } on Exception catch (e, s) {
      L.e('Gagal mengubah pola craving: $e $s');
      if (mounted) {
        final isIzin = e is IzinNotifikasiTidakDiberikanException;
        try {
          final aktifSekarang = await NotifikasiService.aktifPolaCraving();
          if (!mounted) return;
          setState(() {
            _polaCravingAktif = aktifSekarang;
          });
        } on Exception catch (e2, s2) {
          L.e('Gagal membaca status aktif pola craving: $e2 $s2');
        }
        if (isIzin) {
          if (mounted) {
            AppToast.gagal(context, 'Izin notifikasi tidak tersedia');
          }
          try {
            await _muatPreferensiNotifikasi();
          } on Exception catch (e2, s2) {
            L.e('Gagal memuat preferensi notifikasi: $e2 $s2');
          }
          if (!mounted) return;
        } else if (mounted) {
          AppToast.gagal(context, 'Gagal mengubah pola craving');
        }
      }
    } on UnsupportedError catch (e, s) {
      L.e('Platform tidak mendukung notifikasi: $e $s');
      if (mounted) {
        setState(() {
          _polaCravingAktif = false;
        });
        AppToast.gagal(context, 'Platform tidak mendukung pola craving');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  Future<void> _ujiNotifikasi() async {
    if (_sedangMemproses) return;
    L.i('uji notifikasi');
    setState(() {
      _sedangMemproses = true;
    });
    unawaited(
      EasyLoading.show(
        status: 'Memproses...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
      }),
    );
    try {
      await NotifikasiService.tampilkanSekarang();
      if (!mounted) return;
      AppToast.info(context, 'Notifikasi uji coba ditampilkan');
    } on Exception catch (e, s) {
      L.e('Gagal menampilkan notifikasi uji coba: $e $s');
      if (!mounted) return;
      AppToast.gagal(context, 'Gagal menampilkan notifikasi');
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
        }),
      );
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [_buildTema(), _buildNotifikasi(), _buildCadangan()],
        ),
      ),
    );
  }

  Widget _buildTema() {
    final temaAsync = ref.watch(temaProvider);
    L.i('temaAsync=$temaAsync');
    if (temaAsync.isLoading) {
      L.w('tema loading');
      return const SizedBox.shrink();
    }
    if (temaAsync.hasError) {
      L.w('tema error');
      return const SizedBox.shrink();
    }
    final temaSaatIni = temaAsync.requireValue;
    L.i('temaSaatIni=$temaSaatIni');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Tema', style: Theme.of(context).textTheme.bodyMedium),
        PopupMenuButton<TemaEnum>(
          initialValue: temaSaatIni,
          onSelected: (tema) {
            unawaited(_ubahTema(tema));
          },
          itemBuilder: (context) => TemaEnum.values
              .map(
                (tema) => PopupMenuItem<TemaEnum>(
                  value: tema,
                  child: Row(
                    spacing: 8,
                    children: [Icon(tema.icon), Text(tema.label)],
                  ),
                ),
              )
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Icon(temaSaatIni.icon),
              Text(temaSaatIni.label),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotifikasi() {
    if (_memuatNotifikasi) {
      return const Center(child: CircularProgressIndicator());
    }
    // Platform yang tidak mendukung notifikasi terjadwal (Web, Linux, Windows).
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      return const SizedBox.shrink();
    }
    final waktu =
        '${_jam.toString().padLeft(2, '0')}:${_menit.toString().padLeft(2, '0')}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pengingat harian',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Switch(
              value: _notifikasiAktif,
              onChanged: _sedangMemproses
                  ? null
                  : (value) {
                      unawaited(_ubahNotifikasi(value));
                    },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Waktu: $waktu', style: Theme.of(context).textTheme.bodySmall),
            OutlinedButton(
              onPressed: _sedangMemproses
                  ? null
                  : () {
                      unawaited(_pilihWaktu());
                    },
              child: const Text('Ubah waktu'),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: _sedangMemproses
              ? null
              : () {
                  unawaited(_ujiNotifikasi());
                },
          child: const Text('Uji coba notifikasi'),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Check-in Pagi',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Switch(
              value: _checkinPagiAktif,
              onChanged: _sedangMemproses
                  ? null
                  : (value) {
                      unawaited(_ubahCheckinPagi(value));
                    },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Waktu: ${_checkinPagiJam.toString().padLeft(2, '0')}:${_checkinPagiMenit.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            OutlinedButton(
              onPressed: _sedangMemproses
                  ? null
                  : () {
                      unawaited(_pilihWaktuCheckinPagi());
                    },
              child: const Text('Ubah waktu'),
            ),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pengingat Pola Craving',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Switch(
              value: _polaCravingAktif,
              onChanged: _sedangMemproses
                  ? null
                  : (value) {
                      unawaited(_ubahPolaCraving(value));
                    },
            ),
          ],
        ),
        if (_polaCravingAktif)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Jadwal otomatis pada jam craving teratas (min. 3 entri diary).',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildCadangan() {
    L.i('PengaturanScreen build cadangan');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Cadangan & Ekspor Data',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        unawaited(
          Nav.to(context, const CadanganScreen()).catchError((
            Object e,
            StackTrace s,
          ) {
            L.e('Gagal navigasi ke Cadangan: $e $s');
            return null;
          }),
        );
      },
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/rencana_darurat/model/rencana_darurat_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/rencana_darurat/notifier/rencana_darurat_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/rencana_darurat/model/rencana_darurat_model.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/state/rencana_darurat_state.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'rencana_darurat_notifier.g.dart';

/// Batas maksimal rencana darurat yang tersimpan.
const int batasMaksRencanaDarurat = 3;

/// Panjang maksimal masing-masing kolom `jika` dan `maka`.
const int panjangMaksRencanaDarurat = 150;

/// Exception ketika penyimpanan melebihi batas [batasMaksRencanaDarurat].
class RencanaPenuhException implements Exception {
  const RencanaPenuhException();

  @override
  String toString() => 'Rencana darurat sudah penuh (maks $batasMaksRencanaDarurat)';
}

/// Exception ketika `jika` duplikat (trim, case-insensitive).
class RencanaDuplikatException implements Exception {
  const RencanaDuplikatException();

  @override
  String toString() => 'Rencana untuk situasi ini sudah ada';
}

/// Validasi murni untuk kolom `jika` dan `maka` rencana darurat.
bool rencanaDaruratValid(String jika, String maka) {
  final j = jika.trim();
  final m = maka.trim();
  return j.isNotEmpty &&
      m.isNotEmpty &&
      j.length <= panjangMaksRencanaDarurat &&
      m.length <= panjangMaksRencanaDarurat;
}

bool _jikaDuplikat(
  List<RencanaDaruratModel> list,
  String jika, {
  String? kecualiId,
}) {
  final normal = jika.trim().toLowerCase();
  return list.any(
    (e) =>
        e.id != kecualiId && e.jika.trim().toLowerCase() == normal,
  );
}

@Riverpod(keepAlive: true)
class RencanaDaruratNotifier extends _$RencanaDaruratNotifier {
  @override
  Future<RencanaDaruratState> build() async {
    return await _ambilSemua();
  }

  Future<RencanaDaruratState> _ambilSemua() async {
    try {
      final op = const SqfliteOp();
      final rows = await op.ambilSemua(
        NamaTabel.rencanaDarurat,
        orderBy: '${NamaKolom.dibuat} ASC',
      );
      final daftar = rows.map(RencanaDaruratModel.fromSqflite).toList();
      L.i('daftar.length=${daftar.length}');
      return RencanaDaruratState(
        listRencana: daftar,
        jumlahRencana: daftar.length,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil data rencana darurat: $e $s');
      rethrow;
    }
  }

  Future<void> tambah({required String jika, required String maka}) async {
    final jikaTrim = jika.trim();
    final makaTrim = maka.trim();
    L.i('jika.length=${jikaTrim.length}, maka.length=${makaTrim.length}');
    try {
      final dataLama = await future;
      if (dataLama.listRencana.length >= batasMaksRencanaDarurat) {
        L.w('rencana darurat penuh, tambah ditolak');
        throw const RencanaPenuhException();
      }
      if (_jikaDuplikat(dataLama.listRencana, jikaTrim)) {
        L.w('jika duplikat, tambah ditolak');
        throw const RencanaDuplikatException();
      }
      final model = RencanaDaruratModel(
        id: const Uuid().v4(),
        jika: jikaTrim,
        maka: makaTrim,
        dibuat: DateTime.now(),
      );
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.rencanaDarurat,
        model.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final baru = [...dataLama.listRencana, model];
      state = AsyncValue.data(
        RencanaDaruratState(
          listRencana: baru,
          jumlahRencana: baru.length,
        ),
      );
      L.s('Rencana darurat berhasil disimpan');
    } on RencanaPenuhException {
      rethrow;
    } on RencanaDuplikatException {
      rethrow;
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan rencana darurat: $e $s');
      rethrow;
    }
  }

  Future<void> ubah(RencanaDaruratModel model) async {
    final jikaTrim = model.jika.trim();
    final makaTrim = model.maka.trim();
    L.i('model.id=${model.id}');
    try {
      final dataLama = await future;
      if (_jikaDuplikat(dataLama.listRencana, jikaTrim, kecualiId: model.id)) {
        L.w('jika duplikat, ubah ditolak');
        throw const RencanaDuplikatException();
      }
      final modelBaru = model.copyWith(jika: jikaTrim, maka: makaTrim);
      final op = const SqfliteOp();
      await op.ubah(
        NamaTabel.rencanaDarurat,
        modelBaru.toSqflite(),
        where: '${NamaKolom.id} = ?',
        whereArgs: [model.id],
      );
      final baru = dataLama.listRencana
          .map((e) => e.id == model.id ? modelBaru : e)
          .toList();
      state = AsyncValue.data(
        RencanaDaruratState(
          listRencana: baru,
          jumlahRencana: baru.length,
        ),
      );
      L.s('Rencana darurat berhasil diubah');
    } on RencanaDuplikatException {
      rethrow;
    } on Exception catch (e, s) {
      L.e('Gagal mengubah rencana darurat: $e $s');
      rethrow;
    }
  }

  Future<void> hapus(String id) async {
    L.i('id=$id');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.hapus(
        NamaTabel.rencanaDarurat,
        where: '${NamaKolom.id} = ?',
        whereArgs: [id],
      );
      final baru = dataLama.listRencana.where((e) => e.id != id).toList();
      state = AsyncValue.data(
        RencanaDaruratState(
          listRencana: baru,
          jumlahRencana: baru.length,
        ),
      );
      L.s('Rencana darurat berhasil dihapus');
    } on Exception catch (e, s) {
      L.e('Gagal menghapus rencana darurat: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/rencana_darurat/screens/form_rencana_darurat.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/model/rencana_darurat_model.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/notifier/rencana_darurat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Form tambah/ubah rencana darurat if-then.
class FormRencanaDarurat extends ConsumerStatefulWidget {
  const FormRencanaDarurat({super.key, this.rencana});

  /// Rencana yang diubah; `null` untuk mode tambah.
  final RencanaDaruratModel? rencana;

  @override
  ConsumerState<FormRencanaDarurat> createState() => _FormRencanaDaruratState();
}

class _FormRencanaDaruratState extends ConsumerState<FormRencanaDarurat> {
  final _formKey = GlobalKey<FormState>();
  final _jikaController = TextEditingController();
  final _makaController = TextEditingController();
  final _jikaFocusNode = FocusNode();
  final _makaFocusNode = FocusNode();

  bool _sedangMemproses = false;

  @override
  void initState() {
    super.initState();
    final rencana = widget.rencana;
    L.i('rencana=$rencana');
    if (rencana != null) {
      _jikaController.text = rencana.jika;
      _makaController.text = rencana.maka;
    }
  }

  @override
  void dispose() {
    _jikaController.dispose();
    _makaController.dispose();
    _jikaFocusNode.dispose();
    _makaFocusNode.dispose();
    super.dispose();
  }

  String? _validasi(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Wajib diisi';
    }
    if (teks.length > panjangMaksRencanaDarurat) {
      return 'Maksimal $panjangMaksRencanaDarurat karakter';
    }
    return null;
  }

  Future<void> _simpan() async {
    if (_sedangMemproses) {
      L.w('Form rencana darurat masih memproses, simpan diabaikan');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      L.w('validasi form gagal');
      return;
    }

    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Simpan Rencana',
      message: 'Apakah Anda yakin ingin menyimpan rencana darurat ini?',
      okLabel: 'Simpan',
      cancelLabel: 'Batal',
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      L.w('konfirmasi bukan ok');
      return;
    }
    if (!mounted) return;

    setState(() => _sedangMemproses = true);
    unawaited(
      EasyLoading.show(
        status: 'Menyimpan...',
        maskType: EasyLoadingMaskType.black,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan loading: $e $s');
        return null;
      }),
    );
    try {
      final jika = _jikaController.text.trim();
      final maka = _makaController.text.trim();
      if (!rencanaDaruratValid(jika, maka)) {
        L.w('rencana tidak valid setelah trim');
        if (mounted) {
          AppToast.gagal(context, 'Rencana tidak valid');
        }
        return;
      }
      final notifier = ref.read(rencanaDaruratProvider.notifier);
      if (widget.rencana == null) {
        await notifier.tambah(jika: jika, maka: maka);
      } else {
        final model = widget.rencana!.copyWith(jika: jika, maka: maka);
        await notifier.ubah(model);
      }
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Nav.pop(context);
      }
    } on RencanaPenuhException catch (e, s) {
      L.e('Gagal menyimpan rencana darurat (penuh): $e $s');
      if (mounted) {
        AppToast.gagal(
          context,
          'Maksimal $batasMaksRencanaDarurat rencana tersimpan',
        );
      }
    } on RencanaDuplikatException catch (e, s) {
      L.e('Gagal menyimpan rencana darurat (duplikat): $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Rencana untuk situasi ini sudah ada');
      }
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan rencana darurat: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menyimpan rencana darurat');
      }
    } finally {
      unawaited(
        EasyLoading.dismiss().catchError((Object e, StackTrace s) {
          L.e('Gagal menutup loading: $e $s');
          return null;
        }),
      );
      if (mounted) {
        setState(() => _sedangMemproses = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.rencana == null ? 'Tambah Rencana' : 'Ubah Rencana',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Text(
                  'Rencana "Jika …, Maka …" dipakai saat craving datang. '
                  'Pilih tindakan yang bisa langsung dilakukan.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                InputTeks(
                  controller: _jikaController,
                  label: 'Jika …',
                  hintText: 'mis. habis makan',
                  focusNode: _jikaFocusNode,
                  nextFocusNode: _makaFocusNode,
                  wajib: true,
                  maxLength: panjangMaksRencanaDarurat,
                  validator: _validasi,
                ),
                InputTeks(
                  controller: _makaController,
                  label: 'Maka …',
                  hintText: 'mis. sikat gigi',
                  helperText: 'Pilih tindakan yang bisa langsung dilakukan',
                  focusNode: _makaFocusNode,
                  textInputAction: TextInputAction.done,
                  wajib: true,
                  maxLength: panjangMaksRencanaDarurat,
                  validator: _validasi,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  // Dialog konfirmasi dan setState berada di luar try di
                  // _simpan; catchError mencegah error async tidak tertangani.
                  onPressed: _sedangMemproses
                      ? null
                      : () => unawaited(
                          _simpan().catchError((Object e, StackTrace s) {
                            L.e('Gagal menyimpan rencana darurat: $e $s');
                            return null;
                          }),
                        ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/rencana_darurat/screens/rencana_darurat_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/model/rencana_darurat_model.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/notifier/rencana_darurat_notifier.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/screens/form_rencana_darurat.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Layar kelola rencana darurat if-then (daftar + tambah/ubah/hapus).
class RencanaDaruratScreen extends ConsumerStatefulWidget {
  const RencanaDaruratScreen({super.key});

  @override
  ConsumerState<RencanaDaruratScreen> createState() =>
      _RencanaDaruratScreenState();
}

class _RencanaDaruratScreenState extends ConsumerState<RencanaDaruratScreen> {
  @override
  void initState() {
    super.initState();
    L.i('RencanaDaruratScreen initState');
  }

  @override
  void dispose() {
    L.i('RencanaDaruratScreen dispose');
    super.dispose();
  }

  void _navigasiKeForm({RencanaDaruratModel? rencana}) {
    unawaited(
      Nav.to(context, FormRencanaDarurat(rencana: rencana)).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Form Rencana Darurat: $e $s');
        return null;
      }),
    );
  }

  Future<void> _hapus(RencanaDaruratModel item) async {
    L.i('item.id=${item.id}');
    final konfirmasi = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus rencana?',
      message: 'Rencana "Jika ${item.jika}" akan dihapus permanen. Lanjutkan?',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    L.i('konfirmasi=$konfirmasi');
    if (konfirmasi != OkCancelResult.ok) {
      return;
    }
    if (!mounted) return;
    try {
      await ref.read(rencanaDaruratProvider.notifier).hapus(item.id);
      if (mounted) {
        AppToast.sukses(context, 'Rencana darurat berhasil dihapus');
      }
    } on Exception catch (e, s) {
      L.e('Gagal menghapus rencana darurat: $e $s');
      if (mounted) {
        AppToast.gagal(context, 'Gagal menghapus rencana darurat');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rencanaAsync = ref.watch(rencanaDaruratProvider);
    L.i(
      'rencanaAsync.isLoading=${rencanaAsync.isLoading}, '
      'hasError=${rencanaAsync.hasError}',
    );

    if (rencanaAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (rencanaAsync.hasError) {
      L.w('rencanaDaruratProvider error=${rencanaAsync.error}');
      return Scaffold(
        appBar: AppBar(title: const Text('Rencana Darurat')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              const Text('Gagal memuat data rencana darurat'),
              OutlinedButton(
                onPressed: () {
                  final _ = ref.refresh(rencanaDaruratProvider);
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final state = rencanaAsync.requireValue;
    final list = state.listRencana;
    final penuh = list.length >= batasMaksRencanaDarurat;
    L.i('list.length=${list.length}, penuh=$penuh');

    final fab = Tooltip(
      message: penuh
          ? 'Maksimal $batasMaksRencanaDarurat rencana tersimpan'
          : 'Tambah rencana',
      child: FloatingActionButton(
        onPressed: penuh ? null : () => _navigasiKeForm(),
        child: const Icon(CupertinoIcons.add),
      ),
    );

    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rencana Darurat')),
        body: EmptyStateView(
          ikon: Icons.event_note_outlined,
          judul: 'Belum ada rencana darurat',
          deskripsi:
              'Tulis rencana "Jika …, Maka …" agar kamu punya respons '
              'otomatis saat craving muncul.',
          ctaLabel: 'Tambah Rencana',
          onCta: () => _navigasiKeForm(),
        ),
        floatingActionButton: fab,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Rencana Darurat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.separated(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              L.i('item.id=${item.id}');
              return Card(
                key: ValueKey(item.id),
                child: ListTile(
                  title: Text('Jika ${item.jika}'),
                  subtitle: Text('Maka ${item.maka}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Hapus',
                    // Dialog konfirmasi di luar try di _hapus dapat melempar
                    // exception; catchError mencegah error async tidak tertangani.
                    onPressed: () => unawaited(
                      _hapus(item).catchError((Object e, StackTrace s) {
                        L.e('Gagal menghapus rencana darurat: $e $s');
                        return null;
                      }),
                    ),
                  ),
                  onTap: () => _navigasiKeForm(rencana: item),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
          ),
        ),
      ),
      floatingActionButton: fab,
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/rencana_darurat/state/rencana_darurat_state.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/rencana_darurat/model/rencana_darurat_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rencana_darurat_state.freezed.dart';

@freezed
abstract class RencanaDaruratState with _$RencanaDaruratState {
  const RencanaDaruratState._();

  const factory RencanaDaruratState({
    @Default([]) List<RencanaDaruratModel> listRencana,
    @Default(0) int jumlahRencana,
  }) = _RencanaDaruratState;
}
```


// ============================================================
// FILE: lib/fitur/rencana_darurat/widgets/kartu_rencana_darurat.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/rencana_darurat/notifier/rencana_darurat_notifier.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/screens/rencana_darurat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Kartu ringkas "Rencana Darurat Saya" untuk disematkan di SOS Craving.
///
/// Menampilkan daftar if-then plan tersimpan (maks 3 baris) atau empty
/// state bila belum ada. Widget hanya menampilkan teks rencana dan aksi
/// navigasi ke layar kelola; tidak memicu teknik SOS otomatis.
class KartuRencanaDarurat extends ConsumerWidget {
  const KartuRencanaDarurat({super.key});

  void _navigasiKeKelola(BuildContext context) {
    unawaited(
      Nav.to(context, const RencanaDaruratScreen()).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Rencana Darurat: $e $s');
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rencanaAsync = ref.watch(rencanaDaruratProvider);
    L.i(
      'rencanaAsync.isLoading=${rencanaAsync.isLoading}, '
      'hasError=${rencanaAsync.hasError}',
    );
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (rencanaAsync.hasError) {
      L.w('rencanaDaruratProvider error=${rencanaAsync.error}');
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Gagal memuat rencana darurat',
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                OutlinedButton(
                  onPressed: () {
                    final _ = ref.refresh(rencanaDaruratProvider);
                  },
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final list = rencanaAsync.asData?.value.listRencana;
    if (list == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }
    L.i('list.length=${list.length}');

    if (list.isEmpty) {
      L.w('rencana darurat kosong, tampilkan empty state');
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Icon(
                      Icons.event_note_outlined,
                      color: colorScheme.primary,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            'Belum ada rencana darurat',
                            style: textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Tulis rencana "Jika …, Maka …" di saat tenang '
                            'agar siap saat craving menyerang.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () => _navigasiKeKelola(context),
                  child: const Text('Buat rencana'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                children: [
                  Icon(
                    Icons.event_note,
                    color: colorScheme.primary,
                  ),
                  Expanded(
                    child: Text(
                      'Rencana Darurat Saya',
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _navigasiKeKelola(context),
                    child: const Text('Kelola'),
                  ),
                ],
              ),
              for (final item in list)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text('•', style: textTheme.bodyMedium),
                    Expanded(
                      child: Text(
                        'Jika ${item.jika} → Maka ${item.maka}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/enum/hasil_intervensi_sos_enum.dart
// ============================================================

```dart
/// Hasil intervensi SOS Craving dari pertanyaan "Apakah dorongan merokok berkurang?".
// Enum value di-lowerCamelCase sesuai konvensi penamaan proyek (sebelumnya
// snake_case yang ikut tersimpan ke kolom database).
enum HasilIntervensiSos {
  berkurang,
  tetap,
  belumSelesai,
}

/// Extension yang menyediakan label untuk [HasilIntervensiSos].
extension HasilIntervensiSosExtension on HasilIntervensiSos {
  String get label {
    switch (this) {
      case HasilIntervensiSos.berkurang:
        return 'Berkurang';
      case HasilIntervensiSos.tetap:
        return 'Tetap';
      case HasilIntervensiSos.belumSelesai:
        return 'Belum selesai';
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart
// ============================================================

```dart
/// Jenis intervensi yang tersedia pada SOS Craving.
// Enum value di-lowerCamelCase sesuai konvensi penamaan proyek (sebelumnya
// snake_case yang ikut tersimpan ke kolom database).
enum JenisIntervensiSos {
  napas478,
  timer3Menit,
  distraksi,
  napasBox,
  napas90Detik,
  grounding54321,
  urgeSurfing,
  timerCraving,
}

/// Extension yang menyediakan label untuk [JenisIntervensiSos].
extension JenisIntervensiSosExtension on JenisIntervensiSos {
  String get label {
    switch (this) {
      case JenisIntervensiSos.napas478:
        return 'Napas 4-7-8';
      case JenisIntervensiSos.timer3Menit:
        return 'Timer 3 Menit';
      case JenisIntervensiSos.distraksi:
        return 'Distraksi';
      case JenisIntervensiSos.napasBox:
        return 'Box Breathing';
      case JenisIntervensiSos.napas90Detik:
        return 'Napas 90 Detik';
      case JenisIntervensiSos.grounding54321:
        return 'Grounding 5-4-3-2-1';
      case JenisIntervensiSos.urgeSurfing:
        return 'Urge Surfing';
      case JenisIntervensiSos.timerCraving:
        return 'Timer Craving';
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/model/sos_intervensi_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/sos_craving/notifier/sos_intervensi_notifier.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/sos_craving/enum/hasil_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/model/sos_intervensi_model.dart';
import 'package:berhenti_merokok/fitur/sos_craving/state/sos_intervensi_state.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

part 'sos_intervensi_notifier.g.dart';

@Riverpod(keepAlive: true)
class SosIntervensiNotifier extends _$SosIntervensiNotifier {
  @override
  Future<SosIntervensiState> build() async {
    return await _ambilSemua();
  }

  Future<SosIntervensiState> _ambilSemua() async {
    try {
      final op = const SqfliteOp();
      final rows = await op.ambilSemua(
        NamaTabel.sosIntervensi,
        orderBy: '${NamaKolom.dibuat} DESC',
      );
      final daftar = rows.map(SosIntervensiModel.fromSqflite).toList();
      L.i('daftar.length=${daftar.length}');
      return SosIntervensiState(
        listIntervensi: daftar,
        jumlahIntervensi: daftar.length,
      );
    } on Exception catch (e, s) {
      L.e('Gagal mengambil riwayat intervensi SOS: $e $s');
      rethrow;
    }
  }

  /// Menyimpan satu baris hasil intervensi SOS.
  ///
  /// [jenis] wajib valid enum. [detail] hanya untuk tab Distraksi.
  /// [hasil] nullable bila pertanyaan dilewati. [diaryCravingId] nullable.
  /// Mengembalikan model yang disimpan (termasuk [id] yang di-generate).
  Future<SosIntervensiModel> simpan({
    required JenisIntervensiSos jenis,
    String? detail,
    HasilIntervensiSos? hasil,
    String? diaryCravingId,
  }) async {
    final id = const Uuid().v4();
    final dibuat = DateTime.now().toUtc();
    L.i('id=$id, jenis=${jenis.name}, detail=$detail, hasil=${hasil?.name}, diaryCravingId=$diaryCravingId, dibuat=$dibuat');
    try {
      final dataLama = await future;
      final model = SosIntervensiModel(
        id: id,
        jenisIntervensi: jenis,
        detail: detail,
        hasilIntervensi: hasil,
        diaryCravingId: diaryCravingId,
        dibuat: dibuat,
      );
      final op = const SqfliteOp();
      await op.tambah(
        NamaTabel.sosIntervensi,
        model.toSqflite(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      state = AsyncValue.data(
        SosIntervensiState(
          listIntervensi: [model, ...dataLama.listIntervensi],
          jumlahIntervensi: dataLama.jumlahIntervensi + 1,
        ),
      );
      L.s('Riwayat intervensi SOS berhasil disimpan');
      return model;
    } on Exception catch (e, s) {
      L.e('Gagal menyimpan riwayat intervensi SOS: $e $s');
      rethrow;
    }
  }

  /// Memperbarui [diaryCravingId] pada baris [id] sos_intervensi.
  Future<void> ubahDiaryCravingId({
    required String id,
    required String? diaryCravingId,
  }) async {
    L.i('id=$id, diaryCravingId=$diaryCravingId');
    try {
      final dataLama = await future;
      final op = const SqfliteOp();
      await op.ubah(
        NamaTabel.sosIntervensi,
        {NamaKolom.diaryCravingId: diaryCravingId},
        where: '${NamaKolom.id} = ?',
        whereArgs: [id],
      );
      final baru = dataLama.listIntervensi.map((e) {
        if (e.id == id) {
          return e.copyWith(diaryCravingId: diaryCravingId);
        }
        return e;
      }).toList();
      state = AsyncValue.data(
        SosIntervensiState(
          listIntervensi: baru,
          jumlahIntervensi: baru.length,
        ),
      );
      L.s('Diary craving ID berhasil diperbarui');
    } on Exception catch (e, s) {
      L.e('Gagal memperbarui diary craving ID: $e $s');
      rethrow;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/screens/sos_craving_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/alasan_berhenti/notifier/alasan_berhenti_notifier.dart';
import 'package:berhenti_merokok/fitur/alasan_berhenti/screens/alasan_berhenti_screen.dart';
import 'package:berhenti_merokok/fitur/rencana_darurat/widgets/kartu_rencana_darurat.dart';
import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/box_breathing_view.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/distraksi_view.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/grounding_54321_view.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/napas_478_view.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/napas_90_detik_view.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/timer_craving_view.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/urge_surfing_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Halaman bantuan cepat saat craving (SOS Craving).
///
/// Menampilkan kartu "Ingat alasanmu" di atas menu kartu teknik.
/// Mengetuk kartu teknik membuka tampilan detail teknik; tombol kembali
/// pada AppBar mengembalikan ke menu kartu.
class SosCravingScreen extends ConsumerStatefulWidget {
  const SosCravingScreen({super.key});

  @override
  ConsumerState<SosCravingScreen> createState() => _SosCravingScreenState();
}

class _SosCravingScreenState extends ConsumerState<SosCravingScreen> {
  JenisIntervensiSos? _teknikTerpilih;

  /// Daftar kartu teknik sesuai urutan yang disepakati:
  /// Napas 4-7-8 → Timer Craving → Box Breathing → Napas 90 Detik →
  /// Grounding 5-4-3-2-1 → Distraksi → Urge Surfing.
  static const List<({JenisIntervensiSos jenis, IconData ikon, String nama, String deskripsi})>
      _kartuTeknik = [
    (
      jenis: JenisIntervensiSos.napas478,
      ikon: Icons.air,
      nama: 'Napas 4-7-8',
      deskripsi: 'Tarik 4, tahan 7, hembus 8',
    ),
    (
      jenis: JenisIntervensiSos.timerCraving,
      ikon: Icons.timer_outlined,
      nama: 'Timer Craving',
      deskripsi: 'Tahan 3, 5, atau 10 menit',
    ),
    (
      jenis: JenisIntervensiSos.napasBox,
      ikon: Icons.crop_square,
      nama: 'Box Breathing',
      deskripsi: 'Napas kotak 4-4-4-4',
    ),
    (
      jenis: JenisIntervensiSos.napas90Detik,
      ikon: Icons.hourglass_bottom,
      nama: 'Napas 90 Detik',
      deskripsi: '90 detik napas lega',
    ),
    (
      jenis: JenisIntervensiSos.grounding54321,
      ikon: Icons.touch_app,
      nama: 'Grounding 5-4-3-2-1',
      deskripsi: 'Sadar 5 indra sekitar',
    ),
    (
      jenis: JenisIntervensiSos.distraksi,
      ikon: Icons.gamepad_outlined,
      nama: 'Distraksi',
      deskripsi: 'Alihkan dengan aktivitas',
    ),
    (
      jenis: JenisIntervensiSos.urgeSurfing,
      ikon: Icons.waves,
      nama: 'Urge Surfing',
      deskripsi: 'Tunggangi gelombang craving',
    ),
  ];

  @override
  void initState() {
    super.initState();
    L.i('SosCravingScreen initState');
  }

  @override
  void dispose() {
    L.i('SosCravingScreen dispose');
    super.dispose();
  }

  void _pilihTeknik(JenisIntervensiSos jenis) {
    L.i('teknik dipilih: ${jenis.name}');
    setState(() {
      _teknikTerpilih = jenis;
    });
  }

  void _kembaliKeMenu() {
    L.i('kembali ke menu teknik');
    setState(() {
      _teknikTerpilih = null;
    });
  }

  /// Membangun kartu pengingat alasan berhenti terbaru (penguat motivasi).
  Widget _buildKartuAlasanBerhenti() {
    final alasanAsync = ref.watch(alasanBerhentiProvider);
    final listAlasan = alasanAsync.asData?.value.listAlasan;
    L.i('listAlasan.length=${listAlasan?.length}');
    if (listAlasan == null || listAlasan.isEmpty) {
      L.w('alasan kosong, tampilkan pesan + CTA');
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            'Belum ada alasan berhenti',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Catat alasan berhenti agar bisa menguatkanmu '
                            'saat craving.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () => unawaited(
                    Nav.to(context, const AlasanBerhentiScreen()).catchError((
                      Object e,
                      StackTrace s,
                    ) {
                      L.e('Gagal navigasi ke Alasan Berhenti: $e $s');
                      return null;
                    }),
                  ),
                  child: const Text('Tambah alasan'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final terbaru = listAlasan.first;
    L.i('terbaru=$terbaru');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      'Ingat alasanmu',
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      terbaru.teks,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKartuTeknik({
    required IconData ikon,
    required String nama,
    required String deskripsi,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Icon(
                ikon,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                deskripsi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTeknik() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        _buildKartuAlasanBerhenti(),
        const KartuRencanaDarurat(),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            padding: const EdgeInsets.all(16),
            childAspectRatio: 1.05,
            children: [
              for (final kartu in _kartuTeknik)
                _buildKartuTeknik(
                  ikon: kartu.ikon,
                  nama: kartu.nama,
                  deskripsi: kartu.deskripsi,
                  onTap: () => _pilihTeknik(kartu.jenis),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            'Teknik ini bukan pengganti nasihat medis.',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTeknik(JenisIntervensiSos jenis) {
    switch (jenis) {
      case JenisIntervensiSos.napas478:
        return const Napas478View();
      case JenisIntervensiSos.timerCraving:
      case JenisIntervensiSos.timer3Menit:
        return const TimerCravingView();
      case JenisIntervensiSos.napasBox:
        return const BoxBreathingView();
      case JenisIntervensiSos.napas90Detik:
        return const Napas90DetikView();
      case JenisIntervensiSos.grounding54321:
        return const Grounding54321View();
      case JenisIntervensiSos.distraksi:
        return const DistraksiView();
      case JenisIntervensiSos.urgeSurfing:
        return const UrgeSurfingView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final teknik = _teknikTerpilih;
    return Scaffold(
      appBar: AppBar(
        title: Text(teknik == null ? 'SOS Craving' : teknik.label),
        leading: teknik == null
            ? null
            : IconButton(
                tooltip: 'Kembali ke menu',
                icon: const Icon(Icons.arrow_back),
                onPressed: _kembaliKeMenu,
              ),
      ),
      body: SafeArea(
        child: teknik == null
            ? _buildMenuTeknik()
            : _buildDetailTeknik(teknik),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/state/sos_intervensi_state.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/sos_craving/model/sos_intervensi_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sos_intervensi_state.freezed.dart';

@freezed
abstract class SosIntervensiState with _$SosIntervensiState {
  const SosIntervensiState._();

  const factory SosIntervensiState({
    @Default([]) List<SosIntervensiModel> listIntervensi,
    @Default(0) int jumlahIntervensi,
  }) = _SosIntervensiState;
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/box_breathing_view.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Box breathing 4-4-4-4: tarik 4 detik, tahan 4 detik,
/// hembuskan 4 detik, tahan 4 detik. Default 4 siklus.
class BoxBreathingView extends ConsumerStatefulWidget {
  const BoxBreathingView({super.key});

  @override
  ConsumerState<BoxBreathingView> createState() => _BoxBreathingViewState();
}

class _BoxBreathingViewState extends ConsumerState<BoxBreathingView> {
  Timer? _timer;
  bool _berjalan = false;
  int _faseIndex = 0; // 0 tarik, 1 tahan, 2 hembus, 3 tahan
  int _sisaFase = 4;
  int _siklus = 0;

  static const List<({String label, int durasi})> _fase = [
    (label: 'Tarik napas', durasi: 4),
    (label: 'Tahan', durasi: 4),
    (label: 'Hembuskan', durasi: 4),
    (label: 'Tahan', durasi: 4),
  ];

  static const int _targetSiklus = 4;

  @override
  void initState() {
    super.initState();
    L.i('BoxBreathingView initState');
  }

  @override
  void dispose() {
    L.i('BoxBreathingView dispose');
    _timer?.cancel();
    super.dispose();
  }

  void _mulai() {
    if (_berjalan) return;
    L.i('mulai box breathing');
    setState(() {
      _berjalan = true;
      _faseIndex = 0;
      _sisaFase = _fase[0].durasi;
      _siklus = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer _) {
    if (!mounted) return;
    setState(() {
      _sisaFase--;
      if (_sisaFase <= 0) {
        _faseIndex++;
        if (_faseIndex >= _fase.length) {
          _faseIndex = 0;
          _siklus++;
          if (_siklus >= _targetSiklus) {
            _selesai();
            return;
          }
        }
        _sisaFase = _fase[_faseIndex].durasi;
      }
    });
  }

  void _selesai() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('box breathing selesai, siklus=$_siklus');
    AppToast.sukses(context, 'Box breathing selesai. Anda hebat!');
    unawaited(
      tampilkanDanSimpanHasilIntervensi(
        context: context,
        ref: ref,
        jenisIntervensi: JenisIntervensiSos.napasBox,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan bottom sheet hasil intervensi box breathing: $e $s');
        return null;
      }),
    );
  }

  void _henti() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('box breathing dihentikan');
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
      _faseIndex = 0;
      _sisaFase = _fase[0].durasi;
      _siklus = 0;
    });
    L.i('box breathing reset');
  }

  double get _skalaLingkaran {
    if (!_berjalan) return 0.6;
    const durasi = 4;
    final progres = 1 - (_sisaFase / durasi);
    switch (_faseIndex) {
      case 0: // tarik: membesar
        return 0.6 + (0.4 * progres);
      case 1: // tahan setelah tarik
        return 1.0;
      case 2: // hembus: mengecil
        return 1.0 - (0.4 * progres);
      case 3: // tahan setelah hembus
        return 0.6;
      default:
        return 0.6;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fase = _fase[_faseIndex];
    final warna = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Box Breathing',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tarik 4 detik, tahan 4 detik, hembuskan 4 detik, tahan 4 detik. '
            'Ulangi $_targetSiklus kali.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            width: 200 * _skalaLingkaran,
            height: 200 * _skalaLingkaran,
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: warna, width: 3),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _berjalan ? fase.label : 'Siap',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _berjalan ? '$_sisaFase' : '$_targetSiklus siklus',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          if (_berjalan)
            Text(
              'Siklus ${_siklus + 1} dari $_targetSiklus',
              style: textTheme.bodyMedium,
            ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_berjalan)
                FilledButton.icon(
                  onPressed: _mulai,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Mulai'),
                )
              else
                FilledButton.icon(
                  onPressed: _henti,
                  icon: const Icon(Icons.pause),
                  label: const Text('Jeda'),
                ),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/distraksi_view.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Daftar distraksi sederhana.
class DistraksiView extends ConsumerStatefulWidget {
  const DistraksiView({super.key});

  @override
  ConsumerState<DistraksiView> createState() => _DistraksiViewState();
}

class _DistraksiViewState extends ConsumerState<DistraksiView> {
  int _berhasil = 0;
  String? _aktivitasTerpilih;

  static const List<String> _aktivitas = [
    'Minum segelas air putih',
    'Jalan kaki 5 menit',
    'Makan permen atau buah',
    'Cuci muka dengan air dingin',
    'Telepon teman atau keluarga',
    'Dengarkan musik favorit',
    'Lakukan 10 kali push-up ringan',
    'Baca 1 halaman buku',
  ];

  @override
  void initState() {
    super.initState();
    L.i('DistraksiView initState');
  }

  @override
  void dispose() {
    L.i('DistraksiView dispose, berhasil=$_berhasil');
    super.dispose();
  }

  void _tandaiBerhasil() {
    setState(() {
      _berhasil++;
    });
    L.i('distraksi berhasil, total=$_berhasil');
    AppToast.sukses(context, 'Craving berhasil dilewati!');
    unawaited(
      tampilkanDanSimpanHasilIntervensi(
        context: context,
        ref: ref,
        jenisIntervensi: JenisIntervensiSos.distraksi,
        detail: _aktivitasTerpilih,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan bottom sheet hasil intervensi distraksi: $e $s');
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distraksi',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Pilih aktivitas untuk mengalihkan perhatian dari craving.',
            style: textTheme.bodyMedium,
          ),
          if (_berhasil > 0)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Craving dilewati: $_berhasil kali',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              itemCount: _aktivitas.length,
              itemBuilder: (context, index) {
                final aktivitas = _aktivitas[index];
                return ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(aktivitas),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    L.i('distraksi dipilih: $aktivitas');
                    setState(() {
                      _aktivitasTerpilih = aktivitas;
                    });
                    AppToast.info(context, aktivitas);
                  },
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 4),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _tandaiBerhasil,
              icon: const Icon(Icons.verified),
              label: const Text('Saya berhasil melewati craving'),
            ),
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/grounding_54321_view.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Grounding 5-4-3-2-1: mengalihkan perhatian dari craving ke
/// sensasi tubuh/indra saat ini, langkah demi langkah.
class Grounding54321View extends ConsumerStatefulWidget {
  const Grounding54321View({super.key});

  @override
  ConsumerState<Grounding54321View> createState() => _Grounding54321ViewState();
}

class _Grounding54321ViewState extends ConsumerState<Grounding54321View> {
  int _langkah = 0; // 0..4

  static const List<({String indra, String instruksi, IconData ikon})> _langkahList = [
    (
      indra: '5 hal yang kamu LIHAT',
      instruksi: 'Sebutkan dalam hati 5 benda yang terlihat di sekitarmu '
          'saat ini, satu per satu.',
      ikon: Icons.visibility,
    ),
    (
      indra: '4 hal yang kamu SENTUH',
      instruksi: 'Rasakan 4 benda yang bisa kamu sentuh: tekstur meja, '
          'pakaian, atau kursi.',
      ikon: Icons.touch_app,
    ),
    (
      indra: '3 hal yang kamu DENGAR',
      instruksi: 'Dengarkan 3 suara di sekitarmu: kendaraan, kipas angin, '
          'atau suara napasmu sendiri.',
      ikon: Icons.hearing,
    ),
    (
      indra: '2 hal yang kamu CIUM',
      instruksi: 'Cium 2 aroma di sekitarmu: kopi, sabun, atau udara '
          'segar.',
      ikon: Icons.air,
    ),
    (
      indra: '1 hal yang kamu KECAP',
      instruksi: 'Rasakan 1 rasa di mulutmu: sisa makanan, air, atau '
          'permen mint.',
      ikon: Icons.restaurant,
    ),
  ];

  @override
  void initState() {
    super.initState();
    L.i('Grounding54321View initState');
  }

  @override
  void dispose() {
    L.i('Grounding54321View dispose');
    super.dispose();
  }

  void _selanjutnya() {
    L.i('grounding langkah ${_langkah + 1} selesai');
    if (_langkah >= _langkahList.length - 1) {
      _selesai();
      return;
    }
    setState(() {
      _langkah++;
    });
  }

  void _sebelumnya() {
    if (_langkah == 0) return;
    L.i('grounding kembali ke langkah $_langkah');
    setState(() {
      _langkah--;
    });
  }

  void _selesai() {
    L.i('grounding 5-4-3-2-1 selesai');
    AppToast.sukses(context, 'Grounding selesai. Pikiran lebih tenang!');
    unawaited(
      tampilkanDanSimpanHasilIntervensi(
        context: context,
        ref: ref,
        jenisIntervensi: JenisIntervensiSos.grounding54321,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan bottom sheet hasil intervensi grounding: $e $s');
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final langkah = _langkahList[_langkah];
    final progres = (_langkah + 1) / _langkahList.length;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Grounding 5-4-3-2-1',
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Langkah ${_langkah + 1} dari ${_langkahList.length}',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          LinearProgressIndicator(value: progres.clamp(0.0, 1.0)),
          const SizedBox(height: 8),
          Icon(
            langkah.ikon,
            size: 96,
            color: colorScheme.primary,
          ),
          Text(
            langkah.indra,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            langkah.instruksi,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_langkah > 0)
                OutlinedButton.icon(
                  onPressed: _sebelumnya,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Kembali'),
                ),
              FilledButton.icon(
                onPressed: _selanjutnya,
                icon: const Icon(Icons.check),
                label: const Text('Sudah'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/napas_478_view.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Latihan napas 4-7-8: tarik 4 detik, tahan 7 detik, hembuskan 8 detik.
class Napas478View extends ConsumerStatefulWidget {
  const Napas478View({super.key});

  @override
  ConsumerState<Napas478View> createState() => _Napas478ViewState();
}

class _Napas478ViewState extends ConsumerState<Napas478View> {
  Timer? _timer;
  bool _berjalan = false;
  int _faseIndex = 0; // 0 tarik, 1 tahan, 2 hembus
  int _sisaFase = 4;
  int _siklus = 0;

  static const List<({String label, int durasi})> _fase = [
    (label: 'Tarik napas', durasi: 4),
    (label: 'Tahan', durasi: 7),
    (label: 'Hembuskan', durasi: 8),
  ];

  static const int _targetSiklus = 4;

  @override
  void initState() {
    super.initState();
    L.i('Napas478View initState');
  }

  @override
  void dispose() {
    L.i('Napas478View dispose');
    _timer?.cancel();
    super.dispose();
  }

  void _mulai() {
    if (_berjalan) return;
    L.i('mulai napas 4-7-8');
    setState(() {
      _berjalan = true;
      _faseIndex = 0;
      _sisaFase = _fase[0].durasi;
      _siklus = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer _) {
    if (!mounted) return;
    setState(() {
      _sisaFase--;
      if (_sisaFase <= 0) {
        _faseIndex++;
        if (_faseIndex >= _fase.length) {
          _faseIndex = 0;
          _siklus++;
          if (_siklus >= _targetSiklus) {
            _selesai();
            return;
          }
        }
        _sisaFase = _fase[_faseIndex].durasi;
      }
    });
  }

  void _selesai() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('napas 4-7-8 selesai, siklus=$_siklus');
    AppToast.sukses(context, 'Latihan napas selesai. Anda hebat!');
    unawaited(
      tampilkanDanSimpanHasilIntervensi(
        context: context,
        ref: ref,
        jenisIntervensi: JenisIntervensiSos.napas478,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan bottom sheet hasil intervensi napas: $e $s');
        return null;
      }),
    );
  }

  void _henti() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('napas 4-7-8 dihentikan');
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
      _faseIndex = 0;
      _sisaFase = _fase[0].durasi;
      _siklus = 0;
    });
    L.i('napas 4-7-8 reset');
  }

  double get _skalaLingkaran {
    if (!_berjalan) return 0.6;
    switch (_faseIndex) {
      case 0: // tarik: membesar
        final durasi = _fase[0].durasi;
        final progres = 1 - (_sisaFase / durasi);
        return 0.6 + (0.4 * progres);
      case 1: // tahan
        return 1.0;
      case 2: // hembus: mengecil
        final durasi = _fase[2].durasi;
        final progres = 1 - (_sisaFase / durasi);
        return 1.0 - (0.4 * progres);
      default:
        return 0.6;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fase = _fase[_faseIndex];
    final warna = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Latihan Napas 4-7-8',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Tarik napas 4 detik, tahan 7 detik, hembuskan 8 detik. '
            'Ulangi $_targetSiklus kali.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            width: 200 * _skalaLingkaran,
            height: 200 * _skalaLingkaran,
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: warna, width: 3),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _berjalan ? fase.label : 'Siap',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _berjalan ? '$_sisaFase' : '$_targetSiklus siklus',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          if (_berjalan)
            Text(
              'Siklus ${_siklus + 1} dari $_targetSiklus',
              style: textTheme.bodyMedium,
            ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_berjalan)
                FilledButton.icon(
                  onPressed: _mulai,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Mulai'),
                )
              else
                FilledButton.icon(
                  onPressed: _henti,
                  icon: const Icon(Icons.pause),
                  label: const Text('Jeda'),
                ),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/napas_90_detik_view.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Napas 90 detik: latihan napas singkat satu tarikan panjang,
/// diulang selama ±90 detik. Tarik 4 detik, hembuskan 6 detik.
class Napas90DetikView extends ConsumerStatefulWidget {
  const Napas90DetikView({super.key});

  @override
  ConsumerState<Napas90DetikView> createState() => _Napas90DetikViewState();
}

class _Napas90DetikViewState extends ConsumerState<Napas90DetikView> {
  static const int _durasiAwal = 90;

  Timer? _timer;
  bool _berjalan = false;
  int _sisa = _durasiAwal;
  int _faseNapas = 0; // 0 tarik (4 detik), 1 hembus (6 detik)
  int _sisaFase = 4;

  static const List<({String label, int durasi})> _fase = [
    (label: 'Tarik napas', durasi: 4),
    (label: 'Hembuskan', durasi: 6),
  ];

  @override
  void initState() {
    super.initState();
    L.i('Napas90DetikView initState');
  }

  @override
  void dispose() {
    L.i('Napas90DetikView dispose');
    _timer?.cancel();
    super.dispose();
  }

  void _mulai() {
    if (_berjalan) return;
    if (_sisa <= 0) {
      _sisa = _durasiAwal;
      _faseNapas = 0;
      _sisaFase = _fase[0].durasi;
    }
    L.i('napas 90 detik mulai, sisa=$_sisa');
    setState(() {
      _berjalan = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer _) {
    if (!mounted) return;
    setState(() {
      _sisa--;
      _sisaFase--;
      if (_sisaFase <= 0) {
        _faseNapas = (_faseNapas + 1) % _fase.length;
        _sisaFase = _fase[_faseNapas].durasi;
      }
      if (_sisa <= 0) {
        _selesai();
      }
    });
  }

  void _selesai() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
      _sisa = 0;
    });
    L.i('napas 90 detik selesai');
    AppToast.sukses(context, '90 detik berlalu. Craving Anda melemah!');
    unawaited(
      tampilkanDanSimpanHasilIntervensi(
        context: context,
        ref: ref,
        jenisIntervensi: JenisIntervensiSos.napas90Detik,
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan bottom sheet hasil intervensi napas 90 detik: $e $s');
        return null;
      }),
    );
  }

  void _henti() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('napas 90 detik dihentikan');
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
      _sisa = _durasiAwal;
      _faseNapas = 0;
      _sisaFase = _fase[0].durasi;
    });
    L.i('napas 90 detik reset');
  }

  String get _teksSisa {
    final menit = (_sisa ~/ 60).toString().padLeft(2, '0');
    final detik = (_sisa % 60).toString().padLeft(2, '0');
    return '$menit:$detik';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fase = _fase[_faseNapas];
    final progres = 1 - (_sisa / _durasiAwal);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Napas 90 Detik',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Tarik napas dalam 4 detik, hembuskan perlahan 6 detik. '
            'Ulangi hingga 90 detik berlalu.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progres.clamp(0.0, 1.0),
                  strokeWidth: 12,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _berjalan ? fase.label : 'Siap',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _teksSisa,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_berjalan)
                FilledButton.icon(
                  onPressed: _mulai,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(_sisa == 0 ? 'Ulangi' : 'Mulai'),
                )
              else
                FilledButton.icon(
                  onPressed: _henti,
                  icon: const Icon(Icons.pause),
                  label: const Text('Jeda'),
                ),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart
// ============================================================

```dart
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:berhenti_merokok/fitur/sos_craving/enum/hasil_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/model/sos_intervensi_model.dart';
import 'package:berhenti_merokok/fitur/sos_craving/notifier/sos_intervensi_notifier.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite_op.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_kolom.dart';
import 'package:berhenti_merokok/shared/konstanta/nama_tabel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Bottom sheet satu pertanyaan opsi hasil intervensi SOS Craving.
///
/// Tampilkan setelah intervensi selesai. Opsi: Berkurang / Tetap / Belum selesai,
/// plus aksi Lewati. Hasil dikembalikan sebagai [HasilIntervensiSos] atau null
/// bila pengguna menekan Lewati / menutup sheet tanpa memilih.
class SheetHasilIntervensi extends ConsumerWidget {
  const SheetHasilIntervensi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final warnaSurface = Theme.of(context).colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: warnaSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Text(
              'Apakah dorongan merokok berkurang?',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih salah satu atau lewati.',
              style: textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            _TombolHasil(
              label: HasilIntervensiSos.berkurang.label,
              value: HasilIntervensiSos.berkurang,
              onTap: () => Navigator.pop(context, HasilIntervensiSos.berkurang),
            ),
            _TombolHasil(
              label: HasilIntervensiSos.tetap.label,
              value: HasilIntervensiSos.tetap,
              onTap: () => Navigator.pop(context, HasilIntervensiSos.tetap),
            ),
            _TombolHasil(
              label: HasilIntervensiSos.belumSelesai.label,
              value: HasilIntervensiSos.belumSelesai,
              onTap: () =>
                  Navigator.pop(context, HasilIntervensiSos.belumSelesai),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Lewati'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu tombol pilihan hasil intervensi dalam bottom sheet.
class _TombolHasil extends StatelessWidget {
  const _TombolHasil({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final HasilIntervensiSos value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}

/// Mengambil entri diary craving terbaru untuk hari ini.
///
/// Entri diary disimpan dari waktu lokal yang dikonversi ke UTC, sehingga
/// pencarian memakai rentang UTC dari batas hari lokal (00:00 lokal sampai
/// 00:00 lokal besok), bukan prefix tanggal UTC — prefix UTC meleset satu
/// hari untuk zona UTC+X pada pagi hari.
///
/// Mengembalikan `id` entri terbaru bila ditemukan, atau `null` bila tidak ada.
Future<String?> _ambilEntriDiaryTerbaruHariIni() async {
  try {
    final op = const SqfliteOp();
    final now = DateTime.now();
    // Batas hari lokal dinormalisasi lalu dikonversi ke UTC agar konsisten
    // dengan cara tanggal disimpan di kolom `tanggal`.
    final awalLokal = DateTime(now.year, now.month, now.day);
    final awalUtc = awalLokal.toUtc().toIso8601String();
    final akhirUtc =
        awalLokal.add(const Duration(days: 1)).toUtc().toIso8601String();
    final rows = await op.ambil(
      NamaTabel.diaryCraving,
      where: '${NamaKolom.tanggal} >= ? AND ${NamaKolom.tanggal} < ?',
      whereArgs: [awalUtc, akhirUtc],
      orderBy: '${NamaKolom.tanggal} DESC',
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return rows.first[NamaKolom.id] as String?;
  } on Exception catch (e, s) {
    L.w('Gagal mencari entri diary hari ini: $e $s');
    return null;
  }
}

/// Menampilkan bottom sheet pertanyaan hasil intervensi dan menyimpan hasilnya.
///
/// Setelah menyimpan, bila ada entri diary craving hari ini, tawarkan
/// "Tautkan ke catatan craving?" bila pengguna setuju.
///
/// [jenisIntervensi] wajib valid enum. [detail] hanya untuk tab Distraksi.
/// Mengembalikan [HasilIntervensiSos] yang dipilih, atau null bila dilewati.
Future<HasilIntervensiSos?> tampilkanDanSimpanHasilIntervensi({
  required BuildContext context,
  required WidgetRef ref,
  required JenisIntervensiSos jenisIntervensi,
  String? detail,
}) async {
  final hasil = await showModalBottomSheet<HasilIntervensiSos>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const SheetHasilIntervensi(),
  );

  SosIntervensiModel? modelDisimpan;
  try {
    modelDisimpan = await ref
        .read(sosIntervensiProvider.notifier)
        .simpan(
          jenis: jenisIntervensi,
          detail: detail,
          hasil: hasil,
        );
    if (context.mounted) {
      AppToast.sukses(
        context,
        'Hasil intervensi tersimpan${hasil == null ? ' (dilewati)' : ''}',
      );
    }
  } on Exception catch (e, s) {
    L.e('Gagal menyimpan hasil intervensi SOS: $e $s');
    if (context.mounted) {
      AppToast.gagal(context, 'Gagal menyimpan hasil intervensi');
    }
    return hasil;
  }

  // Tawarkan tautan ke diary craving bila ada entri hari ini dan model tersimpan.
  if (context.mounted) {
    final diaryId = await _ambilEntriDiaryTerbaruHariIni();
    if (diaryId != null) {
      final konfirmasi = await showOkCancelAlertDialog(
        context: context,
        title: 'Tautkan ke catatan craving?',
        message:
            'Hasil intervensi ini akan ditautkan ke entri craving hari ini '
            'agar Anda bisa melihat hubungan antara pemicu dan teknik yang '
            'dicoba.',
        okLabel: 'Tautkan',
        cancelLabel: 'Batal',
      );
      if (konfirmasi == OkCancelResult.ok) {
        try {
          await ref
              .read(sosIntervensiProvider.notifier)
              .ubahDiaryCravingId(
                id: modelDisimpan.id,
                diaryCravingId: diaryId,
              );
          if (context.mounted) {
            AppToast.sukses(context, 'Tautkan ke catatan craving berhasil');
          }
        } on Exception catch (e, s) {
          L.w('Gagal menautkan ke catatan craving: $e $s');
          if (context.mounted) {
            AppToast.gagal(context, 'Gagal menautkan ke catatan craving');
          }
        }
      }
    }
  }

  return hasil;
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/timer_craving_view.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Timer craving dengan pilihan durasi 3 / 5 / 10 menit.
class TimerCravingView extends ConsumerStatefulWidget {
  const TimerCravingView({super.key});

  @override
  ConsumerState<TimerCravingView> createState() => _TimerCravingViewState();
}

class _TimerCravingViewState extends ConsumerState<TimerCravingView> {
  static const List<int> _pilihanDurasi = [3, 5, 10];

  int _menitTerpilih = 3;
  int get _durasiAwal => _menitTerpilih * 60;

  Timer? _timer;
  bool _berjalan = false;
  int _sisa = 3 * 60;

  @override
  void initState() {
    super.initState();
    L.i('TimerCravingView initState');
  }

  @override
  void dispose() {
    L.i('TimerCravingView dispose');
    _timer?.cancel();
    super.dispose();
  }

  void _pilihDurasi(int menit) {
    if (_berjalan) return;
    L.i('durasi timer dipilih: $menit menit');
    setState(() {
      _menitTerpilih = menit;
      _sisa = _durasiAwal;
    });
  }

  void _mulai() {
    if (_berjalan) return;
    if (_sisa <= 0) {
      _sisa = _durasiAwal;
    }
    L.i('timer craving mulai, sisa=$_sisa');
    setState(() {
      _berjalan = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer _) {
    if (!mounted) return;
    setState(() {
      _sisa--;
      if (_sisa <= 0) {
        _selesai();
      }
    });
  }

  void _selesai() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
      _sisa = 0;
    });
    L.i('timer craving selesai, durasi=$_menitTerpilih menit');
    AppToast.sukses(
      context,
      '$_menitTerpilih menit berlalu. Craving biasanya singkat. '
      'Anda berhasil!',
    );
    unawaited(
      tampilkanDanSimpanHasilIntervensi(
        context: context,
        ref: ref,
        jenisIntervensi: JenisIntervensiSos.timerCraving,
        detail: '$_menitTerpilih menit',
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan bottom sheet hasil intervensi timer: $e $s');
        return null;
      }),
    );
  }

  void _jeda() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('timer craving dijeda');
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
      _sisa = _durasiAwal;
    });
    L.i('timer craving reset');
  }

  String get _teksWaktu {
    final menit = (_sisa ~/ 60).toString().padLeft(2, '0');
    final detik = (_sisa % 60).toString().padLeft(2, '0');
    return '$menit:$detik';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progres = 1 - (_sisa / _durasiAwal);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Timer Craving',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Craving biasanya berlangsung beberapa menit. '
            'Tahan dorongan hingga waktu habis.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final menit in _pilihanDurasi)
                ChoiceChip(
                  label: Text('$menit menit'),
                  selected: _menitTerpilih == menit,
                  onSelected: _berjalan ? null : (_) => _pilihDurasi(menit),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progres.clamp(0.0, 1.0),
                  strokeWidth: 12,
                ),
                Center(
                  child: Text(
                    _teksWaktu,
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_berjalan)
                FilledButton.icon(
                  onPressed: _mulai,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(_sisa == 0 ? 'Ulangi' : 'Mulai'),
                )
              else
                FilledButton.icon(
                  onPressed: _jeda,
                  icon: const Icon(Icons.pause),
                  label: const Text('Jeda'),
                ),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/sos_craving/widgets/urge_surfing_view.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/sos_craving/enum/jenis_intervensi_sos_enum.dart';
import 'package:berhenti_merokok/fitur/sos_craving/widgets/sheet_hasil_intervensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Urge surfing: "menunggangi" gelombang craving hingga mereda.
/// Timer 10 / 15 / 20 menit dengan fase gelombang naik → puncak → reda.
class UrgeSurfingView extends ConsumerStatefulWidget {
  const UrgeSurfingView({super.key});

  @override
  ConsumerState<UrgeSurfingView> createState() => _UrgeSurfingViewState();
}

class _UrgeSurfingViewState extends ConsumerState<UrgeSurfingView> {
  static const List<int> _pilihanDurasi = [10, 15, 20];

  int _menitTerpilih = 10;
  int get _durasiAwal => _menitTerpilih * 60;

  Timer? _timer;
  bool _berjalan = false;
  int _sisa = 10 * 60;

  @override
  void initState() {
    super.initState();
    L.i('UrgeSurfingView initState');
  }

  @override
  void dispose() {
    L.i('UrgeSurfingView dispose');
    _timer?.cancel();
    super.dispose();
  }

  void _pilihDurasi(int menit) {
    if (_berjalan) return;
    L.i('durasi urge surfing dipilih: $menit menit');
    setState(() {
      _menitTerpilih = menit;
      _sisa = _durasiAwal;
    });
  }

  void _mulai() {
    if (_berjalan) return;
    if (_sisa <= 0) {
      _sisa = _durasiAwal;
    }
    L.i('urge surfing mulai, sisa=$_sisa');
    setState(() {
      _berjalan = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer _) {
    if (!mounted) return;
    setState(() {
      _sisa--;
      if (_sisa <= 0) {
        _selesai();
      }
    });
  }

  void _selesai() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('urge surfing selesai, durasi=$_menitTerpilih menit');
    AppToast.sukses(context, 'Gelombang craving berhasil dilewati!');
    unawaited(
      tampilkanDanSimpanHasilIntervensi(
        context: context,
        ref: ref,
        jenisIntervensi: JenisIntervensiSos.urgeSurfing,
        detail: '$_menitTerpilih menit',
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal menampilkan bottom sheet hasil intervensi urge surfing: $e $s');
        return null;
      }),
    );
  }

  void _jeda() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
    });
    L.i('urge surfing dijeda');
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _berjalan = false;
      _sisa = _durasiAwal;
    });
    L.i('urge surfing reset');
  }

  /// Tiga fase gelombang craving: naik → puncak → reda.
  ({String fase, String afirmasi}) get _faseGelombang {
    final berlalu = _durasiAwal - _sisa;
    final pertiga = _durasiAwal / 3;
    if (berlalu < pertiga) {
      return (
        fase: 'Naik',
        afirmasi: 'Craving sedang naik. Rasakan tanpa dilawan — '
            'ini hanya gelombang, pasti berlalu.',
      );
    }
    if (berlalu < 2 * pertiga) {
      return (
        fase: 'Puncak',
        afirmasi: 'Kamu di puncak gelombang. Tetap di sini, perhatikan '
            'sensasinya tanpa bereaksi.',
      );
    }
    return (
      fase: 'Reda',
      afirmasi: 'Gelombang mulai reda. Kamu lebih kuat dari craving ini.',
    );
  }

  String get _teksWaktu {
    final menit = (_sisa ~/ 60).toString().padLeft(2, '0');
    final detik = (_sisa % 60).toString().padLeft(2, '0');
    return '$menit:$detik';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final progres = 1 - (_sisa / _durasiAwal);
    final fase = _faseGelombang;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Urge Surfing',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'Tunggangi gelombang craving hingga reda, '
            'tanpa melawannya.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final menit in _pilihanDurasi)
                ChoiceChip(
                  label: Text('$menit menit'),
                  selected: _menitTerpilih == menit,
                  onSelected: _berjalan ? null : (_) => _pilihDurasi(menit),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progres.clamp(0.0, 1.0),
                  strokeWidth: 12,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _berjalan ? 'Fase ${fase.fase}' : 'Siap',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _teksWaktu,
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_berjalan)
            Text(
              fase.afirmasi,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
          const SizedBox(height: 8),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_berjalan)
                FilledButton.icon(
                  onPressed: _mulai,
                  icon: const Icon(Icons.play_arrow),
                  label: Text(_sisa == 0 ? 'Ulangi' : 'Mulai'),
                )
              else
                FilledButton.icon(
                  onPressed: _jeda,
                  icon: const Icon(Icons.pause),
                  label: const Text('Jeda'),
                ),
              OutlinedButton.icon(
                onPressed: _selesai,
                icon: const Icon(Icons.done),
                label: const Text('Selesai'),
              ),
              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/tema/enum/tema_enum.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

/// Enum mode tema aplikasi.
enum TemaEnum { sistem, terang, gelap }

/// Extension yang menyediakan label dan ikon untuk [TemaEnum].
extension TemaEnumExtension on TemaEnum {
  String get label {
    switch (this) {
      case TemaEnum.sistem:
        return 'Sistem';
      case TemaEnum.terang:
        return 'Terang';
      case TemaEnum.gelap:
        return 'Gelap';
    }
  }

  IconData get icon {
    switch (this) {
      case TemaEnum.sistem:
        return Icons.brightness_auto;
      case TemaEnum.terang:
        return Icons.light_mode;
      case TemaEnum.gelap:
        return Icons.dark_mode;
    }
  }
}
```


// ============================================================
// FILE: lib/fitur/tema/notifier/tema_notifier.dart
// ============================================================

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:berhenti_merokok/fitur/tema/enum/tema_enum.dart';
import 'package:berhenti_merokok/shared/helper/shared_keys.dart';

part 'tema_notifier.g.dart';

// Pengecualian aturan Freezed untuk state sederhana berbasis enum:
// state tema hanya menyimpan satu nilai TemaEnum, sehingga tidak
// memerlukan state Freezed tersendiri, konsisten dengan BiodataNotifier
// yang juga menggunakan model nullable langsung sebagai state.
@Riverpod(keepAlive: true)
class TemaNotifier extends _$TemaNotifier {
  @override
  Future<TemaEnum> build() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(SharedKeys.tema);
    return TemaEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TemaEnum.sistem,
    );
  }

  Future<void> set([TemaEnum? tema]) async {
    final nilai = tema ?? state.asData?.value ?? TemaEnum.sistem;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedKeys.tema, nilai.name);
    state = AsyncValue.data(nilai);
  }
}
```


// ============================================================
// FILE: lib/fitur/toxin_pelacakan/helper/toxin_hitung_helper.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/toxin_pelacakan/model/toxin_model.dart';
import 'package:share_global_saya/core_shared.dart';

/// Helper murni untuk perhitungan kuantitas toxin yang dihindari tubuh.
///
/// Tidak bergantung pada [BuildContext] atau provider. Semua data referensi
/// bersifat statis dan ilustratif dengan catatan sumber umum (WHO / CDC /
/// AHA / ACS sebagai landasan referensi, bukan klaim medis aplikasi).
class ToxinHitungHelper {
  const ToxinHitungHelper._();

  /// Daftar referensi toxin statis. Faktor per batang adalah perkiraan
  /// ilustratif untuk tujuan visualisasi progres, bukan data klinis.
  static const List<ToxinModel> _daftarReferensi = <ToxinModel>[
    ToxinModel(
      nama: 'Tar',
      jenisZat: 'Zat terpangkal',
      faktorPerBatang: 12.0,
      efekSingkat: 'Menyumbat paru-paru dan mengganggu pertukaran oksigen.',
      sumberReferensi: 'WHO / CDC / AHA / ACS',
    ),
    ToxinModel(
      nama: 'Nikotin',
      jenisZat: 'Zat adiktif',
      faktorPerBatang: 1.2,
      efekSingkat: 'Mendorong ketergantungan dan meningkatkan detak jantung.',
      sumberReferensi: 'WHO / CDC / AHA / ACS',
    ),
    ToxinModel(
      nama: 'Karbon Monoksida',
      jenisZat: 'Gas beracun',
      faktorPerBatang: 18.0,
      efekSingkat: 'Menggantikan oksigen pada hemoglobin darah.',
      sumberReferensi: 'WHO / CDC / AHA / ACS',
    ),
    ToxinModel(
      nama: 'Formaldehida',
      jenisZat: 'Zat kimia industri',
      faktorPerBatang: 0.08,
      efekSingkat: 'Mengiritasi mata, hidung, dan tenggorokan.',
      sumberReferensi: 'WHO / CDC / AHA / ACS',
    ),
    ToxinModel(
      nama: 'Bensen',
      jenisZat: 'Zat karsinogen',
      faktorPerBatang: 0.15,
      efekSingkat: 'Berisiko merusak sumsum darah dan sistem imun.',
      sumberReferensi: 'WHO / CDC / AHA / ACS',
    ),
    ToxinModel(
      nama: 'Ammonia',
      jenisZat: 'Zat penguat nikotin',
      faktorPerBatang: 0.5,
      efekSingkat: 'Mempercepat penyerapan nikotin di paru-paru.',
      sumberReferensi: 'WHO / CDC / AHA / ACS',
    ),
    ToxinModel(
      nama: 'Arsen',
      jenisZat: 'Zat beracun berat',
      faktorPerBatang: 0.02,
      efekSingkat: 'Beracuk bagi jantung, paru-paru, dan kulit.',
      sumberReferensi: 'WHO / CDC / AHA / ACS',
    ),
  ];

  /// Menghitung daftar toxin yang dihindari berdasarkan jumlah rokok
  /// yang tidak dihisap.
  ///
  /// Mengembalikan list kosong jika [rokokTidakDiHisap] nol atau negatif
  /// (guard pembagian/nol dan nilai valid).
  static List<ToxinModel> hitung(int rokokTidakDiHisap) {
    L.i('rokokTidakDiHisap=$rokokTidakDiHisap');
    if (rokokTidakDiHisap <= 0) {
      return const [];
    }
    return _daftarReferensi.map((t) {
      return t.copyWith(
        kuantitasDiHindari: t.faktorPerBatang * rokokTidakDiHisap,
      );
    }).toList();
  }
}
```


// ============================================================
// FILE: lib/fitur/toxin_pelacakan/model/toxin_model.dart
// ============================================================

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


// ============================================================
// FILE: lib/fitur/toxin_pelacakan/screens/toxin_pelacakan_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/biodata/notifier/biodata_notifier.dart';
import 'package:berhenti_merokok/fitur/biodata/screens/form_biodata.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/helper/metrik_berhenti_helper.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/notifier/konsumsi_rokok_notifier.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/screens/konsumsi_rokok_screen.dart';
import 'package:berhenti_merokok/fitur/toxin_pelacakan/helper/toxin_hitung_helper.dart';
import 'package:berhenti_merokok/shared/widget/empty_state_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';

/// Layar pelacakan toxin yang dihindari tubuh sejak tidak merokok.
///
/// Menampilkan daftar zat berbahaya berdasarkan estimasi rokok yang tidak
/// dihisap dari biodata berdampingan dengan aktual dari catatan konsumsi
/// (`MetrikBerhentiHelper`).
class ToxinPelacakanScreen extends ConsumerStatefulWidget {
  const ToxinPelacakanScreen({super.key});

  @override
  ConsumerState<ToxinPelacakanScreen> createState() =>
      _ToxinPelacakanScreenState();
}

class _ToxinPelacakanScreenState extends ConsumerState<ToxinPelacakanScreen> {
  @override
  void initState() {
    super.initState();
    L.i('ToxinPelacakanScreen initState');
  }

  @override
  void dispose() {
    L.i('ToxinPelacakanScreen dispose');
    super.dispose();
  }

  void _bukaKonsumsiRokok() {
    unawaited(
      Nav.to(context, const KonsumsiRokokScreen()).catchError((
        Object e,
        StackTrace s,
      ) {
        L.e('Gagal navigasi ke Konsumsi Rokok: $e $s');
        return null;
      }),
    );
  }

  void _bukaFormBiodata() {
    unawaited(
      Nav.to(
        context,
        const FormBiodata(buatPertama: false),
      ).catchError((Object e, StackTrace s) {
        L.e('Gagal navigasi ke Form Biodata: $e $s');
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final biodataAsync = ref.watch(biodataProvider);
    final konsumsiAsync = ref.watch(konsumsiRokokProvider);

    if (biodataAsync.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (biodataAsync.hasError) {
      L.e(
        'biodataAsync error: ${biodataAsync.error} ${biodataAsync.stackTrace}',
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Pelacakan Toxin')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  const Text('Gagal memuat data'),
                  OutlinedButton(
                    onPressed: () {
                      final _ = ref.refresh(biodataProvider);
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final biodata = biodataAsync.requireValue;
    if (biodata == null) {
      return _buildBiodataNull();
    }

    final tanggalBerhenti = biodata.tanggalMulaiBerhentiMerokok;
    if (tanggalBerhenti == null) {
      return _buildBelumBerhenti();
    }

    final rokokEstimasi = MetrikBerhentiHelper.hitungRokokTidakDiHisapEstimasi(
      biodata,
    );
    final konsumsiList = konsumsiAsync.asData?.value.listKonsumsi;
    final adaCatatan = konsumsiList != null && konsumsiList.isNotEmpty;
    final hariTercatat = adaCatatan
        ? MetrikBerhentiHelper.hitungJumlahHariTercatat(konsumsiList)
        : 0;
    final rokokAktual = adaCatatan
        ? MetrikBerhentiHelper.hitungRokokDihindariAktual(biodata, konsumsiList)
        : 0;

    if (konsumsiAsync.hasError) {
      L.e(
        'konsumsiAsync error: ${konsumsiAsync.error} ${konsumsiAsync.stackTrace}',
      );
    }

    // Fallback seperti badge: aktual bila ada catatan, estimasi bila belum ada.
    final rokokTidakDiHisap = adaCatatan ? rokokAktual : rokokEstimasi;

    if (rokokTidakDiHisap == 0) {
      return _buildBelumAdaRokokDiHindari();
    }

    final daftarToxin = ToxinHitungHelper.hitung(rokokTidakDiHisap);

    return Scaffold(
      appBar: AppBar(title: const Text('Pelacakan Toxin')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text(
                'Zat berbahaya yang dihindari',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Rokok yang tidak dihisap sejak '
                '${FormatTanggal.formatDasar(tanggalBerhenti)}:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Estimasi (baseline): $rokokEstimasi batang',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (konsumsiAsync.isLoading)
                Text(
                  'Menghitung dari catatan…',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else if (konsumsiAsync.hasError)
                Text(
                  'Catatan konsumsi gagal dimuat; menampilkan estimasi.',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else if (!adaCatatan) ...[
                Text(
                  'Belum ada catatan konsumsi — aktual tersedia setelah Anda '
                  'mencatat.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextButton(
                  onPressed: _bukaKonsumsiRokok,
                  child: const Text('Buka Konsumsi Rokok'),
                ),
              ]
              else
                Text(
                  'Dari catatan: $rokokAktual batang dihindari '
                  '(berdasarkan $hariTercatat hari tercatat)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: daftarToxin.length,
                  itemBuilder: (context, index) {
                    final toxin = daftarToxin[index];
                    return Card(
                      key: ValueKey(toxin.nama),
                      child: ListTile(
                        leading: Icon(
                          CupertinoIcons.cloud,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          toxin.nama,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            Text(
                              '${toxin.jenisZat} · '
                              '${toxin.kuantitasDiHindari.toStringAsFixed(1)} unit',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              toxin.efekSingkat,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          'Sumber: ${toxin.sumberReferensi}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Text(
                'Data perkiraan ilustratif berdasarkan referensi kesehatan umum '
                '(WHO / CDC / AHA / ACS), bukan klaim medis aplikasi.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiodataNull() {
    return Scaffold(
      appBar: AppBar(title: const Text('Pelacakan Toxin')),
      body: EmptyStateView(
        ikon: CupertinoIcons.person,
        judul: 'Belum ada data biodata',
        deskripsi:
            'Isi biodata dan tentukan tanggal mulai berhenti untuk melihat '
            'pelacakan toxin.',
        ctaLabel: 'Isi Biodata',
        onCta: _bukaFormBiodata,
      ),
    );
  }

  Widget _buildBelumBerhenti() {
    return Scaffold(
      appBar: AppBar(title: const Text('Pelacakan Toxin')),
      body: EmptyStateView(
        ikon: CupertinoIcons.heart,
        judul: 'Tanggal mulai berhenti belum ditetapkan',
        deskripsi:
            'Isi tanggal mulai berhenti pada biodata untuk melihat '
            'pelacakan toxin.',
        ctaLabel: 'Isi Biodata',
        onCta: _bukaFormBiodata,
      ),
    );
  }

  Widget _buildBelumAdaRokokDiHindari() {
    return Scaffold(
      appBar: AppBar(title: const Text('Pelacakan Toxin')),
      body: EmptyStateView(
        ikon: CupertinoIcons.check_mark_circled,
        judul: 'Belum ada rokok yang dihindari',
        deskripsi:
            'Data toxin akan tersedia setelah Anda melewati hari pertama '
            'smoke-free.',
        ctaLabel: 'Isi Biodata',
        onCta: _bukaFormBiodata,
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/fitur/toxin_pelacakan/state/toxin_pelacakan_state.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/toxin_pelacakan/model/toxin_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'toxin_pelacakan_state.freezed.dart';

/// Status muat data toxin pelacakan.
enum ToxinStatus { belumDimuat, dimuat, error }

/// State hasil perhitungan daftar toxin yang dihindari.
///
/// Tidak ada notifier terpisah untuk state ini; state hanya menampung
/// hasil perhitungan dari [ToxinHitungHelper] yang dikonsumsi langsung di layar.
@freezed
abstract class ToxinPelacakanState with _$ToxinPelacakanState {
  const ToxinPelacakanState._();

  const factory ToxinPelacakanState({
    @Default([]) List<ToxinModel> daftarToxin,
    @Default(ToxinStatus.belumDimuat) ToxinStatus status,
  }) = _ToxinPelacakanState;
}
```


// ============================================================
// FILE: lib/home.dart
// ============================================================

```dart
import 'package:berhenti_merokok/fitur/biodata/screens/biodata_screen.dart';
import 'package:berhenti_merokok/fitur/dashboard/screens/dashboard_screen.dart';
import 'package:berhenti_merokok/fitur/impian/screens/impian_screen.dart';
import 'package:berhenti_merokok/lainnya_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;

  // Tab yang sudah pernah dibuka; awalnya hanya tab 0 (Dashboard).
  final Set<int> _tabTerbuka = {0};

  // GlobalKey per tab agar currentState tetap dapat diakses untuk
  // fitur scroll-to-top setelah tab dibuka. LainnyaScreen adalah
  // StatelessWidget sehingga key-nya tidak bertipe State.
  final GlobalKey _kunciDashboard = GlobalKey();
  final GlobalKey _kunciBiodata = GlobalKey();
  final GlobalKey _kunciImpian = GlobalKey();
  final GlobalKey _kunciLainnya = GlobalKey();

  // Waktu tap terakhir untuk deteksi double-tap pada tab aktif.
  DateTime? _lastTapTime;
  static const Duration _durasiDoubleTap = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saatPilihTab(int i) {
    final sekarang = DateTime.now();
    final lastTap = _lastTapTime;
    final tabSama = i == _selectedIndex;
    final doubleTap =
        tabSama &&
        lastTap != null &&
        sekarang.difference(lastTap) <= _durasiDoubleTap;
    if (doubleTap) {
      _scrollKeAtas(i);
      _lastTapTime = null;
      return;
    }
    if (!tabSama) {
      setState(() {
        _tabTerbuka.add(i);
        _selectedIndex = i;
      });
    }
    _lastTapTime = sekarang;
  }

  void _scrollKeAtas(int i) {
    // Periksa state == null terlebih dahulu (tab belum dibuka) agar tidak crash.
    final state = switch (i) {
      0 => _kunciDashboard.currentState,
      1 => _kunciBiodata.currentState,
      2 => _kunciImpian.currentState,
      _ => _kunciLainnya.currentState,
    };
    if (state == null) {
      return;
    }
    // Hanya panggil scrollToTop() apabila state mengimplementasikan
    // ScrollKeAtas; pada proyek ini layar tab belum menyediakannya.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea dan Padding tepi layar pada lapisan container halaman
      // agar konten tidak tertutup notch/status bar/navigation bar
      // dan tidak menempel pada tepi layar.
      body: IndexedStack(
        index: _selectedIndex,
        children: List<Widget>.generate(4, (i) {
          if (!_tabTerbuka.contains(i)) {
            return const SizedBox.shrink();
          }
          return switch (i) {
            0 => DashboardScreen(key: _kunciDashboard),
            1 => BiodataScreen(key: _kunciBiodata),
            2 => ImpianScreen(key: _kunciImpian),
            _ => LainnyaScreen(key: _kunciLainnya),
          };
        }),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _saatPilihTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(CupertinoIcons.home),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: const Icon(CupertinoIcons.person),
            label: 'Biodata',
          ),
          NavigationDestination(
            icon: const Icon(CupertinoIcons.star),
            label: 'Impian',
          ),
          NavigationDestination(
            icon: const Icon(CupertinoIcons.ellipsis),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/lainnya_screen.dart
// ============================================================

```dart
import 'dart:async';

import 'package:berhenti_merokok/fitur/alasan_berhenti/screens/alasan_berhenti_screen.dart';
import 'package:berhenti_merokok/fitur/diary_craving/screens/diary_craving_screen.dart';
import 'package:berhenti_merokok/fitur/dummy/screens/dummy_screen.dart';
import 'package:berhenti_merokok/fitur/kalender_smoke_free/screens/kalender_smoke_free_screen.dart';
import 'package:berhenti_merokok/fitur/konsumsi_rokok/screens/konsumsi_rokok_screen.dart';
import 'package:berhenti_merokok/fitur/pemulihan_kesehatan/screens/pemulihan_kesehatan_screen.dart';
import 'package:berhenti_merokok/fitur/pengaturan/screens/pengaturan_screen.dart';
import 'package:berhenti_merokok/fitur/sos_craving/screens/sos_craving_screen.dart';
import 'package:berhenti_merokok/fitur/toxin_pelacakan/screens/toxin_pelacakan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_global_saya/core_shared.dart';

/// Navigasi pintasan yang aman: Nav.to mengembalikan Future yang bisa gagal,
/// jadi wajib di-`unawaited` dengan `.catchError` yang mencatat `L.e` agar
/// error tidak menjadi unhandled. Diekstrak agar pola tidak diulang per item.
void _navigasi(BuildContext context, Widget page, String nama) {
  unawaited(
    Nav.to(context, page).catchError((Object e, StackTrace s) {
      L.e('Gagal navigasi ke $nama: $e $s');
      return null;
    }),
  );
}

class LainnyaScreen extends StatelessWidget {
  const LainnyaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Struktur grup statis; item baru masuk ke grup yang sesuai.
    // DummyScreen hanya tampil pada build debug/development.
    final grup = <_GrupLainnya>[
      _GrupLainnya(
        label: 'Dukungan',
        items: [
          _ItemLainnya(
            ikon: Icons.sos,
            label: 'SOS Craving',
            ontap: () => _navigasi(context, const SosCravingScreen(), 'SOS Craving'),
          ),
          _ItemLainnya(
            ikon: CupertinoIcons.heart,
            label: 'Alasan Berhenti',
            ontap: () => _navigasi(context, const AlasanBerhentiScreen(), 'Alasan Berhenti'),
          ),
        ],
      ),
      _GrupLainnya(
        label: 'Riwayat & Data',
        items: [
          _ItemLainnya(
            ikon: CupertinoIcons.smoke,
            label: 'Konsumsi Rokok',
            ontap: () => _navigasi(context, const KonsumsiRokokScreen(), 'Konsumsi Rokok'),
          ),
          _ItemLainnya(
            ikon: CupertinoIcons.book,
            label: 'Diary Craving',
            ontap: () => _navigasi(context, const DiaryCravingScreen(), 'Diary Craving'),
          ),
          _ItemLainnya(
            ikon: CupertinoIcons.calendar,
            label: 'Kalender Smoke-Free',
            ontap: () => _navigasi(context, const KalenderSmokeFreeScreen(), 'Kalender Smoke-Free'),
          ),
        ],
      ),
      _GrupLainnya(
        label: 'Alat',
        items: [
          _ItemLainnya(
            ikon: CupertinoIcons.bandage,
            label: 'Pemulihan Kesehatan',
            ontap: () => _navigasi(context, const PemulihanKesehatanScreen(), 'Pemulihan Kesehatan'),
          ),
          _ItemLainnya(
            ikon: CupertinoIcons.cloud,
            label: 'Pelacakan Toxin',
            ontap: () => _navigasi(context, const ToxinPelacakanScreen(), 'Pelacakan Toxin'),
          ),
        ],
      ),
      _GrupLainnya(
        label: 'Pengaturan',
        items: [
          _ItemLainnya(
            ikon: CupertinoIcons.gear,
            label: 'Pengaturan',
            ontap: () => _navigasi(context, const PengaturanScreen(), 'Pengaturan'),
          ),
          if (kDebugMode)
            _ItemLainnya(
              ikon: CupertinoIcons.wrench,
              label: 'Dummy',
              ontap: () => _navigasi(context, DummyScreen(), 'Dummy'),
            ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lainnya')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final g in grup) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Text(
                  g.label,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (final item in g.items)
                ListTile(
                  leading: Icon(item.ikon),
                  onTap: item.ontap,
                  title: Text(item.label),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GrupLainnya {
  const _GrupLainnya({required this.label, required this.items});

  final String label;
  final List<_ItemLainnya> items;
}

class _ItemLainnya {
  const _ItemLainnya({
    required this.ikon,
    required this.label,
    required this.ontap,
  });

  final IconData ikon;
  final String label;
  final VoidCallback ontap;
}
```


// ============================================================
// FILE: lib/main.dart
// ============================================================

```dart
import 'package:berhenti_merokok/app.dart';
import 'package:berhenti_merokok/shared/db/sqflite/sqflite.dart';
import 'package:berhenti_merokok/shared/notifikasi/notifikasi_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_global_saya/core_shared.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

export 'package:berhenti_merokok/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  try {
    await AppDatabase.database;
  } on Exception catch (e, s) {
    p('Gagal inisialisasi database: $e $s');
    rethrow;
  }
  try {
    await NotifikasiService.inisialisasi();
  } on Exception catch (e, s) {
    p('Gagal inisialisasi notifikasi: $e $s');
  } on UnsupportedError catch (e, s) {
    p('Platform tidak mendukung notifikasi: $e $s');
  }
  runApp(const ProviderScope(child: App()));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotifikasiService.cekNotifikasiSaatBuka();
  });
}
```


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


