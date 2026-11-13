---
name: scaffold-struktur-layar
description: "Trigger: saat menyusun struktur layar | Panduan Scaffold, AppBar, body, floatingActionButton, bottomNavigationBar, drawer untuk struktur layar standar."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Struktur Layar Standar (Scaffold)

Menggunakan `Scaffold` sebagai kerangka layar dengan `AppBar`, `body`, `floatingActionButton`, `bottomNavigationBar`, dan `drawer` sesuai pedoman Material Design.

## Cakupan yang Di-Cover

- Package: `package:flutter` (file `lib/src/material/scaffold.dart`, `lib/src/material/app_bar.dart`, `lib/src/material/bottom_app_bar.dart`, `lib/src/material/floating_action_button.dart`)
- Class: `Scaffold`, `AppBar`, `PreferredSizeWidget`, `BottomNavigationBar`, `BottomNavigationBarItem`, `Drawer`, `FloatingActionButton`, `SnackBar`, `PersistentBottomSheet`, `SliverAppBar`
- Properti: `Scaffold.appBar`, `Scaffold.body`, `Scaffold.floatingActionButton`, `Scaffold.bottomNavigationBar`, `Scaffold.drawer`, `Scaffold.endDrawer`, `Scaffold.bottomSheet`, `Scaffold.backgroundColor`, `Scaffold.resizeToAvoidBottomInset`, `Scaffold.primary`, `Scaffold.drawerEdgeDragWidth`, `Scaffold.extendBody`, `Scaffold.extendBodyBehindAppBar`
- Method: `Scaffold.of(context)`, `ScaffoldMessenger.of(context).showSnackBar`, `showBottomSheet`, `showModalBottomSheet`

## Aturan

1. `Scaffold.body` wajib diisi; tidak boleh null. Gunakan widget kosong (`SizedBox.shrink`) jika tidak ada konten.
2. `AppBar` harus wrap dalam `Scaffold.appBar` dan mengimplementasikan `PreferredSizeWidget`.
3. `Scaffold.of(context)` mengakses `ScaffoldState` untuk `openDrawer()`, `openEndDrawer()`, `showBottomSheet()`.
4. `ScaffoldMessenger.of(context).showSnackBar()` untuk menampilkan pesan sementara (snackbar).
5. `resizeToAvoidBottomInset = true` default agar body menyusut saat keyboard muncul; setel `false` jika body sudah menangani inset sendiri.
6. `extendBody = true` agar `bottomNavigationBar` menimpa area body di bawahnya (dipakai dengan `FloatingActionButtonLocation.centerDocked`).
7. `extendBodyBehindAppBar = true` jika body perlu meluas di belakang app bar (transparan/blur).
8. `bottomNavigationBar` dengan `BottomNavigationBar` untuk navigasi antar tab utama (maksimal 5 item).
9. `floatingActionButton` untuk aksi primer layar, lokasi default `centerFloat`.
10. `drawer` untuk navigasi sekunder, diakses melalui ikon hamburger di `AppBar.leading` atau geser dari tepi.
11. `backgroundColor` diabaikan jika `theme.scaffoldBackgroundColor` diatur; gunakan tema untuk konsistensi.

## Larangan

- `Scaffold` tanpa `body` (null).
- Beberapa `Scaffold` bersarang tanpa alasan (akan menimpa `AppBar` dan `BottomNavigationBar`).
- `Scaffold.of(context)` dengan context di atas Scaffold (melempar error).
- `AppBar` tanpa `title` atau `leading` yang informatif.
- `bottomNavigationBar` dengan lebih dari 5 item (terlalu ramai layar seluler).

## Contoh Benar

```dart
Scaffold(
  appBar: AppBar(
    title: const Text('Profil Saya'),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
  ),
  body: const Center(child: Text('Konten layar profil')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: (index) => setState(() => _selectedIndex = index),
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ],
  ),
  resizeToAvoidBottomInset: true,
);
```

## Contoh Salah

```dart
// Scaffold tanpa body
Scaffold(
  appBar: AppBar(title: Text('Judul')),
  // body hilang -> error
);
```

```dart
// Scaffold bersarang berlebihan
Scaffold(
  body: Scaffold( // DILARANG tanpa alasan khusus
    body: Container(),
  ),
);
```

## Sumber Evaluasi

- File: `/google/flutter/packages/flutter/lib/src/material/scaffold.dart`
- Class terkait: `Scaffold`, `AppBar`, `BottomNavigationBar`, `FloatingActionButton`
