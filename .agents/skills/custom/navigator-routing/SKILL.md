---
name: navigator-routing
description: "Trigger: saat navigasi atau routing Flutter | Panduan Navigator, Route, Page, MaterialApp.router, pushNamed, pop, onGenerateRoute, onUnknownRoute, restorablePushNamed."
metadata:
  kategori: "custom"
  versi: "1.1.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Navigasi dan Routing Flutter

Mengelola navigasi antar layar menggunakan `Navigator`, `Route`, `Page`, dan `MaterialApp` baik dengan imperative API maupun declarative (`MaterialApp.router`).

## Cakupan yang Di-Cover

- Package: `package:flutter` (file `lib/src/widgets/navigator.dart`, `lib/src/widgets/app.dart`, `lib/src/widgets/material/app.dart`)
- Class: `Navigator`, `NavigatorState`, `Route<T>`, `Page<T>`, `RouteSettings`, `MaterialApp`, `WidgetsApp`, `Router`
- Method: `Navigator.push`, `Navigator.pop`, `Navigator.pushNamed`, `Navigator.pushReplacement`, `Navigator.popUntil`, `Navigator.pushNamedAndRemoveUntil`, `Navigator.restorablePushNamed`, `Navigator.maybePop`, `Navigator.of`, `Navigator.maybeOf`
- Tipe: `RouteFactory`, `RoutePredicate`, `PageRouteFactory`, `TransitionBuilder`
- Properti: `Navigator.pages`, `onGenerateRoute`, `onUnknownRoute`, `onGenerateInitialRoutes`, `initialRoute`, `transitionDelegate`, `restorationScopeId`

## Aturan

1. Gunakan `Navigator.of(context)` untuk navigasi imperatif (`push`, `pop`, `pushNamed`).
2. Pastikan `MaterialApp` atau `WidgetsApp` memiliki `onGenerateRoute` jika menggunakan `pushNamed` atau named routes.
3. `onGenerateRoute` tidak boleh mengembalikan `null` kecuali `onUnknownRoute` juga disediakan.
4. `Navigator.pop(context, result)` untuk kembali dan mengirimkan nilai ke route sebelumnya.
5. `Navigator.popUntil(context, ModalRoute.withName('/'))` untuk kembali ke halaman root.
6. `Navigator.pushNamedAndRemoveUntil` untuk mengganti seluruh stack (mis. setelah login).
7. `Navigator.pushReplacement` untuk mengganti route saat ini tanpa menumpuk (mis. splash screen → home).
8. `MaterialApp.router` digunakan untuk declarative routing dengan `routerDelegate` / `routerConfig` (contoh `go_router`).
9. Satu `Navigator` hanya boleh memiliki satu `routerConfig` atau satu kombinasi `routerDelegate`/`routeInformationParser`, tidak keduanya sekaligus.
10. Gunakan `restorablePushNamed` jika route perlu dapat dipulihkan saat state restoration.
11. `RouteSettings.arguments` untuk melewatkan data ke route yang dipush dengan nama.
12. Navigasi pintasan proyek memakai `Nav.to(...)` (helper `share_global_saya`) yang mengembalikan `Future`; setiap pemanggilan wajib `unawaited(...)` dengan `.catchError(...)` yang mencatat `L.e` dan `return null`.
13. Untuk daftar item yang masing-masing menavigasi (mis. menu "Lainnya", kartu aksi), ekstrak pembungkus tunggal (mis. `_navigasi(BuildContext context, Widget page, String nama)`) yang berisi pola `unawaited(Nav.to(...).catchError(...))` — jangan mengulang closure catchError per item.
14. Ratakan indentasi blok `onPressed: () => unawaited(...)` mengikuti pola lain di file yang sama (closure satu level lebih dalam, `child:`/penutup sejajar `onPressed:`).
15. `initialRoute` hanya berlaku saat pertama kali widget dibuat; perubahan setelah itu tidak berpengaruh.

## Larangan

- `pushNamed` tanpa `onGenerateRoute` di `MaterialApp`/`WidgetsApp`.
- `onGenerateRoute` mengembalikan `null` tanpa `onUnknownRoute`.
- `Navigator.of(context)` dengan `context` yang tidak berada di bawah `Navigator` (akan melempar `FlutterError`).
- Menggunakan `initialRoute` dan `routes` yang sama-sama berisi entri `'/'`.
- `Navigator.push` dengan route yang sudah pernah di-install (harus buat `Route` baru).

## Contoh Benar

```dart
// push ke route bernama
Navigator.pushNamed(context, '/profil', arguments: <String, dynamic>{'id': 123});

// pop dengan result
Navigator.pop(context, true);

// kembali ke root
Navigator.popUntil(context, ModalRoute.withName('/'));

// ganti stack seluruhnya
Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

// MaterialApp dengan named routes
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => HomeScreen(),
    '/profil': (context) => ProfilScreen(),
  },
  onGenerateRoute: (settings) {
    if (settings.name == '/detail') {
      return MaterialPageRoute(builder: (context) => DetailScreen());
    }
    return null;
  },
  onUnknownRoute: (settings) => MaterialPageRoute(builder: (context) => NotFoundScreen()),
);
```

## Contoh Salah

```dart
// context bukan di bawah Navigator
Navigator.of(context).push(...); // melempar FlutterError
```

```dart
// routes dengan '/' dan home sekaligus
MaterialApp(home: HomeScreen(), routes: {'/': (context) => HomeScreen()}); // assert error
```

## Sumber Evaluasi

- File: `/google/flutter/packages/flutter/lib/src/widgets/navigator.dart`, `/google/flutter/packages/flutter/lib/src/widgets/app.dart`
- File proyek: `lib/lainnya_screen.dart` (`_navigasi`), `lib/fitur/impian/screens/impian_screen.dart` (indentasi `unawaited` pada FAB)
- Class terkait: `Navigator`, `NavigatorState`, `Route`, `Page`, `MaterialApp`, `WidgetsApp`
- Commit rujukan: `db5dd32f28e92346b9a8d3467fa9b2838e013a02` (pembungkus `_navigasi`), `50c1be708e595449fa2fd18e3491d4418943c565` (perapian indentasi `unawaited` pada FAB impian)
