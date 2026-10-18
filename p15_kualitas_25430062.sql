-- ============================================================================
-- Berkas : p15_kualitas_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store) - Modul 15
-- ============================================================================

USE toko_062;

-- 1. Buat Tabel Penampung Impor Kotor
DROP TABLE IF EXISTS pelanggan_impor_kotor;
CREATE TABLE pelanggan_impor_kotor (
    baris INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100),
    email VARCHAR(100),
    no_hp VARCHAR(50),
    alamat TEXT
);

-- 2. Masukkan 10 Baris Data Impor Bermasalah
INSERT INTO pelanggan_impor_kotor (nama, email, no_hp, alamat) VALUES
('elvin purna', 'elvin@gmail.com', '081234567890', 'Way Kanan'),
('', 'kosong@gmail.com', '081299990000', 'Metro'),
('Galeh Joy', 'galeh.invalid-email', '62899112233', 'Bandar Lampung'),
('Rian Ardianto', 'rian@gmail.com', '+6285211223344', 'Palembang'),
('Dewi Lestari', 'dewi@gmail.com', '081234567890', 'Jakarta'),
('Dewi Lestari', 'dewi@gmail.com', '081234567890', 'Jakarta'), -- Duplikat berkas
('  budi santoso  ', 'budi@yahoo.com', '081122334455', 'Medan'),
('Andi Pratama', 'andi@gmail.com', '12345', 'Semarang'), -- HP Invalid
('Siti Aminah', 'siti@gmail.com', '087788990011', ''),
('Joko Widodo', 'joko@gmail.com', '089900112233', 'Surabaya');

-- 3. Kueri Audit Profil Awal Masalah Proyek
SELECT 'Nama Kosong' AS dimensi_masalah, COUNT(*) AS jumlah FROM pelanggan_impor_kotor WHERE TRIM(nama) = '' OR nama IS NULL
UNION ALL
SELECT 'Format Email Invalid', COUNT(*) FROM pelanggan_impor_kotor WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'
UNION ALL
SELECT 'No HP Tidak Baku', COUNT(*) FROM pelanggan_impor_kotor WHERE no_hp NOT REGEXP '^08[0-9]{8,11}$'
UNION ALL
SELECT 'Duplikat Email di Berkas', COUNT(*) - COUNT(DISTINCT email) FROM pelanggan_impor_kotor;

-- 4. Pembersihan Data di Staging Table
DROP TABLE IF EXISTS pelanggan_bersih;
CREATE TABLE pelanggan_bersih AS
SELECT baris,
       CONCAT(UPPER(LEFT(TRIM(nama), 1)), LOWER(SUBSTRING(TRIM(nama), 2))) AS nama_pelanggan,
       LOWER(TRIM(email)) AS email_pelanggan,
       CASE 
           WHEN REGEXP_REPLACE(no_hp, '[^0-9]', '') REGEXP '^628' THEN CONCAT('0', SUBSTRING(REGEXP_REPLACE(no_hp, '[^0-9]', ''), 3))
           WHEN REGEXP_REPLACE(no_hp, '[^0-9]', '') REGEXP '^8' THEN CONCAT('0', REGEXP_REPLACE(no_hp, '[^0-9]', ''))
           WHEN REGEXP_REPLACE(no_hp, '[^0-9]', '') REGEXP '^08' THEN REGEXP_REPLACE(no_hp, '[^0-9]', '')
       END AS no_hp_pelanggan,
       TRIM(alamat) AS alamat_pelanggan
FROM pelanggan_impor_kotor;

-- 5. Migrasi Data Bersih ke Tabel Utama Pelanggan
INSERT INTO pelanggan (nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pelanggan)
SELECT b.nama_pelanggan, b.email_pelanggan, b.no_hp_pelanggan, b.alamat_pelanggan
FROM (
    SELECT pb.*, ROW_NUMBER() OVER (PARTITION BY pb.email_pelanggan ORDER BY pb.baris) AS urut
    FROM pelanggan_bersih pb
    WHERE pb.nama_pelanggan != '' AND pb.nama_pelanggan IS NOT NULL
      AND pb.email_pelanggan REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'
      AND NOT EXISTS (SELECT 1 FROM pelanggan p WHERE p.email_pelanggan = pb.email_pelanggan)
) AS b
WHERE b.urut = 1;