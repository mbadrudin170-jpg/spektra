
1. saya ingin kamu agar bisa menganalisa semua riwayat commit terbaru setelah riwayat terakhir yang dievaluasi, untuk mengetahui riwayat terakhir yang di evaluasi cukup lihat isi file `catatan.md` saja.  
2. jika semisal isi `catatan.md` nya masih kosong gpt cukup ambil 5 commit terbaru saja dulu untuk data awal, baru setelah itu gunakan commit terakhir dievaluasi.  
3. karena di `catatan,md` terdapat banyak catatan gpt cukup lihat commit terakhir yang berjudul `# Evaluasi Skill dari commit`.  
4. jika ada commit baru saat sedang evaluasi abaikan commit baru itu, untuk tugas berikutnya saja.  
5. jadi commit yang akan di ambil nya itu seperti contoh berikut :   
- contoh ada 10 commit, commit 5, adalah commit terakhir yang tercatat di file catatan.md, nah berarti kita tentukan commit yang akan dievaluasi berarti commit 6 dan 10, ketika sudah menentukan commit yang akan dievaluasi ketika ada commit baru misalnya commit 11 maka commit 11 abaikan jangan ikut dimasukkan ke daftar commit yang akan dievaluasi.  
- setiap commit selalu baca dari yang terlama ke terbaru dulu.  
6. tujuannya yaitu untuk menentukan dari riwayat commit itu code mana yang saya inginkan, lalu perbarui atau tambahkan skill custom agar skills ini bisa saya gunakan untuk semua proyek flutter saya.karena kode yang saya commit sudah pasti sesuai dengan paket dan sdk flutter. serta sudah pasti code yang di commit itu sudah saya analisa.  
7. kalau sudah menemukan cukup perbarui skill yang ada di folder `.agents/skills/custom`   
8. tapi harus baca dulu file `.agents/rules/global/aturan_skill.md` agar cara penulisan serta yang lainnya sesuai dengan yang saya inginkan.  
9. setelah itu perbarui isi file `catatan.md` yang ada di root agar memperbarui terakhir commit apa yang dievaluasi, agar tugas selanjut nya tidak kehilangan arah.  
10. Menentukan commit awal dan commit akhir yang akan dievaluasi.  
11. Commit awal \= commit setelah hash tersebut.  
12. Commit akhir \= HEAD saat tugas dimulai.  
13. Tentukan HEAD di awal tugas dan catat hash-nya sebagai commit akhir.  
14. jika ada dua commit yang merubah kode yang sama, jadikan commit terbaru sebagai sumber kebenaran.  
15. Catat hash-nya sebagai commit akhir.  
16. yang dicatat cuma commit terakhir saja jangan semua commit yang di evaluasi.  
17. untuk file .md jangan semuanya di jadikan evaluasi.  
18. Hanya folder skill custom dan catatan.md yang berubah.  
19. lihat branch `master` karena saya pakai branch `master.`  
20. file yang wajib dibaca terlebih dahulu :  
- AGENTS.md  
- catatan.md  
21. khusus untuk commit yang isi nya  file `task.md` wajib baca diff yang bagian task berstatus batal dan dihapus, berarti ada alasannya kenapa task statusnya di tandai batal, lalu lihat bagian `prompt` disana ada keterangan kenapa sebuah task ditandai \`batal\`, setelah itu perbarui skill yang relevan agar mengikuti arahan dari prompt pada \`task\` itu.  
22. sekalian baca file `.agents/rules/global/aturan_skill.md` agar semua skill di folder `custom` sesuai dengan rules itu.
