-- ============================================================================
-- Berkas : p10_join_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Penggabungan Tabel (JOIN) Kopma_062 - Modul 10
-- ============================================================================

USE kopma_062;

-- Aktifkan Mode Ketat Pengelompokan
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- 1. KI-02: INNER JOIN 3 Tabel - Barang Terlaris Bulan Oktober 2026
-- Jalur ERD: barang -> detail_penjualan -> penjualan
SELECT b.kode_barang, b.nama_barang, SUM(d.qty_detail_penjualan) AS terjual
FROM detail_penjualan d
JOIN barang b ON b.id_barang = d.id_barang
JOIN penjualan p ON p.id_penjualan = d.id_penjualan
WHERE p.tgl_penjualan >= '2026-10-01' AND p.tgl_penjualan < '2026-11-01'
GROUP BY b.id_barang, b.kode_barang, b.nama_barang
ORDER BY terjual DESC
LIMIT 5;

-- 2. KI-04: JOIN 3 Tabel - Anggota dengan Belanja Terbesar
-- Jalur ERD: anggota -> penjualan -> detail_penjualan
SELECT a.no_anggota, a.nama_anggota,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS belanja
FROM anggota a
JOIN penjualan p ON p.id_anggota = a.id_anggota
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
GROUP BY a.id_anggota, a.no_anggota, a.nama_anggota
ORDER BY belanja DESC
LIMIT 5;

-- 3. LEFT JOIN: Mencari Barang yang Belum Pernah Terjual
-- Jalur ERD: barang (LEFT) -> detail_penjualan
SELECT b.kode_barang, b.nama_barang, COUNT(d.id_barang) AS baris_terjual
FROM barang b
LEFT JOIN detail_penjualan d ON d.id_barang = b.id_barang
GROUP BY b.id_barang, b.kode_barang, b.nama_barang
HAVING COUNT(d.id_barang) = 0;

-- 4. Membuktikan Perkalian Kartesius (Sengaja Tanpa Syarat ON)
SELECT COUNT(*) AS total_kartesius FROM penjualan, detail_penjualan;