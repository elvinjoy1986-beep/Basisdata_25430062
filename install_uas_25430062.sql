-- ============================================================================
-- Berkas     : install_uas_25430062.sql
-- NAMA       : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK      : Skrip Master Instalasi Bersih UAS Basis Data - Modul 16
-- PROYEK     : Viinjay Store (toko_062)
-- ============================================================================

-- 1. Inisialisasi Basis Data Toko_062
DROP DATABASE IF EXISTS toko_062;
CREATE DATABASE toko_062;
USE toko_062;

-- 2. Eksekusi DDL & Struktur Tabel Utama (P05)
SOURCE p05_ddl_25430062.sql;

-- 3. Eksekusi Pengisian Data Awal / Seeding (P06)
SOURCE p06_data_25430062.sql;

-- 4. Eksekusi Perancangan View Per Peran & Hak Akses (P13)
SOURCE p13_view_25430062.sql;

-- 5. Eksekusi Audit & Pembersihan Kualitas Data Staging (P15)
SOURCE p15_kualitas_25430062.sql;

SELECT 'INSTALASI BERSIH UAS TOKO_062 BERHASIL 100%' AS status_instalasi;