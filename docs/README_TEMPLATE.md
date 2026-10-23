# JEMT Custom Template Package

Package lengkap customisasi tampilan OJS (Open Journal Systems) untuk Jurnal Ekonomi dan Manajemen Tridarma (JEMT), responsive desktop/tablet/mobile. Dapat dipakai ulang untuk jurnal lain dengan mengganti aset branding.

## Isi package

| File/Folder | Fungsi |
|---|---|
| `indexJournal.tpl` | Template homepage (deskripsi jurnal, kartu nama jurnal, INDEXED, announcements, current issue) |
| `styleSheet.css` | Custom CSS utama (responsive, media query 992px/576px) — pasang sebagai journal stylesheet |
| `fonts/` | Font self-hosted Inter + Jakarta (woff2) |
| `logo2tridarma.png` / `.webp` | Logo jurnal (header, homepage image) |
| `header_banner.png` | Banner header 1300x200 |
| `hero_2026.png` / `.webp` | Hero image homepage |
| `homepageImage.png` | Homepage image OJS |
| `pat_04.png` | Pattern halus untuk latar |
| `Template-JEMT-2026.docx` | Template artikel |
| `sidebar/` | Gambar sidebar: barcode LoA, chat, template, tool (grammarly, ithenticate, mendeley, plagiarism, quillbot, turnitin, zotero) — PNG asli + WebP |
| `indexed/` | Logo indexasi (Google Scholar, Garuda, WorldCat, Scilit, BASE, Clarivate, dll) — PNG asli + WebP |
| `img_backup_orig/` | Gambar asli sebelum optimasi (referensi) |

## Cara pasang ke jurnal lain

### 1. Copy file ke folder public jurnal
Masuk ke container web OJS:
```bash
docker exec -it ojs-ojs_web-1 bash
```
Copy seluruh isi package ini ke `/var/www/html/public/journals/<JOURNAL_ID>/`
(untuk jurnal pertama, `JOURNAL_ID` = 1).

### 2. Pasang indexJournal.tpl (override homepage)
Copy ke:
```bash
cp indexJournal.tpl /var/www/html/templates/frontend/pages/indexJournal.tpl
```
Hapus cache template:
```bash
rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/*
```

### 3. Aktifkan stylesheet di admin OJS
- Login dashboard → **Settings → Journal → Appearance → Setup**
- Pada bagian **Journal Stylesheet**, upload `styleSheet.css`
- **Simpan** (ini akan mencatat timestamp di database sebagai cache-buster)

> CATATAN PENTING: Jika file `styleSheet.css` diganti langsung via shell (bukan upload panel),
> URL cache-buster `?d=` TIDAK berubah otomatis sehingga browser/Cloudflare tetap membaca CSS lama.
> Selalu update timestamp di database setelah mengganti file:
> ```sql
> UPDATE journal_settings
> SET setting_value = '{"name":"styleSheet.css","uploadName":"styleSheet.css","dateUploaded":"<WAKTU_SEKARANG>"}'
> WHERE journal_id = 1 AND setting_name = 'styleSheet';
> ```

### 4. Customisasi branding
- **Logo**: ganti `logo2tridarma.png`/`.webp` (dan `header_banner.png`) dengan logo & banner jurnal baru
- **Nama/deskripsi jurnal**: edit di `indexJournal.tpl` (bagian `.jemt-bcard`) dan lewat admin OJS
- **Font**: ganti file di `fonts/` jika ingin font berbeda
- **Indexed**: ganti isi `indexed/` sesuai daftar indexasi jurnal (nama file webp dipakai di `indexJournal.tpl`)
- **Sidebar**: ganti isi `sidebar/` sesuai keperluan

## Struktur responsif yang didukung
- **Desktop (≥992px)**: layout 2 kolom (main + sidebar), glass navbar, submenu dropdown hover
- **Tablet (576–991px)**: satu kolom, grid 3–5 kolom
- **Mobile (<576px)**: satu kolom, grid 2–3 kolom, menu drawer, submenu ketuk

## Catatan versi
- `styleSheet.css` final responsive: 29.6 KB, 11 media query
- Backup lama tersedia di folder `custom_backup_jemt_final_20260820_184854` dan `styleSheet.css.bak_before_responsive`
