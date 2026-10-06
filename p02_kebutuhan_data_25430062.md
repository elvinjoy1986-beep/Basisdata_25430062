# Dokumen Kebutuhan Data - Viinjay Store (Toko Daring)

## 1. Latar Belakang dan Aktivitas Organisasi
Viinjay Store adalah toko daring yang melayani penjualan aksesoris dan perlengkapan penunjang gadget (seperti pengisi daya, headset, casing, dan aksesoris laptop). Sistem ini dibangun untuk mengelola data katalog produk, registrasi pelanggan, keranjang belanja, pemesanan (*checkout*), pembayaran, pengiriman, serta meminimalisir kesalahan stok barang.

## 2. Aktor dan Proses Bisnis (Tabel PB-xx)
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Registrasi Pelanggan | Pelanggan / Sistem | Pengunjung mendaftar akun baru |
| PB-02 | Pengelolaan Katalog Produk | Admin Toko | Admin menambah atau memperbarui produk & stok |
| PB-03 | Pemrosesan Pesanan (Checkout) | Pelanggan | Pelanggan memilih produk dan membuat pesanan |
| PB-04 | Konfirmasi Pembayaran | Pelanggan / Admin | Pelanggan mengunggah bukti bayar / transfer |
| PB-05 | Pengiriman Pesanan | Bagian Pengiriman | Admin memvalidasi pembayaran dan mengirim barang |
| PB-06 | Pengelolaan Data Pemasok | Admin Toko | Penambahan data vendor/supplier aksesoris |

## 3. Dokumen Sumber yang Dianalisis
* **Invoice / Struk Pesanan Daring:** Memuat nomor invoice, tanggal pesanan, data pelanggan, daftar produk yang dibeli, kuantitas, harga satuan saat transaksi, subtotal, biaya ongkir, total pembayaran, metode bayar, dan status pengiriman.

## 4. Entitas Kandidat dan Elemen Data
* **Pelanggan:** `id_pelanggan`, `nama_pelanggan`, `email_pelanggan`, `password_hash`, `no_hp_pelanggan`, `alamat_pelanggan`, `tgl_daftar`
* **Produk:** `id_produk`, `sku_produk`, `nama_produk`, `kategori_produk`, `harga_produk`, `stok_produk`, `stok_min_produk`
* **Pesanan (Order):** `id_pesanan`, `no_invoice`, `tgl_pesanan`, `id_pelanggan`, `status_pesanan`, `ongkir`, `catatan_pesanan`
* **Detail Pesanan:** `id_pesanan`, `id_produk`, `qty_detail_pesanan`, `harga_saat_beli`
* **Pembayaran:** `id_pembayaran`, `id_pesanan`, `tgl_bayar`, `metode_pembayaran`, `jumlah_bayar`, `status_bayar`
* **Pengiriman:** `id_pengiriman`, `id_pesanan`, `no_resi`, `kurir`, `biaya_kirim`, `tgl_kirim`, `status_kirim`
* **Pemasok:** `id_pemasok`, `nama_pemasok`, `kontak_pemasok`, `alamat_pemasok`
* **Pembelian Stok:** `id_pembelian`, `no_faktur`, `tgl_pembelian`, `id_pemasok`, `total_biaya_beli`
* **Detail Pembelian Stok:** `id_pembelian`, `id_produk`, `qty_beli`, `harga_beli_satuan`

## 5. Aturan Bisnis (Tabel AB-xx)
* **AB-01:** Setiap nomor invoice pesanan bersifat unik dan memuat minimal satu jenis produk dalam detail pesanan.
* **AB-02:** Berdasarkan parameter NIM saya (\(P=9\)), batas maksimal kuantitas pembelian untuk satu jenis produk dalam satu transaksi adalah 11 item (\(P+2\)).
* **AB-03:** Stok produk di gudang tidak boleh bernilai negatif; sistem menolak checkout jika kuantitas melebihi stok aktif.
* **AB-04:** Harga jual produk yang dibeli wajib disimpan permanen pada detail pesanan (`harga_saat_beli`) agar tidak berubah apabila harga katalog master naik di kemudian hari.
* **AB-05:** Alamat email pelanggan bersifat unik untuk keperluan autentikasi akun login.
* **AB-06:** Pemesanan pembelian stok ke pemasok otomatis dibuat jika stok produk mencapai batas minimum.
* **AB-07:** Status pesanan hanya dapat berubah secara berurutan (*Pending* -> *Dibayar* -> *Dikirim* -> *Selesai*).
* **AB-08:** Pelanggan wajib mengisi alamat pengiriman yang valid sebelum tombol checkout dapat divalidasi sistem.

## 6. Kebutuhan Informasi (Tabel KI-xx)
* **KI-01:** Laporan total omzet penjualan dan jumlah pesanan harian serta bulanan.
* **KI-02:** Laporan 5 produk aksesoris terlaris per bulan berdasarkan total kuantitas barang terjual.
* **KI-03:** Daftar produk aksesoris yang memiliki sisa stok di bawah batas minimum (*stok menipis*).
* **KI-04:** Daftar 10 pelanggan dengan total nominal belanja terbesar per bulan.
* **KI-05:** Laporan status pengiriman dan rekap pengeluaran biaya operasional kurir per periode.

## 7. Matriks CRUD
| Proses Bisnis | Pelanggan | Produk | Pesanan | Detail Pesanan | Pembayaran | Pengiriman | Pemasok | Pembelian | Detail Pembelian |
|---|---|---|---|---|---|---|---|---|---|
| PB-01 Registrasi | C | - | - | - | - | - | - | - | - |
| PB-02 Katalog | - | C, U, D | - | - | - | - | - | - | - |
| PB-03 Checkout | R | R, U | C | C | - | - | - | - | - |
| PB-04 Pembayaran | - | - | U | - | C | - | - | - | - |
| PB-05 Pengiriman | - | - | U | - | - | C | - | - | - |
| PB-06 Pemasok | - | - | - | - | - | - | C, U | - | - |

## 8. Kamus Data Awal (Minimal 20 Elemen)
| No | Nama Elemen | Arti / Deskripsi | Contoh Nilai | Aturan / Format | Penanggung Jawab |
|---|---|---|---|---|---|
| 1 | `id_pelanggan` | Kunci unik pelanggan | `101` | Integer, Auto Increment | Admin Sistem |
| 2 | `nama_pelanggan` | Nama lengkap pembeli | `Rian Utama` | String, Wajib isi | Admin |
| 3 | `email_pelanggan` | Email akun login | `rian@mail.com` | Unik, Format email | Admin |
| 4 | `password_hash` | Enkripsi sandi akun | `$2y$10$...` | String terenkripsi | Admin Sistem |
| 5 | `no_hp_pelanggan` | Kontak seluler | `081234567890` | Data Pribadi (PDP) | Admin |
| 6 | `alamat_pelanggan`| Alamat tujuan kirim | `Jl. Merdeka No.10`| Teks lengkap | Admin |
| 7 | `id_produk` | Kunci unik produk | `501` | Integer, Auto Increment | Admin Gudang |
| 8 | `sku_produk` | Kode unik SKU barang | `ACC-HS-01` | Unik, String | Admin Gudang |
| 9 | `nama_produk` | Nama barang aksesoris | `Headset Bluetooth` | String, Wajib isi | Admin Gudang |
| 10 | `kategori_produk`| Kelompok barang | `Audio` | Enum (Audio, Charger, Case, Lainnya)| Admin Gudang |
| 11 | `harga_produk` | Harga jual katalog | `150000.00` | Desimal \(\ge 0\) | Admin Toko |
| 12 | `stok_produk` | Sisa fisik di gudang | `30` | Integer \(\ge 0\) (AB-03)| Admin Gudang |
| 13 | `stok_min_produk`| Batas minimum stok | `5` | Integer \(\ge 0\) | Admin Gudang |
| 14 | `id_pesanan` | Kunci unik transaksi | `1001` | Integer, Auto Increment | Kasir / Sistem |
| 15 | `no_invoice` | Nomor nota daring | `INV-202610-001`| Unik (AB-01) | Sistem |
| 16 | `tgl_pesanan` | Waktu saat checkout | `2026-10-06 10:00:00`| Datetime | Sistem |
| 17 | `status_pesanan` | Status alur order | `Pending` | Enum (Pending, Dibayar, Dikirim, Selesai)| Admin Toko |
| 18 | `qty_detail_pesanan`| Jumlah beli per item| `2` | Integer \(> 0\), maks 11 (AB-02)| Pelanggan |
| 19 | `harga_saat_beli` | Harga terkunci saat beli| `150000.00` | Desimal \(\ge 0\) (AB-04)| Sistem |
| 20 | `id_pembayaran` | Kunci pembayaran | `801` | Integer, Auto Increment | Bagian Keuangan |
| 21 | `jumlah_bayar` | Nominal transfer uang| `310000.00` | Desimal \(\ge 0\) | Bagian Keuangan |
| 22 | `id_pemasok` | Kunci unik supplier | `301` | Integer, Auto Increment | Admin Gudang |

## 9. Kebutuhan Non-Fungsional Data & Parameter Personalisasi
* **Parameter NIM (\(P\)):** Dua digit terakhir NIM `62` mod \(9 = 8 \rightarrow P = 8 + 1 = 9\).
* **Estimasi Volume Transaksi:** Sekitar 85 transaksi pesanan per hari (\(40 + 5 \times 9\)).
* **Retensi Data:** Arsip riwayat transaksi disimpan minimal 5 tahun ke depan.
* **Privasi dan Keamanan:** Data sensitif seperti `no_hp_pelanggan` dan `alamat_pelanggan` dikategorikan sebagai data pribadi yang harus dilindungi kerahasiaannya sesuai ketentuan undang-undang pelindungan data pribadi.

## 10. Isu Kualitas Data yang Diantisipasi
* Potensi kesalahan penulisan format nomor HP (*misal memakai awalan +62 atau 62 saja*), kesalahan input alamat email yang tidak valid, serta duplikasi data registrasi pelanggan yang akan ditangani melalui tahapan pembersihan data di modul berikutnya.