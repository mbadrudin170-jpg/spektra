#!/bin/bash

# ============================================================
# SCRIPT: build_lib_docs.sh
# TANGGUNG JAWAB: Menggabungkan SEMUA file di lib/ ke docs/lib.md
# ============================================================

OUTPUT_FILE="docs/lib.md"

# Pastikan folder docs/ ada
mkdir -p docs

echo "🔄 Membuat $OUTPUT_FILE dari seluruh folder lib/..."

# Kosongkan file (atau buat baru jika belum ada)
> "$OUTPUT_FILE"

# Cari semua file .dart di dalam lib/
# Kecualikan file hasil generator (*.g.dart dan *.freezed.dart)
find lib -type f -name "*.dart" \
  ! -name "*.g.dart" \
  ! -name "*.freezed.dart" \
  | sort | while read -r file; do

    echo "// ============================================================" >> "$OUTPUT_FILE"
    echo "// FILE: $file" >> "$OUTPUT_FILE"
    echo "// ============================================================" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo '```dart' >> "$OUTPUT_FILE"      # ✅ Tambahkan pembuka blok kode Dart
    cat "$file" >> "$OUTPUT_FILE"         # Masukkan isi file dart
    echo '```' >> "$OUTPUT_FILE"          # ✅ Tambahkan penutup blok kode
    echo "" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "✅ Selesai! Semua file di lib/ telah digabung ke $OUTPUT_FILE."