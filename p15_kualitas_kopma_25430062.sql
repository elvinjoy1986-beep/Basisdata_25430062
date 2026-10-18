-- ============================================================================
-- Berkas : p15_kualitas_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Validasi dan Pembersihan Data Kopma_062 - Modul 15
-- ============================================================================

USE kopma_062;

-- 1. Kueri Profil Awal Masalah
SELECT 'Nama Kosong' AS masalah, COUNT(*) AS jumlah FROM anggota_impor WHERE TRIM(nama) = '' OR nama IS NULL
UNION ALL
SELECT 'NIM Bukan 10 Digit', COUNT(*) FROM anggota_impor WHERE nim NOT REGEXP '^[0-9]{10}$'
UNION ALL
SELECT 'NIM Sudah Terdaftar', COUNT(*) FROM anggota_impor i JOIN anggota a ON a.nim_anggota = REGEXP_REPLACE(i.nim, '[^0-9]', '')
UNION ALL
SELECT 'HP Tidak Baku', COUNT(*) FROM anggota_impor WHERE no_hp IS NULL OR no_hp NOT REGEXP '^08[0-9]{8,11}$';

-- 2. Buat Tabel Penampung Kebersihan (Staging Table)
DROP TABLE IF EXISTS anggota_bersih;
CREATE TABLE anggota_bersih AS
SELECT baris,
       REGEXP_REPLACE(nim, '[^0-9]', '') AS nim_anggota,
       CONCAT(UPPER(LEFT(TRIM(nama), 1)), LOWER(SUBSTRING(TRIM(nama), 2))) AS nama_anggota,
       CASE 
           WHEN UPPER(REGEXP_REPLACE(prodi, '[^a-zA-Z]', '')) IN ('ILMUKOMPUTER', 'ILKOM', 'IK') THEN 'Ilmu Komputer'
           WHEN UPPER(REGEXP_REPLACE(prodi, '[^a-zA-Z]', '')) IN ('SISTEMINFORMASI', 'SI') THEN 'Sistem Informasi'
           WHEN UPPER(REGEXP_REPLACE(prodi, '[^a-zA-Z]', '')) IN ('TEKNIKINFORMATIKA', 'TI') THEN 'Teknik Informatika'
           ELSE 'Pendidikan Matematika'
       END AS prodi_anggota,
       CASE 
           WHEN REGEXP_REPLACE(no_hp, '[^0-9]', '') REGEXP '^628' THEN CONCAT('0', SUBSTRING(REGEXP_REPLACE(no_hp, '[^0-9]', ''), 3))
           WHEN REGEXP_REPLACE(no_hp, '[^0-9]', '') REGEXP '^8' THEN CONCAT('0', REGEXP_REPLACE(no_hp, '[^0-9]', ''))
           WHEN REGEXP_REPLACE(no_hp, '[^0-9]', '') REGEXP '^08' THEN REGEXP_REPLACE(no_hp, '[^0-9]', '')
       END AS no_hp_anggota,
       CASE 
           WHEN tgl_daftar REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
                AND CAST(LEFT(tgl_daftar, 2) AS UNSIGNED) BETWEEN 1 AND DAY(LAST_DAY(STR_TO_DATE(CONCAT('01/', SUBSTRING(tgl_daftar, 4)), '%d/%m/%Y')))
           THEN STR_TO_DATE(tgl_daftar, '%d/%m/%Y')
       END AS tgl_daftar_anggota
FROM anggota_impor;

-- 3. Migrasi Data Bersih ke Tabel Utama
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
SELECT CONCAT('A-', LPAD(maks.n + ROW_NUMBER() OVER (ORDER BY k.baris), 4, '0')),
       k.nim_anggota, k.nama_anggota, k.prodi_anggota, k.no_hp_anggota, 'aktif', k.tgl_daftar_anggota
FROM (
    SELECT b.*, ROW_NUMBER() OVER (PARTITION BY b.nim_anggota ORDER BY b.baris) AS urut
    FROM anggota_bersih b
    WHERE b.nama_anggota != '' AND b.nama_anggota IS NOT NULL
      AND b.tgl_daftar_anggota IS NOT NULL
      AND b.prodi_anggota IS NOT NULL
      AND b.nim_anggota REGEXP '^[0-9]{10}$'
      AND NOT EXISTS (SELECT 1 FROM anggota a WHERE a.nim_anggota = b.nim_anggota)
) AS k
CROSS JOIN (SELECT IFNULL(MAX(CAST(SUBSTRING(no_anggota, 3) AS UNSIGNED)), 0) AS n FROM anggota) AS maks
WHERE k.urut = 1;