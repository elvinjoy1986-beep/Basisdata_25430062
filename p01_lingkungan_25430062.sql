-- Modul 1: Lingkungan Kerja MariaDB dan Git
-- NPM : 25430062

CREATE DATABASE IF NOT EXISTS kopma_062 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS toko_062 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_062'@'localhost' IDENTIFIED BY 'PasswordKerja';
GRANT ALL PRIVILEGES ON kopma_062.* TO 'mhs_062'@'localhost';
GRANT ALL PRIVILEGES ON toko_062.* TO 'mhs_062'@'localhost';

CREATE USER IF NOT EXISTS 'tamu_062'@'localhost' IDENTIFIED BY 'PasswordKerja';
-- Tamu hanya diberi hak baca (SELECT) sesuai prinsip least privilege
GRANT SELECT ON kopma_062.* TO 'tamu_062'@'localhost';

FLUSH PRIVILEGES;sss