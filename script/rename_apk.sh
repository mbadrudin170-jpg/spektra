#!/usr/bin/env bash

set -euo pipefail

usage() {
	echo "Usage: $0 <file.apk> [nama-baru]" >&2
	exit 1
}

[[ $# -ge 1 && $# -le 2 ]] || usage

apk="$1"
[[ -f "$apk" ]] || { echo "File APK tidak ditemukan: $apk" >&2; exit 1; }

if [[ $# -eq 2 ]]; then
	nama="$2"
else
	nama="$(basename "${apk%.*}")-renamed"
fi

nama="${nama%.apk}.apk"
tujuan="$(dirname "$apk")/$nama"

[[ "$apk" != "$tujuan" ]] || { echo "Nama file sudah sesuai: $apk"; exit 0; }
[[ ! -e "$tujuan" ]] || { echo "File tujuan sudah ada: $tujuan" >&2; exit 1; }

mv -- "$apk" "$tujuan"
echo "APK berhasil diubah menjadi: $tujuan"
