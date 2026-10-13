-- ============================================================================
-- Berkas : p07_kueri_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Kueri SELECT dan Fungsi Skalar Kopma_062 - Modul 7
-- ============================================================================

USE kopma_062;

-- 1. KI-03: Barang di bawah stok minimum (Penyaringan & Alias)
SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       (stok_min_barang - stok_barang) AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;

-- 2. Penyaringan dengan operator IN (Barang ATK atau Minuman)
SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kategori_barang ASC, harga_jual_barang DESC;

-- 3. Penyaringan dengan BETWEEN (Penjualan rentang September 2026)
SELECT no_nota_penjualan, tgl_penjualan, bayar_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59';

-- 4. Penyaringan dengan IS NULL (Anggota tanpa nomor HP)
SELECT no_anggota, nim_anggota, nama_anggota, prodi_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- 5. Pola Teks, Tanggal, dan Kondisional (Pencarian nama dengan LIKE)
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')') AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_daftar_formatted,
       IFNULL(no_hp_anggota, '-') AS hp,
       CASE status_anggota 
            WHEN 'aktif' THEN 'Diskon 5%'
            ELSE 'Tanpa diskon' 
       END AS keterangan_diskon
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- 6. Perhitungan Umur Keanggotaan (Fungsi Tanggal & Kondisional)
SELECT nama_anggota, tgl_daftar_anggota,
       DATEDIFF('2026-10-13', tgl_daftar_anggota) AS lama_hari,
       IF(DATEDIFF('2026-10-13', tgl_daftar_anggota) < 180, 'Anggota Baru', 'Anggota Senior') AS status_keanggotaan
FROM anggota;

-- 7. Perhitungan Subtotal per Baris Detail Nota (PJ-2609-0142)
SELECT id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
       (qty_detail_penjualan * harga_satuan_detail_penjualan) AS subtotal
FROM detail_penjualan
WHERE id_penjualan = 1;