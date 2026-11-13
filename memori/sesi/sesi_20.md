# Sesi 20 — Riset referensi 10 APK kompetitor Spektra

## Status
- Status Sinkron: Sudah Sinkron
- Tanggal: Sat Nov 14 2026 02:34 WIB
- Topik: Riset referensi APK kompetitor Spektra (perintah pengguna): cari referensi dari APK terdaftar di `apk_kompetitor.md` (catatan: pengguna menyebut `apk_serupa.md`, berkas tersebut tidak ada; poin 7 perintah menegaskan acuan = `apk_kompetitor.md`), hanya yang `Status Analisa = Belum Dianalisa`, cukup 10 APK; perbarui/buat `refrensi_apk.md`.

## Catatan Sesi
- Awal sesi: membaca `MEMORI.md`, `README.md`, `AGENTS.md` (lewat konteks sistem), `apk_kompetitor.md` (seluruh listing ber-status `Belum Dianalisa`), skill `riset-kompetitor`; `refrensi_apk.md` belum ada di root proyek.
- Catch-up sync awal sesi: `memori/sesi/*.md` ber-status `Belum Sinkron` hanya `sesi_19.md` (konteks: konsultasi keluhan rename sesi paralel; tidak ada perubahan proyek di luar berkas sesi itu sendiri; status tidak diputuskan sendiri, dilaporkan ke pengguna).
- Pemilihan 10 APK (semuanya `Belum Dianalisa`, link terverifikasi curl HTTP 200 pada 2026-11-14 02:34 WIB):
  1. DevCheck Device & System Info — Google Play Store — `flar2.devcheck`
  2. AIDA64 — Google Play Store — `com.finalwire.aida64`
  3. CPU-Z — Google Play Store — `com.cpuid.cpu_z`
  4. Device Info HW — Google Play Store — `ru.andr7e.deviceinfohw`
  5. Droid Hardware Info — Google Play Store — `com.inkwired.droidinfo`
  6. Test Your Android — Google Play Store — `hibernate.v2.testyourandroid`
  7. Device Info: System & CPU Info (ytheekshana) — Google Play Store — `com.ytheekshana.deviceinfo`
  8. Athena — F-Droid — `dev.sebaubuntu.athena`
  9. Device Watch — F-Droid — `org.jarsi.devicewatch`
  10. Castro — Google Play Store — `com.itemstudio.castro`
- Output: `refrensi_apk.md` dibuat di root proyek; `Status Analisa` 10 baris APK tersebut di `apk_kompetitor.md` diubah menjadi `Sudah Dianalisa` setelah analisa terdokumentasi.

## Berkas Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `memori/sesi/sesi_20.md` | Dibuat | Berkas sesi ini |
| `refrensi_apk.md` | Dibuat | Laporan referensi hasil riset 10 APK |
| `apk_kompetitor.md` | Diubah | Kolom `Status Analisa` 10 listing → `Sudah Dianalisa` |

## Sinkronisasi ke MEMORI.md
Disinkronkan pada 2026-11-14 (akhir sesi): `MEMORI.md` — `Lokasi Berkas Sesi` (nomor tertinggi 20, sesi_19 tidak disentuh) dan `Catatan untuk Model Selanjutnya` (butir riset 10 APK); `memori/riwayat_perubahan.md` — entri 2026-11-14 riset 10 APK + pembuatan `refrensi_apk.md` + penandaan 10 listing `Sudah Dianalisa` ditambahkan. `refrensi_apk.md` dibuat (belum ada sebelumnya) — bukan "pembaruan" file yang sudah ada; perintah pengguna menyebut `apk_serupa.md` (tidak ada), acuan dipakai `apk_kompetitor.md` sesuai poin 7 perintah. Perubahan `hasil_diskusi/diskusi_4.md` di working tree bukan hasil sesi ini. Tidak ada perubahan kode aplikasi; `dart format`/`dart analyze`/`flutter test` tidak relevan dan tidak dijalankan.
