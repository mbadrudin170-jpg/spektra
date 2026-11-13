#!/bin/bash

# ============================================================
# Skrip migrasi Log → L (versi diperbaiki)
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DRY_RUN=false

# Daftar file/folder yang akan diproses (bisa ditambah via argumen)
FILES=(
)

# Parse argumen
for arg in "$@"; do
    if [ "$arg" == "--dry-run" ] || [ "$arg" == "-n" ]; then
        DRY_RUN=true
        continue
    fi
    FILES+=("$arg")
done

if [ ${#FILES[@]} -eq 0 ]; then
    echo "Usage: $0 [--dry-run] <file1.dart> <dir1> ..."
    exit 1
fi

process_file() {
    local FILE="$1"
    local BASENAME
    BASENAME=$(basename "$FILE")

    echo -e "${YELLOW}🔄 Memproses $FILE ...${NC}"
    if [ "$DRY_RUN" = true ]; then
        echo -e "   ${GREEN}DRY RUN: Akan mengubah $FILE${NC}"
        return
    fi

    # ============================================================
    # 1. Ganti impor log.dart → l.dart (aman)
    # ============================================================
    # Ganti baris yang mengandung import log.dart
    sed -i "s|^import.*['\"]package:myapp/shared/utils/log\.dart['\"].*|import 'package:myapp/shared/utils/l.dart';|" "$FILE"
    sed -i "s|^import.*['\"].*log\.dart['\"].*|import 'package:myapp/shared/utils/l.dart';|" "$FILE"

    # ============================================================
    # 2. Hapus duplikasi impor l.dart (jika ada lebih dari 1)
    # ============================================================
    local count
    count=$(grep -c "import 'package:myapp/shared/utils/l.dart';" "$FILE" || true)
    if [ "$count" -gt 1 ]; then
        # Hapus semua baris import l.dart
        sed -i "/import 'package:myapp\/shared\/utils\/l\.dart';/d" "$FILE"
        # Sisipkan kembali satu baris di akhir daftar import
        local LAST_IMPORT_LINE
        LAST_IMPORT_LINE=$(grep -n '^import' "$FILE" | tail -1 | cut -d: -f1)
        if [ -n "$LAST_IMPORT_LINE" ]; then
            sed -i "${LAST_IMPORT_LINE}a\\
import 'package:myapp/shared/utils/l.dart';" "$FILE"
        else
            sed -i "1i\\
import 'package:myapp/shared/utils/l.dart';" "$FILE"
        fi
    fi

    # ============================================================
    # 3. Perbaiki konstanta file yang masih memakai triple quote
    # ============================================================
    sed -i "s/const String file = '''\([^']*\)''';/const String file = '\1';/" "$FILE"
    sed -i 's/const String file = """\([^"]*\)""";/const String file = '\''\1'\'';/' "$FILE"

    # ============================================================
    # 4. Tambahkan konstanta file jika belum ada
    # ============================================================
    if ! grep -q "const String file =" "$FILE"; then
        local LAST_IMPORT_LINE
        LAST_IMPORT_LINE=$(grep -n '^import' "$FILE" | tail -1 | cut -d: -f1)
        if [ -n "$LAST_IMPORT_LINE" ]; then
            sed -i "${LAST_IMPORT_LINE}a\\
\\
const String file = '${BASENAME}';" "$FILE"
        else
            sed -i "1i\\
const String file = '${BASENAME}';\\
" "$FILE"
        fi
    fi

    # ============================================================
    # 5. Ganti nama metode (Log.xxx → L.xxx)
    # ============================================================
    sed -i 's/Log\.info(/L.i(/g' "$FILE"
    sed -i 's/Log\.sukses(/L.s(/g' "$FILE"
    sed -i 's/Log\.warning(/L.w(/g' "$FILE"
    sed -i 's/Log\.error(/L.e(/g' "$FILE"
    sed -i 's/Log\.api(/L.api(/g' "$FILE"

    # ============================================================
    # 6. Tambahkan parameter ', file' pada panggilan L.i / L.s / L.w / L.e
    #    (tidak menyentuh L.api karena signature-nya berbeda)
    # ============================================================
    # Catatan: pendekatan ini relatif aman untuk kasus umum.
    # Untuk kasus sangat kompleks (multi-line / banyak named parameter)
    # sebaiknya diperiksa manual setelah migrasi.

    # L.i(...)
    perl -i -pe '
        s/L\.i\(\s*([^,\)]+)(\s*)\)/L.i($1, file)/g;
        s/L\.i\(\s*([^,\)]+)\s*,\s*(?!\s*file\b)([^)]*)\)/L.i($1, file, $2)/g;
    ' "$FILE"

    # L.s(...)
    perl -i -pe '
        s/L\.s\(\s*([^,\)]+)(\s*)\)/L.s($1, file)/g;
        s/L\.s\(\s*([^,\)]+)\s*,\s*(?!\s*file\b)([^)]*)\)/L.s($1, file, $2)/g;
    ' "$FILE"

    # L.w(...)
    perl -i -pe '
        s/L\.w\(\s*([^,\)]+)(\s*)\)/L.w($1, file)/g;
        s/L\.w\(\s*([^,\)]+)\s*,\s*(?!\s*file\b)([^)]*)\)/L.w($1, file, $2)/g;
    ' "$FILE"

    # L.e(...)  → sesuai signature: L.e(String message, String file, {dynamic data})
    # Menghapus e: dan s: jika ada, lalu memastikan parameter file ada.
    perl -i -pe '
        # Hapus parameter e: dan s: yang tidak didukung
        s/,\s*e:\s*[^,\)]+//g;
        s/,\s*s:\s*[^,\)]+//g;

        # Tambahkan file jika belum ada
        s/L\.e\(\s*([^,\)]+)(\s*)\)/L.e($1, file)/g;
        s/L\.e\(\s*([^,\)]+)\s*,\s*(?!\s*file\b)([^)]*)\)/L.e($1, file, $2)/g;
    ' "$FILE"

    echo -e "   ${GREEN}✅ Selesai memproses $FILE${NC}"
}

# ============================================================
# Kumpulkan semua file .dart
# ============================================================
declare -a ALL_FILES

for item in "${FILES[@]}"; do
    [ -z "$item" ] && continue
    if [ -f "$item" ] && [[ "$item" == *.dart ]]; then
        ALL_FILES+=("$item")
    elif [ -d "$item" ]; then
        while IFS= read -r -d '' file; do
            ALL_FILES+=("$file")
        done < <(find "$item" -type f -name "*.dart" \
            ! -name "*.g.dart" \
            ! -name "*.freezed.dart" \
            -print0)
    else
        echo -e "${RED}⚠️  $item bukan file .dart atau folder yang valid${NC}"
    fi
done

# Hapus duplikat
IFS=$'\n' ALL_FILES=($(sort -u <<<"${ALL_FILES[*]}"))
unset IFS

if [ ${#ALL_FILES[@]} -eq 0 ]; then
    echo -e "${RED}Tidak ada file .dart yang ditemukan.${NC}"
    exit 1
fi

echo -e "${GREEN}Menemukan ${#ALL_FILES[@]} file .dart untuk diproses.${NC}"

for file in "${ALL_FILES[@]}"; do
    process_file "$file"
done

echo -e "${GREEN}✅ Semua file selesai diproses.${NC}"
echo -e "${YELLOW}⚠️  Harap periksa hasilnya secara manual, khususnya:${NC}"
echo -e "${YELLOW}   • Pemanggilan L.e (pastikan tidak ada e: / s:)${NC}"
echo -e "${YELLOW}   • Pemanggilan L.api${NC}"
echo -e "${YELLOW}   • Baris import dan konstanta file${NC}"