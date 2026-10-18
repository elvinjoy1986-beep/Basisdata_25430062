USE kopma_062;

DROP TABLE IF EXISTS anggota_impor;
CREATE TABLE anggota_impor (
    baris INT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(50),
    nama VARCHAR(100),
    prodi VARCHAR(100),
    no_hp VARCHAR(50),
    tgl_daftar VARCHAR(50)
);

INSERT INTO anggota_impor (nim, nama, prodi, no_hp, tgl_daftar) VALUES
('25430062-1', 'nadia putri', 'ilkom', '+628123456789', '01/10/2026'),
('25430063', '  budi santoso  ', 'IK', '081298765432', '02/10/2026'),
('25430064', '', 'Sistem Informasi', '081311223344', '03/10/2026'), -- Nama kosong
('25430065', 'citra dewi', 'SI', '85211223344', '31/09/2026'), -- Tanggal 31 Sept invalid
('25430066', 'eko prasetyo', 'Teknik Informatika', '081234567890', '05/10/2026'),
('25430066', 'eko prasetyo', 'TI', '081234567890', '05/10/2026'), -- NIM ganda di berkas
('25430001', 'ahmad rivaldi', 'Ilmu Komputer', '081200001111', '06/10/2026'), -- NIM sudah terdaftar di db
('25430067', 'fani rahmawati', 'ilkom', '12345', '07/10/2026'), -- HP invalid
('25430068', 'gilang ramadhan', 'Pendidikan Matematika', '+628990011223', '08/10/2026'),
('25430069', 'hendra wijaya', 'PEND. MATEMATIKA', '087788990011', '09/10/2026');