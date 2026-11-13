---
name: theme-data-color-schema
description: "Trigger: saat mengonfigurasi tema aplikasi | Panduan ThemeData, ColorScheme, textTheme, useMaterial3 untuk konsistensi visual."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# ThemeData, ColorScheme, dan Typografi Tema

Mengonfigurasi `ThemeData` dan `ColorScheme` agar warna, tipografi, dan visual konsisten di seluruh aplikasi, dengan dukungan light/dark mode.

## Cakupan yang Di-Cover

- Package: `package:flutter` (file `lib/src/material/theme_data.dart`, `lib/src/material/color_scheme.dart`)
- Class: `ThemeData`, `ColorScheme`, `TextTheme`, `TextStyle`, `ButtonStyle`, `InputDecorationTheme`, `DividerThemeData`
- Enum: `Brightness.light`, `Brightness.dark`
- Properti: `useMaterial3`, `brightness`, `colorScheme`, `textTheme`, `primaryColor`, `primaryColorLight`, `primaryColorDark`, `accentColor`, `scaffoldBackgroundColor`, `cardTheme`, `elevatedButtonTheme`, `outlinedButtonTheme`, `textButtonTheme`, `inputDecorationTheme`, `dividerTheme`, `appBarTheme`, `bottomNavigationBarTheme`, `dialogTheme`, `popupMenuTheme`, `checkboxTheme`, `radioTheme`, `switchTheme`, `sliderTheme`, `progressIndicatorTheme`, `tabBarTheme`, `tooltipTheme`, `snackBarTheme`, `bottomSheetTheme`
- Method: `ColorScheme.fromSeed`, `ColorScheme.light`, `ColorScheme.dark`, `TextTheme.apply`, `TextStyle.copyWith`, `ThemeData.copyWith`, `ThemeData.light`, `ThemeData.dark`

## Aturan

1. Gunakan `useMaterial3: true` untuk tema modern dengan `ColorScheme` sebagai sumber kebenaran warna.
2. `ColorScheme.fromSeed(seedColor)` menghasilkan skema warna lengkap (primary, secondary, tertiary, surface, background, error, onPrimary, onSecondary, onSurface, onBackground, onError, outline, inversePrimary, scrim) dari satu warna seed.
3. `ColorScheme.light` / `ColorScheme.dark` untuk skema warna bawaan sesuai brightness.
4. `colorScheme.primary` digunakan untuk elemen interaktif utama (tombol, app bar, progress indicator).
5. `colorScheme.onPrimary` untuk teks/ikon di atas warna primary agar kontras.
6. `colorScheme.surface` untuk latar kertas/kartu, `colorScheme.onSurface` untuk teks di atas surface.
7. `colorScheme.error` untuk pesan error dan validasi form, `colorScheme.onError` untuk teks di atas error.
8. `textTheme.bodyLarge/bodyMedium/bodySmall` untuk teks tubuh, `titleLarge/titleMedium/titleSmall` untuk judul, `displayLarge` untuk judul besar layar.
9. Gunakan `textTheme.titleLarge?.copyWith(...)` untuk menurunkan gaya teks dari tema, jangan hardcode ukuran/warna.
10. `scaffoldBackgroundColor` harus sama dengan `colorScheme.surface` atau `colorScheme.background` untuk konsistensi.
11. `cardTheme.color` default diambil dari `colorScheme.surfaceContainerHigh` (M3) atau `colorScheme.surface` (M2).
12. `dividerTheme.color` diambil dari `colorScheme.outline` atau `colorScheme.outlineVariant`.
13. Jika `useMaterial3: false`, warna diturunkan dari `primaryColor` / `accentColor` (M2 legacy), tidak dari `ColorScheme`.

## Larangan

- Hardcode warna (mis. `Colors.blue`, `Color(0xFF...)`) di widget tanpa melalui `Theme.of(context).colorScheme`.
- Menggunakan `primaryColor` untuk latar layar utama (gunakan `scaffoldBackgroundColor` atau `colorScheme.surface`).
- `colorScheme` dengan brightness yang tidak sesuai (`darkTheme` harus `brightness: Brightness.dark`).
- Mengabaikan `onPrimary` / `onSurface` untuk kontras teks pada warna latar.

## Contoh Benar

```dart
final skemaWarna = ColorScheme.fromSeed(
  seedColor: const Color(0xFF2E7D32), // hijau untuk tema berhenti merokok
  brightness: Brightness.light,
);

final tema = ThemeData(
  useMaterial3: true,
  colorScheme: skemaWarna,
  scaffoldBackgroundColor: skemaWarna.surface,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontSize: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: skemaWarna.primary,
      foregroundColor: skemaWarna.onPrimary,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: skemaWarna.surfaceContainerHighest,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: skemaWarna.outline),
    ),
  ),
);
```

## Contoh Salah

```dart
// hardcode warna tanpa melalui tema
Container(color: Colors.green); // DILARANG

// textStyle hardcode tanpa copyWith dari tema
Text('Judul', style: const TextStyle(fontSize: 20, color: Colors.black)); // DILARANG
```

```dart
// darkTheme dengan brightness light
darkTheme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
  brightness: Brightness.light, // salah untuk dark theme
);
```

## Sumber Evaluasi

- File: `/google/flutter/packages/flutter/lib/src/material/theme_data.dart`, `/google/flutter/packages/flutter/lib/src/material/color_scheme.dart`
- Class terkait: `ThemeData`, `ColorScheme`, `TextTheme`
