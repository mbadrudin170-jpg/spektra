1. Hanya untuk skill yang terdaftar di `.config/dart_skills/skills_config.json` dan `skills-lock.json` (di root proyek):
   a. Salin (timpa) isi folder skill dari `.agents/skills/<nama_skill>/` ke `.agents/skills/bawaan/<nama_skill>/`.
   b. Hapus folder skill tersebut dari `.agents/skills/` (root).
2. Jangan menyalin folder `bawaan/` atau `custom/` sendiri ke dalam `bawaan/`.
3. Skill di `bawaan` yang tidak terdaftar di kedua file konfigurasi: dibiarkan, tidak dihapus.
4. Skill di root yang tidak terdaftar di kedua file konfigurasi: tidak disentuh.
