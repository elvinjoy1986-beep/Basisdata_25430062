-- ============================================================================
-- Berkas : p06_data_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Skrip Pengisian Data Sampel Kopma_062 - Modul 6
-- ============================================================================

USE kopma_062;

-- Bersihkan data lama jika ada (urutan dari anak ke induk)
DELETE FROM detail_pembelian;
DELETE FROM pembelian;
DELETE FROM detail_penjualan;
DELETE FROM penjualan;
DELETE FROM pemasok;
DELETE FROM barang;
DELETE FROM anggota;
DELETE FROM petugas;

ALTER TABLE petugas AUTO_INCREMENT = 1;
ALTER TABLE anggota AUTO_INCREMENT = 1;
ALTER TABLE barang AUTO_INCREMENT = 1;
ALTER TABLE pemasok AUTO_INCREMENT = 1;
ALTER TABLE penjualan AUTO_INCREMENT = 1;
ALTER TABLE pembelian AUTO_INCREMENT = 1;

-- 1. Data Petugas
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
('K01', 'Dimas', 'kasir'),
('K02', 'Sari', 'kasir'),
('K03', 'Rina', 'kasir'),
('G01', 'Joko', 'gudang'),
('P01', 'Ketua Kopma', 'ketua');

-- 2. Data Anggota (Minimal 3, 1 nonaktif)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
('A-0457', '25430062', 'Elvin Purna Hidayat', 'Ilmu Komputer', '081234567890', 'aktif', '2026-01-10'),
('A-0458', '25430061', 'Budi Santoso', 'Manajemen', '081298765432', 'aktif', '2026-02-15'),
('A-0102', '24430010', 'Siti Rahma', 'Akuntansi', '085678901234', 'nonaktif', '2024-05-20');

-- 3. Data Barang
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000.00, 120, 20),
('ATK-002', 'Buku Tulis 58', 'ATK', 6500.00, 80, 20),
('MNM-001', 'Air Mineral 600', 'minuman', 4000.00, 48, 24),
('MKN-001', 'Roti Cokelat', 'makanan', 5000.00, 6, 10);

-- 4. Data Pemasok (Minimal 2)
INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
('CV Sumber ATK', '0215551234', 'Jl. Industri No. 12, Bandar Lampung'),
('UD Segar Pangan', '0721444567', 'Jl. Raden Intan No. 45, Metro');

-- 5. Data Transaksi Penjualan (Nota PJ-2609-0142)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan) VALUES
('PJ-2609-0142', '2026-09-24 10:15:00', 3, 1, 30000.00);

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 3, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-001'
UNION ALL
SELECT 1, id_barang, 2, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-002'
UNION ALL
SELECT 1, id_barang, 1, harga_jual_barang FROM barang WHERE kode_barang = 'MNM-001';

-- Update Stok Barang Sesuai Transaksi
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'MNM-001';