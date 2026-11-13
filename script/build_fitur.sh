#!/bin/bash
# generate_fitur_docs_content.sh
# Membuat file dokumentasi per fitur dengan struktur direktori + konten semua file .dart

FITUR_DIR="lib/fitur"
DOCS_DIR="docs/fitur"

mkdir -p "$DOCS_DIR"

# Fungsi untuk menampilkan struktur direktori tanpa tree
print_tree() {
    local base_dir="$1"
    # Gunakan find untuk semua file dan folder, urutkan
    find "$base_dir" \( -type d -o -type f \) | sort | while read -r path; do
        # Hitung kedalaman dengan menghitung '/' setelah base_dir
        rel="${path#$base_dir/}"
        # Jika path sama dengan base_dir, lewati (tidak perlu tampilkan root)
        [ -z "$rel" ] && continue
        depth=$(echo "$rel" | tr -cd '/' | wc -c)
        indent=""
        for ((i=0; i<depth; i++)); do
            indent="$indent  "   # 2 spasi per level
        done
        name=$(basename "$path")
        if [ -d "$path" ]; then
            # Tampilkan folder dengan trailing slash
            echo "${indent}📁 $name/"
        else
            echo "${indent}📄 $name"
        fi
    done
}

# Loop untuk setiap subfolder di lib/fitur
for subdir in "$FITUR_DIR"/*/ ; do
    foldername=$(basename "$subdir")
    output_file="$DOCS_DIR/$foldername.md"

    # Header
    echo "# Konten File di fitur/$foldername" > "$output_file"
    echo "" >> "$output_file"
    echo "Berikut adalah konten dari semua file Dart dalam \`lib/fitur/$foldername\` dan subdirektorinya." >> "$output_file"
    echo "" >> "$output_file"

    # --- Tambahan: Struktur direktori ---
    echo "## 📁 Struktur direktori" >> "$output_file"
    echo "" >> "$output_file"
    echo '```' >> "$output_file"
    print_tree "$subdir" >> "$output_file"
    echo '```' >> "$output_file"
    echo "" >> "$output_file"
    # ------------------------------------

    # Daftar dan isi semua file .dart
    find "$subdir" -type f -name "*.dart" | sort | while read -r file; do
        relpath="${file#$FITUR_DIR/}"
        echo "## File: \`$relpath\`" >> "$output_file"
        echo "" >> "$output_file"
        echo '```dart' >> "$output_file"
        cat "$file" >> "$output_file"
        echo '```' >> "$output_file"
        echo "" >> "$output_file"
    done

    echo "✅ File $output_file dibuat."
done

echo ""
echo "===== File dokumentasi yang telah dibuat ====="
ls -lh "$DOCS_DIR"/*.md