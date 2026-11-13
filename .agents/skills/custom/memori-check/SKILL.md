---
name: memori-check
description: "Trigger: setiap interaksi apa pun di proyek ini | Panduan wajib baca MEMORI.md sebelum interaksi dan perbarui bagian relevan setelahnya (kode, dokumen, state). Alur sesi: di awal sesi AI wajib membuat `memori/sesi/sesi_N.md` (status `Belum Sinkron`) dan mencatat sesi tersebut; sebelum membuat berkas sesi baru, AI wajib melakukan **catch-up sync** — memindai `memori/sesi/*.md` ber-status `Belum Sinkron` dari sesi sebelumnya dan menyinkronkannya (yatim/kosong → `Sudah Sinkron` + catatan eksplisit; berisi perubahan → prosedur akhir sesi; ambigu → lapor pengguna). Di akhir sesi AI wajib memperbarui `MEMORI.md` dengan catatan yang relevan lalu menandai berkas sesi `Sudah Sinkron`. Berkas `sesi_N.md` tidak boleh dihapus (diarsipkan permanen). Jangan dilewati walau interaksi tampak kecil."
metadata:
  kategori: "custom"
  versi: "1.5.0"
  diperbarui: "Fri Nov 13 2026 20:53:20 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan_hasil_diskusi diskusi_1.md — Implementasi langsung"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Memeriksa File MEMORI.md dan Berkas Sesi

Setiap kali model (AI) berinteraksi dengan proyek Flutter "berhenti_merokok", **wajib** membaca file `MEMORI.md` di root proyek sebelum interaksi apa pun (bukan hanya task; termasuk pertanyaan, diskusi, review, penelusuran), dan **wajib** memperbarui bagian yang relevan di `MEMORI.md` setelah interaksi yang mengubah proyek (kode, dokumen, state). Skill ini berlaku untuk SEMUA interaksi di proyek ini.

Mulai 2026-11-13, setiap sesi juga wajib dicatat ke berkas sesi `memori/sesi/sesi_N.md` (bernomor, `sesi_1.md`, `sesi_2.md`, …; penomoran nomor tertinggi + 1, gap tidak diisi). Berkas sesi menjadi perantara antara sesi kerja dan `MEMORI.md`: AI tidak boleh mengubah `MEMORI.md` secara langsung tanpa mencatat sesi ke berkas sesi terlebih dahulu, dan di akhir sesi AI wajib memperbarui `MEMORI.md` dengan catatan yang relevan dari berkas sesi lalu menandai berkas sesi `Sudah Sinkron`. Berkas `sesi_N.md` **tidak boleh dihapus** dengan alasan apa pun (diarsipkan permanen).

Pada setiap **awal sesi**, setelah membaca `MEMORI.md` dan sebelum membuat berkas sesi baru, AI wajib melakukan **catch-up sync**: memindai berkas `memori/sesi/*.md` ber-status `Belum Sinkron` milik sesi sebelumnya dan menyinkronkannya. Sinkronisasi akhir sesi tetap dipertahankan sebagai penyelesaian normal; catch-up berfungsi sebagai **jaring pengaman**. Berkas yatim/kosong tanpa perubahan nyata ditandai `Sudah Sinkron` dengan catatan eksplisit "tidak ada perubahan untuk disinkronkan"; berkas berisi perubahan nyata disinkronkan dengan prosedur akhir sesi; bila isi ambigu/tidak dapat diverifikasi → laporkan ke pengguna, jangan diputuskan sendiri. Pemindaian dibatasi pada berkas `Belum Sinkron` saja (bukan seluruh riwayat). Berkas sesi yang sedang aktif di sesi ini tidak boleh ditandai pada langkah catch-up.

## Cakupan yang Di-Cover

- **File utama**: `MEMORI.md` di root proyek (`/home/muhamadbadrudin1000/berhenti_merokok/`)
- **File sesi**: `memori/sesi/sesi_N.md` di root proyek (folder `memori/sesi/` dibuat 2026-11-13; bernomor, diarsipkan permanen)
- **Objek**: Seluruh isi `MEMORI.md` sebagai konteks hidup proyek (status, konvensi, aturan, catatan teknis, riwayat, dan bagian lain yang ada di dalamnya)
- **Sifat**: `MEMORI.md` adalah dokumen yang **berubah seiring waktu**, bukan kontrak tetap; berkas sesi diarsipkan permanen sebagai jejak per sesi
- **Method**: (1) di awal sesi, membaca `MEMORI.md` lalu melakukan catch-up sync (memindai `memori/sesi/sesi_N.md` `Belum Sinkron` dari sesi sebelumnya dan menyinkronkannya), kemudian membuat berkas `sesi_N.md` dengan status `Belum Sinkron`; (2) selama sesi, mencatat poin penting/perubahan ke berkas sesi; (3) di akhir sesi, memperbarui bagian yang relevan di `MEMORI.md` berdasarkan catatan berkas sesi, lalu menandai berkas sesi `Sudah Sinkron`

## Aturan

1. **Wajib baca `MEMORI.md` terlebih dahulu** sebelum interaksi apa pun di proyek "berhenti_merokok" (task, pertanyaan, diskusi, review, penelusuran).
2. **Catch-up sync di awal sesi.** Setelah membaca `MEMORI.md` dan sebelum membuat berkas sesi baru, pindai berkas `memori/sesi/*.md` ber-status `Belum Sinkron` milik sesi sebelumnya (pemindaian dibatasi pada berkas `Belum Sinkron` saja, bukan seluruh riwayat). Tindak lanjutnya:
   - Berkas yatim/kosong tanpa perubahan nyata → tandai `Sudah Sinkron` dengan catatan eksplisit "tidak ada perubahan untuk disinkronkan" (jejak diarsipkan permanen, tidak dihapus).
   - Berkas berisi perubahan nyata → sinkronkan dengan prosedur yang sama seperti sinkronisasi akhir sesi (perbarui `MEMORI.md` + `memori/riwayat_perubahan.md` → isi `## Sinkronisasi ke MEMORI.md` → tandai `Sudah Sinkron`).
   - Berkas sesi yang sedang aktif di sesi ini → **tidak boleh ditandai** pada langkah catch-up.
   - Isi ambigu/tidak dapat diverifikasi → jangan diputuskan sendiri; laporkan ke pengguna. Sesi paralel: best-effort; bila ambigu, lapor.
   - Alur akhir sesi **tetap dipertahankan**; catch-up hanya jaring pengaman.
3. **Wajib buat berkas sesi di awal sesi.** Pada awal setiap sesi/interaksi, sebelum tindakan apa pun yang mengubah proyek, buat `memori/sesi/sesi_N.md` dengan `N` = nomor tertinggi yang ada + 1 (gap tidak diisi; jika folder kosong, buat `sesi_1.md`). Berkas sesi wajib memuat (struktur lengkap):
   - `## Status` — `Status Sinkron: Belum Sinkron`, `Tanggal` (tanggal Jakarta), `Topik` sesi.
   - `## Catatan Sesi` — kronologi/poin penting/keputusan sesi (diperbarui selama sesi).
   - `## Berkas Terdampak` — tabel `Lokasi File | Status Perubahan | Deskripsi`.
   - `## Sinkronisasi ke MEMORI.md` — ringkasan penyesuaian `MEMORI.md` pada akhir sesi, atau `Belum disinkronkan` selama sesi berlangsung.
4. **Catat ke berkas sesi selama sesi berlangsung.** Setiap perubahan penting (file dibuat/diubah/dihapus, keputusan, temuan) wajib dicatat ke berkas sesi yang aktif; berkas sesi menjadi bahan sinkronisasi `MEMORI.md`, bukan duplikasi penuh `MEMORI.md`.
5. **Pahami konteks dari keseluruhan isi `MEMORI.md`** — termasuk (jika ada) status proyek, struktur, konvensi penamaan, konfigurasi/berkas penting, daftar atau rujukan skill dan aturan, catatan teknis, riwayat, serta bagian lain yang tersedia. Jangan berasumsi hanya ada bagian tertentu.
6. **Terapkan konteks/aturan yang relevan** dari isi `MEMORI.md` pada pekerjaan yang akan dilakukan.
7. **Catat poin-poin penting** dari `MEMORI.md` yang relevan dengan interaksi/task yang akan dikerjakan.
8. **Jangan mulai implementasi** sebelum konteks dari `MEMORI.md` tercerna dan poin-poin relevan tercatat.
9. **Sinkronkan di akhir sesi.** Setelah interaksi yang mengubah proyek selesai, **perbarui bagian yang relevan** di `MEMORI.md` (tentukan berdasarkan isi `MEMORI.md` saat itu, bukan daftar nama bagian yang di-hardcode), tambah entri `memori/riwayat_perubahan.md`, isi bagian `## Sinkronisasi ke MEMORI.md` pada berkas sesi dengan ringkasan penyesuaian, lalu ubah `Status Sinkron` menjadi `Sudah Sinkron`.
10. **Anggap `MEMORI.md` dan berkas sesi bisa berubah strukturnya.** Bila bagian yang biasa diperbarui tidak ada, tambahkan bagian yang sesuai kebutuhan; bila ada bagian baru, ikuti strukturnya. Jangan menghapus bagian yang tidak relevan dengan interaksi.
11. **Jika `MEMORI.md` memuat rujukan ke sumber kebenaran lain** (mis. indeks skill atau rules), patuhi rujukan itu dan jangan menggantinya dengan salinan di `MEMORI.md`.

## Steps

1. Awal sesi: baca `MEMORI.md` (dan berkas pendukung lain sesuai konteks); catat poin relevan.
2. Catch-up sync (sebelum membuat berkas sesi baru): pindai berkas `memori/sesi/*.md` ber-status `Belum Sinkron` milik sesi sebelumnya; yatim/kosong → tandai `Sudah Sinkron` dengan catatan eksplisit; berisi perubahan nyata → sinkronkan dengan prosedur akhir sesi (`MEMORI.md` + `memori/riwayat_perubahan.md` → isi `## Sinkronisasi ke MEMORI.md` → tandai `Sudah Sinkron`); ambigu/tidak dapat diverifikasi atau sesi paralel → laporkan ke pengguna, jangan diputuskan sendiri; berkas sesi yang sedang aktif di sesi ini tidak ditandai.
3. Buat `memori/sesi/sesi_N.md` (format lengkap, status `Belum Sinkron`) — bila folder belum ada, buat foldernya terlebih dahulu.
4. Selama sesi: perbarui `## Catatan Sesi` dan `## Berkas Terdampak` setiap ada perubahan substantif.
5. Akhir sesi: perbarui `MEMORI.md` bagian relevan berdasarkan catatan berkas sesi; tambah entri `memori/riwayat_perubahan.md`; isi `## Sinkronisasi ke MEMORI.md`; ubah `Status Sinkron` berkas sesi menjadi `Sudah Sinkron`.
6. Verifikasi: berkas sesi bernomor benar (`tertinggi + 1`), struktur lengkap, status hasil catch-up sesuai (yatim/kosong ditandai `Sudah Sinkron`), dan `MEMORI.md` konsisten dengan isi berkas sesi.

## Larangan

- DILARANG memulai interaksi/task apa pun tanpa membaca `MEMORI.md` terlebih dahulu.
- DILARANG mengubah `MEMORI.md` secara langsung tanpa mencatat sesi ke `memori/sesi/sesi_N.md` terlebih dahulu (berkas sesi adalah satu-satunya perantara yang sah menuju `MEMORI.md`).
- DILARANG menghapus berkas `sesi_N.md` dengan alasan apa pun, termasuk setelah `Sudah Sinkron` (diarsipkan permanen). Permintaan penghapusan dari pihak mana pun harus ditolak atau dikembalikan kepada pengguna untuk konfirmasi eksplisit luar biasa yang terdokumentasi.
- DILARANG menandai berkas sesi yang sedang aktif di sesi ini sebagai `Sudah Sinkron` pada langkah catch-up.
- DILARANG memutuskan sendiri bila isi berkas sesi yang disinkronkan lewat catch-up ambigu atau tidak dapat diverifikasi — laporkan ke pengguna.
- DILARANG menandai berkas sesi `Sudah Sinkron` sebelum `MEMORI.md` benar-benar diperbarui dan bagian `## Sinkronisasi ke MEMORI.md` terisi (berlaku juga untuk berkas yang disinkronkan lewat catch-up).
- DILARANG mengabaikan bagian "catatan untuk model selanjutnya" (atau sebutan setara) yang ada di `MEMORI.md`.
- DILARANG menggunakan versi proyek yang sudah usang tanpa dicek di `MEMORI.md`.
- DILARANG mengabaikan aturan/konvensi yang tercantum di `MEMORI.md` setelah membacanya.
- DILARANG mengimplementasikan fitur tanpa memastikan kepatuhan terhadap konvensi yang tercantum di `MEMORI.md`.
- DILARANG menganggap daftar di `MEMORI.md` sebagai daftar lengkap bila `MEMORI.md` sendiri merujuk ke sumber kebenaran lain.
- DILARANG mengubah struktur `MEMORI.md` secara membabi buta hanya karena skill ini menyebut bagian tertentu; skill ini tidak menetapkan struktur `MEMORI.md`.

## Contoh Benar

```markdown
Sebelum memulai interaksi ini, lakukan langkah berikut:

1. Buka file MEMORI.md di root proyek dan baca konteks yang relevan
2. Buat memori/sesi/sesi_9.md (nomor tertinggi 8 + 1) dengan Status Sinkron: Belum Sinkron
3. Catat poin penting sesi dan berkas terdampak ke memori/sesi/sesi_9.md selama bekerja
4. Mulai pekerjaan setelah konteks tercerna

Setelah selesai dan bila ada perubahan proyek:
- Perbarui bagian yang relevan di MEMORI.md (mis. status, riwayat, catatan teknis) sesuai kondisi terkini
- Tambah entri memori/riwayat_perubahan.md
- Isi bagian "Sinkronisasi ke MEMORI.md" di memori/sesi/sesi_9.md, lalu ubah Status Sinkron menjadi "Sudah Sinkron"
```

Catch-up sync pada awal sesi (setelah membaca MEMORI.md, sebelum membuat berkas sesi baru):

```markdown
1. Baca MEMORI.md
2. Pindai memori/sesi/*.md yang ber-status Belum Sinkron dari sesi sebelumnya:
   - sesi_1.md, sesi_2.md -> yatim/kosong (topik belum ditentukan, tidak ada perubahan) -> tandai Sudah Sinkron dengan catatan "tidak ada perubahan untuk disinkronkan"
   - sesi_7.md -> berisi perubahan nyata -> sinkronkan dengan prosedur akhir sesi (MEMORI.md + riwayat_perubahan.md -> isi Sinkronisasi ke MEMORI.md -> Sudah Sinkron)
   - sesi_aktif_sesi_ini.md -> JANGAN ditandai
   - isi ambigu / sesi paralel -> laporkan ke pengguna, jangan diputuskan sendiri
3. Buat memori/sesi/sesi_9.md (nomor tertinggi + 1) ...
```

## Contoh Salah

```markdown
// DILARANG: Memulai implementasi tanpa membaca MEMORI.md
// Salah: "Aja langsung aja buat UI-nya, nggak usah baca file2 aneh"

MaterialApp(
  home: Center(child: Text('Contoh Salah')),
); // DILARANG: implementasi tanpa konteks MEMORI.md
```

```markdown
// DILARANG: mengubah MEMORI.md tanpa berkas sesi
// Salah: "Langsung edit MEMORI.md saja, nggak perlu memori/sesi/sesi_9.md"
```

```markdown
// DILARANG: menghapus berkas sesi
// Salah: "sesi_9.md sudah Sudah Sinkron, jadi boleh dihapus"
```

```markdown
// DILARANG: membiarkan berkas sesi yatim tetap Belum Sinkron selamanya
// Salah: "sesi_1.md dan sesi_2.md masih Belum Sinkron, tapi dibiarkan saja"
```

```markdown
// DILARANG: menandai berkas sesi yang sedang aktif di sesi ini pada catch-up
// Salah: "pada awal sesi, catch-up: sesi_9.md ditandai Sudah Sinkron padahal sesi_9.md justru sesi yang sedang berjalan"
```

```markdown
// DILARANG: memutuskan sendiri bila isi sesi yang ditemukan pada catch-up ambigu
// Salah: "sesi_7.md berisi perubahan tapi tidak jelas bagian mana yang nyata; disinkronkan asal-asalan tanpa lapor pengguna"
```

```markdown
// DILARANG: menganggap skill ini menetapkan bagian tertentu di MEMORI.md
// Salah: "MEMORI.md harus punya bagian X, Y, Z" lalu menghapus/menata ulang bagian lain tanpa alasan dari isi proyek
```

## Sumber Evaluasi

- File: `MEMORI.md` di root proyek (`/home/muhamadbadrudin1000/berhenti_merokok/`); `memori/sesi/sesi_N.md`
- Commit rujukan: `1823940` (chore(agents): perluas kewajiban pemeriksaan MEMORI.md ke seluruh interaksi proyek), `5e2a55d` (docs(agents): perbarui path hasil diskusi ke prd/hasil_diskusi), `b7f2b05` (docs(memori): lengkapi catatan proyek dan tata ulang arsip diskusi)
- Skill terkait: `aturan-pembuatan-skill`, `validasi-platform-izin`, `gaya`, `penamaan-konvensi`
- Keputusan rujukan: `hasil_diskusi/diskusi_8.md` (K-1..K-11; alur sesi, larangan penghapusan berkas sesi), `hasil_diskusi/diskusi_1.md` (K-1..K-9, R-1..R-4; catch-up sync awal sesi)
- Catatan: skill ini memuat alur sesi (bukan hanya struktur `MEMORI.md`); pembaruan berikutnya untuk perubahan alur sesi mengikuti `aturan_skill.md`.
