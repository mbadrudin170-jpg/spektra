#!/bin/bash
# ============================================================
# SCRIPT : build_structure.sh
# FUNGSI : Menghasilkan struktur proyek (rekursif) ke markdown
#          - Mirip `ls -R` tapi rapi
#          - Filter file *.freezed.dart & *.g.dart
#          - Opsi: tampilkan isi file (cat)
# ============================================================

set -euo pipefail

# ---------- KONFIGURASI ----------
OUTPUT_FILE="docs/struktur_proyek.md"
DIRS=("lib" "assets" "supabase")

# Ubah ke "true" kalau ingin sekaligus menampilkan ISI setiap file
INCLUDE_CONTENT="false"

# Ekstensi yang di-cat (biar file binary seperti .png/.ttf tidak dirusak)
TEXT_EXT_REGEX='\.(dart|yaml|yml|json|md|txt|xml|html|css|js|ts|kt|java|gradle|properties|env|sh)$'

# Pattern yang di-skip (regex ERE)
SKIP_REGEX='(\.freezed\.dart|\.g\.dart|/\.git/|/build/|/\.dart_tool/|/node_modules/)'

# ---------- PERSIAPAN ----------
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "🔄 Membangun struktur proyek..."
echo "   Output : $OUTPUT_FILE"
echo "   Folder : ${DIRS[*]}"
echo "   Isi    : $INCLUDE_CONTENT"
echo

# ---------- GENERATE ----------
{
  for dir in "${DIRS[@]}"; do
    # Skip kalau direktori tidak ada
    if [ ! -d "$dir" ]; then
      echo "## ⚠️  $dir (tidak ditemukan)"
      echo
      continue
    fi

    echo "## 📁 $dir"
    echo

    # Ambil semua file rekursif, urutkan, filter
    while IFS= read -r -d '' file; do
      rel="${file#"$dir"/}"   # path relatif terhadap $dir

      if [ "$INCLUDE_CONTENT" = "true" ]; then
        echo "### 📄 $file"
        echo

        # Cek apakah file teks
        if [[ "$file" =~ $TEXT_EXT_REGEX ]]; then
          echo '```'"${file##*.}"
          cat "$file"
          echo
          echo '```'
        else
          echo "_[binary file — isi tidak ditampilkan]_"
        fi
        echo
      else
        # Mode list saja
        echo "- \`$file\`"
      fi
    done < <(
      find "$dir" -type f -print0 \
        | sort -z \
        | while IFS= read -r -d '' f; do
            if [[ ! "$f" =~ $SKIP_REGEX ]]; then
              printf '%s\0' "$f"
            fi
          done
    )

    echo
  done
} > "$OUTPUT_FILE"

# ---------- CEK HASIL ----------
if [ ! -s "$OUTPUT_FILE" ]; then
  echo "⚠️  Tidak ada file yang ditemukan setelah penyaringan."
  echo "Tidak ada konten yang sesuai dengan kriteria." > "$OUTPUT_FILE"
  exit 1
fi

echo "✅ Selesai. Tersimpan di $OUTPUT_FILE"