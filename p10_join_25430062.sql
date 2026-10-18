-- ============================================================================
-- Berkas : p10_join_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store) - Modul 10
-- ============================================================================

USE toko_062;

-- Aktifkan Mode Ketat Pengelompokan
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- ----------------------------------------------------------------------------
-- KUERI 1 (INNER JOIN 3 TABEL)
-- Jalur ERD : pelanggan -> pesanan -> detail_pesanan
-- Deskripsi : Menampilkan riwayat rincian item belanja setiap pelanggan.
-- ----------------------------------------------------------------------------
SELECT pl.nama_pelanggan, ps.no_invoice_pesanan, ps.tgl_pesanan,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS subtotal_belanja
FROM pelanggan pl
JOIN pesanan ps ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY ps.id_pesanan, pl.nama_pelanggan, ps.no_invoice_pesanan, ps.tgl_pesanan;

-- ----------------------------------------------------------------------------
-- KUERI 2 (INNER JOIN 4 TABEL DENGAN AGREGASI)
-- Jalur ERD : kategori -> produk -> detail_pesanan -> pesanan
-- Deskripsi : Menampilkan 3 produk terlaris berdasarkan kuantitas penjualan.
-- ----------------------------------------------------------------------------
SELECT k.nama_kategori, pr.kode_produk, pr.nama_produk,
       SUM(dp.qty_detail_pesanan) AS total_unit_terjual
FROM kategori k
JOIN produk pr ON k.id_kategori = pr.id_kategori
JOIN detail_pesanan dp ON pr.id_produk = dp.id_produk
JOIN pesanan ps ON ps.id_pesanan = dp.id_pesanan
GROUP BY pr.id_produk, k.nama_kategori, pr.kode_produk, pr.nama_produk
ORDER BY total_unit_terjual DESC
LIMIT 3;

-- ----------------------------------------------------------------------------
-- KUERI 3 (LEFT JOIN DATA TANPA PASANGAN)
-- Jalur ERD : produk (LEFT) -> detail_pesanan
-- Deskripsi : Menemukan produk katalog yang belum pernah dibeli pelanggan sama sekali.
-- ----------------------------------------------------------------------------
SELECT pr.kode_produk, pr.nama_produk, pr.harga_produk,
       COUNT(dp.id_produk) AS kali_terjual
FROM produk pr
LEFT JOIN detail_pesanan dp ON pr.id_produk = dp.id_produk
GROUP BY pr.id_produk, pr.kode_produk, pr.nama_produk, pr.harga_produk
HAVING COUNT(dp.id_produk) = 0;

-- ----------------------------------------------------------------------------
-- KUERI 4 (LEFT JOIN PELANGGAN TANPA TRANSAKSI)
-- Jalur ERD : pelanggan (LEFT) -> pesanan
-- Deskripsi : Menampilkan seluruh pelanggan yang telah mendaftar namun belum pernah order.
-- ----------------------------------------------------------------------------
SELECT pl.nama_pelanggan, pl.email_pelanggan, pl.no_hp_pelanggan,
       COUNT(ps.id_pesanan) AS jumlah_transaksi
FROM pelanggan pl
LEFT JOIN pesanan ps ON pl.id_pelanggan = ps.id_pelanggan
GROUP BY pl.id_pelanggan, pl.nama_pelanggan, pl.email_pelanggan, pl.no_hp_pelanggan
HAVING COUNT(ps.id_pesanan) = 0;

-- ----------------------------------------------------------------------------
-- KUERI 5 (JOIN 4 TABEL COMPLETE STATUS TRANSAKSI & PEMBAYARAN)
-- Jalur ERD : pesanan -> pelanggan -> pembayaran -> pengiriman
-- Deskripsi : Laporan lengkap invoice, nama pelanggan, metode bayar, dan status pengiriman.
-- ----------------------------------------------------------------------------
SELECT ps.no_invoice_pesanan, pl.nama_pelanggan, pm.metode_pembayaran,
       pm.jumlah_pembayaran, pg.status_pengiriman
FROM pesanan ps
JOIN pelanggan pl ON ps.id_pelanggan = pl.id_pelanggan
JOIN pembayaran pm ON ps.id_pesanan = pm.id_pesanan
JOIN pengiriman pg ON ps.id_pesanan = pg.id_pesanan;