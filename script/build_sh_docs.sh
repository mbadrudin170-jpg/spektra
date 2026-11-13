#!/bin/bash

# ============================================================
# SCRIPT: build_sh_docs.sh
# Menggabungkan semua file .sh (otomatis) + file custom (manual)
# ============================================================

OUTPUT_FILE="docs/sh.md"

# Pastikan folder docs/ ada
mkdir -p docs

echo "🔄 Menggabungkan semua file Shell (.sh) ke $OUTPUT_FILE..."

# Kosongkan file output
> "$OUTPUT_FILE"

# ============================================================
# BAGIAN 1: AMBIL SEMUA FILE .sh SECARA OTOMATIS
# ============================================================

# Cari semua file .sh di root, script/, dan docs/
# Kecualikan bash_aliases.sh agar tidak menduplikasi alias
files=$(find . -maxdepth 3 -type f -name "*.sh" \
  ! -name "bash_aliases.sh" \
  ! -path "./.git/*" \
  ! -path "./.vscode/*" | sort)

# ============================================================
# BAGIAN 2: TAMBAHKAN FILE CUSTOM (jika ada argumen)
# ============================================================

# Jika ada argumen tambahan, tambahkan ke daftar files
if [ $# -gt 0 ]; then
    for custom_file in "$@"; do
        if [ -f "$custom_file" ]; then
            files="$files $custom_file"
            echo "📂 Menambahkan file custom: $custom_file"
        else
            echo "⚠️  File custom tidak ditemukan: $custom_file" >&2
        fi
    done
fi

# ============================================================
# BAGIAN 3: PROSES SEMUA FILE (otomatis + custom)
# ============================================================

# Urutkan daftar file (hilangkan duplikat jika ada)
files=$(echo "$files" | tr ' ' '\n' | sort -u | tr '\n' ' ')

for file in $files; do
    echo "// ============================================================" >> "$OUTPUT_FILE"
    echo "// FILE: $file" >> "$OUTPUT_FILE"
    echo "// ============================================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    echo '```bash' >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"

    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "✅ Selesai! Semua file Shell tersimpan di $OUTPUT_FILE"