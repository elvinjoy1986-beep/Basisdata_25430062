-- ============================================================================
-- Berkas : p13_role_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Role & Keamanan Proyek Viinjay Store - Modul 13
-- ============================================================================

-- 1. Role Kasir Proyek
CREATE ROLE IF NOT EXISTS r_kasir_toko_062;
GRANT SELECT ON toko_062.v_kasir_pelanggan TO r_kasir_toko_062;

-- 2. Role Gudang Proyek
CREATE ROLE IF NOT EXISTS r_gudang_toko_062;
GRANT SELECT, UPDATE ON toko_062.v_gudang_stok_kritis TO r_gudang_toko_062;

-- 3. Pembuatan Pengguna Kasir & Gudang Proyek
CREATE USER IF NOT EXISTS 'kasir_toko_062'@'localhost' IDENTIFIED BY 'PassKasirToko123!';
CREATE USER IF NOT EXISTS 'gudang_toko_062'@'localhost' IDENTIFIED BY 'PassGudangToko123!';

-- Assign & Set Default Role
GRANT r_kasir_toko_062 TO 'kasir_toko_062'@'localhost';
SET DEFAULT ROLE r_kasir_toko_062 FOR 'kasir_toko_062'@'localhost';

GRANT r_gudang_toko_062 TO 'gudang_toko_062'@'localhost';
SET DEFAULT ROLE r_gudang_toko_062 FOR 'gudang_toko_062'@'localhost';

FLUSH PRIVILEGES;