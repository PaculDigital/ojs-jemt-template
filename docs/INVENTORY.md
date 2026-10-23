# Inventaris Aset

Daftar lengkap 108 file dalam repository ini.

## Ringkasan per Kategori

| Kategori | Jumlah | Ukuran |
|---|---|---|
| CSS stylesheet | 1 | 29.649 B |
| Template homepage (.tpl) | 1 | 7.406 B |
| Template naskah (.docx) | 1 | 3.3 MB |
| Font (.woff2) | 4 | — |
| Banner & hero | 4 | — |
| Logo | 2 (.webp + .png) | — |
| Sidebar ikon | 20 (10 × 2 format) | — |
| Logo indeksasi | 34 (17 × 2 format) | — |
| Arsip asli (img_backup_orig) | 44 | — |
| Dokumentasi | 3 | — |
| **Total** | **108** | **7.6 MB** |

---

## Detail File

### `public/journals/1/` — Aset yang di-serve OJS

| File | Ukuran | Keterangan |
|---|---|---|
| `styleSheet.css` | 29.649 B | CSS custom utama, 11 @media query |
| `Template-JEMT-2026.docx` | 3.330.984 B | Template naskah penulis |
| `hero_2026.webp` | 39.832 B | Banner hero (webp, dipakai) |
| `hero_2026.png` | 562.159 B | Banner hero (png, fallback) |
| `homepageImage.png` | 562.159 B | Gambar homepage |
| `header_banner.png` | 389.992 B | Banner header |
| `logo2tridarma.webp` | 7.678 B | Logo jurnal (webp) |
| `logo2tridarma.png` | 367.364 B | Logo jurnal (png) |
| `pat_04.png` | 4.259 B | Pattern dekoratif |

### `public/journals/1/fonts/` — Font Custom

| File | Keterangan |
|---|---|
| `inter-400.woff2` | Inter Regular |
| `inter-700.woff2` | Inter Bold |
| `jakarta-600.woff2` | Plus Jakarta Sans SemiBold |
| `jakarta-800.woff2` | Plus Jakarta Sans ExtraBold |

### `public/journals/1/sidebar/` — Ikon Sidebar (10 ikon × 2 format)

| Nama | Fungsi |
|---|---|
| `barcode` | Barcode ISSN |
| `chat` | Kontak / chat |
| `template` | Download template |
| `tool_grammarly` | Tool: Grammarly |
| `tool_ithenticate` | Tool: iThenticate |
| `tool_mendeley` | Tool: Mendeley |
| `tool_plagiarism` | Tool: Plagiarism checker |
| `tool_quillbot` | Tool: QuillBot |
| `tool_turnitin` | Tool: Turnitin |
| `tool_zotero` | Tool: Zotero |

Setiap ikon tersedia dalam `.png` dan `.webp`.

### `public/journals/1/indexed/` — Logo Indeksasi (17 logo × 2 format)

`1` s/d `17`, plus `clarivate-new` dan `jurnaltocnew`. Tersedia `.png` dan `.webp`.

### `templates/`

| File | Ukuran | Keterangan |
|---|---|---|
| `indexJournal.tpl` | 7.406 B | Override template homepage OJS, class `jemt-bcard` |

### `img_backup_orig/` — Arsip Asli

Salinan `.png` sebelum dikonversi ke `.webp`. Berguna kalau perlu kualitas penuh atau konversi ulang.

### `docs/`

| File | Keterangan |
|---|---|
| `AI_AGENT_INSTALL_GUIDE.md` | Panduan install untuk AI agent |
| `README_TEMPLATE.md` | Dokumentasi asli template |
| `INSTALL.md` | Panduan install manual |
| `INVENTORY.md` | File ini |

---

## Format Gambar

Semua gambar punya **dua format**:

- `.webp` — dipakai CSS/HTML (ringan, kompresi bagus)
- `.png` — fallback & arsip (kualitas penuh)

Kalau mau update gambar: ganti `.png` dulu, konversi ke `.webp`, lalu update `dateUploaded` stylesheet di DB supaya cache-buster berubah.
