-- ============================================================================
-- Berkas Data Lanjutan Kopma (Modul 9)
-- ============================================================================
USE kopma_062;

-- Matikan pengecekan Foreign Key sementara untuk pengosongan tabel bersih
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE detail_pembelian;
TRUNCATE TABLE pembelian;
TRUNCATE TABLE detail_penjualan;
TRUNCATE TABLE penjualan;
TRUNCATE TABLE barang;
TRUNCATE TABLE anggota;
TRUNCATE TABLE petugas;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Insert Data Petugas (Menggunakan kode 3 karakter sesuai constraint CHAR(3))
INSERT INTO petugas (id_petugas, kode_petugas, nama_petugas, peran_petugas) VALUES
(1, 'P01', 'Ahmad Hidayat', 'kasir'),
(2, 'P02', 'Siti Rahma', 'kasir'),
(3, 'P03', 'Budi Santoso', 'gudang');

-- 2. Insert Data Anggota
INSERT INTO anggota (id_anggota, no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
(1, 'A0001', '25430001', 'Rian Ardianto', 'Informatika', '081234567890', 'aktif', '2026-01-10'),
(2, 'A0002', '25430002', 'Dewi Lestari', 'Sistem Informasi', '081234567891', 'aktif', '2026-01-15');

-- 3. Insert Data Barang
INSERT INTO barang (id_barang, kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
(1, 'BRG-001', 'Pulpen Standard AE7', 'ATK', 3500.00, 100, 10),
(2, 'BRG-002', 'Buku Tulis Sidu 38', 'ATK', 5000.00, 80, 10),
(3, 'BRG-003', 'Air Mineral 600ml', 'minuman', 3000.00, 120, 15),
(4, 'BRG-004', 'Roti Cokelat', 'makanan', 6000.00, 50, 5);

-- 4. Insert Data Penjualan
INSERT INTO penjualan (id_penjualan, no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
(1, 'PJ-2609-0001', '2026-09-02 08:30:00', 1, 1, 50000.00),
(2, 'PJ-2609-0002', '2026-09-03 09:15:00', 1, NULL, 20000.00),
(3, 'PJ-2609-0003', '2026-09-03 11:00:00', 2, 2, 30000.00),
(4, 'PJ-2609-0004', '2026-09-04 13:20:00', 1, 1, 60000.00),
(5, 'PJ-2609-0005', '2026-09-04 15:45:00', 2, NULL, 30000.00),
(6, 'PJ-2609-0006', '2026-09-05 10:00:00', 1, 2, 40000.00),
(7, 'PJ-2609-0007', '2026-09-05 14:10:00', 2, NULL, 20000.00),
(8, 'PJ-2609-0008', '2026-09-07 09:00:00', 1, 1, 40000.00);

-- 5. Insert Data Detail Penjualan
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan) VALUES
(1, 1, 4, 3500.00),
(1, 2, 5, 5000.00),
(2, 3, 4, 3000.00),
(3, 4, 3, 6000.00),
(3, 1, 1, 3500.00),
(4, 2, 6, 5000.00),
(5, 1, 2, 3500.00),
(5, 4, 2, 6000.00),
(5, 3, 1, 3000.00),
(6, 2, 4, 5000.00),
(6, 3, 5, 3000.00),
(7, 4, 2, 6000.00),
(7, 1, 2, 3500.00),
(8, 2, 5, 5000.00),
(8, 3, 3, 3000.00);