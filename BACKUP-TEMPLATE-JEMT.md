# BACKUP TEMPLATE JURNAL JEMT

**Semua backup template & aset Jurnal JEMT ada di Git (GitHub).**

---

## Lokasi Backup

| Item | Detail |
|---|---|
| **Repository** | https://github.com/PaculDigital/ojs-jemt-template |
| **Pemilik** | PaculDigital |
| **Visibility** | Publik |
| **Branch utama** | `main` |
| **Commit terakhir** | `f467923` — Samakan repo dengan keadaan live 2026-10-23 |
| **Tanggal commit** | 23 Oktober 2026, 13:07 UTC |
| **Total file** | 123 file |
| **Ukuran repo** | ±7,6 MB |

---

## Isi Backup

### 1. Stylesheet (CSS)

```
public/journals/1/styleSheet.css
```

- Ukuran: **31.403 byte**
- MD5: **0ca8d4926fe65f507b7ea98a21d4b5d2**
- Versi: final live 2026-10-23 (asli + penyesuaian header + outline logo sidebar V3)
- Status: **identik dengan yang live di tridarma.id**

### 2. Template Homepage (.tpl)

```
templates/indexJournal.tpl
```

- Ukuran: **8.701 byte**, 144 baris
- MD5: **e9434581e0a11adee14411ea1ddecc27**
- Fitur: dwibahasa via `$currentLocale` (frekuensi + 2 kartu pengumuman)
- Status: **identik dengan yang live**

### 3. Aset Gambar & Font (73 file)

```
public/journals/1/
├── header_banner.png          389.992 B   banner header gold
├── hero_2026.webp              39.832 B   hero banner homepage
├── hero_2026.png              562.159 B   cadangan PNG
├── homepageImage.png          562.159 B   cadangan
├── logo2tridarma.webp           7.678 B   logo jurnal
├── logo2tridarma.png          367.364 B   cadangan PNG
├── pat_04.png                   4.259 B   pattern
├── Template-JEMT-2026.docx  3.330.984 B   template naskah
├── fonts/                      4 file     Inter 400/700, Jakarta 600/800
├── sidebar/                   20 file     10 ikon × (png + webp)
└── indexed/                   34 file     17 logo indeksasi × (png + webp)
```

### 4. Konten Database EN (13 halaman)

```
database-en/
├── README.md
├── deskripsi-en.sql             deskripsi jurnal EN
├── pasang-database-en.sh        skrip pasang (dengan pencadangan)
└── pasang-en.sql                13 halaman statis EN + footer EN
```

### 5. Dokumentasi

```
docs/
├── INSTALL.md                   panduan install 6 langkah
├── INVENTORY.md                 daftar lengkap aset
├── AI_AGENT_INSTALL_GUIDE.md    panduan asli
└── README_TEMPLATE.md           dokumentasi asli

UPDATE-2026-10-23.md             urutan pemulihan penuh + peringatan stylesheet
README.md                        ringkasan repo
```

### 6. Skrip

```
install.sh                       install otomatis ke container OJS
verify.sh                        verifikasi 20+ aset via HTTP
```

### 7. Arsip

```
img_backup_orig/                 44 file PNG asli
```

---

## Cara Memulihkan (Restore)

### Cepat — satu perintah

```bash
git clone https://github.com/PaculDigital/ojs-jemt-template.git
cd ojs-jemt-template
bash install.sh
bash verify.sh
```

### Manual — per komponen

```bash
# 1. CSS
docker cp public/journals/1/styleSheet.css \
  ojs-ojs_web-1:/var/www/ojs/public/journals/1/styleSheet.css

# 2. Template homepage
docker cp templates/indexJournal.tpl \
  ojs-ojs_web-1:/var/www/html/templates/frontend/pages/indexJournal.tpl

# 3. Semua aset gambar & font
docker cp public/journals/1/. \
  ojs-ojs_web-1:/var/www/ojs/public/journals/1/

# 4. Permission + clear cache
docker exec -u root ojs-ojs_web-1 sh -c \
  'chown -R www-data:www-data /var/www/ojs/public/journals/1; \
   rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/*'
```

### Konten database EN

```bash
cd database-en
bash pasang-database-en.sh
```

---

## Verifikasi Setelah Restore

**Cocokkan MD5** — harus sama persis:

```bash
# CSS harus 0ca8d4926fe65f507b7ea98a21d4b5d2
docker exec ojs-ojs_web-1 md5sum /var/www/ojs/public/journals/1/styleSheet.css

# TPL harus e9434581e0a11adee14411ea1ddecc27
docker exec ojs-ojs_web-1 md5sum /var/www/html/templates/frontend/pages/indexJournal.tpl
```

**Cek aset via HTTP** — semua harus `200`:

```
https://tridarma.id/public/journals/1/styleSheet.css      200  31.403 B
https://tridarma.id/public/journals/1/header_banner.png   200 389.992 B
https://tridarma.id/public/journals/1/hero_2026.webp      200  39.832 B
https://tridarma.id/public/journals/1/logo2tridarma.webp  200   7.678 B
```

**Cek halaman** — semua harus `200`:

```
https://tridarma.id/jemt/id                200
https://tridarma.id/jemt/en                200 (via redirect)
https://tridarma.id/jemt/id/about          200
https://tridarma.id/jemt/id/announcement   200
https://tridarma.id/jemt/id/issue/archive  200
```

---

## Struktur Tampilan (2 Gambar Terpisah)

Desain JEMT memakai **dua gambar header terpisah** — jangan disatukan:

```
┌─────────────────────────────────────────┐
│  HEADER BANNER (header_banner.png)      │  ← 389.992 B, full width
│  gold/perpustakaan                      │     sudut kotak (radius 0)
│  "Tridarma Jurnal Publishing"           │     tinggi 120px di mobile
├─────────────────────────────────────────┤
│  NAVBAR (hamburger, DAFTAR, LOGIN)      │
├─────────────────────────────────────────┤
│  HERO BANNER (hero_2026.webp)           │  ← 39.832 B, kartu
│  "Jurnal Ekonomi dan Manajemen          │     sudut membulat
│   Tridarma (JEMT)"                      │     margin kiri-kanan
├─────────────────────────────────────────┤
│  About the Journal / Tentang Jurnal Ini │
└─────────────────────────────────────────┘
```

**PENTING:** Header banner dan hero banner adalah **dua elemen berbeda**. `header_banner.png` sebagai `background-image` pada `.pkp_structure_head`, sedangkan `hero_2026.webp` sebagai `<img>` di dalam `div.homepage_image`. Jangan pernah memindahkan hero ke background header — itu merusak layout dan memotong judul.

---

## Peringatan

1. **Jangan set `useHomepageImageAsHeader = 1`** di `plugin_settings`. Setting ini memindahkan hero ke background header dan menyebabkan banner bertumpuk.

2. **Jangan pakai `background-size: cover`** untuk `header_banner.png`. Gunakan `100% auto` agar banner tidak ter-crop.

3. **Judul jurnal sudah menyatu di dalam `hero_2026.webp`** — teks HTML-nya sengaja dibuat transparan lewat `.pkp_site_name a.is_text { color: transparent }`. Jangan hapus aturan itu, dan jangan perkecil tinggi hero di bawah rasio gambar (1100×370).

4. **Selalu backup dulu** sebelum mengubah `styleSheet.css` — file ini adalah satu-satunya sumber tampilan.

---

## Riwayat

| Commit | Tanggal | Isi |
|---|---|---|
| `f467923` | 2026-10-23 13:07 | CSS final, tpl dwibahasa, konten database EN |
| `1f4dbdb` | 2026-10-23 08:46 | Commit awal: 108 aset + dokumentasi |

---

**Kesimpulan: backup template Jurnal JEMT ada di Git — https://github.com/PaculDigital/ojs-jemt-template — dan sudah diverifikasi identik dengan keadaan live di tridarma.id.**
