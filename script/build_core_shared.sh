#!/bin/bash

# ============================================================
# SCRIPT: build_core_shared.sh
# TANGGUNG JAWAB: Menggabungkan SEMUA file di lib/shared/ ke 1 file
# ============================================================

OUTPUT_FILE="docs/core_shared.md"
echo "🔄 Membuat $OUTPUT_FILE dari seluruh folder lib/shared/..."

# Kosongkan file (atau buat baru jika belum ada)
> "$OUTPUT_FILE"

# Cari semua file .dart di dalam lib/shared/
# Kecualikan file hasil generator (*.g.dart dan *.freezed.dart)
find lib/shared -type f -name "*.dart" \
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

echo "✅ Selesai! Semua file di lib/shared/ telah digabung ke $OUTPUT_FILE."