# OJS JEMT — Template & Aset Jurnal

Template dan aset tampilan lengkap untuk **JEMT (Jurnal Ekonomi dan Manajemen Tridarma)** di OJS 3.5.

Repository ini berisi **semua file yang dibutuhkan** untuk membangun tampilan jurnal dari nol — bukan cuma panduan.

---

## Ringkasan

| Item | Detail |
|---|---|
| **Jurnal** | Jurnal Ekonomi dan Manajemen Tridarma (JEMT) |
| **Domain** | https://tridarma.id |
| **Path jurnal** | `/jemt/` |
| **OJS** | 3.5.0-5 LTS |
| **E-ISSN** | 3163-608X |
| **DOI Prefix** | 10.64788 |
| **Penerbit** | Universitas Pelita Bangsa |
| **Theme** | `default` + override `indexJournal.tpl` + custom `styleSheet.css` |

---

## Isi Repository

```
public/journals/1/          ← aset yang di-serve OJS (taruh di sini)
├── styleSheet.css          ← CSS custom (29.649 bytes, 11 @media)
├── indexJournal.tpl        ← (lihat templates/) template homepage custom
├── hero_2026.webp / .png   ← banner hero
├── header_banner.png
├── homepageImage.png
├── logo2tridarma.webp/.png
├── pat_04.png
├── Template-JEMT-2026.docx ← template naskah penulis (3.3 MB)
├── fonts/                  ← 4 font custom (.woff2)
│   ├── inter-400.woff2
│   ├── inter-700.woff2
│   ├── jakarta-600.woff2
│   └── jakarta-800.woff2
├── sidebar/                ← 10 ikon sidebar (.png + .webp)
└── indexed/                ← 17 logo indeksasi (.png + .webp)

templates/
└── indexJournal.tpl        ← override template homepage OJS

docs/
├── AI_AGENT_INSTALL_GUIDE.md  ← panduan install untuk AI agent
├── README_TEMPLATE.md         ← dokumentasi asli template
└── INSTALL.md                 ← panduan install manual (file ini)

img_backup_orig/            ← arsip .png asli sebelum konversi .webp
```

**Total: 108 file, 7.6 MB**

---

## Cara Install

Lihat **[docs/INSTALL.md](docs/INSTALL.md)** untuk panduan langkah demi langkah.

Ringkas:

```bash
# 1. Copy aset ke container
docker cp public/journals/1/. ojs-ojs_web-1:/var/www/ojs/public/journals/1/

# 2. Copy template homepage
docker cp templates/indexJournal.tpl \
  ojs-ojs_web-1:/var/www/html/templates/frontend/pages/indexJournal.tpl

# 3. Daftarkan stylesheet di DB
docker exec ojs-ojs_db-1 sh -c "mysql -uroot -p\"\$MYSQL_ROOT_PASSWORD\" ojs -e \"
  DELETE FROM journal_settings WHERE journal_id=1 AND setting_name='styleSheet';
  INSERT INTO journal_settings (journal_id, locale, setting_name, setting_value)
  VALUES (1, '', 'styleSheet',
  '{\\\"name\\\":\\\"styleSheet.css\\\",\\\"uploadName\\\":\\\"styleSheet.css\\\",\\\"dateUploaded\\\":\\\"$(date +%Y-%m-%d\ %H:%M:%S)\\\"}');\""

# 4. Bersihkan cache (WAJIB)
docker exec ojs-ojs_web-1 sh -c \
  'rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/*'
```

---

## Penting: Lokasi File di OJS

Volume Docker yang menyimpan aset **permanen**:

| Volume | Fungsi |
|---|---|
| `ojs_ojs_public` | Aset tampilan (CSS, banner, ikon, template) ← **taruh di sini** |
| `ojs_ojs_files` | PDF artikel, file submission |
| `ojs_ojs_db_data` | Database |

⚠️ File di **dalam container** (`/var/www/html/`) bersifat **ephemeral** — hilang saat container di-recreate. Yang permanen hanya volume.

Jadi `indexJournal.tpl` di `/var/www/html/templates/` **rawan hilang**. Setelah `docker compose up` ulang, jalankan langkah 2 lagi.

---

## Spesifikasi Desain

- **Font**: Inter (400, 700) + Plus Jakarta Sans (600, 800)
- **CSS**: 29.649 bytes, 11 media query (responsive)
- **Warna aksen**: lihat variabel di `styleSheet.css`
- **Template homepage**: custom `indexJournal.tpl` (7.406 bytes) dengan class `jemt-bcard`
- **Format gambar**: `.webp` (utama, ringan) + `.png` (fallback)

---

## Template Naskah

`Template-JEMT-2026.docx` — standar penulisan JEMT:

- Kertas A4, margin 2,54 cm
- **Garamond** 12 pt, spasi 1,15
- Judul 14 pt, kapital, tebal, rata tengah
- Abstrak: Inggris + Indonesia, 11 pt, spasi 1.0, maks 200 kata
- Referensi: APA edisi ke-7, minimal 20 sumber
- Similarity maksimal 30%

---

## Riwayat

| Tanggal | Kejadian |
|---|---|
| 2026-08-20 | Backup awal template (CSS 23.965 bytes) |
| 2026-08-20 | Backup final (CSS 29.649 bytes) |
| 2026-08-21 | Package lengkap dengan fonts + indexed + sidebar |
| 2026-10-23 | Aset hilang dari volume setelah patch PHP CVE; repository ini dibuat sebagai sumber pemulihan permanen |

---

## Lisensi

Aset desain: Universitas Pelita Bangsa.
Kode template OJS: GPL v3 (mengikuti lisensi OJS).
