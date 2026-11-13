---
name: riverpod-pola
description: "Trigger: saat memakai Riverpod | Pola standar: Notifier CRUD keepAlive, ref.watch/ref.read, family providers, autoDispose, overrides testing, ProviderScope & ProviderContainer, Vsync scheduleRefresh/scheduleDispose."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Pola Riverpod Standar

Skill ini mendokumentasikan pola Riverpod yang wajib diterapkan di proyek ini.

## 1. Notifier Database (CRUD)

### Aturan
- Gunakan `@Riverpod(keepAlive: true)` agar state tidak hilang saat tidak ada listener.
- Method `build()` wajib memanggil `_ambilSemua()` yang mengambil data dari database.
- CRUD update state **setelah** operasi DB berhasil.
- Catch `Exception` dan `rethrow` agar error propagate ke UI.

```dart
@Riverpod(keepAlive: true)
class BiodataNotifier extends _$BiodataNotifier {
  @override
  Future<BiodataModel?> build() => _ambilSemua();

  Future<BiodataModel?> _ambilSemua() async {
    final row = await SqfliteOp.ambilSatu(namaTabel: NamaTabel.biodata);
    return row != null ? BiodataModel.fromSqflite(row) : null;
  }

  Future<void> simpan(BiodataModel model) async {
    await SqfliteOp.sisipkan(namaTabel: NamaTabel.biodata, data: model.toSqflite());
    state = AsyncValue.data(await _ambilSemua());
  }
}
```

### Referensi
- `notifier-crud-database` skill untuk detail lengkap

## 2. Provider Usage: `ref.watch` vs `ref.read`

### Aturan
- **`ref.watch(provider)`** di `build()` widget → rebuild otomatis saat state berubah.
- **`ref.read(provider)`** di event handler / callback → tidak trigger rebuild.
- **JANGAN** `ref.watch` di callback/event handler (memory leak, rebuild tidak perlu).

```dart
// BENAR: watch di build
@override
Widget build(BuildContext context, WidgetRef ref) {
  final biodataAsync = ref.watch(biodataProvider);
  // ...
}

// BENAR: read di callback
onPressed: () {
  final notifier = ref.read(biodataProvider.notifier);
  notifier.simpan(model);
}

// SALAH: watch di callback
onPressed: () {
  final data = ref.watch(biodataProvider); // JANGAN
}
```

## 3. Consumer Widget & `Consumer`

### Aturan
- Gunakan `ConsumerWidget` / `ConsumerStatefulWidget` untuk akses `ref` di `build`.
- Untuk optimasi, bungkus bagian kecil saja dengan `Consumer(builder: (context, ref, _) => ...)`.
- **JANGAN** bungkus seluruh halaman besar dengan `Consumer` jika hanya sedikit butuh `ref`.

```dart
// Baik: ConsumerWidget
class BiodataScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodataAsync = ref.watch(biodataProvider);
    // ...
  }
}

// Baik: Consumer granular
class _BiodataContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata = ref.watch(biodataProvider.select((v) => v.valueOrNull));
    return Text(biodata?.nama ?? '-');
  }
}
```

## 4. Family Providers (Parameterized)

### Aturan
- Gunakan `.family` untuk provider yang butuh parameter (mis. ID item).
- Parameter harus **immutable** dan **comparable** (primitif, String, record).
- Key family harus stabil untuk caching yang benar.

```dart
@riverpod
Future<ImpianModel?> impianDetail(Ref ref, String impianId) async {
  final row = await SqfliteOp.ambilSatu(
    namaTabel: NamaTabel.impian,
    where: 'id = ?',
    whereArgs: [impianId],
  );
  return row != null ? ImpianModel.fromSqflite(row) : null;
}

// Penggunaan
final impianAsync = ref.watch(impianDetailProvider(impianId));
```

## 5. `autoDispose` untuk Provider Sementara

### Aturan
- Gunakan `@riverpod` + `autoDispose` (atau `@Riverpod(autoDispose: true)`) untuk provider yang **hanya** dibutuhkan saat layar aktif.
- Contoh: form controller, filter sementara, pencarian.
- State otomatis dibuang saat tidak ada listener.

```dart
@Riverpod(autoDispose: true)
class FormCravingController extends _$FormCravingController {
  @override
  FormCravingState build() => const FormCravingState();
  
  void updateTrigger(String t) => state = state.copyWith(trigger: t);
}

// Di widget: ref.watch(formCravingControllerProvider) // auto dispose saat unmount
```

## 6. Provider Overrides untuk Testing

### Aturan
- Gunakan `ProviderScope(overrides: [...], child: ...)` untuk mock provider di test.
- Override dengan `Provider.overrideWithValue` atau `Provider.overrideWithProvider`.

```dart
// Test widget
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      biodataProvider.overrideWithValue(AsyncValue.data(biodataDummy)),
    ],
    child: MaterialApp(home: BiodataScreen()),
  ),
);
```

## 7. `select` untuk Optimasi Rebuild

### Aturan
- Gunakan `ref.watch(provider.select((state) => state.fieldYangDibutuhkan))` agar widget hanya rebuild saat field tertentu berubah.
- Hindari rebuild seluruh widget saat hanya butuh subset state.

```dart
// Hanya rebuild saat nama berubah
final nama = ref.watch(biodataProvider.select((v) => v.valueOrNull?.nama));

// Hanya rebuild saat loading status berubah
final isLoading = ref.watch(biodataProvider.select((v) => v.isLoading));
```

## 8. AsyncValue Pattern di UI

### Aturan
- Tangani `isLoading` → `hasError` → `requireValue` (early return).
- Gunakan `asData?.value` untuk akses opsional tanpa throw.

```dart
final async = ref.watch(provider);
if (async.isLoading) return LoadingView();
if (async.hasError) return ErrorRetry(onRetry: () => ref.refresh(provider));
final data = async.requireValue; // atau async.asData?.value untuk opsional
```

### Referensi
- `penanganan-async-data-kosong`, `penanganan-asyncvalue-berkali` skills

## 9. `WidgetRef` Tidak Boleh Dioper ke Widget Anak

### Aturan
- DILARANG mengirim `WidgetRef` dari parent ke widget anak lewat konstruktor lalu menyimpannya di field `State` (melanggar siklus hidup element; `ref` terikat pada element pembuatnya dan bisa dipakai setelah element tidak aktif).
- Widget anak yang butuh `ref` wajib `ConsumerStatefulWidget` + `ConsumerState` dan memakai `ref` bawaan langsung di callback/`build`.
- Helper top-level boleh menerima `WidgetRef ref` sebagai parameter saat *pemanggilan* (bukan disimpan di field objek) — pola ini dipakai mis. `tampilkanDanSimpanHasilIntervensi(context: context, ref: ref, ...)`.
- Widget teknik SOS yang interaktif (timer, animasi napas) diekstrak ke file terpisah `lib/fitur/sos_craving/widgets/*_view.dart` sebagai `ConsumerStatefulWidget` (contoh `napas_478_view.dart`, `timer_craving_view.dart`, `distraksi_view.dart`, `urge_surfing_view.dart`).

## 10. Larangan

- **DILARANG** `ref.watch` di luar `build` (callback, initState, effect).
- **DILARANG** mutate state langsung (`state = ...`) di luar Notifier class.
- **DILARANG** `ProviderScope` nested di widget (hanya di `main.dart` / `app.dart`).
- **DILARANG** family parameter yang mutable (List, Map, custom object tanpa equality).

## 11. ProviderScope & ProviderContainer

### Aturan
1. Wajib memasang `ProviderScope` di root widget tree (biasanya `main.dart` atau `app.dart`) agar semua provider dapat diakses di seluruh aplikasi.
2. Gunakan `ProviderScope.containerOf(BuildContext context, {bool listen = true})` untuk mendapatkan `ProviderContainer` dari widget tree.
3. `containerOf(context, listen: true)` mendaftarkan dependensi ke InheritedWidget sehingga widget akan rebuild saat provider berubah; gunakan `listen: false` jika hanya butuh akses baca tanpa trigger rebuild.
4. Parameter `overrides` hanya berlaku untuk `ProviderScope` itu sendiri dan keturunannya (descendants), bukan untuk widget induk (ancestors).
5. `observers` digunakan untuk memantau perubahan provider secara global di dalam scope tersebut.
6. `retry` mengatur logika retry default untuk provider yang terkait dengan container ini.
7. `ProviderContainer` dibuat dalam `initState` dari `ProviderScopeState` dan dibuang dalam `dispose` untuk mengelola siklus hidup container.

### Larangan
- DILARANG membuat `ProviderScope` nested di dalam widget lain (hanya diperbolehkan di `main.dart` / `app.dart`).
- DILARANG memanggil `containerOf()` di konteks yang tidak memiliki `ProviderScope` sebagai ancester (akan melempar `StateError('No ProviderScope found')`).

## 12. UncontrolledProviderScope

### Aturan
1. `UncontrolledProviderScope` expose `ProviderContainer` ke widget tree tanpa mengelola siklus hidupnya (tidak akan dispose container saat widget dihancurkan).
2. Tanggung jawab untuk dispose `ProviderContainer` ada pada pemanggil, bukan pada widget ini.
3. Gunakan `ProviderScope` (bukan `UncontrolledProviderScope`) jika ingin siklus hidup container terkelola otomatis oleh framework.

### Larangan
- DILARANG mengandalkan `UncontrolledProviderScope` untuk dispose container secara otomatis.

## 13. Vsync & scheduleRefresh / scheduleDispose

### Aturan
1. `_UncontrolledProviderScopeState` mengimplementasikan `Vsync` untuk mengelola task refresh dan dispose melalui `setState` serta `Timer`.
2. `scheduleRefresh(Task task)` menjadwalkan task untuk dijalankan pada frame berikutnya menggunakan `Timer(Duration.zero)` dan `setState`.
3. `scheduleDispose(Task task)` menjadwalkan task dispose melalui `Future.microtask` agar dijalankan setelah build tree selesai.
4. Jangan memodifikasi provider di dalam siklus hidup widget (`build`, `initState`, `dispose`, `didUpdateWidget`, `didChangeDependencies`) karena dapat menyebabkan state tidak konsisten di antara widget yang listen ke provider yang sama.

### Larangan
- DILARANG memodifikasi provider secara langsung di dalam lifecycle method widget.

## Referensi Aturan Sumber

- `aturan_bersama.md` — Notifier CRUD, keepAlive, build/_ambilSemua, DB via SqfliteOp
- `aturan_khusus.md` — AsyncValue handling, multiple providers
- `notifier-crud-database` skill — detail Notifier CRUD

## Referensi Commit Terkait

- `3b67d309` — BiodataNotifier, AlasanBerhentiNotifier, dll.
- `19f43e5` — BadgeScreen multiple provider handling
- `a15acd9603fe5d1251afa4acc3817e7e9c1607b1` — SOS Craving: widget anak menerima `ref` via konstruktor (dilanggar)
- `fbbb0906d08d2590caa8c7829595ea7fa4e513a5` — widget teknik SOS diekstrak ke file `*_view.dart` sebagai `ConsumerStatefulWidget`
- `4dd0cdb5d101413a839c37c3dfb8c594aeef60c2` — `tampilkanDanSimpanHasilIntervensi` menerima `ref` sebagai parameter saat pemanggilan
