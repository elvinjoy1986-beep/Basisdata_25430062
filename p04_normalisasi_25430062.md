# Dokumen Normalisasi & Skema Relasional - Viinjay Store 

**Nama Pengembang:** Elvin Purna Hidayat 
**NIM:** 25430062  
**Kode Tema:** toko  
**Nama Basis Data:** toko_062  

---

## 1. Dokumen Sumber & Unnormalized Form (UNF)
Titik awal diambil dari **Invoice Pesanan Daring (INV-202610-0062)** pada Modul 2.

INVOICE_UNF (id_pesanan, tgl_pesanan, id_pelanggan, nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pengiriman, { id_produk, nama_produk, nama_kategori, qty_detail_pesanan, harga_satuan_detail_pesanan, subtotal_detail }, total_harga_item, ongkir_pesanan, diskon_pesanan, grand_total, status_pembayaran, no_resi_pengiriman, status_pengiriman)


---

## 2. First Normal Form (1NF)
Menghilangkan grup berulang item barang. Kunci primer menjadi kunci komposit (`id_pesanan`, `id_produk`).

INVOICE_1NF (id_pesanan, id_produk, tgl_pesanan, id_pelanggan, nama_pelanggan, email_pelanggan, no_hp_pelanggan, alamat_pengiriman, nama_produk, nama_kategori, qty_detail_pesanan, harga_satuan_detail_pesanan, subtotal_detail, total_harga_item, ongkir_pesanan, diskon_pesanan, grand_total, status_pembayaran, no_resi_pengiriman, status_pengiriman)


---

## 3. Dependensi Fungsional (FD) Berbasis Aturan Bisnis
* **FD1:** `id_pesanan` -> `tgl_pesanan`, `id_pelanggan`, `alamat_pengiriman`, `ongkir_pesanan`, `diskon_pesanan`, `status_pesanan` (AB-01, AB-02, AB-08)
* **FD2:** `id_pelanggan` -> `nama_pelanggan`, `email_pelanggan`, `no_hp_pelanggan`, `alamat_pelanggan` (AB-05)
* **FD3:** `id_produk` -> `nama_produk`, `harga_produk`, `stok_produk`, `id_kategori` (AB-03)
* **FD4:** `id_kategori` -> `nama_kategori`
* **FD5:** (`id_pesanan`, `id_produk`) -> `qty_detail_pesanan`, `harga_satuan_detail_pesanan` (AB-01, AB-04)
* **FD6:** `id_pesanan` -> `id_pembayaran`, `tgl_pembayaran`, `metode_pembayaran`, `jumlah_pembayaran` (AB-06)
* **FD7:** `id_pesanan` -> `id_pengiriman`, `no_resi_pengiriman`, `tgl_pengiriman`, `status_pengiriman` (AB-07)
* **FD8 (Turunan):** (`qty_detail_pesanan`, `harga_satuan_detail_pesanan`) -> `subtotal_detail`

---

## 4. Second Normal Form (2NF)
Menghilangkan ketergantungan parsial pada kunci komposit (`id_pesanan`, `id_produk`):

* `PESANAN` ($\underline{\text{id\_pesanan}}$, `tgl_pesanan`, `id_pelanggan`, `nama_pelanggan`, `email_pelanggan`, `no_hp_pelanggan`, `alamat_pengiriman`, `ongkir_pesanan`, `diskon_pesanan`)
* `DETAIL_PESANAN` ($\underline{\text{id\_pesanan}^*}$, $\underline{\text{id\_produk}^*}$, `qty_detail_pesanan`, `harga_satuan_detail_pesanan`)
* `PRODUK` ($\underline{\text{id\_produk}}$, `nama_produk`, `nama_kategori`, `harga_produk`, `stok_produk`)

---

## 5. Third Normal Form (3NF)
Menghilangkan ketergantungan transitif (`id_pelanggan` -> detail pelanggan, `id_kategori` -> `nama_kategori`) dan menghapus atribut kalkulasi turunan (`subtotal_detail`, `total_harga_item`, `grand_total`):

1. **`PELANGGAN`** ($\underline{\text{id\_pelanggan}}$, `nama_pelanggan`, `email_pelanggan`, `no_hp_pelanggan`, `alamat_pelanggan`)
2. **`KATEGORI`** ($\underline{\text{id\_kategori}}$, `nama_kategori`)
3. **`PRODUK`** ($\underline{\text{id\_produk}}$, `id_kategori^*`, `nama_produk`, `harga_produk`, `stok_produk`)
4. **`PESANAN`** ($\underline{\text{id\_pesanan}}$, `id_pelanggan^*`, `tgl_pesanan`, `alamat_pengiriman`, `ongkir_pesanan`, `diskon_pesanan`, `status_pesanan`)
5. **`DETAIL_PESANAN`** ($\underline{\text{id\_pesanan}^*}$, $\underline{\text{id\_produk}^*}$, `qty_detail_pesanan`, `harga_satuan_detail_pesanan`)
6. **`PEMBAYARAN`** ($\underline{\text{id\_pembayaran}}$, `id_pesanan^*`, `tgl_pembayaran`, `metode_pembayaran`, `jumlah_pembayaran`)
7. **`PENGIRIMAN`** ($\underline{\text{id\_pengiriman}}$, `id_pesanan^*`, `no_resi_pengiriman`, `tgl_pengiriman`, `status_pengiriman`)

---

## 6. Pemeriksaan Boyce-Codd Normal Form (BCNF)
Evaluasi ketergantungan fungsional pada seluruh tabel 3NF:
* Pada tabel `PELANGGAN`, penentu `id_pelanggan` dan `email_pelanggan` keduanya merupakan kunci kandidat unik.
* Pada seluruh tabel lainnya (`KATEGORI`, `PRODUK`, `PESANAN`, `DETAIL_PESANAN`, `PEMBAYARAN`, `PENGIRIMAN`), setiap penentu (*determinant*) adalah kunci primer/kandidat.
* **Kesimpulan:** Seluruh relasi telah memenuhi syarat BCNF.

---

## 7. Keputusan Penyimpanan Nilai Turunan
* Atribut `subtotal_detail` ($qty \times harga\_satuan$), `total_harga_item`, dan `grand_total` **DITOLAK / TIDAK DISIMPAN** pada basis data operasional OLTP.
* **Alasan:** Nilai turunan dihitung secara kueri dinamis (`SUM(qty * harga_satuan) + o