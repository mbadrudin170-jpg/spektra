#!/usr/bin/env bash
set -euo pipefail

PUB_CACHE="$HOME/.pub-cache/hosted/pub.dev"
FLUTTER_SDK="/google/flutter"
OUTPUT="$HOME/service/example.md"

: > "$OUTPUT"

# ================== ARRAY FOLDER & FILE ==================
# Daftar folder yang akan diproses.
# - Jika kosong: proses semua paket di pub-cache yang memiliki example/lib.
# - Jika diisi: proses hanya folder yang terdaftar.
#   Bisa berupa nama paket (mis. "shimmer-4.0.0") atau path relatif
#   terhadap PUB_CACHE (mis. "shimmer-4.0.0/example/lib") atau path absolut.
FOLDER=(
  /home/muhamadbadrudin1000/.pub-cache/hosted/pub.dev/camera-0.12.1/example/lib
  /home/muhamadbadrudin1000/.pub-cache/hosted/pub.dev/fl_chart-1.3.0/example/lib
  /home/muhamadbadrudin1000/.pub-cache/hosted/pub.dev/flutter_local_notifications-22.3.3/example/lib
  # "shimmer-4.0.0"
  # "shimmer-4.0.0/example/lib"
  # "material_ui-1.9.0/example/lib"
)

# Daftar file yang akan diproses.
# - Jika kosong: proses semua file *.dart yang ditemukan.
# - Jika diisi: proses hanya file yang terdaftar.
#   Bisa berupa path relatif terhadap PUB_CACHE (mis. "shimmer-4.0.0/example/lib/main.dart")
#   atau path absolut.
FILE=(
  # "shimmer-4.0.0/example/lib/main.dart"
)
# ========================================================

contains() {
  local needle="$1"
  shift
  for x in "$@"; do
    [ "$x" = "$needle" ] && return 0
  done
  return 1
}

# Resolve path folder: dukung nama paket, path relatif ke PUB_CACHE, atau absolut.
resolve_folder() {
  local entry="$1"
  # Jika entry adalah folder yang langsung berisi *.dart (mis. example/lib).
  if [ -d "$entry" ] && [ -n "$(find "$entry" -maxdepth 1 -name '*.dart' -print -quit 2>/dev/null)" ]; then
    echo "$entry"
    return
  fi
  # Jika entry adalah folder paket yang punya example/lib.
  if [ -d "$entry/example/lib" ]; then
    echo "$entry/example/lib"
    return
  fi
  if [ -d "$PUB_CACHE/$entry" ]; then
    if [ -d "$PUB_CACHE/$entry/example/lib" ]; then
      echo "$PUB_CACHE/$entry/example/lib"
      return
    fi
    echo "$PUB_CACHE/$entry"
    return
  fi
  if [ -d "$PUB_CACHE/$entry/example/lib" ]; then
    echo "$PUB_CACHE/$entry/example/lib"
    return
  fi
  echo ""
}

# Kumpulkan daftar folder sumber yang akan diproses.
declare -a SUMBER_FOLDERS=()
if [ "${#FOLDER[@]}" -eq 0 ] && [ "${#FILE[@]}" -eq 0 ]; then
  # Default: semua paket yang memiliki example/lib.
  for pkg in "$PUB_CACHE"/*/; do
    if [ -d "$pkg/example/lib" ]; then
      SUMBER_FOLDERS+=("$pkg/example/lib")
    fi
  done
elif [ "${#FOLDER[@]}" -gt 0 ]; then
  for entry in "${FOLDER[@]}"; do
    # Lewati baris komentar/kosong.
    [[ -z "$entry" || "$entry" == \#* ]] && continue
    resolved="$(resolve_folder "$entry")"
    if [ -z "$resolved" ]; then
      if [ -d "$PUB_CACHE/$entry" ]; then
        resolved="$PUB_CACHE/$entry"
      fi
    fi
    if [ -n "$resolved" ] && [ -d "$resolved" ]; then
      SUMBER_FOLDERS+=("$resolved")
    else
      echo "⚠️  Folder tidak ditemukan: $entry (dilewati)" >&2
    fi
  done
else
  # FOLDER kosong tapi FILE diisi: turunkan folder dari path FILE.
  for entry in "${FILE[@]}"; do
    [[ -z "$entry" || "$entry" == \#* ]] && continue
    # Normalisasi path relatif ke PUB_CACHE.
    if [ -f "$entry" ]; then
      fpath="$entry"
    elif [ -f "$PUB_CACHE/$entry" ]; then
      fpath="$PUB_CACHE/$entry"
    else
      continue
    fi
    dirp="$(dirname "$fpath")"
    # Hindari duplikat.
    dup=0
    for s in "${SUMBER_FOLDERS[@]+"${SUMBER_FOLDERS[@]}"}"; do
      if [ "$s" = "$dirp" ]; then dup=1; break; fi
    done
    if [ "$dup" -eq 0 ]; then
      SUMBER_FOLDERS+=("$dirp")
    fi
  done
fi

# Proses setiap folder sumber.
for src in ${SUMBER_FOLDERS[@]+"${SUMBER_FOLDERS[@]}"}; do
  # Tentukan nama paket (parent dari example/lib) untuk header.
  # src biasanya .../pkg/example/lib → pkg = basename 2 level up.
  pkg_nama="$(basename "$(dirname "$(dirname "$src")")")"
  if [ -z "$pkg_nama" ] || [ "$pkg_nama" = "pub.dev" ]; then
    pkg_nama="$(basename "$src")"
  fi

  echo "# $pkg_nama" >> "$OUTPUT"
  echo "" >> "$OUTPUT"

  while IFS= read -r -d '' f; do
    rel="${f#$PUB_CACHE/}"   # contoh: shimmer-4.0.0/example/lib/main.dart

    # Filter berdasarkan array FILE (jika tidak kosong).
    if [ "${#FILE[@]}" -gt 0 ]; then
      match=0
      for entry in "${FILE[@]}"; do
        [[ -z "$entry" || "$entry" == \#* ]] && continue
        # Cocokkan path relatif penuh atau basename.
        if [ "$rel" = "$entry" ] || [ "$rel" = "${entry#./}" ]; then
          match=1
          break
        fi
        # Jika entry absolut, bandingkan path absolut.
        if [ -f "$entry" ] && [ "$(realpath -m "$f")" = "$(realpath -m "$entry")" ]; then
          match=1
          break
        fi
      done
      if [ "$match" -eq 0 ]; then
        continue
      fi
    fi

    echo "## $rel" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo '```dart' >> "$OUTPUT"
    cat "$f" >> "$OUTPUT"
    echo '```' >> "$OUTPUT"
    echo "" >> "$OUTPUT"
  done < <(find "$src" -type f -name '*.dart' -print0 | sort -z)
done

echo "Selesai. Hasil di: $OUTPUT"
