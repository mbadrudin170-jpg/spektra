#!/bin/bash
# Path: build_docs.sh

# ============================================================
# Validasi argumen
# ============================================================
if [ $# -lt 1 ]; then
    echo "Penggunaan: $0 <output_file> [config_file]"
    echo "Contoh: $0 info.md"
    echo "Contoh: $0 info.md custom_files.txt"
    exit 1
fi

output_file="$1"
config_file="${2:-custom_files.txt}"

total_files=0
total_lines=0

# ============================================================
# Fungsi untuk memproses satu file
# ============================================================
process_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "⚠️  File tidak ditemukan: $file" >&2
        return 1
    fi

    # Hitung baris
    lines=$(wc -l < "$file" 2>/dev/null || echo 0)
    total_lines=$((total_lines + lines))
    ((total_files++))

    {
        echo -e "\n\n// ============================================================"
        echo -e "// FILE: $file"
        echo -e "// ============================================================"

        case "${file##*.}" in
            md|txt) cat "$file" ;;
            dart)   echo '```dart'; cat "$file"; echo '```' ;;
            sh)     echo '```bash'; cat "$file"; echo '```' ;;
            sql)    echo '```sql';  cat "$file"; echo '```' ;;
            json)   echo '```json'; cat "$file"; echo '```' ;;
            yaml|yml) echo '```yaml'; cat "$file"; echo '```' ;;
            *)      cat "$file" ;;
        esac
        echo ""
    } >> "$output_file"
}

# ============================================================
# Fungsi untuk memproses entri (file atau folder) - DIPERBAIKI
# ============================================================
process_entry() {
    local entry="$1"
    if [ -f "$entry" ]; then
        process_file "$entry"
    elif [ -d "$entry" ]; then
        echo "📁 Memproses folder: $entry" >&2
        # ⚡ PERBAIKAN: gunakan process substitution agar loop tidak di subshell
        while IFS= read -r -d '' file; do
            process_file "$file"
        done < <(find "$entry" -type f ! -name ".*" -print0)
    else
        echo "⚠️  Tidak ditemukan: $entry" >&2
        return 1
    fi
}

# ============================================================
# Mulai menulis ke file output (overwrite)
# ============================================================
> "$output_file"

# ============================================================
# Proses berdasarkan konfigurasi
# ============================================================
if [ -f "$config_file" ]; then
    echo "📄 Membaca daftar entri dari: $config_file"
    while IFS= read -r line || [ -n "$line" ]; do
        # Trim spasi
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        # Lewati baris kosong atau komentar
        if [[ -z "$line" || "$line" == \#* ]]; then
            continue
        fi
        process_entry "$line"
    done < "$config_file"
else
    echo "⚠️  File konfigurasi tidak ditemukan: $config_file"
    echo "📁 Mengambil semua file dari folder docs/ sebagai fallback"
    while IFS= read -r -d '' file; do
        process_file "$file"
    done < <(find docs -type f ! -name ".*" -print0 | sort -z)
fi

# ============================================================
# Tambahkan statistik di akhir
# ============================================================
{
    echo -e "\n\n// ============================================================"
    echo -e "// STATISTIK"
    echo -e "// ============================================================"
    echo -e "// Total file yang diproses : $total_files"
    echo -e "// Total baris kode        : $total_lines"
} >> "$output_file"

echo "✅ Dokumentasi selesai: $output_file"
echo "📊 Total file: $total_files"
echo "📊 Total baris: $total_lines"