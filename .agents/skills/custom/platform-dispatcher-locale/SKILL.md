---
name: platform-dispatcher-locale
description: "Trigger: saat membaca pengaturan sistem dari engine | Panduan PlatformDispatcher, Locale, ViewPadding, platformBrightness, textScaleFactor, locale resolution (dart:ui)."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# PlatformDispatcher, Locale, dan Pengaturan Sistem

Akses konfigurasi platform (locale, brightness, text scale, view padding) melalui `PlatformDispatcher.instance` dari `dart:ui`.

## Cakupan yang Di-Cover

- Package: `dart:ui` (file `lib/ui/platform_dispatcher.dart`)
- Class: `PlatformDispatcher`, `Locale`, `ViewPadding`, `ViewConstraints`, `Display`, `FlutterView`, `FrameTiming`, `AccessibilityFeatures`, `SystemColor`, `SystemColorPalette`
- Properti: `PlatformDispatcher.instance`, `locale`, `locales`, `platformBrightness`, `textScaleFactor`, `alwaysUse24HourFormat`, `systemFontFamily`, `views`, `implicitView`, `accessibilityFeatures`, `semanticsEnabled`
- Method: `computePlatformResolvedLocale`, `scaleFontSize`, `scheduleFrame`, `scheduleWarmUpFrame`, `setApplicationLocale`, `sendPlatformMessage`
- Callback: `onLocaleChanged`, `onPlatformBrightnessChanged`, `onTextScaleFactorChanged`, `onMetricsChanged`, `onSemanticsEnabledChanged`

## Aturan

1. `PlatformDispatcher.instance` adalah singleton akses ke engine host. Gunakan `WidgetsBinding.instance.platformDispatcher` jika binding sudah diinisialisasi.
2. `locale` mengembalikan locale sistem utama (first locale). Jika `locales` kosong, mengembalikan `Locale.fromSubtags()` (`und`).
3. `locales` adalah daftar locale sistem berurutan menurut prioritas.
4. `platformBrightness` adalah `Brightness.light` atau `Brightness.dark` dari sistem.
5. `textScaleFactor` adalah skala teks sistem. Gunakan `MediaQuery.textScalerOf` di widget tree daripada memanggil langsung untuk reaktifitas.
6. `scaleFontSize(unscaledFontSize)` mengonversi ukuran font sesuai preferensi sistem.
7. `computePlatformResolvedLocale(supportedLocales)` melakukan resolusi locale platform-native secara sinkron.
8. `setApplicationLocale(Locale)` mengatur locale yang digunakan aplikasi di sisi engine.
9. `ViewPadding` menyediakan padding sistem (status bar, navigation bar, keyboard, inset) dalam physical pixels.
10. `views` berisi daftar `FlutterView` yang tersedia. `implicitView` adalah view default untuk platform single-view (mobile).
11. `scheduleFrame()` meminta engine untuk memulai frame baru (onBeginFrame + onDrawFrame).

## Larangan

- Mengakses `PlatformDispatcher.instance` sebelum `runApp()` jika binding belum siap (kecuali kebutuhan startup awal).
- Mengabaikan hasil null dari `locale` atau `platformBrightness` tanpa fallback.
- Memanggil `scaleFontSize` dengan nilai negatif atau non-finite.
- Mengasumsikan `implicitView` tidak null di semua platform (bisa null).

## Contoh Benar

```dart
final dispatcher = PlatformDispatcher.instance;
final locale = dispatcher.locale;
final brightness = dispatcher.platformBrightness;
final textScale = dispatcher.textScaleFactor;

// resolusi locale terhadap daftar yang didukung
final resolved = dispatcher.computePlatformResolvedLocale([
  const Locale('en', 'US'),
  const Locale('id', 'ID'),
]);
```

## Contoh Salah

```dart
// mengakses locale tanpa cek null/empty
final locale = PlatformDispatcher.instance.locale; // bisa Locale('und') jika kosong
```

```dart
// scaleFontSize dengan nilai invalid
dispatcher.scaleFontSize(-1.0); // assert error
```

## Sumber Evaluasi

- File: `/google/flutter/packages/flutter/bin/cache/pkg/sky_engine/lib/ui/platform_dispatcher.dart`
- Class terkait: `PlatformDispatcher`, `Locale`, `ViewPadding`, `AccessibilityFeatures`
