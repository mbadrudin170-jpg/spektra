#!/bin/bash

# Script untuk mengumpulkan semua file model ke model.md
# Simpan sebagai: scripts/generate_model_docs.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== MENGUMPULKAN SEMUA FILE MODEL ===${NC}"

OUTPUT_DIR="docs"
OUTPUT_FILE="$OUTPUT_DIR/model.md"

mkdir -p "$OUTPUT_DIR"

# Tulis header
cat > "$OUTPUT_FILE" <<EOF
# DAFTAR SEMUA FILE MODEL

Dikumpulkan pada: $(date '+%Y-%m-%d %H:%M:%S')

---

EOF

total_model=0
total_lines=0

add_file_to_output() {
    local file="$1"
    local relative_path="${file#./}"
    
    lines=$(wc -l < "$file")
    total_lines=$((total_lines + lines))
    
    {
        echo "## 📄 File: $relative_path"
        echo ""
        echo "**Jumlah baris:** $lines"
        echo ""
        echo '```dart'
        cat "$file"
        echo '```'
        echo ""
        echo "---"
        echo ""
    } >> "$OUTPUT_FILE"
    
    ((total_model++))
}

echo -e "${YELLOW}Mencari file model...${NC}"

# Gunakan process substitution agar loop berjalan di shell utama
while IFS= read -r file; do
    # Lewati file di direktori yang tidak perlu
    if [[ "$file" == *".dart_tool/"* ]] || \
       [[ "$file" == *"build/"* ]] || \
       [[ "$file" == *"generated/"* ]] || \
       [[ "$file" == *".idx/"* ]] || \
       [[ "$file" == *"test/"* ]] || \
       [[ "$file" == *".freezed.dart" ]] || \
       [[ "$file" == *".g.dart" ]] || \
       [[ "$file" == *".getter.dart" ]]; then
        continue
    fi
    
    echo -e "${GREEN}✓${NC} Menambahkan: $file"
    add_file_to_output "$file"
done < <(
    find . -type f \( \
        -name "model.dart" \
        -o -name "*_model.dart" \
        -o -name "*model.dart" \
        -o -name "*.model.dart" \
        -o -name "*.freezed.dart" \
        -o -name "*.g.dart" \
        -o -name "*.getter.dart" \
        -o -name "*_model.freezed.dart" \
        -o -name "*_model.g.dart" \
    \)
)

# Tambahkan statistik
{
    echo ""
    echo "## 📊 STATISTIK"
    echo ""
    echo "- **Total file model:** $total_model"
    echo "- **Total baris kode:** $total_lines"
    echo "- **File output:** $OUTPUT_FILE"
} >> "$OUTPUT_FILE"

echo -e "${GREEN}✅ Selesai!${NC}"
echo -e "${GREEN}📁 Output: $OUTPUT_FILE${NC}"
echo -e "${YELLOW}📊 Total file model: $total_model${NC}"
echo -e "${YELLOW}📊 Total baris: $total_lines${NC}"