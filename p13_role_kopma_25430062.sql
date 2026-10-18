-- ============================================================================
-- Berkas : p13_role_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Pengaturan Role dan Hak Akses Pengguna - Modul 13
-- ============================================================================

-- 1. Pembuatan Role Kasir
CREATE ROLE IF NOT EXISTS r_kasir_062;
GRANT SELECT ON kopma_062.v_kasir_anggota TO r_kasir_062;
GRANT SELECT ON kopma_062.v_kasir_barang TO r_kasir_062;

-- 2. Pembuatan Akun Kasir dan Penetapan Role
CREATE USER IF NOT EXISTS 'kasir_062'@'localhost' IDENTIFIED BY 'PassKasir062!';
GRANT r_kasir_062 TO 'kasir_062'@'localhost';
SET DEFAULT ROLE r_kasir_062 FOR 'kasir_062'@'localhost';

FLUSH PRIVILEGES;