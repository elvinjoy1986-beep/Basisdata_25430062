-- ============================================================================
-- Berkas : p13_view_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Perancangan View per Peran Kopma_062 - Modul 13
-- ============================================================================

USE kopma_062;

-- 1. View Kasir untuk Data Anggota (Tanpa Data Pribadi no_hp_anggota)
CREATE OR REPLACE VIEW v_kasir_anggota AS
SELECT id_anggota, no_anggota, nim_anggota, nama_anggota, status_anggota 
FROM anggota;

-- 2. View Kasir untuk Data Barang (Tanpa stok_min_barang)
CREATE OR REPLACE VIEW v_kasir_barang AS
SELECT id_barang, kode_barang, nama_barang, harga_jual_barang, stok_barang
FROM barang;

-- 3. View Gudang untuk Barang Menipis (dengan WITH CHECK OPTION)
CREATE OR REPLACE VIEW v_barang_menipis AS
SELECT id_barang, kode_barang, nama_barang, stok_barang, stok_min_barang
FROM barang 
WHERE stok_barang < stok_min_barang
WITH CHECK OPTION;

-- 4. View Ketua untuk Laporan Omzet Harian (Hasil Ringkasan Agregat)
CREATE OR REPLACE VIEW v_omzet_harian AS
SELECT DATE(p.tgl_penjualan) AS tanggal,
       COUNT(DISTINCT p.id_penjualan) AS total_nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS total_omzet
FROM penjualan p
JOIN detail_penjualan d ON p.id_penjualan = d.id_penjualan
GROUP BY DATE(p.tgl_penjualan);