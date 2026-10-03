-- =================================================================
-- Nama File : p01_final_062.sql
-- Deskripsi : Skrip Lengkap Modul 1 & Milestone Viinjay Store (062)
-- =================================================================

-- 1. Database Koperasi & Akun Tamu
CREATE DATABASE IF NOT EXISTS kopma_062;
CREATE USER IF NOT EXISTS 'tamu_062'@'localhost' IDENTIFIED BY 'Elvin#2007';
GRANT SELECT ON kopma_062.* TO 'tamu_062'@'localhost';

-- 2. Database Proyek Viinjay Store & Akun Dev
CREATE DATABASE IF NOT EXISTS viinjay_062 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'dev_062'@'localhost' IDENTIFIED BY 'DevViinjay#062';
GRANT ALL PRIVILEGES ON viinjay_062.* TO 'dev_062'@'localhost';

FLUSH PRIVILEGES;