1. saya ingin kamu mencarikan aplikasi serupa di github, fdroid, google play store,apple app store, samsung store, mi store, oppo store, dan store store yang lainnya juga.
2. tapi yang dicari cuma apk mobile saja.
3. cari sebanyak mungkin yang bisa di dapat.
4. setelah itu tambahkan ke file \`apk_kompetitor.md\` di root proyek,
5. sertakan kolom: nama aplikasi, ringkasan singkat (fitur relevan dengan proyek), nama store, link ke apk/app, dan `Status Analisa`.
6. setiap APK/listing baru yang ditambahkan **wajib** diberi `Status Analisa = Belum Dianalisa` (dilarang menandai `Sudah Dianalisa`; analisa dan perubahan status ke `Sudah Dianalisa` hanya dilakukan oleh perintah `riset_kompetitor.md`).
7. ikuti format tabel dan aturan pada skill `riset-kompetitor` serta struktur yang sudah ada di `apk_kompetitor.md`.
8. File yang wajib di baca terlebih dahulu :

- `README.md`
- `AGENTS.md`
- `apk_kompetitor.md`
- `.agents/skills/custom/riset-kompetitor/SKILL.md`

9. **Satu store per iterasi** — setiap kali perintah ini dijalankan, riset dikerjakan store demi store, bukan sekaligus:
   - Mulai dari store pertama (**Google Play Store** sebagai prioritas).
   - Setelah seluruh kandidat dari store itu terverifikasi independen (curl / iTunes lookup / webfetch) dan ditambahkan ke `apk_kompetitor.md`, perbarui `apk_kompetitor.md` terlebih dahulu sebelum lanjut.
   - Urutan setelah Google Play Store: **F-Droid → GitHub → Apple App Store → Samsung Galaxy Store → Mi/GetApps → Oppo App Market → store lainnya** (instruksi eksplisit pengguna, 2026-11-13).
   - DILARANG meriset semua store sekaligus tanpa memperbarui `apk_kompetitor.md` setelah tiap store.
10. Acuan "aplikasi serupa" = **Spektra sesuai `README.md`**: aplikasi Android berbasis Flutter untuk informasi spesifikasi perangkat, monitoring hardware, dan alat diagnostik perangkat ("Know Your Device"). Ringkasan singkat wajib menyebut fitur relevan Spektra (info CPU/RAM/penyimpanan/baterai/layar/OS/kernel/sensor/termal/benchmark, diagnostik layar/kamera/audio/sensor, uji jaringan, monitoring realtime, widget info perangkat) — bukan deskripsi umum dari store.
11. `apk_kompetitor.md` dibuat **baru** bila belum ada, dengan kerangka skill `riset-kompetitor` (section per store; section `# Tambahan Riset (YYYY-MM-DD)` untuk batch besar; tabel pipe Markdown dengan header+separator; kolom `Status Analisa` per baris). Semua listing baru wajib `Status Analisa = Belum Dianalisa`.
12. Riset store dilakukan berurutan; bila ingin mempercepat pencarian kandidat di dalam satu store boleh memakai subagen paralel, tetapi **verifikasi tetap independen** per skill `riset-kompetitor` dan perbarui `apk_kompetitor.md` sebelum lanjut store berikutnya.
