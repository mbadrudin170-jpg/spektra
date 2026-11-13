---
name: larangan-backup-task
description: "Trigger: saat membuat berkas cadangan task | Larangan membawa berkas .backup/.bak/.sebelum_* ke repository: hanya di working tree, jangan git add, gunakan git stash/reflog."
metadata:
  kategori: "custom"
  versi: "1.0.1"
  diperbarui: "Fri Nov 13 2026 05:33:40 WIB"
  sumber-terakhir: "perintah pengguna: kerjakan task.md (Kelompok 34)"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Larangan Membawa Berkas Cadangan `.backup task/` ke Repository

Berkas cadangan (.bak, .backup, .sebelum_*) hanya di working tree, jangan commit. Gunakan git stash/reflog untuk versi lama.

## Aturan

1. Berkas cadangan hanya boleh ada di working tree, bukan di commit.
2. Jangan `git add` berkas cadangan saat commit `task.md` atau file lain.
3. Simpan versi lama di luar repo atau pakai `git stash`/`git reflog`, bukan file `.bak` di-commit.
4. Commit hanya berisi perubahan yang benar-benar diperlukan.

## Larangan

- Jangan commit file `.bak`, `.backup`, `.sebelum_*`.
- Jangan tinggalkan arsip cadangan di working tree setelah commit (bersihkan).
- Jangan gunakan berkas cadangan sebagai pengganti riwayat Git.

## Contoh Benar

```bash
git add task.md
git commit -m "task: tandai tugas selesai"
```

## Contoh Salah

```bash
git add task.md .backup\ task/task.md.bak
git commit -m "task: tandai tugas selesai"
```

## Sumber Evaluasi

- Commit: `0b0b564f3f2a9b4342facd6a318b7a5c16edb9c0`
- File: `.backup task/lib/fitur/impian/screens/detail_impian_screen.dart.bak`, `.backup task/task.md.bak`
