-- ============================================================================
-- Berkas : p07_kueri_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store G62) - Modul 7
-- ============================================================================

USE toko_062;

-- ----------------------------------------------------------------------------
-- KUERI 1
-- KI-PROJ-01: Pencarian produk berdasarkan pola nama menggunakan LIKE
-- Pertanyaan: Tampilkan produk yang mengandung kata 'Wireless' atau 'RGB'!
-- Harapan   : Mengembalikan 2 baris produk (Mouse Wireless & Keyboard RGB).
-- ----------------------------------------------------------------------------
SELECT kode_produk, nama_produk, harga_produk, stok_produk
FROM produk
WHERE nama_produk LIKE '%Wireless%' OR nama_produk LIKE '%RGB%';

-- ----------------------------------------------------------------------------
-- KUERI 2
-- KI-PROJ-02: Penyaringan harga produk dalam rentang tertentu (BETWEEN)
-- Pertanyaan: Produk apa saja yang harganya antara Rp200.000 hingga Rp500.000?
-- Harapan   : Mengembalikan daftar produk dengan kisaran harga pertengahan.
-- ----------------------------------------------------------------------------
SELECT kode_produk, nama_produk, harga_produk
FROM produk
WHERE harga_produk BETWEEN 200000.00 AND 500000.00
ORDER BY harga_produk ASC;

-- ----------------------------------------------------------------------------
-- KUERI 3
-- KI-PROJ-03: Penyaringan kategori produk tertentu menggunakan IN
-- Pertanyaan: Tampilkan semua produk yang tergolong kategori 2 (Keyboard/Mouse) dan 3 (Storage/RAM)!
-- Harapan   : Mengembalikan baris produk yang sesuai dengan ID kategori tersebut.
-- ----------------------------------------------------------------------------
SELECT id_produk, id_kategori, nama_produk, harga_produk
FROM produk
WHERE id_kategori IN (2, 3);

-- ----------------------------------------------------------------------------
-- KUERI 4
-- KI-PROJ-04: Menampilkan data pengiriman yang belum memiliki nomor resi (IS NULL)
-- Pertanyaan: Pengiriman mana saja yang belum diinputkan nomor resi resminya?
-- Harapan   : Mengembalikan baris data pengiriman bernilai NULL pada no_resi_pengiriman.
-- ----------------------------------------------------------------------------
SELECT id_pengiriman, id_pesanan, status_pengiriman, IFNULL(no_resi_pengiriman, 'BELUM_DITERBITKAN') AS resi
FROM pengiriman
WHERE no_resi_pengiriman IS NULL;

-- ----------------------------------------------------------------------------
-- KUERI 5
-- KI-PROJ-05: Penggunaan ekspresi CASE kondisional untuk status stok produk
-- Pertanyaan: Tampilkan label ketersediaan stok ('Stok Kritis', 'Stok Aman') untuk setiap produk!
-- Harapan   : Tampil kolom 'label_stok' berdasarkan ambang batas stok < 30.
-- ----------------------------------------------------------------------------
SELECT kode_produk, nama_produk, stok_produk,
       CASE 
            WHEN stok_produk < 30 THEN 'Stok Kritis - Perlu Restock'
            ELSE 'Stok Aman'
       END AS status_ketersediaan
FROM produk
ORDER BY stok_produk ASC;

-- ----------------------------------------------------------------------------
-- KUERI 6
-- KI-PROJ-06: Penggunaan Fungsi Tanggal (DATE_FORMAT & DATEDIFF) pada transaksi
-- Pertanyaan: Format tanggal transaksi pesanan ke format Indonesia dan hitung umur hari transaksi!
-- Harapan   : Tampil format DD-MM-YYYY dan selisih hari dari tanggal 2026-10-13.
-- ----------------------------------------------------------------------------
SELECT no_invoice_pesanan,
       DATE_FORMAT(tgl_pesanan, '%d-%m-%Y %H:%i') AS tgl_transaksi_formatted,
       DATEDIFF('2026-10-13', tgl_pesanan) AS selisih_hari
FROM pesanan
LIMIT 5;

-- ----------------------------------------------------------------------------
-- KUERI 7
-- KI-PROJ-07: Penggunaan Fungsi String (CONCAT, UPPER) untuk format identitas pelanggan
-- Pertanyaan: Tampilkan nama pelanggan dalam huruf kapital beserta domain emailnya!
-- Harapan   : Tampil format 'NAMA (email)' secara rapi.
-- ----------------------------------------------------------------------------
SELECT UPPER(nama_pelanggan) AS nama_kapital,
       CONCAT(nama_pelanggan, ' <', email_pelanggan, '>') AS kontak_pelanggan
FROM pelanggan;

-- ----------------------------------------------------------------------------
-- KUERI 8
-- KI-PROJ-08: Perhitungan subtotal transaksi per baris item pesanan
-- Pertanyaan: Berapa subtotal harga setiap baris item produk pada tabel detail_pesanan?
-- Harapan   : Tampil nilai hasil perkalian qty_detail_pesanan * harga_satuan_detail_pesanan.
-- ----------------------------------------------------------------------------
SELECT id_pesanan, id_produk, qty_detail_pesanan, harga_satuan_detail_pesanan,
       (qty_detail_pesanan * harga_satuan_detail_pesanan) AS subtotal_item
FROM detail_pesanan
LIMIT 10;

-- ----------------------------------------------------------------------------
-- KUERI 9
-- KI-PROJ-09: Penggunaan Fungsi Numerik (ROUND / FORMAT) untuk tampilan harga Rp
-- Pertanyaan: Tampilkan daftar produk dengan format mata uang Indonesia yang mudah dibaca!
-- Harapan   : Tampil format harga 'Rp150,000'.
-- ----------------------------------------------------------------------------
SELECT kode_produk, nama_produk,
       CONCAT('Rp', FORMAT(harga_produk, 0, 'id_ID')) AS harga_rupiah
FROM produk;

-- ----------------------------------------------------------------------------
-- KUERI 10 [KI BELUM TERJAWAB 1 TABEL]
-- KI-PROJ-10: Total belanja per invoice pesanan gabungan dengan nama pelanggan
-- Pertanyaan: Berapa total belanja bersih (termasuk ongkir & diskon 9%) untuk invoice 'INV-202610-0001' beserta nama pelanggannya?
-- Catatan   : [BELUM DAPAT DIJAWAB DENGAN 1 TABEL] Kueri ini memerlukan JOIN antara
--             tabel pesanan, detail_pesanan, dan pelanggan serta fungsi agregate SUM().
--             KI ini ditandai untuk diselesaikan pada Modul 9 (JOIN & Agregasi).
-- ----------------------------------------------------------------------------
SELECT no_invoice_pesanan, tgl_pesanan, ongkir_pesanan, diskon_pesanan
FROM pesanan
WHERE no_invoice_pesanan = 'INV-202610-0001';