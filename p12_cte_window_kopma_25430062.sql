-- ============================================================================
-- Berkas : p12_cte_window_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : CTE dan Window Function Kopma_062 - Modul 12
-- ============================================================================

USE kopma_062;

-- 1. D.1 CTE & Peringkat Omzet Barang per Kategori (RANK)
WITH omzet_barang AS (
    SELECT b.kategori_barang, b.nama_barang, 
           SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
    FROM detail_penjualan d 
    JOIN barang b ON b.id_barang = d.id_barang
    GROUP BY b.id_barang, b.kategori_barang, b.nama_barang
)
SELECT kategori_barang, nama_barang, omzet,
       RANK() OVER (PARTITION BY kategori_barang ORDER BY omzet DESC) AS peringkat
FROM omzet_barang
ORDER BY kategori_barang, peringkat;

-- 2. D.2 CTE Rekursif: Mengidentifikasi Hari Tanpa Penjualan (1-14 Oktober 2026)
WITH RECURSIVE kalender AS (
    SELECT DATE('2026-10-01') AS tgl_kalender
    UNION ALL
    SELECT tgl_kalender + INTERVAL 1 DAY 
    FROM kalender 
    WHERE tgl_kalender < '2026-10-14'
)
SELECT k.tgl_kalender, COUNT(p.id_penjualan) AS nota
FROM kalender k
LEFT JOIN penjualan p ON DATE(p.tgl_penjualan) = k.tgl_kalender
GROUP BY k.tgl_kalender
HAVING nota = 0;

-- 3. D.3 Total Berjalan (Cumulative) & Perubahan Harian (LAG)
WITH harian AS (
    SELECT DATE(p.tgl_penjualan) AS tanggal,
           SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
    FROM penjualan p 
    JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
    WHERE p.tgl_penjualan >= '2026-10-01' AND p.tgl_penjualan < '2026-10-11'
    GROUP BY DATE(p.tgl_penjualan)
)
SELECT tanggal, omzet,
       SUM(omzet) OVER (ORDER BY tanggal) AS kumulatif,
       omzet - LAG(omzet) OVER (ORDER BY tanggal) AS selisih
FROM harian;