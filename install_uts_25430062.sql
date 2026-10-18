-- ============================================================================
-- Berkas  : install_uts_25430062.sql
-- NAMA    : Elvin Purna Hidayat (NIM: 25430062)
-- DESKRIPSI: Skrip Pemasangan Bersih Basis Data Viinjay Store (UTS)
-- ============================================================================

-- 1. Buat Basis Data Bersih
DROP DATABASE IF EXISTS toko_062;
CREATE DATABASE toko_062 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE toko_062;

-- 2. Panggil Struktur DDL (Modul 5)
SOURCE p05_ddl_25430062.sql;

-- 3. Panggil Pengisian Data Sampel (Modul 6)
SOURCE p06_data_25430062.sql;

-- 4. Verifikasi Hasil Instalasi
SELECT 'INSTALASI BERSIH UTS BERHASIL!' AS status;
SELECT TABLE_NAME, TABLE_ROWS FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'toko_062';
SELECT COUNT(*) AS total_detail_pesanan_90_rows FROM detail_pesanan;