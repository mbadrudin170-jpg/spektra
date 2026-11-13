1. saya ingin tugas kan kamu untuk mengerjakan PRD yang saya sebutkan di prompt.
   - Saya akan memberikan path file PRD di prompt saat menjalankan command ini.

2. file yang harus dibaca terlebih dahulu dan patuhi aturan di dalamnya:
   - `AGENTS.md`
   - `.agents/rules/global`
   - `.agents/skills/bawaan`
   - `.agents/skills/custom`
   - `.agents/rules/global/format_PRD.md`

3. saat mulai mengimplementasikan, perbarui `Status Implementasi` pada PRD menjadi `Sedang Diimplementasikan`.

4. sebelum mengimplementasikan, cek file-file terdampak pada PRD (section "File-File Terdampak"):
   - bandingkan dengan file-file terdampak pada PRD lain yang status implementasinya `Sedang Diimplementasikan` atau `Sudah Diimplementasikan`.
   - bentrok terjadi jika terdapat file yang sama dan overlap pada bagian yang akan diubah.
   - jika terjadi bentrok, batalkan implementasi PRD ini sepenuhnya (hentikan semua pekerjaan, jangan mengubah file apa pun, jangan memperbarui status).

5. setelah selesai mengimplementasikan:
   a. perbarui `Status Implementasi` pada PRD menjadi `Sudah Diimplementasikan`.
   b. hapus file PRD tersebut.
   c. hapus juga section di `refrensi_apk.md` yang berkaitan dengan PRD tersebut (section yang ditandai dengan nama file PRD, misal melalui komentar `<!-- PRD: <nama-file-prd> -->` atau section header yang mencantumkan nama file PRD).
   - jika tidak ada section yang ditandai dengan nama file PRD di `refrensi_apk.md`, lewati langkah 5c.
