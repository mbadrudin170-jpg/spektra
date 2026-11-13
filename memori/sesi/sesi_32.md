# Sesi 32 — PRD fitur A3 (Info CPU/SoC & GPU)

## Status
- Status Sinkron: Sudah Sinkron
- Tanggal: Fri Nov 14 2026 03:40 WIB
- Topik: Membuat PRD untuk fitur A3 "Info CPU/SoC & GPU (frekuensi per core realtime, governor, arsitektur)" dari `refrensi_apk.md` (item E Prioritas Gabungan, prioritas Tinggi)

## Catatan Sesi
- Pesan pengguna: "buat prd baru untuk fitur baru" atas pengulangan instruksi asli (18 poin); instruksi selesai untuk A4 sebelumnya (sesi_28, dikomit `b27db2e`); PRD lain yang tersedia: A6/A3/A7 dst (A4/A5 sudah punya PRD; A2 sudah diimplementasikan).
- Analisis bentrok (aturan 4): klaim PRD A4 = `lib/home.dart`, `pubspec.yaml`, `android/.../AndroidManifest.xml`, `lib/fitur/diagnostik/**`, `test/diagnostik_test.dart`; klaim PRD A5 = `lib/fitur/statistik/**`, `test/widget_test.dart`, `pubspec.yaml`. Hampir semua fitur baru beririsan salah satunya; pengguna memilih **A3** (Tinggi) dan perlu menyetujui irisan entry secara eksplisit.
- Belum diimplementasikan (grep `cpu|gpu|soc|vulkan|opengl` di `lib/`, `test/`, `pubspec.yaml` kosong 2026-11-14).
- Sesi paralel yang berjalan: `sesi_30` (implementasi PRD A5; sedang aktif), `sesi_31` (implementasi PRD A4; akan menghapus section A4 + `prd/prd_tes_diagnostik.md` setelah selesai; 2026-11-14 03:31 WIB). Sebelum mengandalkan `refrensi_apk.md`/`home.dart`/`statistik_screen.dart`, verifikasi ulang keadaan terkini.
- `refrensi_apk.md` kehilangan 6 baris section A5 (penanda) pada 2026-11-13 20:2x oleh pekerjaan paralel (tidak disentuh sesi ini); baris A3 = `refrensi_apk.md:53-59` (belum berubah; dikonfirmasi 2026-11-14).

## Keputusan (via tool `question`, 2026-11-14)
- Fitur: **A3 — Info CPU/SoC & GPU** (selaras urutan eksekusi `B1 → A1 → A5 → A3` setelah A5, prioritas gabungan Tinggi).
- Entry: kartu "CPU/SoC & GPU" pada tab Statistik (`lib/fitur/statistik/screens/statistik_screen.dart`) — **irisan dengan PRD A5 disetujui eksplisit pengguna** (pola irisan A4↔A5).
- Sumber data: `dart:io` baca `/sys/devices/system/cpu/**` + `/proc/cpuinfo` (frekuensi/governor/core/jumlah core), reuse `device_info_plus` bila perlu (sudah ada); Identitas SoC & GPU via `MethodChannel('spektra/cpu_gpu')` di `MainActivity.kt` (`SOC_*` API 31+, `SUPPORTED_ABIS`, `glEsVersion`, EGL renderer/vendor, Vulkan opsional) — **tanpa dependensi baru, tanpa izin tambahan**.
- Cakupan (dipilih semua + proses manufaktur): identitas SoC/core/ABI, frekuensi & governor realtime per core, GPU renderer/vendor/OpenGL ES/Vulkan, refresh realtime otomatis 1 detik + muat manual, proses manufaktur (`—` bila tidak terdeteksi; tidak boleh dikarang).
- Perilaku refresh: `Timer.periodic(1s)` + tombol muat ulang di AppBar.
- Platform: Android-only.
- Tautan 4 APK diverifikasi via `webfetch` (2026-11-14): CPU-Z 100M+/3,5★, DevCheck 10M+/4,5★ (ad-free; Hardware section menampilkan manufacturing process), Droid Hardware Info 5M+/4,6★ (per-core clock realtime), Device Info HW 5M+/4,5★ ("On recent devices reading some information is blocked" — dicatat di PRD sebagai keterbatasan).

## Berkas Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `memori/sesi/sesi_32.md` | Dibuat | Berkas sesi ini |
| `prd/prd_info_cpu_soc_gpu.md` | Dibuat | PRD fitur A3 Info CPU/SoC & GPU; Status Dokumen: **Final** (2026-11-14, disetujui pengguna), Implementasi: Belum Diimplementasikan |
| `refrensi_apk.md` | Diubah | Isi section A3 dipindahkan ke PRD; section (`refrensi_apk.md:53-57`) ditandai `<!-- PRD: prd_info_cpu_soc_gpu.md -->` |
| `MEMORI.md` | Diubah | Catatan Teknis (PRD ketiga proyek sesi_32; posisi baris A4 kini 59-63); Lokasi Berkas Sesi (nomor tertinggi 32; berikutnya 33); Catatan untuk Model Selanjutnya (A3 irisan statistik_screen HANYA kartu entry) |
| `memori/riwayat_perubahan.md` | Diubah | Entri 2026-11-14 untuk sesi_32 (PRD A3) |
| `prd/prd_info_memori_penyimpanan.md` | Dihapus (paralel) | Dihapus oleh pekerjaan paralel (bukan sesi ini); tidak disentuh |

## Catatan keterbatasan
- `refrensi_apk.md` berpindah 2 baris ke atas setiap kali section dipindahkan/dihapus (A3 kini `53-57`; A4 kini `59-63`; C2 `235-241`; C5 `259-265`; C9 `291-297`; baris prioritas A3 kini `refrensi_apk.md:334`; urutan eksekusi kini `refrensi_apk.md:367`). PRD A3 ditulis mengacu posisi terbaru (2026-11-14).
- `prd/prd_info_memori_penyimpanan.md` dihapus oleh sesi paralel (PRD A5 diimplementasikan sesi paralel; `refrensi_apk.md` section A5 ikut dihapus, 6 baris, 2026-11-13 20:2x) — bukan oleh sesi ini.

## Sinkronisasi ke MEMORI.md
- `MEMORI.md` diperbarui (Catatan Teknis — PRD ketiga proyek A3; Lokasi Berkas Sesi — nomor tertinggi 32, berikutnya 33, sebut `sesi_31.md` paralel; Catatan untuk Model Selanjutnya — A3 irisan `statistik_screen.dart` HANYA kartu entry; bagian PRD kedua sesi_28 diperbarui posisi/rujukan baris A4 kini `59-63`).
- `memori/riwayat_perubahan.md` ditambah entri 2026-11-14 (PRD A3, sesi_32).
- Kode Dart tidak diubah; `dart format`/`dart analyze`/`flutter test` tidak relevan (tidak ada perubahan kode sesi ini). Status PRD A3 disetujui Final oleh pengguna via tool `question` (2026-11-14).
