#!/bin/bash

# ============================================
# Dokumentasi Otomatis
# - Cat file di FILES + CUSTOM_LISTS
# - Auto-trace import package:myapp/... secara rekursif
# - Setiap file yang di-cat → cari txt pasangannya:
#     txt/import/lib/<path-dari-lib>.txt
#     fallback → txt/import/<basename>.txt
#   Isi txt: daftar path .dart (boleh path paket pub cache).
#   File yang dicat dari txt TIDAK di-trace importnya.
# ============================================

PACKAGE_NAME="myapp"
TXT_IMPORT_DIR="txt"
PACKAGE_CONFIG=".dart_tool/package_config.json"

# Root SDK & pub-cache (bisa di-override lewat env)
FLUTTER_ROOT="${FLUTTER_ROOT:-/google/flutter}"
PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache/hosted/pub.dev}"
PROJECT_ROOT="$(pwd)"

# ================== KONFIG PENELUSURAN ==================
IMPORT_MAX_DEPTH="${IMPORT_MAX_DEPTH:-3}"
ONLY_OWN_PACKAGE="${ONLY_OWN_PACKAGE:-true}"
CAT_IMPORTED_FILE="${CAT_IMPORTED_FILE:-true}"

# ================== DAFTAR FILE ==================
CUSTOM_LISTS=(
)

FILES=(
lib/fitur/live/service/livekit_token_service.dart
lib/fitur/live/notifier/livekit_notifier.dart
lib/fitur/grup/service/voice_grup_service.dart
lib/fitur/grup/notifier/voice_grup_notifier.dart
lib/shared/db/supabase/db_supabase.dart
lib/shared/db/supabase/db_supabse_repository.dart
supabase/functions/livekit-token/index.ts
supabase/functions/livekit-token-grup/index.ts
supabase/functions/_shared/livekit.ts
lib/fitur/live/service/livekit_token_service.dart
lib/fitur/live/notifier/livekit_notifier.dart
lib/fitur/grup/service/voice_grup_service.dart
lib/shared/db/supabase/db_supabase.dart
lib/shared/db/supabase/db_supabse_repository.dart
supabase/functions/livekit-token/index.ts
supabase/functions/livekit-token-grup/index.ts
supabase/functions/_shared/livekit.ts
)

# ====================================================
# 1. LOAD PACKAGE ROOTS dari package_config.json
#    (rootUri relatif di-resolve terhadap .dart_tool/)
# ====================================================
declare -A PACKAGE_ROOTS
PACKAGE_CONFIG_DIR="$(dirname "$PACKAGE_CONFIG")"

resolve_root_uri() {
  local rootUri="$1"
  local root="${rootUri#file://}"
  if [[ "$root" != /* ]]; then
    root="$(cd "$PACKAGE_CONFIG_DIR/$root" 2>/dev/null && pwd)" || return 1
  fi
  echo "$root"
}

if [ -f "$PACKAGE_CONFIG" ]; then
  if command -v jq >/dev/null 2>&1; then
    while IFS=$'\t' read -r name rootUri; do
      [[ -z "$name" || -z "$rootUri" ]] && continue
      root=$(resolve_root_uri "$rootUri") || continue
      PACKAGE_ROOTS["$name"]="$root"
    done < <(jq -r '.packages[] | "\(.name)\t\(.rootUri)"' "$PACKAGE_CONFIG")
  elif command -v python3 >/dev/null 2>&1; then
    while IFS=$'\t' read -r name rootUri; do
      [[ -z "$name" || -z "$rootUri" ]] && continue
      root=$(resolve_root_uri "$rootUri") || continue
      PACKAGE_ROOTS["$name"]="$root"
    done < <(python3 - "$PACKAGE_CONFIG" <<'PYEOF'
import json, sys
with open(sys.argv[1]) as f:
    data = json.load(f)
for pkg in data.get("packages", []):
    print(f"{pkg['name']}\t{pkg['rootUri']}")
PYEOF
    )
  fi
fi

# ---- Fallback: paket SDK Flutter ----
PACKAGE_ROOTS["flutter"]="$FLUTTER_ROOT/packages/flutter"
PACKAGE_ROOTS["flutter_test"]="$FLUTTER_ROOT/packages/flutter_test"
PACKAGE_ROOTS["flutter_web_plugins"]="$FLUTTER_ROOT/packages/flutter_web_plugins"
PACKAGE_ROOTS["flutter_driver"]="$FLUTTER_ROOT/packages/flutter_driver"
PACKAGE_ROOTS["flutter_localizations"]="$FLUTTER_ROOT/packages/flutter_localizations"
PACKAGE_ROOTS["flutter_goldens"]="$FLUTTER_ROOT/packages/flutter_goldens"
PACKAGE_ROOTS["sky_engine"]="$FLUTTER_ROOT/bin/cache/pkg/sky_engine"

# ====================================================
# 2. RESOLVE SATU PATH -> ABSOLUT
# ====================================================
resolve_path() {
  local path="$1"
  local sisa pkg rel root found base

  # --- Format: package:xxx/yyy.dart ---
  if [[ "$path" == package:* ]]; then
    sisa="${path#package:}"
    pkg="${sisa%%/*}"
    if [[ "$pkg" == "$sisa" ]]; then
      echo "    ⚠️  paket tanpa path: $path" >&2
      return 1
    fi
    rel="${sisa#*/}"
    root="${PACKAGE_ROOTS[$pkg]}"
    if [ -z "$root" ]; then
      echo "    ⚠️  root paket '$pkg' tidak dikenal" >&2
      return 1
    fi
    echo "${root%/}/lib/$rel"
    return 0
  fi

  # --- Format: dart:core, dart:async ---
  if [[ "$path" == dart:* ]]; then
    return 1
  fi

  # --- Format: mengandung slash ---
  if [[ "$path" == */* ]]; then
    echo "$path"
    return 0
  fi

  # --- Format: basename saja ---
  base="$path"

  if [ -f "$base" ]; then
    echo "$base"; return 0
  fi

  found=$(find "$PUB_CACHE" -maxdepth 6 -type f -name "$base" -print -quit 2>/dev/null)
  if [ -n "$found" ]; then echo "$found"; return 0; fi

  found=$(find "$FLUTTER_ROOT/packages" -maxdepth 8 -type f -name "$base" -print -quit 2>/dev/null)
  if [ -n "$found" ]; then echo "$found"; return 0; fi

  found=$(find "$FLUTTER_ROOT/bin/cache/pkg" -maxdepth 8 -type f -name "$base" -print -quit 2>/dev/null)
  if [ -n "$found" ]; then echo "$found"; return 0; fi

  found=$(find . -type f -name "$base" -print -quit 2>/dev/null)
  if [ -n "$found" ]; then echo "$found"; return 0; fi

  echo "    ⚠️  basename tidak ditemukan: $base" >&2
  return 1
}

# ====================================================
# 3. DEDUP & OUTPUT
# ====================================================
OUTPUT="info.md"
OUTPUT_PAKET="README_PAKET.md"
# OUTPUT_PAKET="info.md"
SEEN_FILE="$(mktemp -t seen_catfile.XXXXXX)"
trap 'rm -f "$SEEN_FILE"' EXIT

# Jika output sama, gabungkan keduanya jadi satu file
SAME_OUTPUT="false"
if [[ "$OUTPUT" == "$OUTPUT_PAKET" ]]; then
  SAME_OUTPUT="true"
fi

# Section untuk file proyek
SECTION_PROYEK="# File Proyek"
# Section untuk file paket eksternal
SECTION_PAKET="# File Paket Eksternal"

if [[ "$SAME_OUTPUT" == "true" ]]; then
  {
    echo "# Dokumentasi Proyek"
    echo ""
    echo "Diperbarui: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "$SECTION_PROYEK"
    echo ""
    echo "$SECTION_PAKET"
    echo ""
  } > "$OUTPUT"
else
  {
    echo "# Dokumentasi Proyek"
    echo ""
    echo "Diperbarui: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "$SECTION_PROYEK"
    echo ""
  } > "$OUTPUT"

  {
    echo "# Dokumentasi Paket Eksternal"
    echo ""
    echo "Diperbarui: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "$SECTION_PAKET"
    echo ""
  } > "$OUTPUT_PAKET"
fi

total_proyek=0
total_paket=0

is_seen() {
  local canon
  if command -v realpath >/dev/null 2>&1; then
    canon=$(realpath "$1" 2>/dev/null) || canon="$1"
  else
    canon=$(readlink -f "$1" 2>/dev/null) || canon="$1"
  fi
  grep -Fxq -- "$canon" "$SEEN_FILE" 2>/dev/null
}

# Cek apakah file adalah file paket eksternal (pub-cache / Flutter SDK)
is_external_file() {
  local file="$1"
  local canon
  if command -v realpath >/dev/null 2>&1; then
    canon=$(realpath "$file" 2>/dev/null) || canon="$file"
  else
    canon=$(readlink -f "$file" 2>/dev/null) || canon="$file"
  fi

  # Cek apakah file adalah bagian dari proyek myapp
  # 1. Cek berdasarkan direktori proyek
  if [[ "$canon" == "$PROJECT_ROOT"* ]]; then
    return 1  # false = proyek
  fi
  
  # 2. Cek berdasarkan PACKAGE_ROOTS untuk package myapp
  if [[ -n "${PACKAGE_ROOTS[$PACKAGE_NAME]+x}" ]] && [[ "$canon" == "${PACKAGE_ROOTS[$PACKAGE_NAME]}"* ]]; then
    return 1  # false = proyek
  fi

  # Cek apakah file ada di PUB_CACHE atau FLUTTER_ROOT
  if [[ "$canon" == "$PUB_CACHE"* ]] || [[ "$canon" == "$FLUTTER_ROOT"* ]]; then
    return 0  # true = eksternal
  fi

  # Cek apakah file ada di PACKAGE_ROOTS (paket lain selain proyek)
  for root in "${PACKAGE_ROOTS[@]}"; do
    if [[ "$canon" == "$root"* ]]; then
      return 0  # true = eksternal
    fi
  done

  # Cek apakah file ada di direktori .pub-cache apapun (lintas akun)
  if [[ "$canon" == */.pub-cache/hosted/pub.dev/* ]]; then
    return 0  # true = eksternal
  fi

  return 1  # false = proyek (default)
}

# ====================================================
# 3b. CARI & CAT TXT PASANGAN UNTUK SATU FILE
#     - File di lib/: cari txt/import/lib/<path-dari-lib>.txt
#     - Fallback: txt/import/<basename>.txt
#     - Isi txt: daftar path .dart (boleh path pub cache)
#     - File yang dicat dari txt TIDAK di-trace importnya.
#
#     FIX: kandidat 1 sekarang juga cocok untuk path "lib/..."
#          dan "./lib/..." (sebelumnya hanya "*/lib/*" yang butuh
#          karakter sebelum "/lib/").
# ====================================================
cari_dan_cat_txt() {
  local file="$1"
  local txt=""

  # Kandidat 1: struktur folder dipertahankan (relatif dari lib/)
  # Cocok untuk: "lib/...", "./lib/...", "/abs/.../lib/..."
  local rel=""
  if [[ "$file" == lib/* ]]; then
    rel="${file#lib/}"
  elif [[ "$file" == */lib/* ]]; then
    rel="${file##*/lib/}"
  fi
  if [ -n "$rel" ]; then
    rel="${rel%.dart}"
    local kandidat="$TXT_IMPORT_DIR/lib/$rel.txt"
    [ -f "$kandidat" ] && txt="$kandidat"
  fi

  # Kandidat 2: fallback basename
  if [ -z "$txt" ]; then
    local base="${file##*/}"
    local no_ext="${base%.dart}"
    local kandidat="$TXT_IMPORT_DIR/$no_ext.txt"
    [ -f "$kandidat" ] && txt="$kandidat"
  fi

  [ -z "$txt" ] && return 0

  echo "    📎 txt: $txt"

  while IFS= read -r line || [ -n "$line" ]; do
    [[ -z "${line//[[:space:]]/}" ]] && continue
    [[ "$line" == \#* ]] && continue

    while IFS= read -r p; do
      [[ -z "$p" ]] && continue

      local resolved
      resolved=$(resolve_path "$p") || { echo "    ⚠️  gagal: $p"; continue; }
      [ -f "$resolved" ] || { echo "    ⚠️  tidak ada: $resolved"; continue; }

      # Cat file paket — hanya file ini, tanpa trace importnya
      cat_file "$resolved" "$p"
    done < <(printf '%s\n' "$line" | grep -oE "[^'\"[:space:]]+\.dart")
  done < "$txt"
}

# ====================================================
# 3c. CAT FILE + AUTO-CARI TXT
# ====================================================
cat_file() {
  local file="$1"
  local label="$2"
  [ -f "$file" ] || { echo "  ⚠️  Tidak ditemukan: $file" >&2; return 1; }

  local canon
  if command -v realpath >/dev/null 2>&1; then
    canon=$(realpath "$file" 2>/dev/null) || canon="$file"
  else
    canon=$(readlink -f "$file" 2>/dev/null) || canon="$file"
  fi

  # Sudah pernah dicat? Tetap cek txt — barangkali txt-nya baru ditambah.
  if grep -Fxq -- "$canon" "$SEEN_FILE" 2>/dev/null; then
    echo "  ⏭️  skip (sudah ada): $file"
    cari_dan_cat_txt "$file"
    return 0
  fi
  printf '%s\n' "$canon" >> "$SEEN_FILE"

  # Tentukan section berdasarkan jenis file
  local section="$SECTION_PROYEK"
  local target_file="$OUTPUT"
  if is_external_file "$file"; then
    section="$SECTION_PAKET"
    target_file="$OUTPUT_PAKET"
    total_paket=$((total_paket+1))
  else
    total_proyek=$((total_proyek+1))
  fi

  # Jika output sama, gabungkan semua ke file yang sama
  if [[ "$SAME_OUTPUT" == "true" ]]; then
    target_file="$OUTPUT"
  fi

  local ext="${file##*.}" lang=""
  case "$ext" in
    dart) LANG="dart" ;;
    yaml|yml) LANG="yaml" ;;
    sql) LANG="sql" ;;
    md) LANG="" ;;
    txt) LANG="" ;;
    *) LANG="" ;;
  esac

  {
    echo "## $label"
    echo ""
    if [ "$ext" = "md" ]; then
      cat "$file"
    else
      echo "\`\`\`$LANG"
      cat "$file"
      echo "\`\`\`"
    fi
    echo ""
    echo "---"
    echo ""
  } >> "$target_file"

  echo "  ✅ $file [$section]"

  # 🔑 Setelah selesai cat, cari txt pasangannya
  cari_dan_cat_txt "$file"
  return 0
}

# ====================================================
# 4. EKSTRAK IMPORT KHUSUS PACKAGE_NAME (untuk auto-trace)
# ====================================================
extract_own_imports() {
  local dart_file="$1"
  [ -f "$dart_file" ] || return 0

  grep -oE "^[[:space:]]*(import|export)[[:space:]]+['\"]package:$PACKAGE_NAME/[^'\"]+['\"]" "$dart_file" 2>/dev/null \
    | grep -oE "['\"][^'\"]+['\"]" \
    | tr -d "'\""
}

# ====================================================
# 5. TELUSURI IMPORT REKURSIF (hanya package:myapp)
# ====================================================
trace_imports() {
  local dart_file="$1"
  local depth="${2:-0}"

  [ -f "$dart_file" ] || return 0
  [ "$depth" -ge "$IMPORT_MAX_DEPTH" ] && return 0

  # 1. cat file itu sendiri (otomatis cari txt pasangannya)
  if [ "$CAT_IMPORTED_FILE" = "true" ]; then
    cat_file "$dart_file" "$dart_file"
  fi

  # 2. telusuri import myapp
  while IFS= read -r imp; do
    [[ -z "$imp" ]] && continue

    local resolved
    resolved=$(resolve_path "$imp") || continue
    [ -f "$resolved" ] || continue

    if is_seen "$resolved"; then
      continue
    fi

    echo "    ↪ $imp"

    if [ "$depth" -lt "$IMPORT_MAX_DEPTH" ]; then
      trace_imports "$resolved" $((depth + 1))
    fi
  done < <(extract_own_imports "$dart_file")

  # 3. kalau ONLY_OWN_PACKAGE=false, telusuri semua import
  if [ "$ONLY_OWN_PACKAGE" != "true" ]; then
    while IFS= read -r imp; do
      [[ -z "$imp" ]] && continue
      [[ "$imp" == dart:* ]] && continue
      [[ "$imp" == package:$PACKAGE_NAME/* ]] && continue

      local resolved
      resolved=$(resolve_path "$imp") || continue
      [ -f "$resolved" ] || continue
      is_seen "$resolved" && continue

      echo "    ↪ (ext) $imp"
      [ "$depth" -lt "$IMPORT_MAX_DEPTH" ] && \
        trace_imports "$resolved" $((depth + 1))
    done < <(grep -oE "^[[:space:]]*(import|export)[[:space:]]+['\"][^'\"]+['\"]" "$dart_file" 2>/dev/null \
             | grep -oE "['\"][^'\"]+['\"]" | tr -d "'\"")
  fi
}

# ====================================================
# 6. CUSTOM_LISTS
# ====================================================
echo "📄 CUSTOM_LISTS:"
for f in "${CUSTOM_LISTS[@]}"; do
  cat_file "$f" "$f"
done

# ====================================================
# 7. FILES + TELUSURI IMPORT
#    (txt pasangan otomatis dicari oleh cat_file)
# ====================================================
echo ""
echo "📄 FILES:"
for dart_file in "${FILES[@]}"; do
  echo ""
  echo "▶️  Memproses: $dart_file"

  # 1. cat file utamanya
  cat_file "$dart_file" "$dart_file"

  # 2. telusuri import myapp secara rekursif
  trace_imports "$dart_file" 0
done

# ====================================================
# 8. STATISTIK
# ====================================================
{
  echo ""
  echo "## 📊 Statistik"
  echo ""
  echo "- **Total file proyek:** $total_proyek"
  echo "- **Total file paket eksternal:** $total_paket"
  echo "- **Total file yang diproses:** $((total_proyek + total_paket))"
  echo "- **Kedalaman maksimal:** $IMPORT_MAX_DEPTH"
  echo "- **Hanya package:** $PACKAGE_NAME"
  echo ""
  echo "---"
  echo "Diperbarui Pada $(date '+%Y-%m-%d %H:%M:%S')"
  echo "tolong hanya sarankan kode yang sesuai dengan kode asli dari paket yang ada di dokumen ini saja, jika belum ada isi kode dari paket tertentu beritahu saya saja nanti saya kirim ulang"
} >> "$OUTPUT"

if [[ "$SAME_OUTPUT" != "true" ]]; then
  {
    echo ""
    echo "## 📊 Statistik"
    echo ""
    echo "- **Total file proyek:** $total_proyek"
    echo "- **Total file paket eksternal:** $total_paket"
    echo "- **Total file yang diproses:** $((total_proyek + total_paket))"
    echo "- **Kedalaman maksimal:** $IMPORT_MAX_DEPTH"
    echo "- **Hanya package:** $PACKAGE_NAME"
    echo ""
    echo "---"
    echo "Diperbarui Pada $(date '+%Y-%m-%d %H:%M:%S')"
    echo "tolong hanya sarankan kode yang sesuai dengan kode asli dari paket yang ada di dokumen ini saja, jika belum ada isi kode dari paket tertentu beritahu saya saja nanti saya kirim ulang"
  } >> "$OUTPUT_PAKET"
fi

echo ""
if [[ "$SAME_OUTPUT" == "true" ]]; then
  echo "✅ $OUTPUT dibuat (file proyek + paket)."
else
  echo "✅ $OUTPUT dibuat."
  echo "✅ $OUTPUT_PAKET dibuat."
fi
echo "📊 Total file proyek: $total_proyek"
echo "📊 Total file paket eksternal: $total_paket"
echo "📊 Total keseluruhan: $((total_proyek + total_paket))"
echo ""
echo "💾 Ukuran file:"
if [[ "$SAME_OUTPUT" == "true" ]]; then
  size_output=$(stat -c%s "$OUTPUT" 2>/dev/null || echo 0)
  size_output_human=$(numfmt --to=iec-i --suffix=B "$size_output" 2>/dev/null || echo "${size_output} bytes")
  echo "   - $OUTPUT: $size_output_human"
else
  size_output=$(stat -c%s "$OUTPUT" 2>/dev/null || echo 0)
  size_output_human=$(numfmt --to=iec-i --suffix=B "$size_output" 2>/dev/null || echo "${size_output} bytes")
  size_output_paket=$(stat -c%s "$OUTPUT_PAKET" 2>/dev/null || echo 0)
  size_output_paket_human=$(numfmt --to=iec-i --suffix=B "$size_output_paket" 2>/dev/null || echo "${size_output_paket} bytes")
  echo "   - $OUTPUT: $size_output_human"
  echo "   - $OUTPUT_PAKET: $size_output_paket_human"
  echo "Peringatan semua kode yang anda usulkan harus sesuai dengan yang ada di readme paket kalau tidak ada cukup bilang kesaya nanti saya carikan kode nya di pub dev"
fi