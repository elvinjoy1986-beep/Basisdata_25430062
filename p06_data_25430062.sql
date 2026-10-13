-- ============================================================================
-- Berkas : p06_data_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store G62) - Modul 6
-- ============================================================================

USE toko_062;

DELETE FROM pengiriman;
DELETE FROM pembayaran;
DELETE FROM detail_pesanan;
DELETE FROM pesanan;
DELETE FROM produk;
DELETE FROM kategori;
DELETE FROM pelanggan;

ALTER TABLE pelanggan AUTO_INCREMENT = 1;
ALTER TABLE kategori AUTO_INCREMENT = 1;
ALTER TABLE produk AUTO_INCREMENT = 1;
ALTER TABLE pesanan AUTO_INCREMENT = 1;
ALTER TABLE pembayaran AUTO_INCREMENT = 1;
ALTER TABLE pengiriman AUTO_INCREMENT = 1;

-- 1. Data Pelanggan (Minimal 5 Baris)
INSERT INTO pelanggan (nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan) VALUES
('Elvin Purna Hidayat', 'galeh@gmail.com', '081234567890', 'Jl. Kampus UM Metro No. 62, Metro'),
('Ahmad Fauzi', 'fauzi@yahoo.com', '085269001122', 'Jl. Yos Sudarso No. 15, Bandar Lampung'),
('Siti Aminah', 'siti@gmail.com', '081377889900', 'Jl. Kartini No. 8, Metro Pusat'),
('Rian Pratama', 'rian@outlook.com', '082144556677', 'Jl. Teuku Umar No. 102, Kedaton'),
('Dewi Lestari', 'dewi@gmail.com', '089611223344', 'Jl. Ahmad Yani No. 45, Metro Barat');

-- 2. Data Kategori (Minimal 5 Baris)
INSERT INTO kategori (nama_kategori) VALUES
('Aksesoris PC'), ('Keyboard & Mouse'), ('Storage & RAM'), ('Audio Gaming'), ('Monitor & Display');

-- 3. Data Produk (Minimal 5 Baris)
INSERT INTO produk (id_kategori, kode_produk, nama_produk, harga_produk, stok_produk) VALUES
(2, 'PRD-001', 'Mouse Wireless Silent G62', 150000.00, 50),
(2, 'PRD-002', 'Keyboard Mechanical RGB', 450000.00, 30),
(3, 'PRD-003', 'SSD NVMe 512GB High Speed', 650000.00, 25),
(4, 'PRD-004', 'Headset Gaming 7.1 Surround', 350000.00, 40),
(1, 'PRD-005', 'Webcam Full HD 1080p', 250000.00, 20);

-- 4. Generator Data Transaksi Utama (Pesanan, Detail, Pembayaran, Pengiriman)
-- Dibuat minimal 90 baris detail_pesanan (10 x P = 90) tersebar pada 3 tanggal berbeda
DELIMITER $$
CREATE PROCEDURE generate_sample_orders_062()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE cur_pesanan_id INT;
  DECLARE tgl_sample DATETIME;
  DECLARE cust_id INT;
  
  WHILE i <= 45 DO
    -- Mengatur sebaran 3 tanggal berbeda (Oktober 1, 5, dan 10 tahun 2026)
    IF i <= 15 THEN
      SET tgl_sample = CONCAT('2026-10-01 08:', LPAD(i, 2, '0'), ':00');
    ELSEIF i <= 30 THEN
      SET tgl_sample = CONCAT('2026-10-05 13:', LPAD(i-15, 2, '0'), ':00');
    ELSE
      SET tgl_sample = CONCAT('2026-10-10 19:', LPAD(i-30, 2, '0'), ':00');
    END IF;

    SET cust_id = (i MOD 5) + 1;

    -- Insert Pesanan
    INSERT INTO pesanan (no_invoice_pesanan, id_pelanggan, tgl_pesanan, alamat_pengiriman, ongkir_pesanan, diskon_pesanan, status_pesanan)
    VALUES (CONCAT('INV-202610-', LPAD(i, 4, '0')), cust_id, tgl_sample, 'Alamat Pengiriman Default pelanggan', 15000.00, 9.00, 'LUNAS');
    
    SET cur_pesanan_id = LAST_INSERT_ID();

    -- Insert 2 Baris Detail Pesanan per Pesanan ( Total 45 x 2 = 90 Baris Detail Pesanan = 10 x P )
    INSERT INTO detail_pesanan (id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan)
    VALUES 
    (cur_pesanan_id, 1, 1, 150000.00),
    (cur_pesanan_id, ((i MOD 4) + 2), 1, 350000.00);

    -- Insert Pembayaran
    INSERT INTO pembayaran (id_pesanan, tgl_pembayaran, metode_pembayaran, jumlah_pembayaran)
    VALUES (cur_pesanan_id, tgl_sample, 'TRANSFER_BANK', 470000.00);

    -- Insert Pengiriman
    INSERT INTO pengiriman (id_pesanan, no_resi_pengiriman, tgl_pengiriman, status_pengiriman)
    VALUES (cur_pesanan_id, CONCAT('JN-062', LPAD(i, 5, '0')), DATE_ADD(tgl_sample, INTERVAL 1 DAY), 'SELESAI');

    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

-- Eksekusi Prosedur & Hapus Prosedur
CALL generate_sample_orders_062();
DROP PROCEDURE generate_sample_orders_062;