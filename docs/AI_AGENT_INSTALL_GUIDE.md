# AI Agent Installation Guide — JEMT OJS Template Package

Dokumen ini khusus untuk **AI Agent** (atau teknisi) yang akan menginstal/menerapkan package template OJS ini ke website Open Journal Systems (OJS). Ikuti langkah secara **berurutan** dan **jangan dilewati**. Setiap langkah punya cara verifikasi agar tidak terjadi kesalahan.

---

## 1. Ringkasan Package

Package ini berisi customisasi tampilan depan (frontend) jurnal OJS:

| File | Tujuan instalasi |
|---|---|
| `indexJournal.tpl` | `/var/www/html/templates/frontend/pages/indexJournal.tpl` |
| `styleSheet.css` | Upload lewat Admin OJS (Journal Stylesheet) — **JANGAN** copy manual saja |
| `fonts/*.woff2` | `/var/www/html/public/journals/<ID>/fonts/` |
| `logo2tridarma.png/.webp` | `/var/www/html/public/journals/<ID>/` |
| `header_banner.png` | `/var/www/html/public/journals/<ID>/` |
| `hero_2026.png/.webp` | `/var/www/html/public/journals/<ID>/` |
| `homepageImage.png` | `/var/www/html/public/journals/<ID>/` |
| `pat_04.png` | `/var/www/html/public/journals/<ID>/` |
| `Template-JEMT-2026.docx` | `/var/www/html/public/journals/<ID>/` |
| `sidebar/` | `/var/www/html/public/journals/<ID>/sidebar/` |
| `indexed/` | `/var/www/html/public/journals/<ID>/indexed/` |
| `img_backup_orig/` | `/var/www/html/public/journals/<ID>/img_backup_orig/` (opsional, referensi) |

> `<ID>` = journal_id di database OJS (biasanya `1` untuk jurnal pertama).

---

## 2. Prasyarat (Harus Dipenuhi Dulu)

Sebelum mulai, pastikan semua ini tersedia:

1. **Akses SSH ke server** (contoh):
   ```
   ssh -i <key> -p <port> ubuntu@<server-ip>
   ```
2. **Akses ke container web OJS** (nama container bisa beda):
   ```bash
   docker ps   # cari container dengan nama seperti ojs-ojs_web-1
   ```
3. **Akses database MySQL/MariaDB** (untuk update cache-buster):
   - Ambil kredensial dari `config.inc.php` di dalam container web.
4. **Package template sudah tersedia di server** (folder ini) ATAU di mesin lokal.

Verifikasi prasyarat:
```bash
docker ps | grep ojs
# Harus muncul container web OJS. Jika tidak, nama container berbeda — sesuaikan.
```

---

## 3. Menentukan Journal ID

Jurnal di OJS punya ID unik. Untuk tahu ID-nya:

```bash
docker exec <container_web> ls /var/www/html/public/journals/
# Akan tampil folder bernomor, misalnya: 1
```

Atau lewat database:
```bash
docker exec <container_db> mysql -u ojs -p'<PASSWORD>' ojs -e "SELECT journal_id, path FROM journals;"
```

> Catat `journal_id`. Semua referensi `/public/journals/1/` di dokumen ini ganti sesuai ID tersebut.

---

## 4. Lokasi File Di Dalam Container

Package bisa dipindahkan ke container web OJS:

```bash
# Dari host VPS ke container
docker cp ./jemt_template_package_YYYYMMDD_HHMMSS <container_web>:/tmp/jemt_pkg
```

Jika package ada di dalam container web (misal `/var/www/html/jemt_template_package_...`), langsung pakai path tersebut.

> Buat variabel agar mudah:
> ```bash
> C=ojs-ojs_web-1              # nama container web
> JID=1                        # journal id
> PKG=/tmp/jemt_pkg            # lokasi package di dalam container web
> ```

---

## 5. Instalasi FILE ASET (Public Files)

Semua file gambar/font/dokumen masuk ke folder public jurnal.

```bash
docker exec $C sh -c "
  DEST=/var/www/html/public/journals/$JID
  mkdir -p \$DEST/fonts \$DEST/sidebar \$DEST/indexed \$DEST/img_backup_orig

  cp $PKG/indexJournal.tpl            \$DEST/  # (sementara, langkah 6 menimpa dengan path template)
  cp $PKG/styleSheet.css              \$DEST/
  cp $PKG/fonts/*.woff2               \$DEST/fonts/
  cp $PKG/logo2tridarma.png           \$DEST/
  cp $PKG/logo2tridarma.webp          \$DEST/
  cp $PKG/header_banner.png           \$DEST/
  cp $PKG/hero_2026.png               \$DEST/
  cp $PKG/hero_2026.webp              \$DEST/
  cp $PKG/homepageImage.png           \$DEST/
  cp $PKG/pat_04.png                  \$DEST/
  cp $PKG/Template-JEMT-2026.docx     \$DEST/
  cp -r $PKG/sidebar/*                \$DEST/sidebar/
  cp -r $PKG/indexed/*                \$DEST/indexed/
  cp -r $PKG/img_backup_orig/*        \$DEST/img_backup_orig/ 2>/dev/null
  echo DONE
"
```

**VERIFIKASI LANGKAH 5:**
```bash
docker exec $C ls /var/www/html/public/journals/$JID/
# Harus ada: fonts/, indexed/, logo2tridarma.png, styleSheet.css, sidebar/, dll.
```

---

## 6. Instalasi Template Homepage (`indexJournal.tpl`)

Ini **override** template homepage bawaan OJS.

```bash
docker exec $C cp $PKG/indexJournal.tpl /var/www/html/templates/frontend/pages/indexJournal.tpl
```

> WAJIB: `indexJournal.tpl` harus ada di `templates/frontend/pages/` (bukan hanya di public/journals). File di public/journals yang dicopy di langkah 5 hanya penyimpanan sementara — boleh dihapus setelah ini agar tidak ganda.

```bash
docker exec $C rm -f /var/www/html/public/journals/$JID/indexJournal.tpl
```

**VERIFIKASI LANGKAH 6:**
```bash
docker exec $C ls -la /var/www/html/templates/frontend/pages/indexJournal.tpl
# File harus ada
```

---

## 7. Membersihkan Cache Template

OJS meng-compile template Smarty. Wajib hapus cache agar template baru terpakai.

```bash
docker exec $C sh -c "
  rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/*
  echo CACHE_CLEARED
"
```

**VERIFIKASI LANGKAH 7:**
```bash
docker exec $C ls -la /var/www/html/cache/t_cache/
# Harus kosong (hanya . / ..)
```

---

## 8. Aktivasi Journal Stylesheet (PENTING — Jangan Dilewatkan)

`styleSheet.css` harus didaftarkan sebagai **Journal Stylesheet** supaya OJS memuatnya di `<head>`.

### Opsi A — Via Admin Panel (DIREKOMENDASIKAN)
1. Login ke dashboard OJS sebagai admin.
2. Pergi ke **Settings → Journal → Appearance** (tab *Setup*).
3. Cari **Journal Stylesheet**.
4. Upload file `styleSheet.css`.
5. Klik **Save**.

### Opsi B — Via Database (jika tidak bisa lewat panel)
OJS menyimpan info stylesheet di tabel `journal_settings`. Cek dulu apakah sudah ada:

```bash
docker exec <container_db> mysql -u ojs -p'<PASSWORD>' ojs -e \
  "SELECT * FROM journal_settings WHERE journal_id=$JID AND setting_name='styleSheet';"
```

- Jika **belum ada** (0 rows): tambahkan dengan INSERT (lihat Langkah 9 — format JSON sama).
- Jika **sudah ada**: langsung update timestamp (Langkah 9).

> **⚠️ PENTING / TIDAK BOLEH DILEWATI:**
> OJS merender stylesheet dengan URL ber-query parameter cache-buster:
> ```
> /public/journals/<ID>/styleSheet.css?d=<dateUploaded>
> ```
> Nilai `dateUploaded` diambil dari **database**, BUKAN dari waktu modifikasi file.
> Jika file di-copy manual via shell tapi `dateUploaded` tidak di-update, browser/Cloudflare
> akan **tetap menampilkan CSS lama**. Langkah 9 mengatasi ini.

---

## 9. Update Cache-Buster di Database (WAJIB setelah copy manual)

Setelah file `styleSheet.css` ada, **harus** update `dateUploaded` ke waktu saat ini.

```bash
NOW=$(date +"%Y-%m-%d %H:%M:%S")
docker exec <container_db> mysql -u ojs -p'<PASSWORD>' ojs -e \
  "UPDATE journal_settings
   SET setting_value='{\"name\":\"styleSheet.css\",\"uploadName\":\"styleSheet.css\",\"dateUploaded\":\"$NOW\"}'
   WHERE journal_id=$JID AND setting_name='styleSheet';"
```

Jika belum ada baris `styleSheet` (hasil SELECT kosong), gunakan INSERT:

```bash
NOW=$(date +"%Y-%m-%d %H:%M:%S")
docker exec <container_db> mysql -u ojs -p'<PASSWORD>' ojs -e \
  "INSERT INTO journal_settings (journal_id, locale, setting_name, setting_value)
   VALUES ($JID, '', 'styleSheet',
   '{\"name\":\"styleSheet.css\",\"uploadName\":\"styleSheet.css\",\"dateUploaded\":\"$NOW\"}');"
```

**VERIFIKASI LANGKAH 9:**
```bash
docker exec <container_db> mysql -u ojs -p'<PASSWORD>' ojs -e \
  "SELECT setting_value FROM journal_settings WHERE journal_id=$JID AND setting_name='styleSheet';"
# dateUploaded harus = waktu saat ini (bukan timestamp lama)
```

---

## 10. Verifikasi URL & Isi CSS yang Di-serve

Ini **langkah verifikasi terakhir yang kritis** — memastikan browser benar-benar mendapat CSS baru.

### 10a. Cek URL stylesheet di halaman
```bash
curl -sL https://<domain>/jemt/ | grep -o 'styleSheet.css?d=[^"]*'
# Contoh output: styleSheet.css?d=2026-08-21+02%3A19%3A40
# d= harus MATCH dengan dateUploaded di database (langkah 9)
```

### 10b. Cek isi CSS yang di-serve
```bash
curl -sL "https://<domain>/public/journals/$JID/styleSheet.css?d=<DARI_LANGKAH_10A>" | grep -c "@media"
# Harus ≥ 11 (package ini punya 11 media query responsive)
```

### 10c. Cek tidak ada horizontal scroll di mobile (opsional, jika punya browser tool)
- Buka https://<domain>/jemt/ di viewport 390px.
- `document.documentElement.scrollWidth` harus = `clientWidth` (tidak overflow).

---

## 11. Customisasi Branding (Untuk Jurnal Lain)

Setelah template terpasang, ganti aset berikut agar sesuai jurnal baru:

| Aset | Lokasi | Keterangan |
|---|---|---|
| Logo jurnal | `public/journals/<ID>/logo2tridarma.png/.webp` | Ganti dengan logo jurnal sendiri. WebP = versi terkompresi (bisa generate: `cwebp -q 82 input.png -o output.webp`) |
| Banner header | `public/journals/<ID>/header_banner.png` | Banner 1300x200 |
| Hero image | `public/journals/<ID>/hero_2026.png/.webp` | Gambar hero homepage |
| Nama/deskripsi jurnal | `indexJournal.tpl` (bagian `.jemt-bcard`) | Edit teks statis di template |
| Daftar indexasi | `public/journals/<ID>/indexed/*.webp` | Ganti sesuai indexasi jurnal; nama file harus sama dengan referensi di `indexJournal.tpl` |
| Sidebar tools | `public/journals/<ID>/sidebar/*.webp` | Ganti sesuai tools jurnal |
| Template artikel | `public/journals/<ID>/Template-JEMT-2026.docx` | Ganti dengan template artikel jurnal |

> Setelah mengganti file branding via shell, **ulangi Langkah 9** hanya jika file `styleSheet.css` yang berubah (branding lain tidak butuh cache-buster karena URL-nya tanpa `?d=`). Namun tetap bersihkan cache template (Langkah 7) jika `indexJournal.tpl` diubah.

---

## 12. Rollback (Jika Terjadi Masalah)

### Rollback CSS
- File CSS lama otomatis dibackup jika proses ini dilakukan di jurnal asal. Untuk jurnal baru tanpa backup: hapus baris `styleSheet` dari `journal_settings`, atau upload CSS lain via admin.
- Jika sebelumnya ada backup:
  ```bash
  docker exec $C cp /var/www/html/public/journals/$JID/styleSheet.css.bak_* \
    /var/www/html/public/journals/$JID/styleSheet.css 2>/dev/null || true
  ```

### Rollback Template
```bash
docker exec $C rm -f /var/www/html/templates/frontend/pages/indexJournal.tpl
docker exec $C rm -rf /var/www/html/cache/t_compile/* /var/www/html/cache/t_cache/*
# Template kembali ke bawaan OJS
```

---

## 13. Checklist Akhir (Semua Harus Centang)

- [ ] Journal ID diketahui
- [ ] Semua file aset tercopy ke `public/journals/<ID>/`
- [ ] `indexJournal.tpl` ada di `templates/frontend/pages/`
- [ ] Cache template dibersihkan
- [ ] `styleSheet.css` terdaftar di `journal_settings` (baris `styleSheet` ada)
- [ ] `dateUploaded` = waktu saat ini (cache-buster baru)
- [ ] URL CSS di halaman memakai `?d=` yang sama dengan database
- [ ] Isi CSS yang di-serve punya ≥11 media query
- [ ] Tampilan benar di desktop ≥992px, tablet 576–991px, mobile <576px
- [ ] Tidak ada horizontal scroll di mobile

---

## 14. Troubleshooting Cepat

| Gejala | Penyebab | Solusi |
|---|---|---|
| Tampilan CSS lama terus muncul | `dateUploaded` di DB tidak diupdate | Ulangi Langkah 9 |
| Homepage tidak berubah | Template cache tidak dihapus | Ulangi Langkah 7 |
| `styleSheet.css` tidak dimuat sama sekali | Belum didaftarkan di `journal_settings` | Langkah 8/9 |
| Gambar 404 | Path `/public/journals/<ID>/` salah | Cek journal_id, ulangi Langkah 5 |
| Menu mobile tidak muncul | Cache browser | Hard refresh / Ctrl+Shift+R |
| Submenu tidak terbuka di mobile | Browser lama | Update browser; pakai tap sekali pada item menu |
| Cloudflare cache membandel | URL `?d=` lama di-cache | Pastikan `?d=` baru; tunggu TTL atau purge cache Cloudflare |

---

**Dokumen ini ditulis agar AI Agent dapat menjalankan instalasi secara otonom, dengan verifikasi di tiap langkah. Selalu konfirmasi nama container, password DB, dan journal ID sebelum memulai.**
