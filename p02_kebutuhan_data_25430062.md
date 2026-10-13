# Dokumen Kebutuhan Data - Viinjay Store (Toko Daring)

**Nama Pengembang:** Elvin Purna Hidayat 
**NIM:** 25430062  
**Kode Tema:** toko  
**Nama Basis Data:** toko_062  

---

## 1. Latar Belakang dan Aktivitas Organisasi
Viinjay Store adalah platform retail toko daring yang menjual perlengkapan komputer dan aksesori digital. Aktivitas bisnis utama meliputi pendaftaran pelanggan, pemeliharaan katalog produk, pemrosesan keranjang dan pesanan pelanggan, verifikasi pembayaran, pelacakan pengiriman barang, serta penyusunan laporan penjualan harian/bulanan.

## 2. Aktor dan Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Registrasi Pelanggan | Pelanggan | Pelanggan membuat akun baru |
| PB-02 | Mengelola Katalog Produk | Admin Toko | Adanya produk baru atau perubahan harga/stok |
| PB-03 | Memproses Pesanan & Keranjang | Pelanggan | Pelanggan melakukan checkout barang |
| PB-04 | Verifikasi Pembayaran | Kasir / Admin | Pelanggan mengunggah konfirmasi bayar |
| PB-05 | Mengelola Pengiriman | Kurir / Admin | Pesanan telah diverifikasi pembayarannya |
| PB-06 | Menyusun Laporan Penjualan | Manajer Toko | Penutupan buku transaksi bulanan |

## 3. Dokumen Sumber Fiktif yang Dianalisis
### Invoice Pesanan Daring (INV-202610-0062)
* **Header:** Nomor Invoice (`INV-202610-0062`), Tgl Pesanan (`13-10-2026`), ID Pelanggan (`CUST-062`), Nama Pelanggan (`Elvin Purna`), Alamat Pengiriman (`Jl. Kampus No. 62, Metro`).
* **Item:** Kode Produk (`PRD-01`), Nama Produk (`Mouse Wireless G`), Qty (`2`), Harga Satuan (`150.000`), Subtotal (`300.000`).
* **Footer:** Total Harga Item (`300.000`), Ongkos Kirim (`15.000`), Diskon Pelanggan (`9%` = `28.350`), Grand Total (`286.650`), Status Pembayaran (`LUNAS`), Resi Pengiriman (`JP-06299182`).

## 4. Entitas Kandidat dan Elemen Data
1. **Pelanggan:** `id_pelanggan`, `nama_pelanggan`, `email_pelanggan`, `no_hp_pelanggan`, `alamat_pelanggan`
2. **Kategori:** `id_kategori`, `nama_kategori`
3. **Produk:** `id_produk`, `id_kategori`, `nama_produk`, `harga_produk`, `stok_produk`
4. **Pesanan:** `id_pesanan`, `id_pelanggan`, `tgl_pesanan`, `ongkir_pesanan`, `diskon_pesanan`, `status_pesanan`
5. **Detail Pesanan:** `id_pesanan`, `id_produk`, `qty_detail_pesanan`, `harga_satuan_detail_pesanan`
6. **Pembayaran:** `id_pembayaran`, `id_pesanan`, `tgl_pembayaran`, `metode_pembayaran`, `jumlah_pembayaran`
7. **Pengiriman:** `id_pengiriman`, `id_pesanan`, `no_resi_pengiriman`, `tgl_pengiriman`, `status_pengiriman`

## 5. Aturan Bisnis
* **AB-01:** Setiap pesanan memiliki nomor invoice unik dan memuat maksimal **11 item barang** ($P+2 = 9+2$) per transaksi.
* **AB-02:** Diskon pendaftaran pelanggan baru ditetapkan sebesar **9%** ($P = 9\%$) dari total belanja produk.
* **AB-03:** Nilai `stok_produk` tidak boleh bernilai negatif ($>= 0$).
* **AB-04:** Harga satuan pada `detail_pesanan` dicatat saat transaksi terjadi dan tidak berubah jika `harga_produk` pada katalog diperbarui.
* **AB-05:** `email_pelanggan` bersifat unik untuk tiap akun.
* **AB-06:** Pesanan akan dibatalkan secara otomatis jika pembayaran tidak dilakukan dalam kurun $1 \times 24$ jam.
* **AB-07:** Nomor resi pengiriman wajib diisi sewaktu status pengiriman diubah menjadi 'DIKIRIM'.
* **AB-08:** Alamat pengiriman pada entitas pesanan mengunci alamat tujuan saat pemesanan dilakukan.

## 6. Kebutuhan Informasi
* **KI-01:** Total omzet penjualan harian dan bulanan setelah dipotong diskon $9\%$.
* **KI-02:** Daftar 5 produk paling laris terjual per bulan.
* **KI-03:** Laporan rekapitulasi status pengiriman yang belum sampai ke pelanggan.
* **KI-04:** Laporan riwayat transaksi per pelanggan.
* **KI-05:** Daftar produk dengan stok menipis ($< 5$ unit).

## 7. Matriks CRUD
| Proses Bisnis | Pelanggan | Kategori | Produk | Pesanan | Detail Pesanan | Pembayaran | Pengiriman |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| PB-01 Registrasi Pelanggan | C | - | - | - | - | - | - |
| PB-02 Kelola Katalog | - | C, U, D | C, U, D | - | - | - | - |
| PB-03 Memproses Pesanan | R | R | R, U | C | C | - | - |
| PB-04 Verifikasi Pembayaran | - | - | - | R, U | - | C, U | - |
| PB-05 Kelola Pengiriman | - | - | - | R | - | R | C, U |
| PB-06 Menyusun Laporan | R | R | R | R | R | R | R |

## 8. Kamus Data Awal (20 Elemen Inti)
| Elemen Data | Arti | Contoh | Aturan | Penanggung Jawab |
|---|---|---|---|---|
| `id_pelanggan` | ID Unik Pelanggan | CUST-062 | Primary Key, Unik | Admin Toko |
| `nama_pelanggan` | Nama Lengkap | Elvin Purna | Teks, Wajib Diisi | Admin Toko |
| `email_pelanggan` | Email Akun | galeh@example.com | Format Email, Unik | Admin Toko |
| `no_hp_pelanggan` | Nomor HP Pelanggan | 081234567890 | Data Pribadi Spesifik | Admin Toko |
| `alamat_pelanggan` | Alamat Utama | Jl. Kampus Metro | Teks Alamat | Admin Toko |
| `id_kategori` | Kode Kategori | KAT-01 | Primary Key | Admin Toko |
| `nama_kategori` | Nama Kategori | Aksesori PC | Teks | Admin Toko |
| `id_produk` | Kode Unik Produk | PRD-01 | Primary Key | Admin Toko |
| `nama_produk` | Nama Produk Katalog | Mouse Wireless | Teks | Admin Toko |
| `harga_produk` | Harga Katalog | 150000 | Angka $>= 0$ | Admin Toko |
| `stok_produk` | Stok Barang | 50 | Angka $>= 0$ (AB-03) | Admin Toko |
| `id_pesanan` | Kode Invoice Pesanan | INV-202610-0062 | Primary Key, Unik | Kasir |
| `tgl_pesanan` | Tanggal Checkout | 2026-10-13 | Format Tanggal | Kasir |
| `ongkir_pesanan` | Biaya Kirim | 15000 | Angka $>= 0$ | Kasir |
| `diskon_pesanan` | Nilai Potongan ($9\%$) | 28350 | Angka $>= 0$ | Kasir |
| `status_pesanan` | Status Proses | LUNAS | Enum Status | Kasir |
| `qty_detail_pesanan` | Jumlah Item Dibeli | 2 | Maksimal 11 (AB-01) | Kasir |
| `harga_satuan_detail_pesanan` | Harga Terkunci | 150000 | Angka $>= 0$ (AB-04) | Kasir |
| `no_resi_pengiriman` | Nomor Resi Kurir | JP-06299182 | Unik per Pengiriman | Kurir |
| `status_pengiriman` | Status Kurir | DIKIRIM | Enum Status | Kurir |

## 9. Kebutuhan Non-Fungsional & Parameter P
* **Parameter NIM ($P$):**
  * $P = (62 \bmod 9) + 1 = 9$
  * Batas Maksimal Item per Transaksi = $P + 2 = 11$ item.
  * Persentase Diskon Pelanggan Baru = $9\%$.
  * Perkiraan Volume Transaksi Harian = $40 + (5 \times 9) = 85$ transaksi/hari.
* **Retensi & Privasi Data:** Data transaksi disimpan minimal 5 tahun. Email dan nomor HP pelanggan termasuk data pribadi yang dilindungi dan dilarang ditampilkan secara terbuka pada antarmuka publik.

## 10. Isu Kualitas Data yang Dianalisis
* **Duplikasi Produk:** Adanya variasi nama produk yang sama akibat kesalahan pengetikan admin.
* **Inkonsistensi Alamat:** Perubahan alamat pada entitas pelanggan yang berpotensi mengubah riwayat pengiriman transaksi lama (diantisipasi dengan menyalin alamat pengiriman langsung ke entitas pesanan).
