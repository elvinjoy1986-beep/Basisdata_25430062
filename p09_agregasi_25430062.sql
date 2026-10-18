-- ============================================================================
-- Berkas : p09_agregasi_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store) - Modul 9
-- ============================================================================

USE toko_062;

-- Aktifkan Mode Ketat Pengelompokan SQL ISO Standard
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- ----------------------------------------------------------------------------
-- KUERI 1 (KI-PROJ-01)
-- Pertanyaan: Berapa total item produk terjual dan total omzet kotor per kategori produk?
-- Harapan   : Menampilkan daftar nama kategori, jumlah unit terjual, dan omzet kotor.
-- ----------------------------------------------------------------------------
SELECT k.nama_kategori,
       SUM(dp.qty_detail_pesanan) AS total_unit_terjual,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS omzet_kategori
FROM kategori k
JOIN produk pr ON k.id_kategori = pr.id_kategori
JOIN detail_pesanan dp ON pr.id_produk = dp.id_produk
GROUP BY k.id_kategori, k.nama_kategori
ORDER BY omzet_kategori DESC;

-- ----------------------------------------------------------------------------
-- KUERI 2 (KI-PROJ-02: Penggunaan WITH ROLLUP)
-- Pertanyaan: Tampilkan ringkasan total belanja per invoice beserta Grand Total keseluruhan!
-- Harapan   : Menampilkan subtotal belanja per pesanan dan baris ROLLUP (NULL) untuk Grand Total.
-- ----------------------------------------------------------------------------
SELECT ps.no_invoice_pesanan,
       COUNT(dp.id_produk) AS variasi_produk,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS total_belanja
FROM pesanan ps
JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY ps.id_pesanan, ps.no_invoice_pesanan WITH ROLLUP;

-- ----------------------------------------------------------------------------
-- KUERI 3 (KI-PROJ-03: Penggunaan HAVING)
-- Pertanyaan: Siapa saja pelanggan setia yang telah melakukan total transaksi belanja di atas Rp500.000?
-- Harapan   : Menampilkan nama pelanggan, email, dan akumulasi total belanja yang disaring oleh HAVING.
-- ----------------------------------------------------------------------------
SELECT pl.id_pelanggan, pl.nama_pelanggan, pl.email_pelanggan,
       COUNT(DISTINCT ps.id_pesanan) AS jumlah_pesanan,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS akumulasi_belanja
FROM pelanggan pl
JOIN pesanan ps ON pl.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY pl.id_pelanggan, pl.nama_pelanggan, pl.email_pelanggan
HAVING SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) > 500000.00;

-- ----------------------------------------------------------------------------
-- KUERI 4 (KI-PROJ-04: Analisis Metode Pembayaran & Diskon 9%)
-- Pertanyaan: Berapa total pembayaran bersih yang diterima berdasarkan metode pembayaran setelah diskon P=9%?
-- Harapan   : Menampilkan metode pembayaran, jumlah transaksi, dan total uang yang diterima.
-- ----------------------------------------------------------------------------
SELECT pm.metode_pembayaran,
       COUNT(pm.id_pembayaran) AS frekuensi_penggunaan,
       SUM(pm.jumlah_pembayaran) AS total_pemasukan_bersih
FROM pembayaran pm
GROUP BY pm.metode_pembayaran;

-- ----------------------------------------------------------------------------
-- KUERI 5 (KI-PROJ-05: Solusi KI-PROJ-10 Modul 7 yang Tertunda)
-- Pertanyaan: Berapa nilai total invoice 'INV-202610-0001' bersih (termasuk ongkir & diskon 9%) beserta nama pelanggannya?
-- Harapan   : Berhasil menjawab KI yang sebelumnya tidak dapat dijawab dengan 1 tabel di Modul 7.
-- ----------------------------------------------------------------------------
SELECT ps.no_invoice_pesanan, pl.nama_pelanggan, ps.tgl_pesanan,
       SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) AS subtotal_kotor,
       (SUM(dp.qty_detail_pesanan * dp.harga_satuan_detail_pesanan) * (1 - (ps.diskon_pesanan/100))) + ps.ongkir_pesanan AS total_bersih_invoice
FROM pesanan ps
JOIN pelanggan pl ON ps.id_pelanggan = pl.id_pelanggan
JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
WHERE ps.no_invoice_pesanan = 'INV-202610-0001'
GROUP BY ps.id_pesanan, ps.no_invoice_pesanan, pl.nama_pelanggan, ps.tgl_pesanan, ps.diskon_pesanan, ps.ongkir_pesanan;