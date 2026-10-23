#!/usr/bin/env bash
# Install aset template JEMT ke container OJS
# Pemakaian: bash install.sh
set -euo pipefail

CONTAINER="${OJS_CONTAINER:-ojs-ojs_web-1}"
DB_CONTAINER="${OJS_DB_CONTAINER:-ojs-ojs_db-1}"
JOURNAL_ID="${JOURNAL_ID:-1}"
PUBLIC_DIR="/var/www/ojs/public/journals/${JOURNAL_ID}"
TPL_DIR="/var/www/html/templates/frontend/pages"

echo "=== Install Template JEMT ==="
echo "Container : $CONTAINER"
echo "Journal ID: $JOURNAL_ID"
echo

# --- 1. Cek container jalan ---
if ! docker ps --format '{{.Names}}' | grep -qx "$CONTAINER"; then
  echo "ERROR: container $CONTAINER tidak jalan." >&2
  exit 1
fi

# --- 2. Cek config files_dir ---
echo "[1/6] Cek config..."
docker exec "$CONTAINER" sh -c \
  'grep -nE "^files_dir|^public_files_dir" /var/www/html/config.inc.php'

# --- 3. Pastikan symlink public ---
echo "[2/6] Cek symlink public..."
if docker exec "$CONTAINER" sh -c "[ -d /var/www/html/public ] && [ ! -L /var/www/html/public ]"; then
  echo "  Membuat symlink /var/www/html/public -> /var/www/ojs/public"
  docker exec -u root "$CONTAINER" sh -c '
    mv /var/www/html/public /var/www/html/public.orig-image 2>/dev/null || true
    ln -sfn /var/www/ojs/public /var/www/html/public'
fi
docker exec "$CONTAINER" sh -c 'readlink -f /var/www/html/public'

# --- 4. Copy aset ---
echo "[3/6] Copy aset tampilan..."
docker exec -u root "$CONTAINER" sh -c "mkdir -p $PUBLIC_DIR"
docker cp "public/journals/${JOURNAL_ID}/." "${CONTAINER}:${PUBLIC_DIR}/"

COUNT=$(docker exec "$CONTAINER" sh -c "find $PUBLIC_DIR -type f | wc -l")
echo "  $COUNT file terpasang"

# --- 5. Copy template homepage ---
echo "[4/6] Copy indexJournal.tpl..."
docker cp templates/indexJournal.tpl "${CONTAINER}:${TPL_DIR}/indexJournal.tpl"

# --- 6. Daftarkan stylesheet ---
echo "[5/6] Daftarkan stylesheet di DB..."
NOW=$(date '+%Y-%m-%d %H:%M:%S')
docker exec "$DB_CONTAINER" sh -c "mysql -uroot -p\"\$MYSQL_ROOT_PASSWORD\" ojs -e \"
  DELETE FROM journal_settings WHERE journal_id=${JOURNAL_ID} AND setting_name='styleSheet';
  INSERT INTO journal_settings (journal_id, locale, setting_name, setting_value)
  VALUES (${JOURNAL_ID}, '', 'styleSheet',
    '{\\\"name\\\":\\\"styleSheet.css\\\",\\\"uploadName\\\":\\\"styleSheet.css\\\",\\\"dateUploaded\\\":\\\"${NOW}\\\"}');\"" 2>/dev/null

docker exec "$DB_CONTAINER" sh -c \
  "mysql -uroot -p\"\$MYSQL_ROOT_PASSWORD\" ojs -e \
  \"SELECT setting_name, LEFT(setting_value,60) FROM journal_settings
    WHERE journal_id=${JOURNAL_ID}
      AND setting_name IN ('themePluginPath','styleSheet');\"" 2>/dev/null

# --- 7. Bersihkan cache ---
echo "[6/6] Bersihkan cache..."
docker exec -u root "$CONTAINER" sh -c \
  'rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/* 2>/dev/null || true'
echo "  cache dibersihkan"

echo
echo "=== SELESAI ==="
echo "Buka jurnal dan hard refresh (Ctrl+Shift+R)."
echo "Kalau masih polos, cek: docs/INSTALL.md bagian Troubleshooting."
