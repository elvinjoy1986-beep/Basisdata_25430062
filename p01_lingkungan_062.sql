-- =================================================================
-- Nama File : p01_lingkungan_062.sql
-- Deskripsi : Skrip penyiapan lingkungan basis data dan akun pengguna
-- Praktikum : Modul 1 - Basis Data
-- =================================================================

-- 1. Membuat basis data khusus praktikum (sesuaikan dengan NIM Anda)
CREATE DATABASE IF NOT EXISTS kopma_062;

-- 2. Mengamankan akun root (pastikan sandi Anda simpan dengan aman)
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Elvin#2007';
ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY 'Elvin#2007';
ALTER USER 'root'@'::1' IDENTIFIED BY 'Elvin#2007';

-- 3. Membuat akun kerja praktikum dan memberikan hak akses penuh
CREATE USER IF NOT EXISTS 'mhs_062'@'localhost' IDENTIFIED BY 'PasswordKerja#062';
GRANT ALL PRIVILEGES ON kopma_062.* TO 'mhs_062'@'localhost';

-- 4. Menyegarkan hak akses peladen
FLUSH PRIVILEGES;

-- 5. Perintah verifikasi (opsional untuk pengecekan)
SHOW DATABASES;
SHOW GRANTS FOR 'mhs_062'@'localhost';