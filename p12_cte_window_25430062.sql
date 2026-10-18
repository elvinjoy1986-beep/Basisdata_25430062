-- ============================================================================
-- Berkas : p12_cte_window_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store G62) - Modul 12
-- ============================================================================

USE toko_062;

-- ----------------------------------------------------------------------------
-- LAPORAN 1: Peringkat Produk Terlaris per Kategori (DENSE_RANK)
-- ----------------------------------------------------------------------------
WITH omzet_produk_kategori AS (
    SELECT k.nama_kategori, pr.nama_produk,
           SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS total_omzet
    FROM kategori k
    JOIN produk pr ON k.id_kategori = pr.id_kategori
    JOIN detail_pesanan dp ON pr.id_produk = dp.id_produk
    GROUP BY pr.id_produk, k.nama_kategori, pr.nama_produk
),
peringkat_kategori AS (
    SELECT nama_kategori, nama_produk, total_omzet,
           DENSE_RANK() OVER (PARTITION BY nama_kategori ORDER BY total_omzet DESC) AS rangking
    FROM omzet_produk_kategori
)
SELECT nama_kategori, nama_produk, total_omzet, rangking
FROM peringkat_kategori
WHERE rangking <= 3;

-- ----------------------------------------------------------------------------
-- LAPORAN 2: Total Berjalan (Cumulative Revenue) Omzet Harian
-- ----------------------------------------------------------------------------
WITH omzet_harian AS (
    SELECT DATE(ps.tgl_pesanan) AS tgl_transaksi,
           SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS omzet
    FROM pesanan ps
    JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
    GROUP BY DATE(ps.tgl_pesanan)
)
SELECT tgl_transaksi, omzet,
       SUM(omzet) OVER (ORDER BY tgl_transaksi ASC) AS omzet_kumulatif
FROM omzet_harian;

-- ----------------------------------------------------------------------------
-- LAPORAN 3: Perubahan Tren Pertumbuhan Omzet Harian (LAG & Pertumbuhan %)
-- ----------------------------------------------------------------------------
WITH tren_penjualan AS (
    SELECT DATE(ps.tgl_pesanan) AS tgl_transaksi,
           SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS omzet_sekarang
    FROM pesanan ps
    JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
    GROUP BY DATE(ps.tgl_pesanan)
)
SELECT tgl_transaksi, omzet_sekarang,
       LAG(omzet_sekarang, 1) OVER (ORDER BY tgl_transaksi) AS omzet_sebelumnya,
       (omzet_sekarang - LAG(omzet_sekarang, 1) OVER (ORDER BY tgl_transaksi)) AS selisih_nominal
FROM tren_penjualan;

-- ----------------------------------------------------------------------------
-- LAPORAN 4: CTE Rekursif Kalender Harian untuk Pelacakan Transaksi
-- ----------------------------------------------------------------------------
WITH RECURSIVE kalender_oktober AS (
    SELECT DATE('2026-10-01') AS tanggal
    UNION ALL
    SELECT tanggal + INTERVAL 1 DAY 
    FROM kalender_oktober 
    WHERE tanggal < '2026-10-15'
)
SELECT k.tanggal,
       COUNT(ps.id_pesanan) AS jumlah_pesanan,
       IFNULL(SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan), 0) AS total_omzet
FROM kalender_oktober k
LEFT JOIN pesanan ps ON DATE(ps.tgl_pesanan) = k.tanggal
LEFT JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY k.tanggal;