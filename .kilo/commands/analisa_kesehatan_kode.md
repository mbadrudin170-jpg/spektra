1. saya ingin kamu menganalisa semua commit terbaru saya, apakah code terbaru saya sudah sehat, baik itu sudah sesuai paket sdk dan flutter atau sudah sesuai skills yang ada.
2. untuk paket sdk wajib baca versi yang terinstall di pubscl.yml lalu cari di pub.dev dan dokumentasi terkait untuk sumber kebenaran.
3. jika masih terdapat tidak sehat sedikitpun wajib perbarui isi file [task.md](http://task.md) di root proyek.
4. baca terlebih dahulu isi file `.agents/rules/global/format_task.md` agar penulisan format nya sesuai dengan aturan yang saya inginkan.
5. untuk commit commit tersebut yang di cek hanya commit mengenai code dart saja.
6. yang hanya boleh di sentuh cuma file [`catatan.md`](http://catatan.md) dan `` `task.md` `` saja.
7. baca bagian `# Evaluasi kesehatan code dari commit` untuk mengetahui commit terakhir mana yang sudah dievaluasi.
8. ketika sudah menemukan commit terakhir tersebut sekarang cari semua commit yang akan dievaluasi, tentu kan dulu semua commit yang akan di evaluasi.
9. jadi commit yang akan di ambil nya itu seperti contoh berikut :

- contoh ada 10 commit, commit 5, adalah commit terakhir yang tercatat di file [catatan.md](http://catatan.md), nah berarti kita tentukan commit yang akan dievaluasi berarti commit 6 dan 10, ketika sudah menentukan commit yang akan dievaluasi ketika ada commit baru misalnya commit 11 maka commit 11 abaikan jangan ikut dimasukkan ke daftar commit yang akan dievaluasi.
- setiap commit selalu baca dari yang terlama ke terbaru dulu.
-

10. jika sedang evaluasi dan terdapat commit baru maka abaikan semua commit baru tersebut, biarkan commit baru untuk di kerjakan pada tugas selanjut nya saja.
11. setelah selesai memperbarui [`task.md`](http://task.md) maka perbarui isi file [`catatan.md`](http://catatan.md) ny yang bagian `# Evaluasi kesehatan code dari commit` dengan commit terakhir yang di evaluasi tersebut.
12. cari di branch `master` untuk melihat riwayat commit menggunakan branch itu.
13. jika belum ada commit terakhir dievaluasi yang tercatat di `# Evaluasi kesehatan code dari commit` cukup ambil 5 commit terakhir saja.
14. file yang wajib dibaca terlebih dahulu :

- AGENTS.md
- [catatan.md](http://catatan.md)
- task.md
