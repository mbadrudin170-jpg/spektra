---
name: konfigurasi-kilo-proyek
description: "Trigger: saat membuat atau mengubah konfigurasi Kilo proyek atau command Kilo | Panduan prosedur & larangan konfigurasi `.kilo/kilo.jsonc` proyek (bukan snapshot isi config): baca `permission` sebelum `bash` (AGENTS.md aturan 11), deny mutlak, perbarui `MEMORI.md` setelah ubah config, jangan commit config tanpa perintah pengguna; plus tutorial pembuatan commands Kilo (lokasi & struktur rekursif, frontmatter, variabel template, subcommand & fallback, konvensi proyek); rujukan `.kilo/kilo.jsonc`, `.kilo/commands/`, dan dokumen resmi Kilo."
metadata:
  kategori: "custom"
  versi: "1.0.0"
  diperbarui: "Fri Nov 13 2026 10:18:12 WIB"
  sumber-terakhir: "26362be"
  model: "openrouter/thinkingmachines/inkling-2-small:free"
---

# Konfigurasi Kilo Proyek dan Commands Kilo

Prosedur dan larangan konfigurasi Kilo tingkat proyek (`.kilo/kilo.jsonc`) beserta tutorial pembuatan commands Kilo di `.kilo/commands/`. Isi bersifat prosedural — bukan snapshot isi config; nilai config (model, daftar permission) sengaja tidak disalin agar skill tidak cepat usang. Sumber kebenaran konfigurasi adalah berkas config proyek itu sendiri; untuk konfigurasi Kilo generik (bukan spesifik proyek), rujuk skill bawaan `kilo-config`.

## Cakupan yang Di-Cover

- Berkas: `.kilo/kilo.jsonc` (config proyek, sumber kebenaran — AGENTS.md aturan 11), `.kilo/prompts/code.md`, `.kilo/prompts/ask.md`, `.kilo/prompts/debug.md`, `.kilo/commands/**`, `SKILLS_INDEX.md`, `MEMORI.md`, `memori/riwayat_perubahan.md`, `docs/kilo/kilo_global.txt` (arsip usang)
- Konsep config Kilo: bagian `permission` (`allow`/`ask`/`deny`, pola glob, proteksi `.env`), `instructions`, `skills.paths` (path relatif), `agent.<nama>.prompt` dengan `{file:...}`, `commit_message.prompt`, `indexing`
- Konsep commands Kilo: pola pemuatan `{command,commands}/**/*.md` rekursif, frontmatter command (`description`, `agent`, `model`, `variant`, `subtask`), variabel template (`$1`–`$N`, `$ARGUMENTS`, `@file`), mirror `gpt/`
- Skill bawaan: `kilo-config` (builtin, generik; bukan pengganti skill ini dan bukan project-local)

## Aturan

1. Sumber kebenaran konfigurasi Kilo proyek adalah `.kilo/kilo.jsonc` (bukan `kilo.json`, bukan `~/.config/kilo/kilo.jsonc` global, bukan `docs/kilo/kilo_global.txt`). Baca ulang berkas ini setiap interaksi — nilai (terutama `permission`) dapat berubah sewaktu-waktu.
2. Sebelum menjalankan `bash` atau tindakan lain, wajib baca bagian `permission` pada `.kilo/kilo.jsonc` (AGENTS.md aturan 11). Izin `deny` bersifat mutlak: DILARANG dilewati, diakali, atau dieksekusi lewat perintah lain (mis. `python3 *`, `sed *`, `cat *` untuk membaca berkas yang dilarang).
3. `deny` saat ini: `bash` → `cat *`, `sed *`, `python3 *`; `read` → `*.env`, `*.env.*` (`*.env.example` diizinkan). Jangan menghafal daftar ini; verifikasi dari berkas.
4. Config global `~/.config/kilo/kilo.jsonc` kini nyaris kosong (hanya `$schema`, terverifikasi 2026-11-12). Seluruh `permission` aktif berada di config proyek; jangan mengandalkan global.
5. `docs/kilo/kilo_global.txt` adalah arsip usang (memuat model dan prompt inline lama, mis. `agent.code` `kilo/baidu/ernie-5.5-flash-preview:free` dan prompt `"kamu adalah pekerja saya"`). DILARANG dijadikan rujukan aktif atau dasar restore; gunakan hanya sebagai arsip historis.
6. Setelah mengubah `.kilo/kilo.jsonc`, wajib perbarui `MEMORI.md` (bagian `File Konfigurasi & Penting` dan bagian relevan lain) dan tambah entri pada `memori/riwayat_perubahan.md`.
7. Config tidak boleh di-commit, di-push, atau diubah "sekalian" tanpa perintah pengguna; perubahan config yang berdampak (permission, `external_directory`, model) menunggu keputusan eksplisit pengguna.
8. `.kilo/kilo.jsonc` tervalidasi otomatis oleh harness Kilo saat diedit; bila edit gagal validasi, perbaiki berkas sebelum melanjutkan, jangan mengabaikan galat validasi.
9. Prompt agent disimpan sebagai berkas di `.kilo/prompts/` dan dirujuk dari config dengan `{file:./prompts/<nama>.md}` (diterapkan 2026-11-12/13: `code.md` dipindahkan dari root `prompts/`, `ask.md` dan `debug.md` dibuat). Prompt inline panjang tidak ditulis langsung di config.
10. `skills.paths` memakai path relatif (`.agents/skills/custom`, `.agents/skills`, `.agents/skills/bawaan`) yang portabel lintas mesin; jangan memakai path absolut spesifik mesin.
11. Untuk konfigurasi Kilo generik (paths, fields, providers, TUI, Agent Manager, dll.), rujuk skill bawaan `kilo-config`; skill ini hanya memuat prosedur & larangan khusus proyek berhenti_merokok.
12. Perubahan pada config yang belum diputuskan pengguna (mis. `external_directory` yang menunjuk path usang dan `kilo_memory_recall: "*": "allow"`) DILARANG dilakukan sepihak; catat sebagai pertanyaan terbuka pada `diskusi_N.md`.
13. Isi tutorial commands pada skill ini bersumber dari berkas nyata di `.kilo/commands/` proyek dan riwayat commit; jangan menambah contoh fiktif.

## Tutorial Pembuatan Commands Kilo

### Lokasi dan Struktur

- Commands proyek berada di `.kilo/commands/`; baik direktori bernama `command/` maupun `commands/` didukung, dan pola pemuatan `{command,commands}/**/*.md` bersifat rekursif, sehingga subdirektori di proyek ini ikut dimuat: `.kilo/commands/mode/` (mis. `mode_diskusi.md`), `.kilo/commands/prd/` (mis. `kerjakan_prd.md`), `.kilo/commands/fitur/` (mis. `diskusi_fitur_baru.md`), `.kilo/commands/sinkronisasi/` (mis. `sinkronkan_commands.md`).
- Nama berkas (minus `.md`) menjadi nama command yang dipanggil (mis. `kerjakan_task.md` → `/kerjakan_task`).
- Mirror manual `gpt/` (root proyek) dijaga sinkron dengan `.kilo/commands/` via `.kilo/commands/sinkronkan_semua.md` atau `.kilo/commands/sinkronisasi/sinkronkan_commands.md`; mirror bukan sumber kebenaran.
- Config global `~/.config/kilo/command/*.md` berada di luar cakupan proyek ini; jangan mencampuradukkan.

### Frontmatter dan Nama Command

- Field frontmatter yang didukung: `description`, `agent`, `model`, `variant`, `subtask`.
- Frontmatter minimal cukup `description` bila tidak perlu override agent/model.
- Contoh nyata di proyek: `tambah_log.md` dan `analisa_log.md` (`description` + `agent: code`); `kerjakan_hasil_diskusi.md` dan `evaluasi_size_ruang_kerja.md` (hanya `description`); `kerjakan_task.md` (tanpa frontmatter sama sekali, tetap sah dimuat).
- Nama berkas harus aman dijadikan nama command: huruf kecil, angka, dan garis bawah; DILARANG memakai spasi (preseden: berkas `contoh satu.md` pernah di-rename karena nama command menjadi ambigu).
- `agent` pada frontmatter menunjuk agent yang menjalankan command (mis. `code`); `variant` override reasoning effort model; `subtask` menandai command sebagai subtask.

### Variabel Template

- `$1`–`$N`: argumen positional (kata ke-1 sampai ke-N dari argumen command).
- `$ARGUMENTS`: seluruh string argumen apa adanya.
- `@file`: TIDAK di-expand oleh Kilo (terverifikasi via uji pada sesi 2026-11-13); teks sampai ke model apa adanya dan agen membaca isi berkas dengan tool `read`. Jangan menaruh `@file` dengan harapan isinya disuntik otomatis.
- `` !`cmd` ``: output shell; sintaks ini berisiko ambigu di editor dan DILARANG dipakai pada command proyek.
- Kedua variabel positional (`$1`, `$ARGUMENTS`) terverifikasi di-substitute (command tanpa argumen → keduanya kosong).
- Tidak ada command di repo saat ini yang memakai variabel template; variabel di atas bersumber dari dokumentasi resmi Workflows dan verifikasi sesi 2026-11-13.

### Subcommand dan Fallback

- Command kustom TIDAK dapat mendaftarkan subcommand lewat frontmatter (berbeda dengan command bawaan seperti `/review uncommitted`).
- Pola (a): satu berkas dengan positional `$1` + percabangan instruksi + fallback tool `question` saat argumen kosong/tidak dikenal. Rujukan nyata pola fallback: `.kilo/commands/kerjakan_hasil_diskusi.md` (meminta input file diskusi bila belum ditentukan) dan `.kilo/commands/sinkronkan_semua.md` (memakai `git status`/`git diff` sebagai sumber saat konteks hilang, lalu `question` bila tetap tidak jelas).
- Pola (b): satu berkas per subcommand (masing-masing tampil sebagai entri terpisah) dengan logika bersama di-*include*. Catatan akurasi: contoh historis pola ini (`contoh_menu.md`, `contoh_menu_satu.md`, `contoh_menu_dua.md`, `.kilo/shared/contoh_bersama.md`) **tidak ditemukan di repository** (dibuat di working tree pada 2026-11-13, tidak pernah ter-commit, dan kini sudah tidak ada) — jangan dirujuk seolah berkas nyata; gunakan pola (a) atau susun berkas baru sesuai kebutuhan.

### Konvensi Proyek untuk Commands

- Isi command menggunakan bahasa Indonesia baku, bergaya instruksi untuk agen (bukan kode Dart).
- Cantumkan larangan eksplisit bila command tidak boleh menyentuh sesuatu (kode Dart, file hasil generate, arsip `hasil_diskusi/`, `docs/kilo/kilo_global.txt`, commit/push) — contoh nyata: `.kilo/commands/sinkronkan_semua.md`.
- Larangan umum lain: jangan commit/push kecuali diminta; jangan mengubah config Kilo tanpa keputusan pengguna.
- Contoh command yang baik di proyek ini: `.kilo/commands/tambah_log.md`, `.kilo/commands/kerjakan_task.md`, `.kilo/commands/analisa_log.md`, `.kilo/commands/kerjakan_hasil_diskusi.md`.
- Setelah membuat/mengubah command, sinkronkan mirror `gpt/` bila diminta pengguna (via `sinkronkan_semua.md` atau `sinkronisasi/sinkronkan_commands.md`) dan perbarui `MEMORI.md`/`memori/riwayat_perubahan.md` bila mengubah state proyek.
- Jangan menyalin isi command ke dalam skill atau dokumen lain; rujuk path berkasnya.

## Larangan

- DILARANG melewati, mengakali, atau mendelegasikan izin `deny` (`cat *`, `sed *`, `python3 *`, `read` `*.env`/`*.env.*`) lewat perintah atau tool lain.
- DILARANG menjadikan `docs/kilo/kilo_global.txt` atau `~/.config/kilo/kilo.jsonc` sebagai sumber kebenaran permission/konfigurasi aktif proyek.
- DILARANG menyalin isi atau nilai `.kilo/kilo.jsonc` (model, daftar permission, `instructions`) ke dalam skill, dokumen, atau command sebagai snapshot; rujuk path berkas.
- DILARANG membuat atau mengubah `.kilo/kilo.jsonc` tanpa perintah pengguna, dan DILARANG commit/push config tanpa perintah eksplisit.
- DILARANG menulis prompt agent inline panjang di config; gunakan berkas di `.kilo/prompts/` + `{file:...}`.
- DILARANG `skills.paths` dengan path absolut spesifik mesin; gunakan path relatif.
- DILARANG nama berkas command mengandung spasi; gunakan huruf kecil/angka/garis bawah.
- DILARANG mendaftarkan subcommand command kustom lewat frontmatter (tidak didukung); gunakan pola positional + fallback atau berkas per subcommand.
- DILARANG memakai sintaks `` !`cmd` `` dan DILARANG mengandalkan `@file` ter-expand otomatis pada command proyek.
- DILARANG mengarang isi dokumen resmi Kilo; skill hanya merujuk URL, tidak menyalin isinya.
- DILARANG mengubah config untuk temuan yang menunggu keputusan pengguna (mis. `external_directory` usang dan `kilo_memory_recall: "*": "allow"`).

## Contoh Benar

```jsonc
// Pola wiring prompt agent dengan berkas (di .kilo/kilo.jsonc — commit 50ee3c7, 26362be)
"agent": {
  "ask": {
    "model": "kilo/kilo-auto/free",
    "variant": "max",
    "prompt": "{file:./prompts/ask.md}"
  }
}
```

```markdown
<!-- .kilo/commands/tambah_log.md (contoh nyata — frontmatter minimal + instruksi bahasa Indonesia) -->
---
description: Menambahkan log debug terstruktur (L.i, L.w, L.e) secara presisi pada variabel dan parameter di file Dart yang ditentukan sesuai standar proyek.
agent: code
---

# TUJUAN UTAMA

Perintahkan AI untuk menambahkan baris log debug ...
```

```markdown
<!-- Pola fallback saat argumen kosong/tidak dikenal (dirujuk dari .kilo/commands/sinkronkan_semua.md) -->
Jika konteks percakapan sesi ini sudah hilang (mis. setelah auto compaction), gunakan `git status` dan `git diff` untuk menentukan pembaruan, dan jangan menebak. Jika tetap tidak jelas, tanyakan dulu ke pengguna dengan tool `question` sebelum mengubah berkas apa pun.
```

## Contoh Salah

```jsonc
// Prompt inline panjang langsung di config
"debug": {
  "model": "kilo/kilo-auto/free",
  "prompt": "kamu harus mengatasi masalah ini, agar mengikuti file dependensi nya supaya ketemu solusinya" // salah: prompt inline; wajib berkas di .kilo/prompts/ + {file:...}
}
```

```bash
# Mengakali deny dengan interpreter lain
python3 -c "print(open('.env').read())"   # DILARANG: deny `python3 *` bersifat mutlak
sed -n '1,20p' .env                        # DILARANG: deny `sed *` dan `read *.env`
cat .env                                   # DILARANG: deny `cat *`
```

```markdown
<!-- Snapshot config ke dalam skill/dokumen -->
Skill ini mencatat bahwa permission proyek berisi `"*": "ask"`, `"git status *": "allow"`, ... // salah: snapshot cepat usang; rujuk .kilo/kilo.jsonc
```

```markdown
<!-- Frontmatter command mencoba mendaftar subcommand -->
---
description: Menu utama
subcommands: [satu, dua]   # salah: field tidak didukung; subcommand via $1 + fallback atau berkas per subcommand
---
```

## Sumber Evaluasi

Berkas sumber (proyek):

- File: `.kilo/kilo.jsonc` (sumber kebenaran konfigurasi & permission), `AGENTS.md` (aturan 11), `docs/kilo/kilo_global.txt` (arsip usang), `MEMORI.md`, `memori/riwayat_perubahan.md`, `SKILLS_INDEX.md`
- File: `.kilo/prompts/code.md`, `.kilo/prompts/ask.md`, `.kilo/prompts/debug.md`
- File: `.kilo/commands/tambah_log.md`, `.kilo/commands/analisa_log.md`, `.kilo/commands/kerjakan.md`, `.kilo/commands/kerjakan_task.md`, `.kilo/commands/kerjakan_hasil_diskusi.md`, `.kilo/commands/evaluasi_size_ruang_kerja.md`, `.kilo/commands/sinkronkan_semua.md`, `.kilo/commands/mode/mode_diskusi.md`, `.kilo/commands/prd/kerjakan_prd.md`, `.kilo/commands/fitur/diskusi_fitur_baru.md`, `.kilo/commands/sinkronisasi/sinkronkan_commands.md`
- Catatan akurasi: `contoh_menu*.md` dan `.kilo/shared/contoh_bersama.md` yang disebut pada diskusi_6 tidak ditemukan di repository (tidak pernah ter-commit); tutorial merujuk berkas nyata di atas.
- Skill bawaan: `kilo-config` (builtin, konfigurasi Kilo generik)
- Diskusi terkait: `hasil_diskusi/diskusi_6.md` (K-1 s.d. K-10, R-1 s.d. R-5, TL-1 s.d. TL-5)

Commit rujukan (menyentuh `.kilo/kilo.jsonc` dan/atau `.kilo/prompts/`; sumber isi disusun dari commit yang berkaitan sesuai `.agents/rules/global/aturan_skill.md` §5):

- `26362be` (terbaru relevan — menyentuh `.kilo/kilo.jsonc` dan `.kilo/prompts/ask.md`, `.kilo/prompts/debug.md`)
- `50ee3c7` (penerapan config proyek `.kilo/kilo.jsonc` dan pemindahan `prompts/code.md` → `.kilo/prompts/code.md`)
- `afd2064` (model `agent.code` → `openrouter/thinkingmachines/inkling-2-small:free`, variant `high` → `max`)
- `3bb9ebb` (pembuatan config proyek awal + `prompts/code.md`)
- `6ec9cce`, `7e0a4ef`, `944bb73` (config proyek: indexing & retention)
- `4a5329a` (dokumentasi tutorial commands pada diskusi_6 + perbarui prompt commit)

Dokumen resmi Kilo (92 URL unik; K-8 diverifikasi dapat diakses pada sesi diskusi_6 2026-11-13; 85 URL lainnya — 36 K-9 + 49 K-10 — diverifikasi 2026-11-13 saat pembuatan skill, seluruhnya OK; isi dokumen tidak disalin):

K-8 (dok-dok resmi terpilih, 7 URL):

- https://kilo.ai/docs/customize/workflows
- https://kilo.ai/docs/customize/skills
- https://kilo.ai/docs/getting-started/settings
- https://kilo.ai/docs/customize/agent-permissions
- https://kilo.ai/docs/customize/custom-instructions
- https://kilo.ai/docs/code-with-ai/platforms/cli
- https://kilo.ai/docs/code-with-ai/platforms/cli-reference

K-9 (daftar dari `.kilo/commands/optimalkan_kilo.md`, dideduplikasi terhadap K-8; 36 URL baru):

- https://kilo.ai/docs/customize
- https://kilo.ai/docs/customize/marketplace
- https://kilo.ai/docs/customize/custom-modes
- https://kilo.ai/docs/customize/custom-rules
- https://kilo.ai/docs/customize/custom-subagents
- https://kilo.ai/docs/customize/agents-md
- https://kilo.ai/docs/customize/prompt-engineering
- https://kilo.ai/docs/customize/context/codebase-indexing
- https://kilo.ai/docs/customize/context/context-condensing
- https://kilo.ai/docs/customize/context/kilocodeignore
- https://kilo.ai/docs/code-with-ai/features/autocomplete
- https://kilo.ai/docs/code-with-ai/features/enhance-prompt
- https://kilo.ai/docs/code-with-ai/features/browser-use
- https://kilo.ai/docs/code-with-ai/features/task-todo-list
- https://kilo.ai/docs/code-with-ai/features/checkpoints
- https://kilo.ai/docs/code-with-ai/features/file-encoding
- https://kilo.ai/docs/code-with-ai/features/message-feedback
- https://kilo.ai/docs/code-with-ai/agents/goals
- https://kilo.ai/docs/code-with-ai/agents/auto-model
- https://kilo.ai/docs/code-with-ai/agents/model-selection
- https://kilo.ai/docs/code-with-ai/agents/context-mentions
- https://kilo.ai/docs/code-with-ai/agents/session-history
- https://kilo.ai/docs/code-with-ai/agents/chat-interface
- https://kilo.ai/docs/code-with-ai/gastown
- https://kilo.ai/docs/code-with-ai/gastown/quick-start
- https://kilo.ai/docs/code-with-ai/gastown/concepts
- https://kilo.ai/docs/code-with-ai/gastown/mayor
- https://kilo.ai/docs/code-with-ai/gastown/sling-work
- https://kilo.ai/docs/code-with-ai/gastown/code-review
- https://kilo.ai/docs/code-with-ai/gastown/settings
- https://kilo.ai/docs/code-with-ai/gastown/wasteland
- https://kilo.ai/docs/code-with-ai/gastown/wasteland/quick-start
- https://kilo.ai/docs/code-with-ai/gastown/wasteland/workflow
- https://kilo.ai/docs/code-with-ai/gastown/wasteland/admin
- https://kilo.ai/docs/code-with-ai/gastown/wasteland/concepts
- https://kilo.ai/docs/code-with-ai/gastown/wasteland/settings

K-10 (URL tambahan relevan konfigurasi Kilo, tanpa duplikat; sumber indeks `https://kilo.ai/docs/llms.txt`; 49 URL):

- https://kilo.ai/docs/getting-started/installing
- https://kilo.ai/docs/getting-started/setup-authentication
- https://kilo.ai/docs/getting-started/using-kilo-for-free
- https://kilo.ai/docs/getting-started/byok
- https://kilo.ai/docs/ai-providers
- https://kilo.ai/docs/getting-started/settings/auto-approving-actions
- https://kilo.ai/docs/getting-started/settings/sandboxing
- https://kilo.ai/docs/getting-started/settings/notifications
- https://kilo.ai/docs/getting-started/settings/keep-awake
- https://kilo.ai/docs/getting-started/adding-credits
- https://kilo.ai/docs/getting-started/rate-limits-and-costs
- https://kilo.ai/docs/getting-started/cost-controls-and-usage-safeguards
- https://kilo.ai/docs/getting-started/migrating
- https://kilo.ai/docs/getting-started/troubleshooting
- https://kilo.ai/docs/getting-started/using-docs-with-agents
- https://kilo.ai/docs/automate
- https://kilo.ai/docs/automate/integrations
- https://kilo.ai/docs/automate/code-reviews/overview
- https://kilo.ai/docs/automate/code-reviews/github
- https://kilo.ai/docs/automate/code-reviews/gitlab
- https://kilo.ai/docs/automate/agent-manager
- https://kilo.ai/docs/automate/agent-manager-workflows
- https://kilo.ai/docs/automate/agent-manager-projects
- https://kilo.ai/docs/automate/extending/local-models
- https://kilo.ai/docs/automate/extending/shell-integration
- https://kilo.ai/docs/automate/extending/plugins
- https://kilo.ai/docs/automate/mcp/overview
- https://kilo.ai/docs/automate/mcp/using-in-kilo-code
- https://kilo.ai/docs/automate/mcp/using-in-cli
- https://kilo.ai/docs/automate/mcp/what-is-mcp
- https://kilo.ai/docs/automate/mcp/server-transports
- https://kilo.ai/docs/automate/mcp/mcp-vs-api
- https://kilo.ai/docs/automate/how-tools-work
- https://kilo.ai/docs/automate/tools
- https://kilo.ai/docs/automate/tools/semantic-search
- https://kilo.ai/docs/customize/context/memory
- https://kilo.ai/docs/contributing
- https://kilo.ai/docs/contributing/development-environment
- https://kilo.ai/docs/contributing/ecosystem
- https://kilo.ai/docs/contributing/architecture
- https://kilo.ai/docs/contributing/architecture/cli-runtime
- https://kilo.ai/docs/contributing/architecture/vscode-extension
- https://kilo.ai/docs/contributing/architecture/jetbrains-plugin
- https://kilo.ai/docs/contributing/architecture/cloud-platform
- https://kilo.ai/docs/contributing/architecture/automation-services
- https://kilo.ai/docs/contributing/architecture/cloud-security
- https://kilo.ai/docs/contributing/architecture/development-patterns
- https://kilo.ai/docs/contributing/architecture/config-schema
- https://kilo.ai/docs/code-with-ai/agents/custom-models
