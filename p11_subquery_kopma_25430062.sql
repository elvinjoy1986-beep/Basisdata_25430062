-- ============================================================================
-- Berkas : p11_subquery_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Subquery & Operasi Himpunan Kopma_062 - Modul 11
-- ============================================================================

USE kopma_062;

-- 1. Subquery Skalar: Barang di Atas Rata-rata Harga
SELECT kode_barang, nama_barang, harga_jual_barang
FROM barang
WHERE harga_jual_barang > (SELECT AVG(harga_jual_barang) FROM barang)
ORDER BY harga_jual_barang DESC;

-- 2. Pembuktian Jebakan NOT IN vs NOT EXISTS
-- Cara 1 (Terkena Jebakan NULL -> 0 Baris):
SELECT no_anggota, nama_anggota FROM anggota
WHERE id_anggota NOT IN (SELECT id_anggota FROM penjualan);

-- Cara 1 Perbaikan (Menapis NULL -> Aman):
SELECT no_anggota, nama_anggota FROM anggota
WHERE id_anggota NOT IN (SELECT id_anggota FROM penjualan WHERE id_anggota IS NOT NULL);

-- Cara 2 (NOT EXISTS -> Aman):
SELECT a.no_anggota, a.nama_anggota, a.status_anggota 
FROM anggota a
WHERE NOT EXISTS (SELECT 1 FROM penjualan p WHERE p.id_anggota = a.id_anggota);

-- 3. Tabel Turunan (Derived Table): Rata-rata Nominal per Nota
SELECT ROUND(AVG(t.total), 0) AS rata_nota
FROM (
    SELECT d.id_penjualan, SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS total
    FROM detail_penjualan d 
    GROUP BY d.id_penjualan
) AS t;

-- 4. Operasi Himpunan
SELECT id_barang FROM detail_pembelian
INTERSECT
SELECT id_barang FROM detail_penjualan;

SELECT id_barang FROM detail_pembelian
EXCEPT
SELECT id_barang FROM detail_penjualan;