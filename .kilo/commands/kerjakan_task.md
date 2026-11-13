1. Baca terlebih dahulu file \`[AGENTS.md](http://AGENTS.md)\` diroot lalu patuhi aturannya.
2. implementasikan semua task yang hanya berstatus `kerjakan` saja.
3. urutannya cari semua task yang berstatus `kerjakan` pada setiap kelompok, implementasikan dulu semua task itu sampai task dalam satu kelompok selesai, baru pindah ke kelompok lainnya.
4. setelah mengerjakan satu task wajib edit dulu file task.md nya agar menandai task itu dengan selesai atau dilewati.
5. jangan mengerjakan task yang file nya sedang terbuka di `editor` dan ubah statusnya sebagai `dilewati` lalu berikan alasan kenapa `dilewati`
6. untuk task yang ternyata setelah di `analyze` error nya tak kunjung hilang maka stop dan rollback isi file .dart nya ke semula lalu ubah status nya menjadi dilewati lalu kasih tahu alasannya.
7. untuk task yang ternyata sudah diimplementasikan ubah status nya menjadi `selesai`.
8. setiap ingin mengedit file tolong buat file backupnya dulu di folder .`backup_task` dan kasih tipe `.bak` contoh `app.dart.bak`.
9. komentar : tambahkan komentar ke kode yang diedit/ditambahkan jelaskan alasannya kenapa diedit/ditambah. harus deskriptif dan tidak panjang juga.
10. dilewati : setiap `task` yang diubah status menjadi `dilewati` beri penjelasan kenapa sebuah task statusnya diubah ke dilewati.
11. flutter analyze : setelah itu jalankan flutter analyze harus bersih dari linter.
12. kelompok kosong : setiap kali file task.md diedit (termasuk saat menandai task `selesai` atau `dilewati`), periksa seluruh kelompok; jika sebuah kelompok tidak memuat satu pun `#### Task N` di bawah `## Tinggi`, `## Sedang`, atau `## Rendah` — termasuk kelompok yang hanya berisi `Tidak ada temuan.` atau heading kosong — maka kelompok tersebut wajib dihapus dari task.md.
