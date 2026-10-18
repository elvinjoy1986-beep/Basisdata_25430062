-- ============================================================================
-- Berkas : p14_transaksi_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Transaksi dan Integritas Data Kopma_062 - Modul 14
-- ============================================================================

USE kopma_062;

-- 1. D.1 Skenario 1: Transaksi Gagal karena Stok Tidak Cukup (ROLLBACK)
START TRANSACTION;
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2611-0900', '2026-11-01 09:00:00', 3, 4, 50000);
SET @id = LAST_INSERT_ID();

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT @id, id_barang, 10, harga_jual_barang FROM barang WHERE kode_barang = 'BRG-004';

UPDATE barang SET stok_barang = stok_barang - 10
WHERE kode_barang = 'BRG-004' AND stok_barang >= 10;

SELECT ROW_COUNT() AS baris_stok_berubah;
ROLLBACK;

-- 2. D.1 Skenario 2: Transaksi Berhasil (COMMIT)
START TRANSACTION;
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2611-0901', '2026-11-01 09:05:00', 1, 1, 20000);
SET @id2 = LAST_INSERT_ID();

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT @id2, id_barang, 2, harga_jual_barang FROM barang WHERE kode_barang = 'BRG-001';

UPDATE barang SET stok_barang = stok_barang - 2
WHERE kode_barang = 'BRG-001' AND stok_barang >= 2;

SELECT ROW_COUNT() AS baris_stok_berubah;
COMMIT;

-- 3. D.4 Demonstrasi SAVEPOINT
START TRANSACTION;
UPDATE barang SET stok_barang = stok_barang + 1 WHERE kode_barang = 'BRG-001';
SAVEPOINT sp1;
UPDATE barang SET stok_barang = stok_barang + 100 WHERE kode_barang = 'BRG-001';
ROLLBACK TO SAVEPOINT sp1;
COMMIT;