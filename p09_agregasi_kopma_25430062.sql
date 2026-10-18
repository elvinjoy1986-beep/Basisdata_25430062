-- ============================================================================
-- Berkas : p09_agregasi_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Agregasi Data & GROUP BY Kopma_062 - Modul 9
-- ============================================================================

USE kopma_062;

-- Aktifkan Mode Ketat Pengelompokan SQL ISO Standard
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- 1. Verifikasi Jumlah Total Nota & Rentang Tanggal
SELECT COUNT(*) AS total_nota, MIN(tgl_penjualan) AS transaksi_awal, MAX(tgl_penjualan) AS transaksi_akhir 
FROM penjualan;

-- 2. Menghitung Total Satu Nota Spesifik (PJ-2609-0001)
SELECT p.no_nota_penjualan, 
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS jumlah_total
FROM penjualan p 
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.no_nota_penjualan = 'PJ-2609-0001'
GROUP BY p.id_penjualan, p.no_nota_penjualan;

-- 3. KI-01: Laporan Omzet Harian Minggu Pertama September 2026 dengan WITH ROLLUP
SELECT DATE(p.tgl_penjualan) AS tanggal,
       COUNT(DISTINCT p.id_penjualan) AS total_nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet_harian
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01' AND p.tgl_penjualan < '2026-09-08'
GROUP BY DATE(p.tgl_penjualan) WITH ROLLUP;

-- 4. Laporan Omzet Bulanan (September vs Oktober 2026)
SELECT DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan_transaksi,
       COUNT(DISTINCT p.id_penjualan) AS jumlah_nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS total_omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
GROUP BY DATE_FORMAT(p.tgl_penjualan, '%Y-%m');

-- 5. Menyaring Kelompok dengan HAVING (Petugas yang Melayani > 20 Nota)
SELECT pt.kode_petugas, pt.nama_petugas, COUNT(p.id_penjualan) AS jumlah_nota_dilayani
FROM penjualan p 
JOIN petugas pt ON pt.id_petugas = p.id_petugas
GROUP BY pt.id_petugas, pt.kode_petugas, pt.nama_petugas
HAVING COUNT(p.id_penjualan) > 20;