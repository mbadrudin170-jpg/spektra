---
name: keamanan-aplikasi
description: "Trigger: saat menerapkan keamanan aplikasi | Aturan keamanan: validasi input, enkripsi data sensitif, penyimpanan aman, platform validation, error handling tidak bocor info sensitif, dependency scanning."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Aturan Keamanan Aplikasi

Skill ini mendokumentasikan aturan keamanan yang wajib diterapkan di proyek ini.

## 1. Validasi Input (Input Validation)

### Aturan
- **WAJIB** validasi semua input pengguna (form, query param, deep link, notifikasi payload).
- Validasi di sisi client (UI) DAN server-side (repository/notifier) - defense in depth.
- Gunakan `Form` + `GlobalKey<FormState>` + `validator` untuk form.
- **DILARANG** `?? 0` atau `?? ''` masking input tidak valid (lihat `validasi-form-sebelum-penyimpanan`).
- Sanitasi input sebelum simpan ke DB (trim, escape, normalisasi).

```dart
// Validator contoh
validator: (value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) return 'Wajib diisi';
  if (trimmed.length > 100) return 'Maksimal 100 karakter';
  // Sanitasi: hapus karakter berbahaya
  if (trimmed.contains(RegExp(r'[<>\"\'&]'))) return 'Karakter tidak diperbolehkan';
  return null;
}
```

## 2. Penyimpanan Data Sensitif

### Aturan
- **DILARANG** simpan password, token, PIN, kunci enkripsi di `SharedPreferences` / SQLite plaintext.
- Data sensitif **WAJIB** dienkripsi (mis. `flutter_secure_storage` untuk keychain/keystore).
- Database SQLite lokal **TIDAK** dienkripsi (offline-first, data tidak sensitif: biodata, craving, impian).
- Jika butuh enkripsi DB, gunakan `sqflite_sqlcipher` (native dependency).

### Data yang BOLEH plaintext SQLite:
- Biodata (nama, tanggal, jumlah rokok, harga)
- Craving diary (trigger, feeling, durasi)
- Impian (nama, target, deskripsi)
- Badge, milestone, preferensi UI

### Data yang WAJIB enkripsi (pakai flutter_secure_storage):
- API keys (kalau ada)
- Auth tokens (kalau ada backend)
- Biometric keys

## 3. Platform Validation & Permission

### Aturan
- **WAJIB** cek dukungan platform sebelum pakai API (lihat `validasi-platform-izin`, `flutter-local-notifications-22-3-3`).
- **WAJIB** minta izin runtime sesuai kebijakan OS (Android 13+ POST_NOTIFICATIONS, iOS UNUserNotificationCenter).
- **DILARANG** asumsikan izin granted → cek hasil request izin.
- **DILARANG** tampilkan kontrol fitur yang tidak didukung platform (mis. scheduled notification di Web).

```dart
// Contoh: cek platform & izin sebelum schedule notifikasi
if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
  final granted = await FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  if (granted == true) {
    // Schedule notifikasi
  } else {
    // Handle izin ditolak - jangan crash, tampilkan info
  }
}
```

## 4. Error Handling - Tidak Bocor Info Sensitif

### Aturan
- **DILARANG** tampilkan stack trace, SQL query, path file, detail internal ke user.
- Log error detail (`L.e`) untuk debugging, tampilkan user-friendly message (`AppToast.error`).
- Exception khusus (`class implements Exception`) untuk deteksi via `is`, bukan string matching.

```dart
// SALAH: Bocor detail internal
catch (e) {
  AppToast.error(context, 'DB Error: $e'); // JANGAN
}

// BENAR: User-friendly + log detail
catch (e, s) {
  L.e('Gagal simpan biodata', e, s);
  AppToast.error(context, 'Gagal menyimpan data. Coba lagi.');
}
```

### Referensi
- `exception-khusus-deteksi-error` skill
- `penanganan-error-unawaited` skill
- `logging-debug` skill

## 5. Dependency Security

### Aturan
- **WAJIB** `flutter pub outdated` berkala untuk cek vulnerability.
- **WAJIB** review `pubspec.lock` saat upgrade dependency major.
- Gunakan `dart pub deps --style=compact` untuk audit dependency tree.
- Hindari dependency yang tidak maintained / deprecated.

## 6. Network Security (Jika Ada Backend)

### Aturan
- **WAJIB** HTTPS (TLS 1.2+) untuk semua network call.
- **DILARANG** `http://` production (kecuali localhost development dengan `usesCleartextTraffic=true` di Android manifest).
- Certificate pinning untuk API kritikal (opsional tapi direkomendasikan).
- Timeout network call wajib di-set (mis. 10 detik).

## 7. Data Export/Backup Security

### Aturan
- File backup **WAJIB** validasi struktur sebelum restore (lihat `ekspor-pemulihan-cadangan`).
- **DILARANG** restore file backup tanpa validasi signature/checksum.
- **DILARANG** overwrite data tanpa konfirmasi destruktif (lihat `konfirmasi-sebelum-simpan`).
- Hapus file backup parsial gagal setelah operasi.

## 8. Local Authentication (Biometric/PIN)

### Aturan
- Gunakan `local_auth` package untuk biometric/PIN.
- **DILARANG** fallback ke PIN aplikasi custom (pakai OS lockscreen).
- Hanya aktifkan fitur sensitif (hapus data, export) setelah auth berhasil.

## 9. Logging Security

### Aturan
- **DILARANG** log data sensitif (password, token, PII lengkap) ke `L.i`/`L.w`/`L.e`.
- Log metadata saja: `L.i('userId=$id, action=login')`, bukan `L.i('password=$pass')`.
- Production: matikan debug log verbose, hanya error/warning.

## 10. Larangan Keamanan

- **DILARANG** `eval()` / `Function.apply` / dynamic code execution.
- **DILARANG** `dart:mirrors` (tidak support Flutter AOT).
- **DILARANG** `WebView` load URL tidak trusted tanpa validasi.
- **DILARANG** `path_provider` akses directory sensitif tanpa alasan.
- **DILARANG** hardcode secret di kode (API key, password) → gunakan `--dart-define` / env.

## Referensi Aturan Sumber

- `aturan_bersama.md` — Validasi platform/izin, Form validation, Exception khusus
- `aturan_khusus.md` — Konfirmasi destruktif, Platform validation
- `validasi-platform-izin` skill
- `flutter-local-notifications-22-3-3` skill
- `ekspor-pemulihan-cadangan` skill
- `konfirmasi-sebelum-simpan` skill
- `exception-khusus-deteksi-error` skill
- `penanganan-error-unawaited` skill
- `logging-debug` skill

## Referensi Commit Terkait

- `774431d` — flutter_local_notifications setup dengan platform check
- `338a021` — Backup/restore dengan validasi & konfirmasi
- `3b67d309` — Form validation, error handling pattern
