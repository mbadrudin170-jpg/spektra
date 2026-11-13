#!/bin/bash
set -euo pipefail

OUTPUT_FILES=(
AGENTS.md
)

ADDITIONAL_FILES=(
)

# Folder yang isinya ingin di-cat (semua file di dalam folder)
FOLDERS=(
)

for OUTPUT_FILE in "${OUTPUT_FILES[@]}"; do
    echo "🔄 Menggabungkan isi semua file aturan ke $OUTPUT_FILE..."
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    : > "$OUTPUT_FILE"

    # Folder aturan dipindahkan dari prompt/aturan ke .agents/rules
    if [[ -d .agents/rules ]]; then
        while IFS= read -r file; do
            {
                echo "// ============================================================"
                echo "// FILE: $file"
                echo "// ============================================================"
                echo ""
                sed '/^$/d' "$file"
                echo ""
                echo ""
            } >> "$OUTPUT_FILE"
        done < <(find .agents/rules -type f -name "*.md" ! -name "AGENTS.md" | sort)
    fi

    for file in "${ADDITIONAL_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            {
                echo "// ============================================================"
                echo "// FILE: $file"
                echo "// ============================================================"
                echo ""
                sed '/^$/d' "$file"
                echo ""
                echo ""
            } >> "$OUTPUT_FILE"
        else
            echo "⚠️ Peringatan: File $file tidak ditemukan"
        fi
    done

    # Proses FOLDERS: cat semua file di dalam folder (rekursif)
    for folder in "${FOLDERS[@]}"; do
        [[ -z "$folder" || "$folder" == \#* ]] && continue
        if [[ ! -d "$folder" ]]; then
            echo "⚠️ Peringatan: Folder $folder tidak ditemukan"
            continue
        fi
        while IFS= read -r file; do
            [[ -z "$file" ]] && continue
            {
                echo "// ============================================================"
                echo "// FILE: $file"
                echo "// ============================================================"
                echo ""
                sed '/^$/d' "$file"
                echo ""
                echo ""
            } >> "$OUTPUT_FILE"
        done < <(find "$folder" -type f | sort)
    done

    echo "✅ Selesai! Semua isi aturan telah digabung ke $OUTPUT_FILE"
done