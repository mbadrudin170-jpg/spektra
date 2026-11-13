#!/bin/bash

# Script untuk menyalin isi file-file tertentu ke README_PAKET.md
# Berdasarkan daftar path yang ada di code_paket.txt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CODEPAKET_FILE="$PROJECT_DIR/code_paket.txt"
README_FILE="$PROJECT_DIR/README_PAKET.md"

# Validasi file code_paket.txt ada
if [ ! -f "$CODEPAKET_FILE" ]; then
    echo "ERROR: File $CODEPAKET_FILE tidak ditemukan" >&2
    exit 1
fi

# Buat README_PAKET.md baru
{
    echo "# Dokumentasi Paket Eksternal"
    echo ""
    echo "Diperbarui: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "# File Paket Eksternal"
    echo ""

    # Baca setiap path dari code_paket.txt dan salin isinya
    first=true
    declare -A seen=()
    while IFS= read -r filepath || [ -n "$filepath" ]; do
        # Lewati baris kosong
        if [ -z "$filepath" ]; then
            continue
        fi

        # Lewati duplikat
        if [ -n "${seen[$filepath]+x}" ]; then
            continue
        fi
        seen["$filepath"]=1

        # Validasi file ada
        if [ ! -f "$filepath" ]; then
            # echo "WARNING: File tidak ditemukan: $filepath" >&2
            continue
        fi

        # Tambah separator antar file (kecuali sebelum file pertama yang valid)
        if [ "$first" = true ]; then
            first=false
        else
            echo "---"
            echo ""
        fi

        echo "## $filepath"
        echo ""
        echo "\`\`\`dart"
        cat "$filepath"
        echo "\`\`\`"
        echo ""
    done < "$CODEPAKET_FILE"

} > "$README_FILE"

echo "Berhasil memperbarui $README_FILE"
