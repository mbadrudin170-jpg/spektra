#!/bin/bash
# //script/duplicate_file.sh

PROJECT_ROOT=~/warkop
BACKUP_ROOT=~/warkop/txt   # <-- SEKARANG DI DALAM WARTOP

SOURCE_FILE="$1"

if [ ! -f "$SOURCE_FILE" ]; then
    echo "❌ Error: File '$SOURCE_FILE' tidak ditemukan!"
    echo "Gunakan: ./duplicate_file.sh <path_file>"
    exit 1
fi

ABSOLUTE_PATH=$(realpath "$SOURCE_FILE")
RELATIVE_PATH=${ABSOLUTE_PATH#$PROJECT_ROOT/}

if [ "$RELATIVE_PATH" = "$ABSOLUTE_PATH" ]; then
    echo "❌ Error: File harus berada di dalam $PROJECT_ROOT"
    exit 1
fi

DEST_FILE="$BACKUP_ROOT/$RELATIVE_PATH"
mkdir -p "$(dirname "$DEST_FILE")"
cp "$SOURCE_FILE" "$DEST_FILE"

echo "✅ File berhasil diduplikasi ke: $DEST_FILE"