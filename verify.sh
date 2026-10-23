#!/usr/bin/env bash
# Verifikasi semua aset template JEMT
# Pemakaian: bash verify.sh [URL_DASAR]
set -uo pipefail

BASE="${1:-https://tridarma.id}"
CONT="${OJS_CONTAINER:-ojs-ojs_web-1}"
JID="${JOURNAL_ID:-1}"

echo "=== Verifikasi Aset JEMT ==="
echo "Base URL: $BASE"
echo

PASS=0
FAIL=0

check() {
  local path="$1"
  local code
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 "${BASE}${path}")
  if [ "$code" = "200" ]; then
    printf "  \033[32m%s\033[0m  %s\n" "$code" "$path"
    PASS=$((PASS+1))
  else
    printf "  \033[31m%s\033[0m  %s\n" "$code" "$path"
    FAIL=$((FAIL+1))
  fi
}

echo "--- Aset utama ---"
check "/public/journals/${JID}/styleSheet.css"
check "/public/journals/${JID}/hero_2026.webp"
check "/public/journals/${JID}/logo2tridarma.webp"
check "/public/journals/${JID}/header_banner.png"
check "/public/journals/${JID}/pat_04.png"
check "/public/journals/${JID}/Template-JEMT-2026.docx"

echo "--- Font ---"
for f in inter-400 inter-700 jakarta-600 jakarta-800; do
  check "/public/journals/${JID}/fonts/${f}.woff2"
done

echo "--- Sidebar ---"
for s in barcode chat template tool_grammarly tool_ithenticate \
         tool_mendeley tool_plagiarism tool_quillbot tool_turnitin tool_zotero; do
  check "/public/journals/${JID}/sidebar/${s}.webp"
done

echo "--- Indeksasi (sampel) ---"
for i in 1 2 3; do
  check "/public/journals/${JID}/indexed/${i}.webp"
done

echo
echo "--- Halaman jurnal ---"
for p in "/jemt/id" "/jemt/id/about" "/jemt/id/issue/archive"; do
  check "$p"
done

echo
echo "=== HASIL: $PASS OK, $FAIL GAGAL ==="

if [ "$FAIL" -gt 0 ]; then
  echo
  echo "Ada yang gagal. Cek docs/INSTALL.md bagian Troubleshooting."
  exit 1
fi

echo
echo "Cek template custom ter-render:"
HMTL=$(curl -s -L --max-time 25 "${BASE}/jemt/id")
if echo "$HMTL" | grep -q 'jemt-bcard'; then
  echo "  jemt-bcard: DITEMUKAN (template custom aktif)"
else
  echo "  jemt-bcard: TIDAK ditemukan (template homepage belum terpasang)"
fi
