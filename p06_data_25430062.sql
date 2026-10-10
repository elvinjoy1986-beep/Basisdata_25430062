-- p06_data_25430062.sql
USE toko_062;

-- Bersihkan data lama agar skrip dapat dijalankan berulang kali tanpa error
DELETE FROM transaksi;
DELETE FROM pelanggan;
DELETE FROM produk;

-- 1. Mengisi Data Induk Pelanggan
INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, email, alamat) VALUES
('PLG-001', 'Budi Santoso', 'budi@gmail.com', 'Jl. Ahmad Yani No. 10'),
('PLG-002', 'Siti Nurhaliza', 'siti@gmail.com', 'Jl. Merdeka No. 45'),
('PLG-003', 'Rian Hidayat', 'rian@gmail.com', 'Jl. Sudirman No. 12');

-- 2. Mengisi Data Induk Produk
INSERT INTO produk (id_produk, nama_produk, harga, stok) VALUES
('PRD-001', 'Kemeja Flanel', 150000, 10),
('PRD-002', 'Celana Jeans', 250000, 15),
('PRD-003', 'Sepatu Sneakers', 400000, 8),
('PRD-004', 'Tas Ransel', 200000, 12);

-- 3. Mengisi Data Transaksi
INSERT INTO transaksi (id_transaksi, id_pelanggan, tanggal_transaksi, total_harga) VALUES
('TRX-001', 'PLG-001', '2026-10-01', 150000),
('TRX-002', 'PLG-002', '2026-10-02', 400000),
('TRX-003', 'PLG-001', '2026-10-05', 500000);