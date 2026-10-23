# Panduan Install — Template OJS JEMT

Panduan lengkap memasang template & aset JEMT ke server OJS 3.5.

---

## Prasyarat

- Container OJS jalan: `ojs-ojs_web-1` (image `pkpofficial/ojs:3_5_0-5`)
- Container DB jalan: `ojs-ojs_db-1` (mariadb)
- Akses `docker` di host
- `journal_id = 1` untuk JEMT

Cek dulu:

```bash
docker ps --format '{{.Names}}\t{{.Status}}' | grep ojs
```

---

## Langkah 1 — Verifikasi Path di Container

OJS 3.5 bisa memakai `files_dir` **absolut** atau **relatif**. Cek dulu:

```bash
docker exec ojs-ojs_web-1 sh -c \
  'grep -nE "^files_dir|^public_files_dir" /var/www/html/config.inc.php'
```

Contoh output yang benar:

```
files_dir = /var/www/ojs/files
public_files_dir = public
```

**Catatan penting:**
- `files_dir` **boleh absolut** → `/var/www/ojs/files`
- `public_files_dir` **HARUS relatif** → `public` (kalau diisi absolut, URL jadi rusak: `https://domain//var/www/...`)

Pastikan `/var/www/html/public` adalah symlink ke volume:

```bash
docker exec ojs-ojs_web-1 sh -c 'readlink -f /var/www/html/public'
# harus: /var/www/ojs/public
```

Kalau belum, buat symlink:

```bash
docker exec -u root ojs-ojs_web-1 sh -c '
  [ -d /var/www/html/public ] && [ ! -L /var/www/html/public ] && \
    mv /var/www/html/public /var/www/html/public.orig-image
  ln -sfn /var/www/ojs/public /var/www/html/public'
```

---

## Langkah 2 — Copy Aset Tampilan

```bash
# dari root repo
docker cp public/journals/1/. \
  ojs-ojs_web-1:/var/www/ojs/public/journals/1/
```

Verifikasi:

```bash
docker exec ojs-ojs_web-1 sh -c \
  'find /var/www/ojs/public/journals/1 -type f | wc -l'
# harapan: 100+ file
```

---

## Langkah 3 — Copy Template Homepage

```bash
docker cp templates/indexJournal.tpl \
  ojs-ojs_web-1:/var/www/html/templates/frontend/pages/indexJournal.tpl
```

⚠️ File ini **ephemeral** — hilang kalau container di-recreate. Backup di repo ini adalah sumber permanennya.

---

## Langkah 4 — Daftarkan Stylesheet di Database

OJS hanya memuat `styleSheet.css` kalau terdaftar di `journal_settings`:

```bash
docker exec ojs-ojs_db-1 sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" ojs -e "
  DELETE FROM journal_settings
   WHERE journal_id=1 AND setting_name='"'styleSheet'"';

  INSERT INTO journal_settings (journal_id, locale, setting_name, setting_value)
  VALUES (1, '', 'styleSheet',
    '{\"name\":\"styleSheet.css\",\"uploadName\":\"styleSheet.css\",\"dateUploaded\":\"2026-10-23 08:00:00\"}');"'
```

Verifikasi:

```bash
docker exec ojs-ojs_db-1 sh -c \
  'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" ojs -e \
  "SELECT setting_name, setting_value FROM journal_settings
   WHERE journal_id=1 AND setting_name IN (\"themePluginPath\",\"styleSheet\");"'
```

Harapan:
- `themePluginPath` = `default`
- `styleSheet` = JSON dengan `dateUploaded`

**Jangan ubah `themePluginPath`** ke selain `default` — template ini memakai theme default yang di-override.

---

## Langkah 5 — Bersihkan Cache (WAJIB)

```bash
docker exec ojs-ojs_web-1 sh -c \
  'rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/*'
```

Kalau memakai `-u root`:

```bash
docker exec -u root ojs-ojs_web-1 sh -c \
  'rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/*'
```

⚠️ **Jangan hapus cache lain** — hanya `t_cache` dan `t_compile`.

---

## Langkah 6 — Verifikasi

### 6a. Cek semua aset HTTP 200

```bash
for f in hero_2026.webp styleSheet.css Template-JEMT-2026.docx \
         logo2tridarma.webp header_banner.png pat_04.png \
         sidebar/barcode.webp sidebar/tool_zotero.webp \
         indexed/1.webp fonts/inter-400.woff2; do
  printf "%-32s " "$f"
  curl -s -o /dev/null -w "%{http_code}\n" \
    "https://tridarma.id/public/journals/1/$f"
done
```

Semua harus **200**.

### 6b. Cek halaman ter-render

```bash
curl -s -L "https://tridarma.id/jemt/id" -o /tmp/jemt.html
grep -c 'jemt-bcard' /tmp/jemt.html
# >0 = template custom ter-render
```

### 6c. Cek dari dalam container

```bash
IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ojs-ojs_web-1)
curl -s -o /dev/null -w "%{http_code}\n" \
  -H "Host: tridarma.id" "http://$IP/index.php/jemt/id"
```

---

## Troubleshooting

| Gejala | Penyebab | Solusi |
|---|---|---|
Semua aset **403** | File tidak ada / permission salah | Cek `docker exec ojs-ojs_web-1 ls -la /var/www/ojs/public/journals/1/` |
Semua aset **404** | `public_files_dir` salah path | Set ke `public` (relatif) |
URL aneh `domain//var/www/...` | `public_files_dir` diisi absolut | Set ke `public` |
CSS tidak termuat | `styleSheet` tidak ada di DB | Jalankan Langkah 4 |
Halaman **500** | `usageStats` dir tidak ada | Cek `files_dir` benar → harus ada folder `usageStats/` |
Redirect loop https/http | OJS hardcode `getProtocol()`, abaikan `X-Forwarded-Proto` | Apache: `SetEnvIf X-Forwarded-Proto "https" HTTPS=on` |
Template tidak berubah | Cache | Jalankan Langkah 5 + hard refresh (Ctrl+Shift+R) |
Font tidak muncul | Folder `fonts/` hilang | Copy ulang, cek `@font-face` di CSS |

### Fix redirect loop (kalau pakai reverse proxy TLS)

```bash
docker exec -u root ojs-ojs_web-1 sh -c '
cat > /etc/apache2/conf-available/set-https.conf <<EOF
<IfModule mod_setenvif.c>
    SetEnvIf X-Forwarded-Proto "https" HTTPS=on
    SetEnvIf X-Forwarded-Proto "https" REQUEST_SCHEME=https
</IfModule>
EOF
a2enconf set-https && apache2ctl graceful'
```

---

## Setelah Recreate Container

Karena `config.inc.php`, `indexJournal.tpl`, dan direktori `/var/www/html/` bersifat **ephemeral**, setelah `docker compose up -d --force-recreate`:

1. Restore `config.inc.php` dari backup
2. Copy ulang `indexJournal.tpl` ← **Langkah 3**
3. Cek symlink `/var/www/html/public` ← **Langkah 1**
4. Bersihkan cache ← **Langkah 5**

Aset di volume `ojs_ojs_public` **tetap aman** (tidak perlu copy ulang).

---

## Checklist Cepat

```
[ ] files_dir & public_files_dir benar
[ ] symlink /var/www/html/public → /var/www/ojs/public
[ ] aset tercopy (100+ file di journals/1)
[ ] indexJournal.tpl tercopy
[ ] styleSheet terdaftar di DB
[ ] themePluginPath = default
[ ] cache dibersihkan
[ ] semua aset HTTP 200
[ ] jemt-bcard ter-render di HTML
[ ] hard refresh browser
```
