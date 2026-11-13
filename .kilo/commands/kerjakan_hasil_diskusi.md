---
description: Menindaklanjuti hasil diskusi (hasil_diskusi/diskusi_N.md) menjadi rencana kerja terstruktur di task.md, rekomendasi PRD, atau eksekusi langsung di sesi ini atas konfirmasi pengguna.
---

1. **Input**: pengguna wajib menentukan file sumber `hasil_diskusi/diskusi_N.md` yang akan ditindaklanjuti (nomor/path). Jika belum ditentukan, minta pengguna memilih file diskusi terlebih dahulu.
2. **Baca konteks wajib terlebih dahulu**:
   - `AGENTS.md` (root) dan patuhi aturannya.
   - Setelah itu, baca file diskusi sumber yang ditunjuk pengguna dan periksa `## Status` beserta isi relevannya.
3. **Validasi status diskusi**:
   - Jika file diskusi berstatus `Draft`, **jangan dikerjakan walaupun ditunjuk oleh pengguna**. Hentikan proses, sampaikan bahwa diskusi masih `Draft`, dan minta pengguna mengubah status menjadi `Final` terlebih dahulu (atau `Batal` jika tidak dilanjutkan).
   - Hanya file diskusi berstatus `Final` yang boleh ditindaklanjuti. Jika status bukan `Final`/tidak valid, hentikan dan minta klarifikasi.
4. **Baca konteks pendukung** (setelah status valid): baca aturan format yang relevan (`.agents/rules/global/format_hasil_diskusi.md`, serta `.agents/rules/global/format_task.md` dan `.agents/rules/global/format_PRD.md` bila diperlukan) agar hasil sesuai aturan proyek.
5. **Fokus topik**: proses hanya tindak lanjut yang berkaitan langsung dengan diskusi sumber; jangan menambah pekerjaan di luar keputusan/topik diskusi.
6. **Analisis dan petakan tindak lanjut**:
   - Identifikasi item tindakan yang konkret dari `## Keputusan` dan `## Tindak Lanjut`.
   - Tentukan bentuk keluaran per item:
     - **task.md**: untuk pekerjaan implementasi/perbaikan yang terpetakan ke file terdampak dan langkah teknis.
     - **PRD**: jika cakupan adalah fitur/produk besar yang butuh spesifikasi sesuai `format_PRD.md` (sarankan pembuatan/pembaruan PRD, jangan langsung menulis PRD tanpa konfirmasi).
      - **Implementasi langsung**: untuk tindak lanjut kecil/terukur yang bisa langsung dikerjakan atas konfirmasi pengguna (tanpa `task.md`/PRD). Ditindaklanjuti dengan eksekusi kode di sesi ini oleh agent saat itu, setelah konfirmasi eksplisit pengguna; draf ringkas (file terdampak, langkah, verifikasi) disusun lebih dulu sebagai bahan konfirmasi.
      - **Tidak dapat dieksekusi**: jika butuh informasi/keputusan tambahan, catat sebagai pertanyaan/klarifikasi.
7. **Susun draf usulan terstruktur** (belum ditulis ke berkas target, kecuali disetujui):
   - Untuk `task.md`, susun draf mengikuti `format_task.md` secara ketat: `# Kelompok N`, `## file terdampak`, prioritas (`## Tinggi`/`## Rendah`/sesuai konteks), dan setiap task berisi `Status`, `Masalah`, `Solusi`, `aturan dilanggar`, `file bermasalah`, `prompt`.
   - Set `Status` task baru sebagai `kerjakan` hanya bila siap dieksekusi; sertakan referensi aturan/file bermasalah bila relevan.
    - Kelompokkan berdasarkan himpunan file terdampak yang sama (sesuai aturan `format_task.md`).
    - Untuk **Implementasi langsung**, susun draf ringkas: daftar file terdampak, langkah teknis singkat, dan verifikasi yang dibutuhkan (mis. `dart format`, `dart analyze`, `flutter test`). Draf dipakai sebagai bahan konfirmasi sebelum eksekusi di sesi ini; kode tidak diubah sebelum pengguna menyetujui draf tersebut.
8. **Konfirmasi sebelum menulis**: tampilkan ringkasan draf (item task/kelompok, rekomendasi PRD, atau draf rencana eksekusi langsung) dan minta konfirmasi pengguna mengenai:
   - file target yang akan diubah/dibuat (`task.md`, dan/atau rujukan PRD, dan/atau file yang akan dieksekusi langsung di sesi ini),
   - isi draf yang disetujui.
   - Untuk **Implementasi langsung**, konfirmasi mencakup persetujuan mengeksekusi kode di sesi ini beserta daftar file terdampak dan rencana verifikasi.
   - Jangan mengubah berkas apa pun sebelum ada konfirmasi eksplisit.
9. **Tulis hasil yang disetujui**:
   - Perbarui/buat entri di `task.md` sesuai draf yang disetujui dan `format_task.md` (jangan menghapus atau mengubah task lain tanpa alasan yang disepakati).
    - Jika disepakati membuat/memperbarui PRD, ikuti `format_PRD.md` dan batasi perubahan pada file PRD yang relevan.
     - Jika disepakati **Implementasi langsung**, eksekusi kode di sesi ini setelah konfirmasi eksplisit pengguna; ikuti skill/rules yang relevan sesuai area (mis. `notifier-crud-database`, `gaya`, dst.); jangan ubah kode sebelum konfirmasi; jalankan verifikasi (`dart format`, `dart analyze`, `flutter test` bila relevan).
    - **Dilarang** mengubah kode sumber implementasi (`.dart` atau file kode lain) sebelum konfirmasi eksplisit pengguna (§8).
    - Jika tindak lanjut ini menjawab salah satu pertanyaan pada `## Pertanyaan Terbuka` berkas diskusi sumber, perbarui berkas diskusi sumber: hapus pertanyaan yang sudah terjawab dari daftar dan catat jejaknya di `## Riwayat Perubahan` (mis. "Pertanyaan terbuka ditutup: <ringkasan> — <jawaban singkat> (<tanggal>)"); bila tidak ada pertanyaan terbuka tersisa, tulis `Belum ada`.
10. **Kriteria selesai**:
    - Sumber diskusi terbaca, status tervalidasi `Final`, dan tindak lanjutnya terpetakan.
     - Draf/usulan ditampilkan dan status konfirmasi jelas.
    - Bagian `## Pertanyaan Terbuka` pada berkas diskusi sumber diperbarui sesuai hasil tindak lanjut (pertanyaan terjawab dihapus + jejak di `## Riwayat Perubahan`); bila tidak ada, berisi `Belum ada`.
     - Jika disetujui, `task.md`/PRD yang relevan diperbarui sesuai format dan siap ditindaklanjuti oleh `kerjakan_task.md` atau alur PRD, atau perubahan untuk Implementasi langsung tereksekusi di sesi ini dengan verifikasi (`dart format`, `dart analyze`, `flutter test` bila relevan) lulus.
11. **Bahasa**: selalu gunakan bahasa Indonesia saat berinteraksi dengan pengguna.
