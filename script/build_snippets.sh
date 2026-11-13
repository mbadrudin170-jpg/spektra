#!/bin/bash

# ============================================================
# SCRIPT: build_snippets.sh
# Menggabungkan semua file .code-snippets dari .vscode/ ke docs/snippet.md
# ============================================================

OUTPUT_FILE="docs/snippet.md"

# Pastikan folder docs/ ada
mkdir -p docs

echo "🔄 Menggabungkan semua snippet VS Code ke $OUTPUT_FILE..."

# Kosongkan file output
> "$OUTPUT_FILE"

# Cari semua file .code-snippets di .vscode/
find .vscode -type f -name "*.code-snippets" | sort | while read -r file; do
    echo "// ============================================================" >> "$OUTPUT_FILE"
    echo "// FILE: $file" >> "$OUTPUT_FILE"
    echo "// ============================================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"

    # Bungkus isi file dengan blok kode JSON
    echo '```json' >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"

    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "✅ Selesai! Semua snippet tersimpan di $OUTPUT_FILE"