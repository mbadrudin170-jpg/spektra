#!/bin/bash

# ============================================================
# SCRIPT: cp_to_service.sh
# FUNGSI: Menyalin file/folder dari warkop ke service
# ============================================================


SOURCE_BASE="$HOME/warkop"
DEST_BASE="$HOME/service"

# ============================================================
# 📋 DAFTAR PATH DEFAULT
#    - Tuliskan path relatif dari folder warkop
#    - Contoh: analysis_options.yaml  (bukan /home/.../analysis_options.yaml)
#    - Bisa berupa file atau folder
#    - Baris kosong dan komentar (#) diabaikan
# ============================================================
DEFAULT_PATHS="
.agents/rules/log_debug_aturan.md


"

# ============================================================
# 🔍 GENERATE DAFTAR FILE (otomatis di awal)
# ============================================================

# Buat folder service jika belum ada
mkdir -p "$DEST_BASE"

echo "📂 Menghasilkan daftar file relatif dari $SOURCE_BASE..."
find "$SOURCE_BASE" -type f \
  -not -path "*/\.git/*" \
  -not -path "*/build/*" \
  -not -path "*/.dart_tool/*" \
  -not -path "*/android/.gradle/*" \
  | sort \
  | sed "s|^$SOURCE_BASE/||" > "$DEST_BASE/struktur_proyek_warkop.md"

echo "✅ Daftar file tersimpan di $DEST_BASE/struktur_proyek_warkop.md"
echo ""

# ============================================================
# KODE UTAMA (TIDAK PERLU DIUBAH)
# ============================================================

# Fungsi bantuan
usage() {
    echo "Penggunaan: $0 [options] <path_relatif1> [path_relatif2 ...]"
    echo "Atau:       $0 --from-list <file_daftar>"
    echo "Atau:       $0 (tanpa argumen, pakai DEFAULT_PATHS)"
    echo ""
    echo "Options:"
    echo "  --from-list FILE   Baca daftar path dari file"
    echo "  --help             Tampilkan bantuan ini"
    echo ""
    echo "Contoh:"
    echo "  $0 analysis_options.yaml"
    echo "  $0 lib/fitur/arus_kas pubspec.yaml"
    echo "  $0 --from-list daftar.txt"
    echo "  $0                 (pakai DEFAULT_PATHS)"
    echo ""
    echo "Path relatif dari $SOURCE_BASE"
    exit 1
}

# Proses argumen
PATHS=()
FROM_LIST=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --from-list)
            if [ -z "$2" ]; then
                echo "❌ Error: --from-list membutuhkan nama file"
                usage
            fi
            FROM_LIST="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        *)
            PATHS+=("$1")
            shift
            ;;
    esac
done

# Jika menggunakan --from-list, baca file
if [ -n "$FROM_LIST" ]; then
    if [ ! -f "$FROM_LIST" ]; then
        echo "❌ Error: File '$FROM_LIST' tidak ditemukan"
        exit 1
    fi
    while IFS= read -r line || [ -n "$line" ]; do
        trimmed=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [ -n "$trimmed" ] && [[ ! "$trimmed" =~ ^# ]]; then
            PATHS+=("$trimmed")
        fi
    done < "$FROM_LIST"
fi

# Jika tidak ada argumen dan tidak ada --from-list, gunakan DEFAULT_PATHS
if [ ${#PATHS[@]} -eq 0 ] && [ -z "$FROM_LIST" ]; then
    echo "📋 Menggunakan daftar DEFAULT_PATHS dari script..."
    while IFS= read -r line || [ -n "$line" ]; do
        trimmed=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if [ -n "$trimmed" ] && [[ ! "$trimmed" =~ ^# ]]; then
            PATHS+=("$trimmed")
        fi
    done <<< "$DEFAULT_PATHS"
fi

# Cek apakah ada path yang diberikan
if [ ${#PATHS[@]} -eq 0 ]; then
    echo "❌ Error: Tidak ada path yang diberikan"
    usage
fi

# Fungsi untuk menyalin satu item
copy_item() {
    local rel_path="$1"
    local source_file="$SOURCE_BASE/$rel_path"
    local dest_file="$DEST_BASE/$rel_path"

    if [ ! -e "$source_file" ]; then
        echo "❌ Error: Sumber tidak ditemukan: $source_file"
        return 1
    fi

    local dest_dir=$(dirname "$dest_file")
    mkdir -p "$dest_dir"

    if [ -d "$source_file" ]; then
        echo "📁 Menyalin folder: $rel_path"
        cp -r "$source_file" "$dest_dir/"
        echo "✅ Folder berhasil disalin ke: $dest_file"
    else
        echo "📄 Menyalin file: $rel_path"
        cp "$source_file" "$dest_file"
        echo "✅ File berhasil disalin ke: $dest_file"
    fi
}

# Loop untuk setiap path
echo "📂 Sumber base: $SOURCE_BASE"
echo "📂 Tujuan base: $DEST_BASE"
echo "📋 Total item: ${#PATHS[@]}"
echo ""

for path in "${PATHS[@]}"; do
    copy_item "$path"
done

echo ""
echo "🎉 Selesai menyalin semua item."