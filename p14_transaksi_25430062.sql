-- ============================================================================
-- Berkas : p14_transaksi_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store G62) - Modul 14
-- PARAMETER : P = 9, Batas Item (P+2) = 11
-- ============================================================================

USE toko_062;

-- ----------------------------------------------------------------------------
-- SKENARIO 1: TRANSAKSI BERHASIL (COMMIT)
-- Melunasi Utang Desain: Pemesanan Wajib Punya Detail & Stok Tercukupi
-- ----------------------------------------------------------------------------
START TRANSACTION;

-- Step 1: Buat Header Pesanan
INSERT INTO pesanan (no_invoice_pesanan, tgl_pesanan, id_pelanggan, total_bayar_pesanan, status_pesanan)
VALUES ('INV-20261018-01', '2026-10-18 10:00:00', 1, 150000.00, 'menunggu_pembayaran');
SET @id_pesanan_1 = LAST_INSERT_ID();

-- Step 2: Tambahkan Detail Pesanan
INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT @id_pesanan_1, id_produk, 2, harga_produk 
FROM produk WHERE kode_produk = 'PRD-001';

-- Step 3: Potong Stok Produk dengan Syarat Aman
UPDATE produk 
SET stok_produk = stok_produk - 2 
WHERE kode_produk = 'PRD-001' AND stok_produk >= 2;

-- Step 4: Evaluasi Perubahan Stok
SELECT ROW_COUNT() AS stok_terpotong, @@in_transaction AS status_transaksi;

-- Keputusan: Berhasil
COMMIT;


-- ----------------------------------------------------------------------------
-- SKENARIO 2: TRANSAKSI DIBATALKAN (ROLLBACK)
-- Melanggar Aturan Bisnis: Pembelian Melebihi Batas Maksimal P+2 (11 Item)
-- ----------------------------------------------------------------------------
START TRANSACTION;

-- Step 1: Buat Header Pesanan
INSERT INTO pesanan (no_invoice_pesanan, tgl_pesanan, id_pelanggan, total_bayar_pesanan, status_pesanan)
VALUES ('INV-20261018-02', '2026-10-18 10:15:00', 2, 500000.00, 'menunggu_pembayaran');
SET @id_pesanan_2 = LAST_INSERT_ID();

-- Step 2: Mencoba Membeli 15 Item (Melebihi Batas P+2 = 11 Item)
INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
SELECT @id_pesanan_2, id_produk, 15, harga_produk 
FROM produk WHERE kode_produk = 'PRD-002';

-- Step 3: Cek Jumlah Item yang Dipesan
SELECT SUM(qty_detail_pesanan) INTO @total_qty_order 
FROM detail_pesanan WHERE id_pesanan = @id_pesanan_2;

-- Step 4: Tampilkan Hasil Evaluasi (Terbukti > 11)
SELECT @total_qty_order AS qty_order, @@in_transaction AS status_transaksi;

-- Keputusan: Dibatalkan karena melanggar aturan batas item
ROLLBACK;