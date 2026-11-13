#!/usr/bin/env bash
# ============================================================
# script/path_paket.sh  (v2 - sudah diperbaiki)
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT="$PROJECT_ROOT/path_paket.md"
PUBSPEC_LOCK="$PROJECT_ROOT/pubspec.lock"

# ----- Cari pub-cache -----
PUB_CACHE=""
for candidate in \
  "/home/muhamadbadrudin1000/.pub-cache/hosted/pub.dev" \
  "/home/mbadrudin170/.pub-cache/hosted/pub.dev" \
  "/home/codespace/.pub-cache/hosted/pub.dev" \
  "/home/thefarmercompanyba/.pub-cache/hosted/pub.dev" \
  "$HOME/.pub-cache/hosted/pub.dev"; do
  if [[ -d "$candidate" ]]; then
    PUB_CACHE="$candidate"
    break
  fi
done

# ----- Cari Flutter SDK -----
# PERBAIKAN 1: pakai realpath supaya path bersih, tidak ada 'bin/..'
FLUTTER_SDK=""
if command -v flutter >/dev/null 2>&1; then
  FLUTTER_BIN_PATH="$(realpath "$(command -v flutter)")"
  FLUTTER_SDK="$(realpath "$(dirname "$FLUTTER_BIN_PATH")/..")"
fi
if [[ -z "$FLUTTER_SDK" || ! -d "$FLUTTER_SDK" ]]; then
  for candidate in "/google/flutter" "/opt/flutter" "$HOME/flutter"; do
    if [[ -d "$candidate" ]]; then
      FLUTTER_SDK="$(realpath "$candidate")"
      break
    fi
  done
fi

FLUTTER_BIN="flutter"
if [[ -n "$FLUTTER_SDK" ]]; then
  FLUTTER_BIN="$FLUTTER_SDK/bin/flutter"
fi
pushd "$PROJECT_ROOT" >/dev/null
"$FLUTTER_BIN" pub get
popd >/dev/null

# ----- Pastikan pubspec.lock ada -----
if [[ ! -f "$PUBSPEC_LOCK" ]]; then
  echo "ERROR: $PUBSPEC_LOCK tidak ditemukan."
  echo "Jalankan 'flutter pub get' terlebih dahulu."
  exit 1
fi

# ----- Daftar paket SDK yang ada di Flutter SDK (bukan di pub-cache) -----
# PERBAIKAN 2: paket-paket ini di-skip saat scanning pub.dev
SDK_PACKAGES=(
  "flutter"
  "flutter_test"
  "flutter_driver"
  "flutter_goldens"
  "flutter_localizations"
  "flutter_tools"
  "flutter_web_plugins"
  "fuchsia_remote_debug_protocol"
  "integration_test"
  "sky_engine"
)

is_sdk_package() {
  local name="$1"
  for sdk in "${SDK_PACKAGES[@]}"; do
    [[ "$name" == "$sdk" ]] && return 0
  done
  return 1
}

ubah_ke_file_link() {
  printf 'file://%s' "$1"
}

# ----- Fungsi: daftar file .dart di lib/ (1 level) -----
daftar_file_dart() {
  local pkg_dir="${1%/}"
  local lib_dir="$pkg_dir/lib"
  if [[ -d "$lib_dir" ]]; then
    local found=0
    for f in "$lib_dir"/*.dart; do
      if [[ -f "$f" ]]; then
        echo "  - [${f}]($(ubah_ke_file_link "$f"))"
        found=1
      fi
    done
    for d in "$lib_dir"/*/; do
      if [[ -d "$d" ]]; then
        echo "  - [${d%/}/]($(ubah_ke_file_link "${d%/}")/)"
        for f in "$d"*.dart; do
          if [[ -f "$f" ]]; then
            echo "    - [${f}]($(ubah_ke_file_link "$f"))"
            found=1
          fi
        done
      fi
    done
    if [[ $found -eq 0 ]]; then
      echo "  (tidak ada file .dart di lib/)"
    fi
  else
    # PERBAIKAN 3: coba baca pubspec.yaml untuk cari entry point plugin
    local pubspec="$pkg_dir/pubspec.yaml"
    if [[ -f "$pubspec" ]]; then
      # Cari dartPluginClass atau pluginClass di pubspec.yaml
      local dart_class
      dart_class=$(grep -E "^\s*(dartPluginClass|pluginClass)\s*:" "$pubspec" | head -1 | sed 's/.*:\s*//' | tr -d '"' | tr -d "'" || true)
      if [[ -n "$dart_class" ]]; then
        echo "  ℹ️  Plugin native (tanpa lib/). Kelas Dart: \`$dart_class\`"
        echo "  ℹ️  Entry point kemungkinan ada di file .dart lain di dalam paket."
        # Cari file .dart di mana pun dalam paket (kecuali test/example)
        local alt_files
        alt_files=$(find "$pkg_dir" -name "*.dart" -not -path "*/test/*" -not -path "*/example/*" -not -path "*/.*" 2>/dev/null | head -5 || true)
        if [[ -n "$alt_files" ]]; then
          echo "  File .dart yang ditemukan (di luar lib/):"
          while IFS= read -r f; do
            echo "    - [${f}]($(ubah_ke_file_link "$f"))"
          done <<< "$alt_files"
        fi
      else
        echo "  (tidak ada direktori lib/)"
      fi
    else
      echo "  (tidak ada direktori lib/)"
    fi
  fi
}

# ----- Fungsi: daftar file .dart di folder SDK (rekursif 1 level) -----
daftar_file_sdk() {
  local root="${1%/}"
  if [[ ! -d "$root" ]]; then
    echo "  (folder tidak ada)"
    return
  fi
  for sub in "$root"/*/; do
    if [[ -d "$sub" ]]; then
      local sub_name
      sub_name=$(basename "$sub")
      echo "  - [${sub_name}/]($(ubah_ke_file_link "${sub%/}")/)"
      for f in "$sub"*.dart; do
        if [[ -f "$f" ]]; then
          echo "    - [$(basename "$f")]($(ubah_ke_file_link "$f"))"
        fi
      done
    fi
  done
}

# ----- Tulis header -----
{
  echo "# Path Paket Terpasang"
  echo ""
  echo "> Otomatis dihasilkan oleh \`script/path_paket.sh\` (v2)."
  echo "> Jalankan ulang setelah \`flutter pub get\`."
  echo ""
  echo "---"
  echo ""

  # ======== Flutter SDK ========
  echo "## Flutter SDK"
  echo ""
  if [[ -n "$FLUTTER_SDK" ]]; then
    if [[ -d "$FLUTTER_SDK/packages" ]]; then
      for pkg_dir in "$FLUTTER_SDK/packages"/*/; do
        if [[ -d "$pkg_dir" ]]; then
          pkg_name=$(basename "$pkg_dir")
          echo "### \`$pkg_name\`"
          echo ""
          echo "**Path:** [${pkg_dir%/}]($(ubah_ke_file_link "${pkg_dir%/}"))"
          echo ""
          echo "**File .dart:**"
          daftar_file_dart "$pkg_dir"
          echo ""
        fi
      done
    fi
  else
    echo "_Flutter SDK tidak ditemukan._"
    echo ""
  fi

  # ======== Dart SDK & Sky Engine ========
  echo "---"
  echo ""
  echo "## Dart SDK & Sky Engine"
  echo ""
  echo "> Library inti Dart: \`dart:core\` (String, int, bool), \`dart:async\` (Future, Stream), \`dart:ui\` (Canvas, Paint)."
  echo ""

  if [[ -n "$FLUTTER_SDK" ]]; then
    for sdk_lib in \
      "$FLUTTER_SDK/bin/cache/dart-sdk/lib" \
      "$FLUTTER_SDK/bin/cache/pkg/sky_engine/lib"; do
      if [[ -d "$sdk_lib" ]]; then
        sdk_label=$(basename "$(dirname "$sdk_lib")")
        echo "### \`$sdk_label\`"
        echo ""
        echo "**Path:** [$sdk_lib]($(ubah_ke_file_link "$sdk_lib"))"
        echo ""
        echo "**File .dart (1 level):**"
        daftar_file_sdk "$sdk_lib"
        echo ""
      fi
    done
  else
    echo "_Flutter SDK tidak ditemukan, tidak bisa memindai Dart SDK._"
    echo ""
  fi

  # ======== Paket Hosted ========
  echo "---"
  echo ""
  echo "## Paket Hosted (pub.dev)"
  echo ""
  echo "> Paket SDK Flutter (flutter, flutter_test, dll.) tidak ditampilkan di sini."
  echo "> Lihat bagian **Flutter SDK** di atas."
  echo ""
  if [[ -z "$PUB_CACHE" ]]; then
    echo "_pub-cache tidak ditemukan._"
    echo ""
  else
    current_pkg=""
    while IFS= read -r line; do
      if [[ "$line" =~ ^[[:space:]]{2}([a-z_][a-z0-9_]*):$ ]]; then
        current_pkg="${BASH_REMATCH[1]}"
      elif [[ "$line" =~ ^[[:space:]]{4}version:[[:space:]]\"([0-9][^\"]+)\" ]] && [[ -n "$current_pkg" ]]; then
        current_ver="${BASH_REMATCH[1]}"

        # PERBAIKAN 2: skip paket SDK — jangan tampilkan dobel di pub.dev
        if is_sdk_package "$current_pkg"; then
          current_pkg=""
          continue
        fi

        pkg_dir="$PUB_CACHE/${current_pkg}-${current_ver}"
        pkg_path=""
        if [[ -d "$pkg_dir" ]]; then
          pkg_path="$pkg_dir"
        else
          pkg_path=$(find "$PUB_CACHE" -maxdepth 1 -type d -name "${current_pkg}-*" 2>/dev/null | head -1 || true)
        fi

        echo "### \`$current_pkg\`"
        echo ""
        if [[ -n "$pkg_path" ]]; then
          echo "**Path:** [${pkg_path%/}]($(ubah_ke_file_link "${pkg_path%/}"))"
          echo ""
          echo "**File .dart:**"
          daftar_file_dart "$pkg_path"
        else
          echo "**Path:** ❌ tidak ditemukan"
        fi
        echo ""
        current_pkg=""
      fi
    done < "$PUBSPEC_LOCK"
  fi

  # ======== Ringkasan ========
  echo "---"
  echo ""
  echo "## Ringkasan Lokasi Pencarian"
  echo ""
  echo "| Lokasi | Path |"
  echo "|--------|------|"
  echo "| pub-cache | [${PUB_CACHE:-tidak ditemukan}]($(ubah_ke_file_link "${PUB_CACHE:-}")) |"
  echo "| Flutter SDK | [${FLUTTER_SDK:-tidak ditemukan}]($(ubah_ke_file_link "${FLUTTER_SDK:-}")) |"
  echo "| Dart SDK | [${FLUTTER_SDK:+$FLUTTER_SDK/bin/cache/dart-sdk}]($(ubah_ke_file_link "${FLUTTER_SDK:+$FLUTTER_SDK/bin/cache/dart-sdk}")) |"
  echo "| Sky Engine | [${FLUTTER_SDK:+$FLUTTER_SDK/bin/cache/pkg/sky_engine}]($(ubah_ke_file_link "${FLUTTER_SDK:+$FLUTTER_SDK/bin/cache/pkg/sky_engine}")) |"
  echo "| pubspec.lock | [$PUBSPEC_LOCK]($(ubah_ke_file_link "$PUBSPEC_LOCK")) |"
  echo ""
} > "$OUTPUT"

echo "✅ Selesai! Path paket ditulis ke: $OUTPUT"