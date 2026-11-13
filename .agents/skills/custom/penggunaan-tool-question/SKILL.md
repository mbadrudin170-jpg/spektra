---
name: penggunaan-tool-question
description: "Trigger: saat menyusun pertanyaan ke pengguna | Panduan tool question Kilo: header maks 30 karakter, label + description, multiple vs single, default, rekomendasi pertama (Recommended), larangan opsi catch-all, kunci i18n."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Penggunaan Tool `question`

Mengatur cara memanggil tool `question` Kilo agar setiap pertanyaan, permintaan klarifikasi, atau permintaan keputusan ke pengguna konsisten, jelas, dan sesuai kontrak tool. Tool ini wajib dipakai alih-alih menyisipkan pertanyaan sebagai teks biasa.

## Cakupan yang Di-Cover

- Tool: `question` (Kilo built-in)
- Parameter: `questions` (array), `question`, `header`, `options`, `label`, `description`, `multiple`, `default`
- Parameter i18n opsional: `questionKey`, `headerKey`, `labelKey`, `descriptionKey`
- Aturan: `header` maksimal 30 karakter, `label` ringkas 1-5 kata, `description` wajib per opsi, `multiple` vs single-select, opsi rekomendasi "(Recommended)", opsi bebas "Type your own answer" otomatis

## Aturan

1. Gunakan tool `question` setiap kali perlu bertanya, meminta klarifikasi, atau meminta keputusan/input dari pengguna; jangan menyisipkan pertanyaan sebagai teks biasa.
2. Setiap pertanyaan WAJIB memiliki `header` singkat maksimal 30 karakter yang melabeli pertanyaan.
3. Setiap opsi jawaban WAJIB memiliki `label` ringkas (1-5 kata) dan `description` yang menjelaskan pilihan/konsekuensinya.
4. `question` WAJIB berupa pertanyaan lengkap dan tidak ambigu.
5. Jika `multiple` tidak diset atau bernilai `false`, pertanyaan bersifat single-select (satu jawaban); set `multiple: true` hanya bila pengguna memang boleh memilih lebih dari satu opsi.
6. Bila memberi rekomendasi, letakkan opsi rekomendasi di urutan pertama dan akhiri `label` dengan "(Recommended)".
7. Jangan membuat opsi catch-all (mis. "Other", "Lainnya") karena opsi "Type your own answer" tersedia otomatis.
8. Bila keputusan bergantung pada input pengguna, jangan berikan jawaban/keputusan final sebelum input diterima melalui tool `question`.

## Steps

1. Tentukan apakah input pengguna benar-benar diperlukan (bukan dapat diputuskan dari skill/rules/konteks).
2. Susun `header` ≤ 30 karakter dan `question` lengkap.
3. Daftarkan opsi dengan `label` singkat + `description`; taruh opsi rekomendasi di urutan pertama dengan "(Recommended)" bila ada.
4. Tentukan `multiple` (default single-select) dan `default` bila perlu praseleksi.
5. Panggil tool `question` dan tunggu jawaban sebelum melanjutkan.

## Larangan

- DILARANG bertanya lewat teks biasa tanpa tool `question`.
- DILARANG `header` melebihi 30 karakter.
- DILARANG opsi tanpa `description` atau dengan `label` ambigu.
- DILARANG menambahkan opsi catch-all seperti "Other"/"Lainnya".
- DILARANG mengambil keputusan final yang bergantung pada input pengguna tanpa menunggu jawaban tool `question`.

## Contoh Benar

```json
{
  "questions": [
    {
      "header": "Lokasi skill",
      "question": "Di mana skill `penggunaan-tool-question` sebaiknya ditempatkan?",
      "options": [
        {
          "label": "custom (Recommended)",
          "description": "Panduan khusus proyek ini, sesuai konvensi skill kustom."
        },
        {
          "label": "bawaan",
          "description": "Skill bawaan yang dibagikan lintas proyek."
        }
      ],
      "multiple": false,
      "default": "custom (Recommended)"
    }
  ]
}
```

## Contoh Salah

```jsonc
// SALAH: header > 30 karakter
{
  "header": "Pertanyaan tentang lokasi penempatan file skill yang baru dibuat",
  "question": "..."
}
```

```jsonc
// SALAH: opsi tanpa description dan memakai catch-all
{
  "options": [
    { "label": "custom" },
    { "label": "Lainnya" }
  ]
}
```

```text
// SALAH: bertanya lewat teks biasa tanpa tool question
"Pertanyaannya: skill ini mau ditaruh di mana ya, custom atau bawaan?"
```

## Sumber Evaluasi

- File aturan: `.kilo/commands/mode/mode_diskusi.md` §5 (Aturan Penggunaan Tool `question`)
- Skema tool: parameter `question`, `header` (maks. 30 karakter), `options[].label` (1-5 kata), `options[].description`, `multiple`, `default`, serta varian kunci i18n `questionKey`/`headerKey`/`labelKey`/`descriptionKey`
- Commit rujukan: `208e3ec` (menambahkan §5 "Aturan Penggunaan Tool `question`" ke `.kilo/commands/mode/mode_diskusi.md`)