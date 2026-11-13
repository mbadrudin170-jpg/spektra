

// ============================================================
// FILE: docs/core_shared.md
// ============================================================



// ============================================================
// FILE: docs/kilo/kilo_global.txt
// ============================================================
{
  "$schema": "https://app.kilo.ai/config.json",
  "model": "kilo/kilo-auto/free",
  "small_model": "kilo/kilo-auto/free",
  "subagent_model": "kilo/kilo-auto/free",
  "agent": {
    "code": {
      "model": "openrouter/thinkingmachines/inkling-2-small:free",
      "prompt": "{file:./prompts/code.md}",
      "variant": "max"
    },
    "ask": {
      "model": "kilo/kilo-auto/free",
      "variant": "max",
      "prompt": "{file:./prompts/ask.md}"
    },
    "plan": {
      "model": "kilo/kilo-auto/free"
    },
    "orchestrator": {
      "model": "kilo/kilo-auto/free"
    },
    "debug": {
      "model": "kilo/kilo-auto/free",
      "prompt": "{file:./prompts/debug.md}"
    },
    "compaction": {
      "model": "kilo/kilo-auto/free"
    }
  },

  "permission": {
    "bash": {
      "*": "ask",
      "git status *": "allow",
      "git status": "allow",
      "git diff *": "allow",
      "git diff": "allow",
      "git log *": "allow",
      "git log": "allow",
      "git show *": "allow",
      "git branch *": "allow",
      "git branch": "allow",
      "git rev-parse *": "allow",
      "git remote *": "allow",
      "git blame *": "allow",
      "ls *": "allow",
      "ls": "allow",
      "pwd": "allow",
      "which *": "allow",
      "find *": "allow",
      "cat *": "deny",
      "head *": "allow",
      "tail *": "allow",
      "rg *": "allow",
      "grep *": "allow",
      "echo *": "allow",
      "flutter analyze *": "allow",
      "flutter analyze": "allow",
      "flutter test *": "allow",
      "flutter test": "allow",
      "dart format *": "allow",
      "dart format": "allow",
      "dart analyze *": "allow",
      "dart fix *": "allow",
      "flutter pub get *": "allow",
      "flutter pub get": "allow",
      "flutter pub add *": "allow",
      "flutter pub remove *": "allow",
      "wc *": "allow",
      "sort *": "allow",
      "sed *": "deny",
      "webfetch *": "allow",
      "cp *": "ask",
      "python3 *": "deny",
      "flutter *": "allow",
      "dart *": "allow",
      "timeout *": "allow",
      "date *": "allow",
      "mkdir *": "allow"
    },
    "external_directory": {
      "/home/mbadrudin170/.pub-cache/*": "allow",
      "/home/mbadrudin170/.config/kilo/*": "allow",
      "/google/flutter/*": "allow",
      "/home/mbadrudin170/.codeoss/extensions/kilocode.kilo-code-7.8.27-linux-x64/*": "allow",
      "/home/mbadrudin170/share_global_saya/lib/src/utils/*": "allow",
      "/home/mbadrudin170/share_global_saya/*": "allow"
    },
    "read": {
      "*": "allow",
      "*.env": "deny",
      "*.env.*": "deny",
      "*.env.example": "allow"
    },
    "kilo_memory_recall": {
      "*": "allow"
    }
  },
  "web_search": true,
  "indexing": {
    "enabled": true
  },
  "instructions": [
    "AGENTS.md",
    ".agents/rules/global/aturan_skill.md",
    ".agents/rules/global/format_PRD.md",
    ".agents/rules/global/format_hasil_diskusi.md",
    ".agents/rules/global/format_task.md",
    "SKILLS_INDEX.md"
  ],
  "auto_collapse_reasoning": true,
  "terminal_command_display": "collapsed",
  "experimental": {
    "batch_tool": true,
    "shared_agent_board": true,
    "openTelemetry": false,
    "continue_loop_on_deny": true,
    "multi_project_agent_manager": true,
    "codebase_search": false,
    "mcp_timeout": 30000
  },
  "default_agent": "code",
  "commit_message": {
    "prompt": "Buat pesan commit mengikuti format Conventional Commits berdasarkan diff perubahan yang di-stage. Aturan: (1) Format wajib `<type>(<scope>): <deskripsi>` dengan type salah satu dari feat, fix, docs, style, refactor, test, chore, perf, build, ci; scope opsional, diisi nama area/fitur yang jelas (mis. sqflite, biodata, command) bila ada. (2) Deskripsi menggunakan bahasa Indonesia baku, diawali huruf kecil, maksimal 72 karakter, bentuk imperatif, tanpa tanda titik di akhir. (3) Isi commit harus sesuai dengan diff yang di-stage; dilarang mengarang perubahan yang tidak ada di diff. (4) Jawab hanya dengan pesan commit: tanpa kata pengantar, tanpa penjelasan, tanpa backtick, dan tanpa tanda kutip. (5) Bila perubahan kompleks, tambahkan body setelah satu baris kosong; body juga bahasa Indonesia baku dan difokuskan pada alasan perubahan, bukan mengulang diff."
  },
  "compaction": {
    "auto": true,
    "prune": true
  },
  "watcher": {
    "ignore": [
      ".env",
      ".git/**",
      ".dart_tool/**",
      "build/**",
      "android/.gradle/**",
      "ios/.symlinks/**",
      "ios/Flutter/**",
      "ios/Flutter/Generated.xcconfig",
      "ios/Flutter/flutter_export_environment.sh",
      "**/Pods/**",
      "**/Podfile.lock",
      "generated_plugin_registrant.dart",
      "**/*.g.dart",
      "**/*.freezed.dart",
      ".idea/**",
      ".vscode/**",
      "*.iml",
      "*.tmp",
      "*.swp",
      "*~",
      "**/*.log",
      "coverage/**",
      "lcov.info",
      "**/*.apk",
      "**/*.aab",
      "**/*.ipa",
      ".fvm/**",
      ".fvmrc"
    ]
  },
  "reasoning_display": "headline",
  "code_edit_display": "collapsed",
  "mcp_tool_display": "collapsed",
  "disabled_providers": [],
  "provider": {},
  "skills": {
    "paths": [
      ".agents/skills/custom",
      ".agents/skills",
      ".agents/skills/bawaan"
    ]
  },
  "retention": {
    "enabled": true
  }
}



// ============================================================
// FILE: docs/lib.md
// ============================================================
// ============================================================
// FILE: lib/app.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

import 'package:spektra/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```


// ============================================================
// FILE: lib/home.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```


// ============================================================
// FILE: lib/main.dart
// ============================================================

```dart
import 'package:flutter/material.dart';

import 'package:spektra/app.dart';

void main() {
  runApp(const MyApp());
}
```





// ============================================================
// FILE: docs/model.md
// ============================================================
# DAFTAR SEMUA FILE MODEL

Dikumpulkan pada: 2026-11-13 18:09:29

---


## 📊 STATISTIK

- **Total file model:** 0
- **Total baris kode:** 0
- **File output:** docs/model.md



// ============================================================
// FILE: docs/rencana_integrasi_profile.md
// ============================================================
# Rencana Integrasi: ProfilePageCustom + ProfileOrangPage

## 1. Tujuan

Menggabungkan logika UI dari `profile_orang_page.dart` ke dalam `profile_page_custom.dart` agar:

- Menghindari duplikasi kode profil pengguna
- Memiliki satu halaman profil yang seragam
- Tetap mempertahankan fitur khusus profil orang lain (follow, chat, laporkan, blokir)
- Selaras dengan struktur `NestedScrollView` + `SliverAppBar` yang sudah ada di `profile_page_custom.dart`

---

## 2. Analisis Komponen

### 2.1 Komponen yang SUDAH ADA di `profile_page_custom.dart`

- Struktur `NestedScrollView` + `SliverAppBar`
- `TabController` dengan 2 tab (Informasi, Momen)
- Galeri foto dengan upload
- Info card dasar (Nama, Nomor ID, Negara, Autentikasi, Bio, Hobi)
- `FormatUtils` untuk tanggal
- Widget `_buildGalleryItem`, `_buildInfoCard`

### 2.2 Komponen yang PERLU DITAMBAHKAN dari `profile_orang_page.dart`

| Komponen                           | Fungsi                                   | Prioritas    |
| ---------------------------------- | ---------------------------------------- | ------------ |
| Badge Premium                      | Menampilkan status premium pengguna lain | **TINGGI**   |
| Status Online/Offline              | Menampilkan ketersediaan pengguna        | **TINGGI**   |
| Tombol Follow/Berhenti Follow      | Fitur sosial follow                      | **TINGGI**   |
| Tombol Chat                        | Memulai percakapan                       | **TINGGI**   |
| Menu Options (Laporkan & Blokir)   | Aksi terhadap pengguna lain              | **TINGGI**   |
| Level Indicator Lengkap            | Level Skor + Berlian + Kekayaan          | **MENENGAH** |
| Hobi dengan Chips                  | Tampilan hobi dalam Wrap                 | **MENENGAH** |
| Alamat dengan privasi `showAlamat` | Menampilkan/sembunyikan alamat           | **MENENGAH** |
| Umur (dari tanggal lahir)          | Menghitung umur                          | **MENENGAH** |
| Jenis Kelamin (teks)               | "Laki-laki"/"Perempuan"                  | **RENDAH**   |

### 2.3 Komponen yang PERLU DIADAPTASI

| Komponen                  | Asal                      | Adaptasi yang Diperlukan                                                             |
| ------------------------- | ------------------------- | ------------------------------------------------------------------------------------ |
| `_buildProfilePhoto`      | `profile_orang_page.dart` | Integrasi dengan `_selectedImageUrl` di header                                       |
| `_buildVerificationBadge` | `profile_orang_page.dart` | Sesuaikan dengan asset gambar yang sudah ada di `profile_page_custom.dart`           |
| `_buildLevelIndicator`    | `profile_orang_page.dart` | Integrasi dengan widget `LevelKekayaanWidget` dan `LevelPesonaWidget` yang sudah ada |
| `_buildHobiSection`       | `profile_orang_page.dart` | Sesuaikan dengan gaya `_buildInfoCard` yang sudah ada                                |

---

## 3. Perubahan Struktural

### 3.1 Modifikasi `ProfilePageCustom`

**File:** `lib/fitur/saya/page/profile_page_custom.dart`

#### 3.1.1 Tambahkan Parameter `isMe`

```dart
class ProfilePageCustom extends ConsumerStatefulWidget {
  final bool isMe;
  final String idPengguna;

  const ProfilePageCustom({
    super.key,
    required this.isMe,
    required this.idPengguna,
  });
}
```

#### 3.1.2 Tambahkan Import yang Diperlukan

```dart
import 'package:service/fitur/pengguna/enum/jenis_kelamin_enum.dart';
import 'package:service/fitur/pengguna/utils/kekayaan_utils.dart';
import 'package:service/fitur/pengguna/utils/skor_utils.dart';
import 'package:service/fitur/premium/widget/premium_badge_widget.dart';
import 'package:service/fitur/saya/widget/tombol_opsi_tampilan_widget.dart';
import 'package:service/fitur/sosial/notifier/blokir_notifier.dart';
import 'package:service/fitur/sosial/notifier/relasi_notifier.dart';
import 'package:service/shared/tema/app_size.dart';
```

#### 3.1.3 Tambahkan State Baru

```dart
class _ProfilePageCustomState extends ConsumerState<ProfilePageCustom>
    with SingleTickerProviderStateMixin {
  // ... existing state ...
  OpsiTampilan _opsiTampilan = OpsiTampilan.informasi;
  ProviderSubscription<AsyncValue<RelasiState>>? _relasiSub;
  bool _isLoading = false;
}
```

#### 3.1.4 Modifikasi `initState` dan `dispose`

- Tambahkan listener untuk `relasiProvider` di `initState`
- Tutup `_relasiSub` di `dispose`

#### 3.1.5 Tambahkan Fungsi-fungsi Baru

- `_calculateAge(DateTime? tanggalLahir)` - menghitung umur
- `_toggleFollow()` - toggle follow/unfollow
- `_bukaChat()` - buka chat dengan pengguna
- `_showMenuOptions(BuildContext context)` - tampilkan menu laporkan/blokir
- `_showReportDialog(BuildContext context)` - dialog laporkan
- `_showBlockDialog(BuildContext context)` - dialog blokir
- `_updateFollowingStatus()` - update status follow

#### 3.1.6 Modifikasi `build` Method

- Tampilkan badge premium jika `!isMe && user.tanggalAkhirPremium?.isAfter(DateTime.now()) ?? false`
- Tampilkan status online jika `!isMe`
- Tampilkan tombol Follow/Chat jika `!isMe`
- Tampilkan menu options (Laporkan/Blokir) jika `!isMe`
- Ganti tab "Informasi"/"Momen" dengan `TombolOpsiTampilanWidget` jika `!isMe`

#### 3.1.7 Tambahkan Widget Baru

- `_buildProfileHeader(PenggunaModel user, ColorScheme colorScheme)` - header dengan foto, nama, badge premium, status online
- `_buildProfilePhoto(PenggunaModel user)` - foto profil dengan gradient border
- `_buildOnlineStatus(PenggunaModel user)` - indikator online/offline
- `_buildLevelIndicator(PenggunaModel user)` - level skor, berlian, kekayaan
- `_buildActionButtons(...)` - tombol Follow dan Chat
- `_buildInfoInformasi(ColorScheme colorScheme)` - informasi lengkap (alamat, umur, jenis kelamin, hobi)
- `_buildHobiSection(List<String> hobi, ColorScheme colorScheme)` - chips hobi
- `_buildVerificationBadge(ColorScheme colorScheme)` - badge verifikasi
- `_buildInfoRow(...)` - baris info umum

### 3.2 Modifikasi `ProfileOrangPage`

**File:** `lib/fitur/saya/page/profile_orang_page.dart`

#### 3.2.1 Ganti menjadi wrapper ke `ProfilePageCustom`

```dart
class ProfileOrangPage extends ConsumerWidget {
  final PenggunaModel penggunaLain;

  const ProfileOrangPage({super.key, required this.penggunaLain});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfilePageCustom(
      isMe: false,
      idPengguna: penggunaLain.id,
    );
  }
}
```

---

## 4. Daftar Tugas Konkret

### Phase 1: Preparasi (Tidak Mengubah Kode)

- [x] **TASK-01**: Baca dan analisis kedua file profil
- [x] **TASK-02**: Identifikasi komponen yang perlu dipertahankan
- [x] **TASK-03**: Buat rencana integrasi (dokumen ini)

### Phase 2: Modifikasi `profile_page_custom.dart`

- [ ] **TASK-04**: Tambahkan parameter `isMe` ke `ProfilePageCustom`
- [ ] **TASK-05**: Tambahkan import yang diperlukan (premium, sosial, utils)
- [ ] **TASK-06**: Tambahkan state `_opsiTampilan`, `_relasiSub`, `_isLoading`
- [ ] **TASK-07**: Modifikasi `initState` untuk listen `relasiProvider`
- [ ] **TASK-08**: Modifikasi `dispose` untuk tutup `_relasiSub`
- [ ] **TASK-09**: Tambahkan fungsi `_calculateAge()`
- [ ] **TASK-10**: Tambahkan fungsi `_toggleFollow()`
- [ ] **TASK-11**: Tambahkan fungsi `_bukaChat()`
- [ ] **TASK-12**: Tambahkan fungsi `_showMenuOptions()`
- [ ] **TASK-13**: Tambahkan fungsi `_showReportDialog()`
- [ ] **TASK-14**: Tambahkan fungsi `_showBlockDialog()`
- [ ] **TASK-15**: Tambahkan fungsi `_updateFollowingStatus()`
- [ ] **TASK-16**: Modifikasi `build()` untuk kondisi `isMe`
- [ ] **TASK-17**: Tambahkan widget `_buildProfileHeader()`
- [ ] **TASK-18**: Tambahkan widget `_buildProfilePhoto()`
- [ ] **TASK-19**: Tambahkan widget `_buildOnlineStatus()`
- [ ] **TASK-20**: Tambahkan widget `_buildLevelIndicator()`
- [ ] **TASK-21**: Tambahkan widget `_buildActionButtons()`
- [ ] **TASK-22**: Tambahkan widget `_buildInfoInformasi()`
- [ ] **TASK-23**: Tambahkan widget `_buildHobiSection()`
- [ ] **TASK-24**: Tambahkan widget `_buildVerificationBadge()`
- [ ] **TASK-25**: Tambahkan widget `_buildInfoRow()`

### Phase 3: Modifikasi `profile_orang_page.dart`

- [ ] **TASK-26**: Ganti `ProfileOrangPage` menjadi wrapper ke `ProfilePageCustom`

### Phase 4: Verifikasi

- [ ] **TASK-27**: Jalankan `flutter analyze` pada kedua file
- [ ] **TASK-28**: Test build untuk memastikan tidak ada error kompilasi
- [ ] **TASK-29**: Verifikasi semua fitur profil orang lain masih berfungsi
- [ ] **TASK-30**: Verifikasi profil sendiri tetap berfungsi

---

## 5. Dependensi yang Diperlukan

### 5.1 Model

- `PenggunaModel` (sudah ada)
- `RelasiState` (sudah ada)
- `GaleriUserModel` (sudah ada)

### 5.2 Notifier

- `penggunaProvider` (sudah ada)
- `galeriUserProvider` (sudah ada)
- `momenProvider` (sudah ada)
- `relasiProvider` (sudah ada)
- `blokirProvider` (sudah ada)
- `pesertaPercakapanProvider` (sudah ada)
- `percakapanProvider` (sudah ada)

### 5.3 Widget

- `PremiumBadge` (sudah ada)
- `TombolOpsiTampilanWidget` (sudah ada)
- `JenisKelaminWidget` (sudah ada)
- `LevelKekayaanWidget` (sudah ada)
- `LevelPesonaWidget` (sudah ada)

### 5.4 Utils

- `SkorUtils` (sudah ada)
- `KekayaanUtils` (sudah ada)
- `FormatUtils` (sudah ada)
- `Nav` (sudah ada)

---

## 6. Risiko dan Mitigasi

| Risiko                                          | Dampak             | Mitigasi                                           |
| ----------------------------------------------- | ------------------ | -------------------------------------------------- |
| Kompleksitas `build()` meningkat                | Sulit maintain     | Pisahkan ke widget kecil yang jelas                |
| State `_relasiSub` bocor                        | Memory leak        | Pastikan `dispose()` menutup subscription          |
| Perubahan mengubah perilaku profil sendiri      | Bug                | Test kedua mode (`isMe: true/false`)               |
| Duplikasi kode dengan `profile_orang_page.dart` | Maintenance burden | Setelah integrasi, hapus `profile_orang_page.dart` |

---

## 7. Kriteria Sukses

1. `profile_page_custom.dart` mendukung kedua mode (`isMe: true` dan `isMe: false`)
2. `profile_orang_page.dart` menjadi wrapper sederhana ke `ProfilePageCustom`
3. Tidak ada duplikasi kode UI profil
4. Semua fitur profil orang lain tetap berfungsi (follow, chat, laporkan, blokir)
5. `flutter analyze` lulus tanpa error/warning
6. UI tetap konsisten dengan desain yang ada

---

## 8. Catatan Tambahan

- **Jangan menghapus `profile_orang_page.dart`** sampai integrasi sudah diverifikasi bekerja
- **Gunakan `FormatUtils`** untuk semua format tanggal (sesuai aturan proyek)
- **Gunakan `withValues(alpha:)`** bukan `withOpacity()` (sesuai aturan deprecated)
- **Gunakan `surfaceContainerHighest`** bukan `surfaceVariant` (sesuai aturan deprecated)
- Seluruh komentar dan teks UI menggunakan Bahasa Indonesia



// ============================================================
// FILE: docs/snippet.md
// ============================================================
// ============================================================
// FILE: .vscode/aturan.code-snippets
// ============================================================

```json
{
	"Snippet baru": {
		"scope": "json,jsonc,snippets",
		"prefix": "/snippet_baru",
		"body": [
			"\"$1\": {",
			"    \"scope\": \"${2|dart,markdown|}\",",
			"    \"prefix\": \"$3\",",
			"    \"body\": [",
			"        \"$4\"",
			"    ],",
			"    \"description\": \"$5\"",
			"},"
		],
		"description": "Membuat template snippet baru (pilih scope: dart/markdown)"
	},
	"Aturan Komentar": {
		"scope": "markdown",
		"prefix": "/aturan_komentar",
		"body": [
			"Tolong bantu saya perbaiki komentar di file $1 tugas nya  hapus komentar tidak penting dan perbaiki komentar yang penting agar jangan terlalu bertele tele jadi komentar itu cukup singkat, padat jelas dan mudah di pahami, dan ingat jangan ubah kode yang ada "
		],
	},
	"Aturan Log Debug ": {
		"scope": "markdown",
		"prefix": "/aturan_log_debug",
		"body": [
			"aturan penggunaan log  debug, Tolong tambahkan log debug di setiap titik pada file $1 log debug nya harus lengkap, makdusnya lengkap disini adalah agar setiap parameter di kasih log debug nya dan panggil parameter itu ke log debug agar saya mudah mengetahui output nya per paramter. dan juga setiap log debug jangan terlalu panjang dan bertele tele cukup simpel dan jelas saja."
		],
		"description": ""
	},
	"Aturan percantik ui": {
		"scope": "markdown",
		"prefix": "/percantik ui",
		"body": [
			"tolong percantik ui untuk file $1 tapi jangan pernah ubah logika yang sudah ada"
		],
		"description": "untuk prompt memeprcantik ui suatu halaman"
	},
}```


// ============================================================
// FILE: .vscode/dart.code-snippets
// ============================================================

```json
{
  "saringList": {
    "scope": "dart",
    "prefix": "/dart_saringList",
    "body": [
      "List<${4:Model}> ${1:listHasil} = ${2:listSumber}",
      "  .where((m) => !${3:listPembanding}.any((d) => d.${5:propertiId} == m.${5:propertiId}))",
      "  .toList();$0"
    ],
    "description": "Filter: ambil item dari listSumber yang tidak ada di listPembanding"
  },
  "urutkanListDesc": {
    "scope": "dart",
    "prefix": "/dart_urutkanListDesc",
    "body": [
      "List<${2:Model}> ${1:listHasil} = [...${3:listSumber}]..sort((a, b) => b.${4:properti}.compareTo(a.${4:properti}));$0"
    ],
    "description": "Sorting descending menggunakan properti"
  },
  "variabel ambilSatuItem": {
    "scope": "dart",
    "prefix": "/variabel_ambilSatuItem",
    "body": [
      "final ${4:item} = ${1:listSumber}.firstWhereOrNull((item) => item.${3:propertiId} == ${2:idValue});$0"
    ],
    "description": "Mengambil satu item berdasarkan ID menggunakan package collection, menghasilkan null jika tidak ditemukan"
  },
  "filterList": {
    "scope": "dart",
    "prefix": "/dart_filterList",
    "body": [
      "final ${1:listHasil} = ${2:listSumber}",
      "    .where((item) => ${3:kondisi})",
      "    .toList();$0"
    ],
    "description": "Filter list berdasarkan kondisi"
  },
  "mapList": {
    "scope": "dart",
    "prefix": "/dart_mapList",
    "body": [
      "final ${1:listHasil} = ${2:listSumber}",
      "    .map((item) => ${3:item.properti})",
      "    .toList();$0"
    ],
    "description": "Mengubah setiap item dalam list menggunakan map"
  },
  "mapListModel": {
    "scope": "dart",
    "prefix": "/dart_mapListModel",
    "body": [
      "List<${1:ModelHasil}> ${2:listHasil} = ${3:listSumber}",
      "    .map((item) => ${4:ModelHasil}(/* data */))",
      "    .toList();$0"
    ],
    "description": "Mengubah list menjadi list model lain"
  },
  "anyList": {
    "scope": "dart",
    "prefix": "/dart_anyList",
    "body": [
      "final ${1:ada} = ${2:listSumber}.any((item) => ${3:kondisi});$0"
    ],
    "description": "Mengecek apakah minimal satu item memenuhi kondisi"
  },
  "everyList": {
    "scope": "dart",
    "prefix": "/dart_everyList",
    "body": [
      "final ${1:semua} = ${2:listSumber}.every((item) => ${3:kondisi});$0"
    ],
    "description": "Mengecek apakah semua item memenuhi kondisi"
  },
  "containsList": {
    "scope": "dart",
    "prefix": "/dart_containsList",
    "body": [
      "final ${1:ada} = ${2:listSumber}.contains(${3:nilai});$0"
    ],
    "description": "Mengecek apakah list mengandung nilai tertentu"
  },
  "isEmptyList": {
    "scope": "dart",
    "prefix": "/dart_isEmptyList",
    "body": [
      "if (${1:listSumber}.isEmpty) {",
      "  ${2:}",
      "}$0"
    ],
    "description": "Mengecek apakah list kosong"
  },
  "isNotEmptyList": {
    "scope": "dart",
    "prefix": "/dart_isNotEmptyList",
    "body": [
      "if (${1:listSumber}.isNotEmpty) {",
      "  ${2:}",
      "}$0"
    ],
    "description": "Mengecek apakah list tidak kosong"
  },
  "firstList": {
    "scope": "dart",
    "prefix": "/dart_firstList",
    "body": [
      "final ${1:item} = ${2:listSumber}.first;$0"
    ],
    "description": "Mengambil item pertama dari list"
  },
  "lastList": {
    "scope": "dart",
    "prefix": "/dart_lastList",
    "body": [
      "final ${1:item} = ${2:listSumber}.last;$0"
    ],
    "description": "Mengambil item terakhir dari list"
  },
  "takeList": {
    "scope": "dart",
    "prefix": "/dart_takeList",
    "body": [
      "final ${1:listHasil} = ${2:listSumber}.take(${3:5}).toList();$0"
    ],
    "description": "Mengambil sejumlah item pertama dari list"
  },
  "skipList": {
    "scope": "dart",
    "prefix": "/dart_skipList",
    "body": [
      "final ${1:listHasil} = ${2:listSumber}.skip(${3:5}).toList();$0"
    ],
    "description": "Melewati sejumlah item pertama dari list"
  },
  "reverseList": {
    "scope": "dart",
    "prefix": "/dart_reverseList",
    "body": [
      "final ${1:listHasil} = ${2:listSumber}.reversed.toList();$0"
    ],
    "description": "Membalik urutan list"
  },
  "copyList": {
    "scope": "dart",
    "prefix": "/dart_copyList",
    "body": [
      "final ${1:listHasil} = [...${2:listSumber}];$0"
    ],
    "description": "Membuat salinan list baru"
  },
  "addList": {
    "scope": "dart",
    "prefix": "/dart_addList",
    "body": [
      "${1:list}.add(${2:item});$0"
    ],
    "description": "Menambahkan satu item ke list"
  },
  "addAllList": {
    "scope": "dart",
    "prefix": "/dart_addAllList",
    "body": [
      "${1:list}.addAll(${2:listTambahan});$0"
    ],
    "description": "Menambahkan banyak item ke list"
  },
  "removeList": {
    "scope": "dart",
    "prefix": "/dart_removeList",
    "body": [
      "${1:list}.remove(${2:item});$0"
    ],
    "description": "Menghapus item dari list"
  },
  "removeWhereList": {
    "scope": "dart",
    "prefix": "/dart_removeWhereList",
    "body": [
      "${1:list}.removeWhere((item) => ${2:kondisi});$0"
    ],
    "description": "Menghapus semua item yang memenuhi kondisi"
  },
  "clearList": {
    "scope": "dart",
    "prefix": "/dart_clearList",
    "body": [
      "${1:list}.clear();$0"
    ],
    "description": "Mengosongkan list"
  },
  "sortListCustom": {
    "scope": "dart",
    "prefix": "/variabel_sortListCustom",
    "body": [
      "final ${1:listHasil} = [...${2:listSumber}]",
      "  ..sort((a, b) {",
      "    return ${3:a.properti.compareTo(b.properti)};",
      "  });$0"
    ],
    "description": "Sorting list dengan comparator custom"
  },
  "groupListBy": {
    "scope": "dart",
    "prefix": "/dart_groupListBy",
    "body": [
      "final Map<${1:String}, List<${2:Model}>> ${3:hasil} = {};",
      "",
      "for (final item in ${4:listSumber}) {",
      "  final key = item.${5:properti};",
      "  ${3:hasil}.putIfAbsent(key, () => []).add(item);",
      "}$0"
    ],
    "description": "Mengelompokkan item berdasarkan properti"
  },
  "forFinal": {
    "scope": "dart",
    "prefix": "/dart_forFinal",
    "body": [
      "for (final ${1:item} in ${2:listSumber}) {",
      "  ${3:}",
      "}$0"
    ],
    "description": "Perulangan for final untuk setiap item dalam list"
  }
}```


// ============================================================
// FILE: .vscode/freezed.code-snippets
// ============================================================

```json
{
  "Freezed Model (Supabase + Sqflite) Minimal": {
    "prefix": "/freezed_model",
    "scope": "dart",
    "body": [
      "import 'package:freezed_annotation/freezed_annotation.dart';",
      "",
      "part '${TM_FILENAME_BASE}.freezed.dart';",
      "",
      "@freezed",
      "abstract class ${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g} with _$${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g} {",
      "  const ${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g}._();",
      "",
      "  const factory ${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g}({",
      "    required String id,",
      "     ${1:// tambahkan field lain di sini}",
      "  }) = _${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g};",
      "",
      "}"
    ],
    "description": "Freezed model with Supabase & Sqflite, using ParserUtil and NamaKolom constants"
  },
  "Freezed State (List Default)": {
    "scope": "dart",
    "prefix": "/freezed_state",
    "body": [
      "",
      "import 'package:freezed_annotation/freezed_annotation.dart';",
      "",
      "part '${TM_FILENAME_BASE}.freezed.dart';",
      "",
      "@freezed",
      "abstract class ${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g} with _$${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g} {",
      "  const ${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g}._();",
      "",
      "  const factory ${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g}({",
      "    @Default([]) List<${TM_FILENAME_BASE/^(.*?)_state$/${1:/capitalize}/g}Model> list${TM_FILENAME_BASE/^(.*?)_state$/${1:/capitalize}/g},",
      "  }) = _${TM_FILENAME_BASE/(?:^|_)([a-z])/${1:/upcase}/g};",
      "}"
    ],
    "description": "Membuat Freezed state dengan list default kosong, nama file sebagai  name"
  }
}```


// ============================================================
// FILE: .vscode/ide.code-snippets
// ============================================================

```json
{
  "Ide Baru": {
    "scope": "markdown",
    "prefix": "/idea",
    "body": [
      "- **ID Ide**: `IDE-${1:01}`",
      "- **Tanggal Dibuat**: $CURRENT_DATE $CURRENT_MONTH $CURRENT_YEAR",
      "## 💡 IDE: ${2:Judul Ide / Konsep}",
      "- **Tujuan / Proyek**: `${3:Nama_Tujuan_Utama}`",
      "- **Status**: ${4|Draft / Coretan,Perlu Diskusi AI,Siap Jadi Task|}",
      "",
      "### 🎯 Latar Belakang & Masalah",
      "${5:Kenapa ide ini muncul? Masalah apa yang mau diselesaikan?}",
      "",
      "### 🧠 Gambaran Konsep (Brain Dump)",
      "${6:Tulis acak isi kepala Anda di sini...}",
      "",
      "### 🔗 Rencana Task (Turunan dari Ide Ini)",
      "- [ ] ${7:Langkah / Task 1 yang harus dibuat}",
      "",
      "### 📁 File / Area Terkait",
      "- `${8:path/to/file}`",
      "",
      "### 🛑 Batasan & Pengaman",
      "- ${9:Misal: Jangan ubah kode lama, buat fungsi baru di file terpisah}",
      "",
    ],
    "description": "Membuat entri ide baru dengan ID unik",
  },
  "Tugas Baru": {
    "scope": "markdown",
    "prefix": "/task",
    "body": [
      "- **Tanggal Dibuat**: $CURRENT_DATE $CURRENT_MONTH $CURRENT_YEAR",
      "### ${1:Judul Tugas}",
      "- **Tujuan / Proyek**: `${3:Nama_Tujuan_Utama}`",
      "- **Prioritas**: ${4|Tinggi,Sedang,Rendah|}",
      "- **Status**: Belum Dikerjakan",
      "- **Deskripsi**: ${5:Deskripsi singkat tugas}",
      "- **File**:",
      "  - `${6:path/to/file}`",
      "- **Kode / Fungsi Terkait**:",
      "  - `${7:NamaClass / namaFungsi()}`",
      "",
    ],
    "description": "Membuat entri tugas baru yang terhubung ke ID Ide",
  },
  "Ask Baru": {
    "scope": "markdown",
    "prefix": "/ask",
    "body": [
      "# ${1:1}. ${2: Judul Tugas}",
      "- **Prioritas**: ${100|Tinggi,Sedang,Rendah|}",
      "- **Deskripsi**: $3",
      "- file:",
      "  - [${6:file1}](${7:})",
      "  - [${8:file2}](${9:})",
      "  - [${10:file3}](${11:})",
      "  - [${12:file4}](${13:})",
      "  - [${14:file5}](${15:})",
      "  - [${16:file6}](${17:})",
      "setiap selesai menerjakan task satu task baca lagi file task.md nya karena terkadang saya nmelakukan perubahan pada task ini",
      "**Kalau sudah sesuai lewati saja pertanyaan $1**",
      "- **Tanggal Dibuat**: $CURRENT_DATE $CURRENT_MONTH $CURRENT_YEAR $2",
    ],
    "description": "Membuat entri tugas baru yang terhubung ke ID Ide",
  },
  "File Sumber": {
    "scope": "markdown",
    "prefix": "/file_sumber",
    "body": ["[$1]($2)", "[$3]($4)", "[$5]($6)"],
    "description": "Membuat tautan ke file sumber dalam format Markdown",
  },
  "Tanggal": {
    "scope": "markdown",
    "prefix": "/tanggal",
    "body": [
      "- **Tanggal Dibuat**: $CURRENT_DATE $CURRENT_MONTH $CURRENT_YEAR $CURRENT_HOUR:$CURRENT_MINUTE:$CURRENT_SECOND",
    ],
    "description": "Membuat tanggal dan waktu saat ini",
  },
  "menulis file PRD": {
    "scope": "markdown",
    "prefix": "/prd",
    "body": [
      "# MASALAH",
      "$1",
      "# SOLUSI",
      "",
      "<!-- semua masalah diatas harus di berikan solusi -->",
      "## Fitur yang Harus Dibuat",
      "### Fitur 1:",
      "### Fitur 2:",
      "### Fitur 3:",
    ],
    "description": "Menulis sebuah file PRD berformat .md",
  },
}
```


// ============================================================
// FILE: .vscode/komentar.code-snippets
// ============================================================

```json
{
  "komentar belum paham": {
    "scope": "dart",
    "prefix": "/komentar belum paham",
    "body": [
      "// TODO : tolong tambahkan komentar untuk kode di bawah ini karena saya belum paham fungsinya untuk apa",
    ],
    "description": "komentar untuk memerintahkan ai agar menulis komentar untuk kode yang belum di pahami",
  },
}
```


// ============================================================
// FILE: .vscode/lainnya.code-snippets
// ============================================================

```json
{
  "AsyncValueWidget with data": {
    "scope": "dart",
    "prefix": "/asyncvaluewidget",
    "body": [
      "AsyncValueWidget(",
      "  value: ref.watch($1Provider),",
      "  data: ($1State) {",
      "    ${2:return Text('data');},",
      "  },)",
      "$0",
    ],
    "description": "AsyncValueWidget hanya dengan value dan data (loading & error default)",
  },
  "Fungsi": {
    "scope": "dart",
    "prefix": "/fungsi",
    "body": ["${1:void} ${2:namaFungsi}() {", "  $3", "}$0"],
    "description": "Membuat fungsi",
  },
  "Log debug info ": {
    "scope": "dart",
    "prefix": "/loginfo",
    "body": ["L.i('$1');$0"],
    "description": "membuat log debug info",
  },
  "Log debug error": {
    "scope": "dart",
    "prefix": "/logerror",
    "body": ["L.e('$1: \\$e \\$s');$0"],
    "description": "membuat log debug error",
  },
  "snackbar info ": {
    "scope": "dart",
    "prefix": "/apptoastinfo",
    "body": ["AppToast.info(context, '$1');$0"],
    "description": "membuat snackbar info",
  },
  "snackbar sukses ": {
    "scope": "dart",
    "prefix": "/apptoastsukses",
    "body": ["AppToast.sukses(context, '$1');$0"],
    "description": "membuat snackbar sukses",
  },
  "snackbar gagal ": {
    "scope": "dart",
    "prefix": "/apptoastgagal",
    "body": ["AppToast.gagal(context, '$1');$0"],
    "description": "",
  },
  "InputDropdown widget": {
    "scope": "dart",
    "prefix": "/inputdropdown",
    "body": [
      "InputDropdown<${1:T}>(",
      "  value: _${2:selected},",
      "  label: '${3:Label}',",
      "  items: ${4:listItem},",
      "  displayString: (item) => item.${5:namaProperti},",
      "  onChanged: (value) {",
      "    setState(() {",
      "      _${2:selected} = value;",
      "    });",
      "  },",
      ")$0",
    ],
    "description": "Widget InputDropdown (Material 3) dengan generic type",
  },
  "InputAngka widget": {
    "scope": "dart",
    "prefix": "/inputangka",
    "body": [
      "InputAngka(",
      "  controller: _${1:angka}Controller,",
      "  label: '${2:Label}',",
      "  prefixIcon: Icons.numbers,",
      "  focusNode: _${1:angka}FocusNode,",
      "  nextFocusNode: _${3:nextFocusNode},",
      ")$0",
    ],
    "description": "Widget InputAngka dengan controller dan label",
  },
  "Konfirmasi hapus": {
    "scope": "dart",
    "prefix": "/konfirmasi hapus",
    "body": [
      "final confirmed = await ConfirmationDialog.showDelete(",
      "  context: context,",
      "  itemName: '${1:nama_item}',",
      "  title: 'Hapus Data?',",
      "  message: 'Yakin ingin menghapus data ini?',",
      ");",
      "if (confirmed == true) {",
      "  ${2:// lakukan penghapusan}",
      "}$0",
    ],
    "description": "Tampilkan dialog konfirmasi hapus menggunakan ConfirmationDialog",
  },
  "ElevatedButton Loading (disabled)": {
    "scope": "dart",
    "prefix": "/tombolSimpan",
    "body": [
      "ElevatedButton(",
      "  onPressed: ${1:_isLoading} ? null : ${2:() {}},",
      "  child: ${1:_isLoading}",
      "      ? const SizedBox(",
      "          height: 20,",
      "          width: 20,",
      "          child: CircularProgressIndicator(",
      "            strokeWidth: 2,",
      "            color: Colors.white,",
      "          ),",
      "        )",
      "      : const Text('${3:Simpan}'),$0",
      ")",
    ],
    "description": "ElevatedButton dengan state loading (disabled saat loading)",
  },
  "Nav.to": {
    "scope": "dart",
    "prefix": "/Nav.to",
    "body": [" Nav.to(context, $1());$0"],
    "description": "Nav.to",
  },
  "Nav.pop": {
    "scope": "dart",
    "prefix": "/Nav.pop",
    "body": ["Nav.pop(context);$0"],
    "description": "",
  },
  "InputTeks (ringkas)": {
    "scope": "dart",
    "prefix": "/inputteks",
    "body": [
      "InputTeks(",
      "  controller: ${1:_controller},",
      "  label: '${2:Label}',",
      "  hintText: '${3:Hint}',",
      "  validator: ${7:(value) {}},",
      "  focusNode: ${10:null},",
      "  nextFocusNode: ${11:null},",
      ")$0",
    ],
    "description": "InputTeks dengan parameter umum, tanpa default yang tidak perlu",
  },
  "parameter log debug": {
    "scope": "dart",
    "prefix": "///parameter log debug",
    "body": ["$1=\\$$1, $0"],
    "description": "Log nilai variabel Dart",
  },
}
```


// ============================================================
// FILE: .vscode/logika_flutter.code-snippets
// ============================================================

```json
{
  "Try-catch dengan logging": {
    "scope": "dart",
    "prefix": "/trycatchlog",
    "body": [
      "try {",
      "  ${1:// operasi yang berpotensi error}",
      "} catch (e, s) {",
      "  L.e('Gagal melakukan operasi: \\$e \\$s');",
      "  rethrow;",
      "}"
    ],
    "description": "Blok try-catch dengan L.e dan rethrow"
  },
  "Form Key (GlobalKey)": {
    "scope": "dart",
    "prefix": "/formkey",
    "body": [
      "final _formKey = GlobalKey<FormState>();"
    ],
    "description": "Deklarasi GlobalKey<FormState> untuk form"
  },
  "TextEditingController with FocusNode": {
    "scope": "dart",
    "prefix": "/TextEditingController&FocusNode",
    "body": [
      "final  _${1:controller}Controller = TextEditingController();",
      "final  _${1:focusNode}FocusNode = FocusNode();"
    ],
    "description": "Deklarasi TextEditingController dan FocusNode"
  },
  "Enum basic": {
    "scope": "dart",
    "prefix": "/enum",
    "body": [
      "enum ${1:Status} {",
      "  ${2:active},",
      "  ${3:inactive},",
      "  ${4:pending}",
      "}"
    ],
    "description": "Deklarasi enum dasar"
  },
  "Enum label": {
    "scope": "dart",
    "prefix": "/enumlabel",
    "body": [
      "extension ${1:Status}Extension on ${1:Status} {",
      "  String get label {",
      "    switch (this) {",
      "      case ${1:Status}.${2:active}:",
      "        return '${2:active}';",
      "      case ${1:Status}.${3:inactive}:",
      "        return '${3:inactive}';",
      "      case ${1:Status}.${4:pending}:",
      "        return '${4:pending}';",
      "    }",
      "  }",
      "}"
    ],
    "description": "Enum dengan label (extension untuk konversi ke String)"
  },
  "Enum icon": {
    "scope": "dart",
    "prefix": "/enumicon",
    "body": [
      "extension ${1:Status}Extension on ${1:Status} {",
      "  IconData get icon {",
      "    switch (this) {",
      "      case ${1:Status}.${2:active}:",
      "        return Icons.${5:check_circle};",
      "      case ${1:Status}.${3:inactive}:",
      "        return Icons.${6:cancel};",
      "      case ${1:Status}.${4:pending}:",
      "        return Icons.${7:pending};",
      "    }",
      "  }",
      "}"
    ],
    "description": "Enum dengan IconData (extension untuk konversi ke Icon)"
  },
  "variable": {
    "scope": "dart",
    "prefix": "/variabelfinal",
    "body": [
      "${1:final} $2 = $3;"
    ],
    "description": "variabel final"
  }
}```


// ============================================================
// FILE: .vscode/method.code-snippets
// ============================================================

```json
{
	"initState method": {
		"scope": "dart",
		"prefix": "/initstate",
		"body": [
			"@override",
			"void initState() {",
			"  super.initState();",
			"  ${1:// TODO: inisialisasi}",
			"}"
		],
		"description": "Metode initState Flutter"
	},
	"dispose method": {
		"scope": "dart",
		"prefix": "/dispose",
		"body": [
			"@override",
			"void dispose() {",
			"  ${1:// TODO: dispose resources}",
			"  super.dispose();",
			"}"
		],
		"description": "Metode dispose Flutter"
	},
	"ambil satu item by id": {
		"scope": "dart",
		"prefix": "/method_ambilSatuItem",
		"body": [
			"${1:ModelType}? getById(String id) {",
			"  return list${2:Model}.firstWhereOrNull((item) => item.id == id);",
			"}"
		],
		"description": "Method untuk mengambil satu item berdasarkan id menggunakan package collection"
	},
	"urutkanListAsc": {
		"scope": "dart",
		"prefix": "/method_urutkanListAsc",
		"body": [
			"List<${2:Model}> ${1:listHasil} = [...${3:listSumber}]..sort((a, b) => a.${4:properti}.compareTo(b.${4:properti}));$0"
		],
		"description": "Sorting ascending menggunakan properti"
	},
	"getListById": {
		"scope": "dart",
		"prefix": "/dart_getListById",
		"body": [
			"List<${1:Model}> ${2:getListById}(${3:String} ${4:id}) {",
			"  return ${5:listSumber}.where((${6:item}) => ${6:item}.${7:propertiId} == ${4:id}).toList();",
			"}"
		],
		"description": "Fungsi mengambil list berdasarkan ID"
	}
}```


// ============================================================
// FILE: .vscode/path.code-snippets
// ============================================================

```json
{
  "Dokumentasi path model": {
    "prefix": "/path",
    "body": [
      "// ${TM_FILEPATH/^.*?service\\///}",
      "$1"
    ],
    "description": "Menulis komentar path file"
  }
}```


// ============================================================
// FILE: .vscode/riverpod.code-snippets
// ============================================================

```json
{
  "ConsumerWidget": {
    "prefix": "/ConsumerWidget",
    "scope": "dart",
    "body": [
      "import 'package:flutter/material.dart';",
      "import 'package:flutter_riverpod/flutter_riverpod.dart';",
      "",
      "class $1 extends ConsumerWidget {",
      "  const $1({super.key});",
      "",
      "  @override",
      "  Widget build(BuildContext context, WidgetRef ref) {",
      "    return Scaffold(",
      "      appBar: AppBar(title: const Text('data')),",
      "      body: Center(child: Text('$1')),",
      "    );",
      "  }",
      "}"
    ],
    "description": "Buat ConsumerWidget baru",
  },
  "ConsumerStatefulWidget": {
    "prefix": "/ConsumerStatefulWidget",
    "body": [
      "import 'package:flutter/material.dart';",
      "import 'package:flutter_riverpod/flutter_riverpod.dart';",
      "",
      "class $1 extends ConsumerStatefulWidget {",
      "  const $1({super.key});",
      "",
      "  @override",
      "  ConsumerState<$1> createState() => _$1State();",
      "}",
      "",
      "class _$1State extends ConsumerState<$1> {",
      "  @override",
      "  void initState() {",
      "    super.initState();",
      "    // TODO: implement initState",
      "  }",
      "  @override",
      "  void dispose() {",
      "    // TODO: implement dispose",
      "    super.dispose();",
      "  }",
      "",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return Scaffold(",
      "      appBar: AppBar(title: const Text('data')),",
      "      body: Center(child: Text('$1')),",
      "    );",
      "  }",
      "",
      "}"
    ],
    "description": "Buat ConsumerStatefulWidget baru",
    "scope": "dart"
  },
  "final v = ref.watch(provider)": {
    "prefix": "/RefWatchFinal",
    "body": [
      "final ${1:variableName} = ref.watch($2Provider);"
    ],
    "description": "Buat variabel final dan memantau provider",
    "scope": "dart"
  },
  "final v = ref.watch(provider).value": {
    "scope": "dart",
    "prefix": "/refwatchValue",
    "body": [
      "final $1 = ref.watch($2Provider).value;$0"
    ],
    "description": "final ref watch value"
  },
  "final async=ref.watch(provider)": {
    "scope": "dart",
    "prefix": "/async value",
    "body": [
      "final $1Async=ref.watch($2Provider)"
    ],
    "description": ""
  },
  "AwaitRefReadNotifier": {
    "scope": "dart",
    "prefix": "/refreadNotifier",
    "body": [
      "final $1 =await ref.read($2Provider.notifier).$3;$0"
    ],
    "description": "AwaitRefReadNotifier"
  },
  "AwaitRefReadFuture": {
    "scope": "dart",
    "prefix": "/refReadFuture",
    "body": [
      "final $1 =await ref.read($2Provider.future);$0"
    ],
    "description": ""
  },
  "RefListen": {
    "prefix": "/RefListen",
    "body": [
      "ref.listen(${1:provider}, (previous, next) {",
      "\t$0",
      "});"
    ],
    "description": "Mendengarkan provider",
    "scope": "dart"
  },
  "Riverpod notifier class autoDispose": {
    "prefix": "/riverpod_notifier",
    "body": [
      "import 'package:riverpod_annotation/riverpod_annotation.dart';",
      "",
      "part '${TM_FILENAME_BASE}.g.dart';",
      "",
      "@riverpod",
      "class ${1:Nama} extends _$${1:Nama} {",
      "  @override",
      "  ${2:String} build() {",
      "    return ${3:\"\"};",
      "  }",
      "}"
    ],
    "description": "Buat Notifier class dengan riverpod generator"
  },
  "Riverpod provider family keepAlive": {
    "scope": "dart",
    "prefix": "/riverpod_provider_family_keepalive",
    "body": [
      "import 'package:riverpod_annotation/riverpod_annotation.dart';",
      "",
      "part '${TM_FILENAME_BASE}.g.dart';",
      "",
      "@Riverpod(keepAlive: true)",
      "${1:String} ${2:namaProvider}(Ref ref, ${3:String} ${4:parameter}) {",
      "  return ${5:\"\"};",
      "}"
    ],
    "description": "Buat provider family keepAlive dengan riverpod generator"
  },
  "Riverpod provider family autodispose": {
    "scope": "dart",
    "prefix": "/riverpod_provider_family_autodispose",
    "body": [
      "import 'package:riverpod_annotation/riverpod_annotation.dart';",
      "",
      "part '${TM_FILENAME_BASE}.g.dart';",
      "",
      "@riverpod",
      "${1:String} ${2:namaProvider}(Ref ref, ${3:String} ${4:parameter}) {",
      "  return ${5:\"\"};",
      "}"
    ],
    "description": "Buat provider family autoDispose (default) dengan riverpod generator"
  },
}```


// ============================================================
// FILE: .vscode/todo.code-snippets
// ============================================================

```json
{
	"TODO singkat": {
		"scope": "dart",
		"prefix": "/todo_singkat",
		"body": [
			"// TODO : ${1:cek sebelum listing}"
		],
		"description": ""
	},
		"TODO komentar": {
			"scope": "dart",
			"prefix": "/todo_komentar",
			"body": [
				"// TODO : tambah komentar untuk kode dibawah ini"
			],
			"description": ""
		},
}```


// ============================================================
// FILE: .vscode/widget_flutter.code-snippets
// ============================================================

```json
{
  "IconButton": {
    "prefix": "/iconbutton",
    "body": [
      "IconButton(",
      "  icon: const Icon(Icons.$1),",
      "  onPressed: () {",
      "    // TODO: ${2:Implement action}",
      "  },",
      ")",
      "$0"
    ],
    "description": "Membuat IconButton hapus pada Flutter"
  },
  "IconButton Hapus": {
    "prefix": "/iconbutton-hapus",
    "body": [
      "IconButton(",
      "  icon: const Icon(Icons.delete),",
      "  onPressed: () {",
      "    // TODO: ${2:Implement delete action}",
      "  },",
      ")",
      "$0"
    ],
    "description": "Membuat IconButton hapus pada Flutter"
  },
  "IconButton Edit": {
    "prefix": "/iconbutton-edit",
    "body": [
      "IconButton(",
      "  icon: const Icon(Icons.edit),",
      "  onPressed: () {",
      "    // TODO: ${2:Implement edit action}",
      "  },",
      ")",
      "$0"
    ],
    "description": "Membuat IconButton edit pada Flutter"
  },
  "ListView.builder": {
    "scope": "dart",
    "prefix": "/listviewbuilder",
    "body": [
      "ListView.builder(",
      "  itemCount: ${1:items}.length,",
      "  itemBuilder: (context, index) {",
      "    final item = ${1:items}[index];",
      "    return ${2:Text('item')};",
      "  },",
      ")",
      "$0"
    ],
    "description": "Flutter ListView.builder with item variable"
  },
  "ListView.separated": {
    "scope": "dart",
    "prefix": "/listviewseparated",
    "body": [
      "ListView.separated(",
      "  itemCount: ${1:items}.length,",
      "  itemBuilder: (context, index) {",
      "    final item = ${1:items}[index];",
      "    return ${2:YourItemWidget(item)};",
      "  },",
      "  separatorBuilder: (context, index) {",
      "    return ${3:Divider()};",
      "  },",
      ")",
      "$0"
    ],
    "description": "Flutter ListView.separated with item variable and separator"
  },
  "ElevatedButton Dasar": {
    "scope": "dart",
    "prefix": "/elevatedbutton",
    "body": [
      "ElevatedButton(",
      "  onPressed: () {$1},",
      "  child: const Text('${2:Tombol}'),",
      ")$0"
    ],
    "description": "ElevatedButton dasar dengan onPressed dan child"
  },
  "ElevatedButton dengan Icon": {
    "scope": "dart",
    "prefix": "/ElevatedButton.icon",
    "body": [
      "ElevatedButton.icon(",
      "  onPressed: () {$1},",
      "  icon: const Icon(Icons.${2:add}),",
      "  label: const Text('${3:Tombol}'),",
      ")$0"
    ],
    "description": "ElevatedButton dengan icon di sebelah kiri"
  },
  "ElevatedButton Tombol Hapus (Merah)": {
    "scope": "dart",
    "prefix": "/buttondelete",
    "body": [
      "ElevatedButton(",
      "  onPressed: ${1:() {}},",
      "  style: ElevatedButton.styleFrom(",
      "    backgroundColor: Theme.of(context).colorScheme.error,",
      "    foregroundColor: Colors.white,",
      "  ),",
      "  child: const Text('${2:Hapus}'),",
      ")$0"
    ],
    "description": "ElevatedButton untuk aksi hapus (warna merah dari theme)"
  },
  "ElevatedButton dengan OutlinedButton (Pasangan)": {
    "scope": "dart",
    "prefix": "/buttonpair",
    "body": [
      "Row(",
      "  children: [",
      "    Expanded(",
      "      child: OutlinedButton(",
      "        onPressed: ${1:() => Navigator.pop(context)},",
      "        child: const Text('${2:Batal}'),",
      "      ),",
      "    ),",
      "    const SizedBox(width: 12),",
      "    Expanded(",
      "      child: ElevatedButton(",
      "        onPressed: ${3:() {}},",
      "        child: const Text('${4:Simpan}'),",
      "      ),",
      "    ),",
      "  ],",
      "  $0"
    ],
    "description": "Pasangan OutlinedButton + ElevatedButton (Batal & Simpan)"
  },
  "widget ": {
    "scope": "dart",
    "prefix": "/widget",
    "body": [
      "Widget _build$1 (){return $2}$0"
    ],
    "description": "widget untuk class tersebut"
  },
  "FloatingActionButton": {
    "scope": "dart",
    "prefix": "/FloatingActionButton",
    "body": [
      "FloatingActionButton(",
      "  onPressed: ${1:() {}}, ",
      "  child: const Icon(${2:Icons.add}),",
      ")$0"
    ],
    "description": "Floating Action Button with icon"
  },
  "Text ": {
    "scope": "dart",
    "prefix": "/text",
    "body": [
      "Text('$1')$0"
    ],
    "description": "Widget Text flutter"
  },
  "Icons": {
    "scope": "dart",
    "prefix": "/Icons",
    "body": [
      "Icon(Icons.$1)$0"
    ],
    "description": "Widget Icon Flutter"
  },
  "CupertinoIcons": {
    "scope": "dart",
    "prefix": "/icon.cupertinoIcons",
    "body": [
      "Icon(CupertinoIcons.$1)$0"
    ],
    "description": ""
  },
  "Column": {
    "scope": "dart",
    "prefix": "/column",
    "body": [
      "Column(children:[$1]),$0"
    ],
    "description": "Widget Column flutter"
  },
  "Row": {
    "scope": "dart",
    "prefix": "/row",
    "body": [
      "Row(",
      "  children: [",
      "    ${1:child},",
      "  ],",
      "),$0"
    ],
    "description": "Widget Row Flutter dengan children"
  },
  "SizedBox (Height & Width)": {
    "scope": "dart",
    "prefix": "/sizedbox",
    "body": [
      "const SizedBox(",
      "  width: ${1:double.infinity},",
      "  height: ${2:100},",
      "  child: ${3:child},",
      "),$0"
    ],
    "description": "SizedBox dengan width, height, dan child"
  },
  "SizedBox Height": {
    "scope": "dart",
    "prefix": "/sizedbox.height",
    "body": [
      "const SizedBox(height: ${1:10})$0"
    ],
    "description": "SizedBox hanya untuk tinggi (spacer vertikal)"
  },
  "SizedBox Width": {
    "scope": "dart",
    "prefix": "/sizedbox.width",
    "body": [
      "const SizedBox(width: ${1:10}),$0"
    ],
    "description": "SizedBox hanya untuk lebar (spacer horizontal)"
  },
  "SizedBox Expand": {
    "scope": "dart",
    "prefix": "/sizedbox.expand",
    "body": [
      "const SizedBox.expand(",
      "  child: ${1:child},",
      ")$0"
    ],
    "description": "SizedBox.expand untuk mengisi seluruh ruang"
  },
  "SizedBox Shrink": {
    "scope": "dart",
    "prefix": "/sizedboxshrink",
    "body": [
      "const SizedBox.shrink()$0"
    ],
    "description": "SizedBox.shrink untuk widget kosong (ukuran 0x0)"
  },
  "Scaffold": {
    "scope": "dart",
    "prefix": "/scaffold",
    "body": [
      "Scaffold(",
      "  appBar: AppBar(",
      "    title: const Text('${1:Judul}'),",
      "  ),",
      "  body: Center(",
      "    child: ${2:Center(",
      "      child: Text('Halo Dunia'),",
      "    )},",
      "  ),",
      ")$0"
    ],
    "description": "Scaffold dengan SafeArea untuk menghindari notched area"
  },
  "TextButton Dasar": {
    "scope": "dart",
    "prefix": "/textbutton",
    "body": [
      "TextButton(",
      "  onPressed: () {$1},",
      "  child: Text('${2:Tombol}'),",
      ")$0"
    ],
    "description": "TextButton dasar dengan onPressed dan child"
  },
  "TextButton dengan Icon": {
    "scope": "dart",
    "prefix": "/textbuttonicon",
    "body": [
      "TextButton.icon(",
      "  onPressed: ${1:() {}},",
      "  icon: const Icon(${2:Icons.add}),",
      "  label: const Text('${3:Tombol}'),",
      ")$0"
    ],
    "description": "TextButton dengan icon di sebelah kiri"
  },
  "showDialog": {
    "scope": "dart",
    "prefix": "/showDialog",
    "body": [
      "showDialog(",
      "  context: context,",
      "  builder: (context) {",
      "    return $1;",
      "  },",
      ");",
      "$0"
    ],
    "description": "showDialog"
  },
  "Card": {
    "scope": "dart",
    "prefix": "/card",
    "body": [
      "Card(",
      "  child: ${1:child},",
      ")$0"
    ],
    "description": "Card widget"
  },
  "CircleAvatar": {
    "scope": "dart",
    "prefix": "/circleavatar",
    "body": [
      "CircleAvatar(",
      "  radius: ${1:24},",
      "  backgroundImage: NetworkImage('${2:url}'),",
      ")$0"
    ],
    "description": "Avatar berbentuk lingkaran"
  },
  "GridView.builder": {
    "scope": "dart",
    "prefix": "/gridviewbuilder",
    "body": [
      "GridView.builder(",
      "  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(",
      "    crossAxisCount: ${1:2},",
      "    crossAxisSpacing: ${2:8},",
      "    mainAxisSpacing: ${3:8},",
      "  ),",
      "  itemCount: ${4:items}.length,",
      "  itemBuilder: (context, index) {",
      "    final item = ${4:items}[index];",
      "    return ${5:YourItemWidget(item)};",
      "  },",
      ")$0"
    ],
    "description": "GridView.builder dengan item variable"
  },
  "showModalBottomSheet": {
    "scope": "dart",
    "prefix": "/bottomsheet",
    "body": [
      "showModalBottomSheet(",
      "  context: context,",
      "  builder: (context) {",
      "    return ${1:child};",
      "  },",
      ");$0"
    ],
    "description": "Menampilkan modal bottom sheet"
  },
  "AlertDialog": {
    "scope": "dart",
    "prefix": "/alertdialog",
    "body": [
      "AlertDialog(",
      "  title: const Text('${1:Judul}'),",
      "  content: const Text('${2:Pesan}'),",
      "  actions: [",
      "    TextButton(",
      "      onPressed: () => Navigator.pop(context),",
      "      child: const Text('${3:Batal}'),",
      "    ),",
      "    ElevatedButton(",
      "      onPressed: () {",
      "        ${4:}",
      "      },",
      "      child: const Text('${5:OK}'),",
      "    ),",
      "  ],",
      ")$0"
    ],
    "description": "AlertDialog dengan tombol Batal dan OK"
  },
  "InkWell": {
    "scope": "dart",
    "prefix": "/inkwell",
    "body": [
      "InkWell(",
      "  onTap: () {",
      "    ${1:}",
      "  },",
      "  child: ${2:child},",
      ")$0"
    ],
    "description": "Widget dengan efek ripple saat ditekan"
  },
  "GestureDetector": {
    "scope": "dart",
    "prefix": "/gesturedetector",
    "body": [
      "GestureDetector(",
      "  onTap: () {",
      "    ${1:}",
      "  },",
      "  child: ${2:child},",
      ")$0"
    ],
    "description": "GestureDetector dasar"
  },
  "Container": {
    "scope": "dart",
    "prefix": "/container",
    "body": [
      "Container(",
      "  padding: const EdgeInsets.all(${1:16}),",
      "  child: ${2:child},",
      ")$0"
    ],
    "description": "Container sederhana dengan padding dan child"
  }
}```





// ============================================================
// FILE: docs/struktur_proyek.md
// ============================================================
## 📁 lib

- `lib/app.dart`
- `lib/home.dart`
- `lib/main.dart`

## ⚠️  assets (tidak ditemukan)

## ⚠️  supabase (tidak ditemukan)




// ============================================================
// FILE: docs/struktur_rules.md
// ============================================================
# Ringkasan

- semua aturan yang ada dibawah ini wajib dibaca oleh AI dengan hanya menggunakan tool read saja.

## 📁 .agents/rules

```
.agents/rules/
├── global/
│   ├── aturan_bersama.md
│   ├── aturan_build.md
│   ├── aturan_global.md
│   ├── aturan_lainnya.md
│   ├── aturan_notifikasi.md
│   ├── aturan_pemanfaatan_sdk_dan_paket.md
│   ├── aturan_riverpod.md
│   ├── aturan_testing.md
│   ├── format_task.md
│   ├── model_agent.md
│   ├── optimasi_boilerplate.md
│   ├── optimasi_bug_runtime.md
│   ├── optimasi_keamanan.md
│   ├── optimasi_performa.md
│   ├── optimasi_ui.md
│   ├── optimasi_ux.md
│   └── setup_prettier.md
└── proyek/
    ├── aturan_khusus.md
    └── aturan_proyek.md
```

### 📋 Daftar File (lengkap)

#### global/

- `aturan_bersama.md` — Penambahan log debug pada variabel dan parameter
- `aturan_build.md` — Aturan build dan pengelolaan APK
- `aturan_global.md` — Ringkasan aturan global
- `aturan_lainnya.md` — Aturan umum pengembangan Flutter dan Dart
- `aturan_notifikasi.md` — Aturan notifikasi
- `aturan_pemanfaatan_sdk_dan_paket.md` — Pemanfaatan SDK dan paket Flutter
- `aturan_riverpod.md` — Aturan Riverpod
- `aturan_testing.md` — Aturan testing
- `format_task.md` — Format penulisan task.md
- `model_agent.md` — Model agent (OpenRouter / Kilo Code)
- `optimasi_boilerplate.md` — Aturan optimasi boilerplate
- `optimasi_bug_runtime.md` — Aturan optimasi bug runtime
- `optimasi_keamanan.md` — Aturan optimasi keamanan
- `optimasi_performa.md` — Aturan optimasi performa
- `optimasi_ui.md` — Optimasi UI
- `optimasi_ux.md` — Aturan optimasi UX/UI Flutter
- `setup_prettier.md` — Pengaturan dan penggunaan Prettier

#### proyek/

- `aturan_khusus.md` — Aturan khusus proyek (log debug, biodata, dummy, migrasi, notifier, form, empty state, async state, normalisasi tanggal, multi-provider async, ekstraksi perhitungan, notifikasi harian, zona waktu, tapering)
- `aturan_proyek.md` — Aturan proyek (target platform, keterbatasan pengujian)



// ============================================================
// FILE: docs/vs code/cloud_shell/bashrc.txt
// ============================================================
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

# ==========================================
# DEFAULT WORKSPACE
# ==========================================

WORKSPACE="$HOME/berhenti_merokok"

if [ -d "$WORKSPACE" ]; then
    cd "$WORKSPACE"
fi

add_path_front() {
  case ":$PATH:" in
    *:"$1":*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# export PATH="$PATH:/google/flutter/bin"
# . "/home/muhamadbadrudin1000/.deno/env"

add_path_front "$HOME/.local/bin"
# add_path_front "/usr/bin"  # biasanya tidak perlu; aktifkan hanya jika ada alasan spesifik
add_path_front "/google/devshell/editor/code-oss-for-cloud-shell/node_modules/@vscode/ripgrep-universal/bin/linux-x64"
=======
=======
>>>>>>> parent of 3c28174 (`chore: sinkronkan dokumen proyek, migrasi skema database, dan perbarui aturan AGENTS`)
=======
>>>>>>> parent of 3c28174 (`chore: sinkronkan dokumen proyek, migrasi skema database, dan perbarui aturan AGENTS`)
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
source /google/devshell/bashrc.google

cd ~/berhenti_merokok
# export PATH="$PATH:/google/flutter/bin"
# . "/home/muhamadbadrudin1000/.deno/env"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/google/devshell/editor/code-oss-for-cloud-shell/node_modules/@vscode/ripgrep-universal/bin/linux-x64:$PATH"
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> parent of 3c28174 (`chore: sinkronkan dokumen proyek, migrasi skema database, dan perbarui aturan AGENTS`)
=======
>>>>>>> parent of 3c28174 (`chore: sinkronkan dokumen proyek, migrasi skema database, dan perbarui aturan AGENTS`)
=======
>>>>>>> parent of 3c28174 (`chore: sinkronkan dokumen proyek, migrasi skema database, dan perbarui aturan AGENTS`)



// ============================================================
// FILE: docs/vs code/cloud_shell/keybinding.txt
// ============================================================
// Place your key bindings in this file to override the defaults
[
  {
    "key": "meta+e",
    "command": "editor.unfoldAll",
    "when": "editorTextFocus && foldingEnabled",
  },
  {
    "key": "meta+w",
    "command": "editor.foldLevel2",
    "when": "editorTextFocus && foldingEnabled",
  },
  {
    "key": "meta+`",
    "command": "kilo-code.new.addToContext",
    "when": "editorHasSelection && editorTextFocus",
  },
  {
    "key": "meta+2",
    "command": "editor.action.rename",
    "when": "editorHasRenameProvider && editorTextFocus && !editorReadonly",
  },
  {
    "key": "meta+2",
    "command": "agentSession.rename",
    "when": "agentSessionsViewerFocused && !agentSessionHasMultipleSelected && chatSessionType == 'local'",
  },
  {
    "key": "meta+2",
    "command": "renameFile",
    "when": "filesExplorerFocus && foldersViewVisible && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus",
  },
  {
    "key": "meta+2",
    "command": "workbench.action.terminal.renameActiveTab",
    "when": "terminalHasBeenCreated && terminalTabsFocus && terminalTabsSingularSelection || terminalProcessSupported && terminalTabsFocus && terminalTabsSingularSelection",
  },
  {
    "key": "meta+2",
    "command": "debug.renameWatchExpression",
    "when": "watchExpressionsFocused",
  },
  {
    "key": "meta+tab",
    "command": "geminicodeassist.terminal.addSelectionToChatContext",
    "when": "terminalTextSelectedInFocused",
  },
  {
    "key": "meta+tab",
    "command": "geminicodeassist.editor.addSelectionToChatContext",
    "when": "!terminalTextSelectedInFocused",
  },
  {
    "key": "meta+c",
    "command": "copyRelativeFilePath",
    "when": "!editorFocus",
  },
  {
    "key": "meta+c",
    "command": "copyRelativeFilePath",
    "when": "editorFocus",
  },
  {
    "key": "meta+k",
    "command": "workbench.action.pinEditor",
    "when": "!activeEditorIsPinned",
  },
  {
    "key": "meta+k",
    "command": "workbench.action.unpinEditor",
    "when": "activeEditorIsPinned",
  },
  {
    "key": "meta+5",
    "command": "workbench.action.debug.continue",
    "when": "debugState == 'stopped'",
  },
  {
    "key": "f5",
    "command": "-workbench.action.debug.continue",
    "when": "debugState == 'stopped'",
  },
  {
    "key": "meta+5",
    "command": "workbench.action.debug.start",
    "when": "debuggersAvailable && debugState == 'inactive'",
  },
  {
    "key": "f5",
    "command": "-workbench.action.debug.start",
    "when": "debuggersAvailable && debugState == 'inactive'",
  },
  {
    "key": "meta+5",
    "command": "debug.openView",
    "when": "!debuggersAvailable",
  },
  {
    "key": "f5",
    "command": "-debug.openView",
    "when": "!debuggersAvailable",
  },
  {
    "key": "meta+6",
    "command": "workbench.action.debug.stop",
    "when": "inDebugMode && !focusedSessionIsAttach",
  },
  {
    "key": "shift+f5",
    "command": "-workbench.action.debug.stop",
    "when": "inDebugMode && !focusedSessionIsAttach",
  },
]



// ============================================================
// FILE: docs/vs code/cloud_shell/setting.txt
// ============================================================
{
  "window.menuBarVisibility": "classic",
  "window.commandCenter": true,
  "http.proxySupport": "off",
  "workbench.startupEditor": "welcomePageInEmptyWorkbench",
  "redhat.telemetry.enabled": false,
  "workbench.layoutControl.enabled": false,
  "window.autoDetectColorScheme": true,
  "chat.disableAIFeatures": true,
  "http.systemCertificatesNode": true,
  "cloudcode.beta.enableBigqueryExplorer": false,
  "terminal.integrated.defaultProfile.linux": "Google Cloud Shell",
  "terminal.integrated.commandsToSkipShell": [
    "kilo-code.new.agentManagerOpen",
    "kilo-code.new.agentManager.showTerminal",
    "kilo-code.new.agentManager.previousTerminal",
    "kilo-code.new.agentManager.nextTerminal",
  ],
  "google.cloud.project": "service-514211",
  "jupyter.runStartupCommands": [
    "import bigframes",
    "%load_ext bigframes",
    "bigframes.options.bigquery.project = \"service-514211\"",
    "bigframes.options.bigquery.application_name = \"datacloud.code oss for cloud shell\"",
  ],
  "kilo-code.new.agentWorkStyle": "skipped",

  // Custom
  "google.cloud.region": "asia-south1",
  "jupyter.jupyterLaunchTimeout": 300000,
  "git.confirmSync": false,
  "kilo-code.new.autoApprove.enabled": true,

  // Pengaturan custom
  "git.autofetch": false,
  "git.autofetchPeriod": 180,
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.formatOnType": false,
  "editor.bracketPairColorization.independentColorPoolPerBracketType": true,
  "editor.guides.bracketPairs": "active",
  "git.enableSmartCommit": true,
  "kotlin.languageServer.enabled": false,
  "kotlin.debugAdapter.enabled": false,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnType": false,
    "editor.rulers": [80],
    "editor.selectionHighlight": false,
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off",
    "editor.codeActionsOnSave": {
      "source.fixAll": "explicit",
      "source.organizeImports": "explicit",
    },
  },
  "git.openRepositoryInParentFolders": "never",
  "diffEditor.ignoreTrimWhitespace": true,
  "diffEditor.hideUnchangedRegions.enabled": true,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  "editor.minimap.enabled": false,
  "files.watcherExclude": {
    "**/.git/**": true,
    "**/.dart_tool/**": true,
    "**/build/**": true,
    "**/.gradle/**": true,
    "**/android/.gradle/**": true,
  },
  "search.exclude": {
    "**/.git": true,
    "**/.dart_tool": true,
    "**/build": true,
    "**/.gradle": true,
  },
  "editor.codeLens": false,
  "breadcrumbs.enabled": true,
  "editor.smoothScrolling": false,
  "workbench.list.smoothScrolling": false,
  "dart.flutterHotReloadOnSave": "allIfDirty",
  "dart.hotReloadOnSave": "never",
  "dart.previewHotReloadOnSaveWatcher": false,
  "dart.showTodos": false,
  "dart.analysisExcludedFolders": [
    "build",
    ".dart_tool",
    "supabase",
    "assets",
    "android",
    "ios",
    "web",
    "linux",
    "macos",
    "windows",
  ],
  "deno.enablePaths": ["./supabase/functions"],
  "deno.suggest.imports.hosts": {
    "https://deno.land": true,
    "https://jsr.io": true,
  },
  "deno.path": "/home/mbadrudin170/.deno/bin/deno",
  "dart.hotReloadProgress": "statusBar",
  "markdown.validate.enabled": true,
  "editor.codeActionWidget.includeNearbyQuickFixes": true,
  "kilo-code.new.autocomplete.enableAutoTrigger": false,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "kilo-code.new.showTaskTimeline": false,
  "[skill]": {
    "diffEditor.ignoreTrimWhitespace": true,
  },
  "json.schemaDownload.trustedDomains": {
    "https://developer.microsoft.com/json-schemas/": true,
    "https://json-schema.org/": true,
    "https://json.schemastore.org/": true,
    "https://raw.githubusercontent.com/devcontainers/spec/": true,
    "https://raw.githubusercontent.com/microsoft/vscode/": true,
    "https://schemastore.azurewebsites.net/": true,
    "https://www.schemastore.org/": true,
  },
  "files.exclude": {
    "**/.git": true,
    "**/.dart_tool": true,
    "**/build": true,
    "**/.gradle": true,
    "**/android/.gradle": true,
  },
}



// ============================================================
// STATISTIK
// ============================================================
// Total file yang diproses : 11
// Total baris kode        : 2477
