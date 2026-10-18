-- ============================================================================
-- Berkas : p13_view_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store G62) - Modul 13
-- ============================================================================

USE toko_062;

-- ----------------------------------------------------------------------------
-- VIEW PERAN 1: v_kasir_pelanggan
-- Menyembunyikan data sensitif PDP (no_hp_pelanggan & alamat_pelanggan)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_kasir_pelanggan AS
SELECT id_pelanggan, nama_pelanggan, email_pelanggan
FROM pelanggan;

-- ----------------------------------------------------------------------------
-- VIEW PERAN 2: v_gudang_stok_kritis
-- Memantau produk yang stoknya menipis (< 10) dengan WITH CHECK OPTION
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_gudang_stok_kritis AS
SELECT id_produk, kode_produk, nama_produk, stok_produk, harga_produk
FROM produk
WHERE stok_produk < 10
WITH CHECK OPTION;

-- ----------------------------------------------------------------------------
-- VIEW PERAN 3: v_eksekutif_omzet_bulan
-- Laporan eksekutif ringkasan penjualan per bulan
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_eksekutif_omzet_bulan AS
SELECT DATE_FORMAT(ps.tgl_pesanan, '%Y-%m') AS bulan,
       COUNT(DISTINCT ps.id_pesanan) AS jumlah_invoice,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS omzet_kotor
FROM pesanan ps
JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY DATE_FORMAT(ps.tgl_pesanan, '%Y-%m');