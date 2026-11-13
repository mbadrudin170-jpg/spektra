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


