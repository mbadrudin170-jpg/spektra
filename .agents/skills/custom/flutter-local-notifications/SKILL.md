---
name: flutter-local-notifications
description: "Trigger: saat menambahkan notifikasi lokal Flutter | Panduan flutter_local_notifications v23.0.0: cek platform, izin runtime, payload validation, lifecycle tap, exception khusus, unawaited catchError."
metadata:
  kategori: "custom"
  versi: "2.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Standar flutter_local_notifications v23.0.0 pada Notifikasi Harian

Aturan khusus untuk plugin versi 23.0.0: cek platform, dukungan multi-platform (Android/iOS/macOS/Linux/Windows), izin runtime, payload, lifecycle tap, dan penjadwalan terjadwal.

## Cakupan yang Di-Cover

- Package: `package:flutter_local_notifications` v23.0.0 (class `FlutterLocalNotificationsPlugin`, `InitializationSettings`, `AndroidInitializationSettings`, `DarwinInitializationSettings`, `LinuxInitializationSettings`, `WindowsInitializationSettings`, `NotificationDetails`, `NotificationResponse`, `AndroidNotificationDetails`, `DarwinNotificationDetails`, `LinuxNotificationDetails`, `WindowsNotificationDetails`), `package:timezone` as `tz` (class `tz`, `TZDateTime`), `dart:async` (`unawaited`)
- Class: `FlutterLocalNotificationsPlugin`, `InitializationSettings`, `AndroidInitializationSettings`, `DarwinInitializationSettings`, `LinuxInitializationSettings`, `WindowsInitializationSettings`, `NotificationDetails`, `NotificationResponse`, `AndroidNotificationDetails`, `DarwinNotificationDetails`, `LinuxNotificationDetails`, `WindowsNotificationDetails`, `TZDateTime`, `AndroidFlutterLocalNotificationsPlugin`, `IOSFlutterLocalNotificationsPlugin`, `MacOSFlutterLocalNotificationsPlugin`, `WebFlutterLocalNotificationsPlugin`, `LinuxFlutterLocalNotificationsPlugin`, `FlutterLocalNotificationsWindows`
- Enum: `Importance`, `Priority`, `AndroidScheduleMode`, `DateTimeComponents`, `RepeatInterval`, `LinuxNotificationUrgency`, `LinuxNotificationTimeout`, `WebNotificationDirection`
- Method: `plugin.initialize()`, `plugin.zonedSchedule()`, `plugin.show()`, `plugin.cancel()`, `plugin.cancelAll()`, `plugin.cancelAllPendingNotifications()`, `plugin.getNotificationAppLaunchDetails()`, `plugin.resolvePlatformSpecificImplementation()`, `plugin.pendingNotificationRequests()`, `plugin.openAppNotificationSettings()`, `plugin.getActiveNotifications()`, `androidPlugin?.requestNotificationsPermission()`, `iosPlugin?.requestPermissions()`, `macOSPlugin?.requestPermissions()`, `unawaited()`, `catchError()`
- Properti: `kIsWeb`, `defaultTargetPlatform`, `TargetPlatform.android`, `TargetPlatform.iOS`, `TargetPlatform.macOS`, `TargetPlatform.linux`, `TargetPlatform.windows`, `isDestructiveAction`

## Aturan

1. Periksa dukungan fitur berdasarkan platform dan versi plugin sebelum menggunakan API penjadwalan.
2. Jangan gunakan penjadwalan berulang (`matchDateTimeComponents`, `zonedSchedule` dengan pengulangan) pada Web, Linux, Windows. macOS didukung via `zonedSchedule`.
3. Gunakan `AndroidScheduleMode.inexactAllowWhileIdle` untuk penjadwalan harian standar; `AndroidScheduleMode.alarmClock` hanya untuk pengingat kritis yang harus tepat waktu.
4. Inisialisasi plugin dengan `InitializationSettings` untuk platform yang di 지원: `android`, `iOS`, `macOS`, `linux`, dan `windows`. Jangan set `requestAlertPermission`, `requestSoundPermission`, `requestBadgePermission` ke `true` secara default di `DarwinInitializationSettings`.
5. Jangan minta izin notifikasi otomatis saat startup (termasuk iOS Darwin default). Minta saat pengguna aktifkan fitur melalui `mintaIzin()`.
6. Periksa hasil izin sebelum simpan status aktif. Periksa kembali izin saat buka aplikasi melalui `_periksaIzinSistem()`.
7. Rollback state, tampilkan feedback, jangan simpan status aktif jika penjadwalan gagal.
8. Tangani gagal penjadwalan ulang saat buka aplikasi: log error, jangan biarkan unhandled.
9. Pisahkan ID notifikasi uji coba dari ID pengingat utama.
10. Handle tap notifikasi 3 kondisi lifecycle: foreground, background, terminated. Gunakan `getNotificationAppLaunchDetails()` untuk terminated.
11. Validasi payload: parse `kategori` dan `id`, hanya proses kategori dikenal, log warning jika tidak valid.
12. Izin dicabut → cancel jadwal, update preferensi, pastikan tidak ada jadwal tertinggal. Aktifkan kembali → minta izin dulu.
13. Konsistensi waktu: simpan nilai lama, terapkan baru setelah berhasil, gagal → pulihkan lama.
14. unawaited navigasi/loading wajib catchError dengan `L.e`.
15. Gunakan exception khusus (class implements `Exception`), deteksi via `is`, bukan string matching.
16. `cancelAllPendingNotifications()` hanya didukung pada Android, iOS, dan macOS. Pada platform lain akan melempar `UnimplementedError`.
17. `openAppNotificationSettings()` tidak didukung pada Web.

## Larangan

- Jangan minta izin notifikasi otomatis saat startup aplikasi.
- Jangan gunakan penjadwalan berulang di Web/Linux/Windows.
- Jangan gunakan ID notifikasi uji coba sama dengan ID pengingat utama.
- Jangan unawaited navigasi/loading tanpa catchError.
- Jangan string matching untuk deteksi exception.
- Jangan simpan status aktif sebelum izin terverifikasi.
- Jangan panggil `cancelAllPendingNotifications()` di Web/Linux/Windows.
- Jangan panggil `openAppNotificationSettings()` di Web.

## Contoh Benar

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotifikasiService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _idPengingatHarian = 1001;
  static const int _idUjiCoba = 1002;

  /// Inisialisasi plugin TANPA minta izin otomatis.
  static Future<void> inisialisasi() async {
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

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onTapNotifikasi,
    );
  }

  /// Handle tap notifikasi (foreground/background).
  static void _onTapNotifikasi(NotificationResponse response) {
    _navigasiDariPayload(response.payload);
  }

  /// Handle kondisi terminated saat aplikasi dibuka.
  static Future<void> cekNotifikasiSaatBuka() async {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      return; // Platform tidak mendukung launch details
    }
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      final payload = details?.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        _navigasiDariPayload(payload);
      }
    }
  }

  /// Jadwalkan pengingat harian.
  static Future<void> jadwalkanPengingatHarian({
    required int jam,
    required int menit,
  }) async {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      throw UnsupportedError('Platform tidak mendukung notifikasi terjadwal');
    }

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, jam, menit,
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
  }

  /// Batalkan pengingat harian.
  static Future<void> batalkanPengingatHarian() async {
    await _plugin.cancel(id: _idPengingatHarian);
  }

  /// Tampilkan notifikasi langsung (untuk uji coba).
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
    await _plugin.show(
      id: _idUjiCoba,
      title: 'Berhenti Merokok',
      body: 'Jaga semangat! Cek progres smoke-free Anda hari ini.',
      notificationDetails: details,
      payload: 'kategori=pengingat_harian&id=$_idUjiCoba',
    );
  }

  /// Resolve implementasi platform-specific (contoh Android).
  static Future<bool> mintaIzinAndroid() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final granted = await androidPlugin?.requestNotificationsPermission();
    return granted ?? false;
  }
}

void _navigasiDariPayload(String? payload) {
  String? kategori;
  if (payload != null) {
    for (final part in payload.split('&')) {
      final kv = part.split('=');
      if (kv.length == 2 && kv[0] == 'kategori') {
        kategori = kv[1];
      }
    }
  }
  if (kategori == 'pengingat_harian') {
    // unawaited dengan catchError
    // unawaited(Nav.pushAndRemoveUntil(context, const Home()).catchError((e, s) {
    //   L.e('Gagal navigasi: $e $s');
    // }));
  }
}

// Exception khusus
class IzinNotifikasiTidakDiberikanException implements Exception {
  const IzinNotifikasiTidakDiberikanException();
  @override
  String toString() => 'Izin notifikasi tidak diberikan';
}
```

## Contoh Salah

```dart
// DILARANG: Tidak cek platform sebelum pakai API penjadwalan
await plugin.zonedSchedule(
  1, 'Test', 'Body',
  tz.TZDateTime.now(tz.local).add(const Duration(days: 1)),
  const NotificationDetails(),
  matchDateTimeComponents: DateTimeComponents.time, // Tidak didukung Web
);

// DILARANG: Minta izin otomatis saat startup (termasuk iOS default true)
await plugin.requestNotificationsPermission();

// DILARANG: ID uji coba sama dengan ID pengingat utama
await plugin.show(1, 'Test', 'Body', const NotificationDetails());

// DILARANG: unawaited tanpa catchError
unawaited(plugin.show(1, 'Test', 'Body', const NotificationDetails()));

// DILARANG: cancelAllPendingNotifications di Web
await plugin.cancelAllPendingNotifications(); // UnimplementedError di Web

// DILARANG: openAppNotificationSettings di Web
await plugin.openAppNotificationSettings(); // UnimplementedError di Web
```

## Sumber Evaluasi

- File: `lib/shared/notifikasi/notifikasi_service.dart`, `lib/main.dart`, `lib/app.dart`, `lib/fitur/pengaturan/screens/pengaturan_screen.dart`, `android/app/src/main/AndroidManifest.xml`
- Class terkait: `FlutterLocalNotificationsPlugin`, `InitializationSettings`, `NotificationDetails`, `NotificationResponse`, `AndroidNotificationDetails`, `DarwinNotificationDetails`
- Commit rujukan: `774431dbf61bb330d548785e8d47597c5bdcd123`, `0cb0e52f48f6d6f95f2bfc9e8b82a092bb5f9e4f`, `07fc8df6cf5ea28fe7133b1aee5dae7b05b96590`, `6e1a7672d58c7575f195e27dd5921d3d6a3c44af`
