# Konten Database Versi English (locale `en`)

Bagian template JEMT yang tersimpan di **database** (tidak ikut `install.sh` yang hanya
menangani berkas). Tanpa langkah ini, situs hasil pemulihan hanya berbahasa Indonesia;
halaman /en akan menampilkan isi lama/fallback.

## Isi folder

| Berkas | Fungsi |
|---|---|
| `pasang-database-en.sh` | Skrip utama — jalankan ini saja |
| `pasang-en.sql` | 13 halaman statis EN (`static_page_settings`) + operasi footer EN |
| `deskripsi-en.sql` | Deskripsi jurnal EN (`journal_settings` `description`) |

## Cara pakai (di server, dari folder repo)

```
bash database-en/pasang-database-en.sh
```

Skrip bersifat **idempotent** (aman dijalankan ulang) dan membuat cadangan dulu:
`tabel bak_en_settings`, `bak_en_journal`, `bak_en_desc`.

## Catatan teknis (penting, hasil temuan lapangan 2026-10-23)

- Kode locale di database ditulis **`en` / `id`** (bukan `en_US` / `id_ID`).
- `static_page_settings` **punya** kolom `setting_type`; pola tulisnya DELETE + INSERT...SELECT
  meniru baris `id` agar tipe kolomnya persis.
- `journal_settings` **tidak punya** kolom `setting_type` — INSERT memakai VALUES polos.
  (Mengira ada kolom itu menghasilkan ERROR 1054.)
- Footer EN tidak ditulis ulang dari nol; cukup REPLACE di tempat: cabut string
  `Universitas Pelita Bangsa` dan ganti `085720505555` → `085178138514`, supaya email
  dan lisensi tidak berubah.
- Halaman /en untuk klien tanpa cookie terlihat redirect berputar — itu perilaku cookie
  locale OJS 3.5, bukan kerusakan.
