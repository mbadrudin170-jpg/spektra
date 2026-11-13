# Sesi 28 — PRD fitur dari refrensi_apk.md (pilihan pengguna, diskusi sampai Final)

## Status
- Status Sinkron: Sudah Sinkron
- Tanggal: Fri Nov 14 2026 03:08 WIB
- Topik: Membuat/memperbarui PRD untuk satu fitur dari `refrensi_apk.md` (pilihan via tool `question`); diskusi sampai PRD Final; tanpa mengubah kode Dart; hanya mengedit file PRD terkait + menandai `refrensi_apk.md`

## Catatan Sesi
- Awal sesi: membaca `MEMORI.md`, `AGENTS.md` (aturan global `.agents/rules/global/*`, termasuk `format_PRD.md`), `refrensi_apk.md` (401 baris, worktree), `prd/prd_info_memori_penyimpanan.md` (PRD A5 yang sudah ada), `pubspec.yaml`, `keluhan.md`, `memori/riwayat_perubahan.md` (ekor), struktur `lib/`.
- Catch-up sync awal sesi: `memori/sesi/*.md` berstatus `Belum Sinkron` tersisa `sesi_26.md`; isinya sudah tersinkron (entri PRD A5 ada di `MEMORI.md` + `memori/riwayat_perubahan.md`) dan statusnya ternyata sudah dibalik menjadi `Sudah Sinkron` oleh sesi paralel. Tidak ada berkas lain yang disentuh.
- Skill dimuat: `memori-check`, `penggunaan-tool-question`.
- PRD A5 (`prd/prd_info_memori_penyimpanan.md`) adalah satu-satunya PRD di proyek; file terdampaknya: `pubspec.yaml`, `refrensi_apk.md`, `lib/fitur/statistik/{model/memori_info.dart, data/memori_repository.dart, notifier/memori_notifier.dart, notifier/memori_notifier.g.dart, widgets/memori_penyimpanan_section.dart, screens/statistik_screen.dart}`, `test/widget_test.dart`, `lib/home.dart` (Diubah, tidak direncanakan). Fitur yang terdampaknya beririsan dengan daftar ini wajib dilewati (aturan perintah pengguna poin 4).
- `refrensi_apk.md` section A5 sudah dipindahkan ke PRD A5 dan ditandai `<!-- PRD: prd_info_memori_penyimpanan.md -->` (`refrensi_apk.md:69-73`).
- Belum ada fitur (selain kerangka + baterai) yang diimplementasikan; verifikasi implementasi tiap kandidat dilakukan terhadap `lib/` dan `pubspec.yaml` sebelum dipilih.
- Instruksi pengguna: ambil satu fitur dari `refrensi_apk.md`; `refrensi_apk.md` wajib disertakan path+baris di PRD; isi section terkait dipindahkan ke PRD; section di `refrensi_apk.md` ditandai sudah dibuatkan PRD; kode Dart tidak boleh diubah; PRD wajib sesuai `format_PRD`; pertanyaan selalu via tool `question` sampai PRD Final; tandai bagian `refrensi_apk.md` sebagai sudah dibuatkan PRD.
- Fitur dipilih pengguna via tool `question`: **A4 — Tes diagnostik komponen interaktif** (bukan A5; A5 sudah dibuatkan PRD sesi_26). Verifikasi implementasi: tidak ada kode diagnostik di `lib/` dan tidak ada dependensi terkait di `pubspec.yaml` → A4 belum diimplementasikan.
- Tautan A4 yang dibaca via `webfetch` (2026-11-14): Test Your Android (`hibernate.v2.testyourandroid`, 4,8★, 1M+ dl), ytheekshana (`com.ytheekshana.deviceinfo`, 4,8★, 10M+ dl, Hardware Tests ~15), DevCheck (`flar2.devcheck`, 4,5★, 10M+ dl, Tests: flashlight/vibrator/buttons/multitouch/display/speaker/mic); ketiganya tidak punya ringkasan hasil gabungan.
- Keputusan pengguna (via tool `question`): cakupan tes = semua (warna, dead pixel, multi-touch, kecerahan opsional, getar, audio speaker, audio mikrofon loopback, senter, tombol volume); paket audio/senter diputuskan saat implementasi via `flutter pub add` (paket terbaru & aktif di pub.dev, bukan di-pin di PRD); ringkasan hasil = in-memory per sesi (tanpa persistensi); platform = Android saja; entry point = tab Dashboard (`lib/home.dart` — irisan dengan PRD A5 disetujui eksplisit); `pubspec.yaml` berubah (irisan dengan PRD A5 disetujui eksplisit); nama file = `prd/prd_tes_diagnostik.md`.
- PRD `prd/prd_tes_diagnostik.md` dibuat (Status Dokumen: Draft) memuat path+baris ke `refrensi_apk.md` (A4 → `refrensi_apk.md:61-65`; C2 → `243-249`; C5 → `267-273`; C9 → `299-305`; prioritas → `343`; urutan eksekusi → `375`).
- `refrensi_apk.md`: isi section A4 dipindahkan ke PRD; section ditandai `<!-- PRD: prd_tes_diagnostik.md -->` (pola sama dengan penanda A5).
- Penanganan irisan dengan PRD A5: `refrensi_apk.md` (section berbeda, diwajibkan instruksi), `pubspec.yaml` (disetujui eksplisit), `lib/home.dart` (disetujui eksplisit); `test/widget_test.dart` TIDAK disentuh (diganti `test/diagnostik_test.dart` baru); `lib/fitur/statistik/**` tidak disentuh.
- Kode Dart: tidak diubah sama sekali.

- Review draft via tool `question`: pengguna menyetujui seluruh isi PRD → `Status Dokumen` diubah Draft → **Final** (2026-11-14).
- PRD `prd/prd_tes_diagnostik.md` — Status Dokumen: Final (2026-11-14), Implementasi: Belum Diimplementasikan.

## Berkas Terdampak
| Lokasi File | Status Perubahan | Deskripsi |
|-------------|------------------|-----------|
| `memori/sesi/sesi_28.md` | Dibuat | Berkas sesi ini |
| `prd/prd_tes_diagnostik.md` | Dibuat | PRD fitur A4 Tes diagnostik komponen interaktif; Status Dokumen: Final (2026-11-14, disetujui pengguna) |
| `refrensi_apk.md` | Diubah | Isi section A4 dipindahkan ke PRD; section (`refrensi_apk.md:61-65`) ditandai `<!-- PRD: prd_tes_diagnostik.md -->` |
| `MEMORI.md` | Diubah | Catatan Teknis (PRD kedua proyek sesi_28); Lokasi Berkas Sesi (nomor tertinggi 28); Catatan untuk Model Selanjutnya (irisan A4/A5) |
| `memori/riwayat_perubahan.md` | Diubah | Entri 2026-11-14 untuk sesi_28 (PRD A4) |

## Sinkronisasi ke MEMORI.md
- `MEMORI.md` diperbarui (Catatan Teknis — PRD kedua proyek; Lokasi Berkas Sesi — nomor tertinggi 28, berikutnya 29; Catatan untuk Model Selanjutnya — irisan A4/A5 pada `pubspec.yaml`/`lib/home.dart`, `test/diagnostik_test.dart`, rujukan baris terbaru).
- `memori/riwayat_perubahan.md` ditambahkan entri 2026-11-14 (PRD A4, sesi_28).
- Koreksi posisi baris `refrensi_apk.md`: section A5 kini `refrensi_apk.md:67-71` (setelah A4 menyusut); rujukan `69-73` pada catatan sesi_26 dibiarkan sebagai arsip.
- Kode Dart tidak diubah; `dart format`/`dart analyze`/`flutter test` tidak relevan (tidak ada perubahan kode).
- Status PRD A4 disetujui Final oleh pengguna via tool `question`.
