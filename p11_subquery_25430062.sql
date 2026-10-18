-- ============================================================================
-- Berkas : p11_subquery_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store) - Modul 11
-- ============================================================================

USE toko_062;

-- ----------------------------------------------------------------------------
-- KUERI 1 (SUBQUERY SKALAR)
-- Pertanyaan: Produk mana yang harganya melebihi rata-rata harga katalog?
-- ----------------------------------------------------------------------------
SELECT kode_produk, nama_produk, harga_produk
FROM produk
WHERE harga_produk > (SELECT AVG(harga_produk) FROM produk)
ORDER BY harga_produk DESC;

-- ----------------------------------------------------------------------------
-- KUERI 2 (SUBQUERY BERKORELASI - NOT EXISTS & TEST JEBAKAN NOT IN)
-- Pertanyaan: Pelanggan mana yang terdaftar tetapi belum pernah order?
-- ----------------------------------------------------------------------------
-- Pengujian Jebakan NOT IN (Aman karena kolom id_pelanggan di pesanan NOT NULL):
SELECT nama_pelanggan, email_pelanggan FROM pelanggan
WHERE id_pelanggan NOT IN (SELECT id_pelanggan FROM pesanan);

-- Versi NOT EXISTS (Praktik Terbaik & Aman):
SELECT pl.nama_pelanggan, pl.email_pelanggan
FROM pelanggan pl
WHERE NOT EXISTS (
    SELECT 1 FROM pesanan ps WHERE ps.id_pelanggan = pl.id_pelanggan
);

-- ----------------------------------------------------------------------------
-- KUERI 3 (TABEL TURUNAN / DERIVED TABLE)
-- Pertanyaan: Berapa rerata belanja total per transaksi di Viinjay Store G62?
-- ----------------------------------------------------------------------------
SELECT ROUND(AVG(tabel_total.total_belanja), 2) AS rata_rata_per_invoice
FROM (
    SELECT id_pesanan, SUM(qty_detail_pesanan * harga_satuan_detail_pesanan) AS total_belanja
    FROM detail_pesanan
    GROUP BY id_pesanan
) AS tabel_total;

-- ----------------------------------------------------------------------------
-- KUERI 4 (OPERASI HIMPUNAN - UNION ALL)
-- Pertanyaan: Tampilkan daftar direktori seluruh kontak pelanggan dan email toko.
-- ----------------------------------------------------------------------------
SELECT nama_pelanggan AS entitas, email_pelanggan AS email, 'Pelanggan' AS tipe
FROM pelanggan
UNION ALL
SELECT 'Administrator Viinjay' AS entitas, 'admin@viinjay.com' AS email, 'Internal' AS tipe;

-- ----------------------------------------------------------------------------
-- KUERI 5 (OPERASI HIMPUNAN - EXCEPT)
-- Pertanyaan: ID Produk apa saja yang ada di katalog tetapi belum ada di transaksi?
-- ----------------------------------------------------------------------------
SELECT id_produk FROM produk
EXCEPT
SELECT id_produk FROM detail_pesanan;