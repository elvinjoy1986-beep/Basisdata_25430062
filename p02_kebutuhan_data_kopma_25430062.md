# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar Belakang dan Aktivitas Organisasi
Koperasi Mahasiswa Sejahtera (Kopma) melayani penjualan alat tulis, makanan ringan, dan minuman di lingkungan kampus. Sistem pencatatan sebelumnya masih menggunakan buku tulis dan spreadsheet yang sering menimbulkan kendala seperti harga lama yang hilang dan selisih stok minus.

## 2. Aktor dan Proses Bisnis (Tabel PB-xx)
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas Gudang | Stok barang di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas Gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua Koperasi | Memasuki awal bulan |

## 3. Dokumen Sumber yang Dianalisis
* **Nota Penjualan:** Memuat nomor nota, tanggal-jam, kasir, anggota (opsional), rincian barang, qty, harga satuan saat transaksi, subtotal, diskon anggota 5%, total, bayar, dan kembali.

## 4. Entitas Kandidat dan Elemen Data
* **Anggota:** `no_anggota`, `nim_anggota`, `nama_anggota`, `prodi_anggota`, `no_hp_anggota`, `status_anggota`, `tgl_daftar_anggota`
* **Barang:** `kode_barang`, `nama_barang`, `kategori_barang`, `harga_jual_barang`, `stok_barang`, `stok_min_barang`
* **Penjualan:** `no_nota_penjualan`, `tgl_penjualan`, `id_petugas`, `id_anggota`, `bayar_penjualan`
* **Detail Penjualan:** `no_nota_penjualan`, `kode_barang`, `qty_detail_penjualan`, `harga_satuan_detail_penjualan`
* **Petugas:** `kode_petugas`, `nama_petugas`, `peran_petugas`
* **Pemasok:** `id_pemasok`, `nama_pemasok`, `telepon_pemasok`, `alamat_pemasok`
* **Pembelian & Detail:** `no_faktur_pembelian`, `tgl_pembelian`, `id_pemasok`, `kode_barang`, `qty`, `harga_beli`

## 5. Aturan Bisnis (Tabel AB-xx)
* **AB-01:** Setiap nota memiliki nomor unik dan minimal satu baris barang.
* **AB-02:** Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%.
* **AB-03:** Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia.
* **AB-04:** Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik.
* **AB-05:** NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM.
* **AB-06:** Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut.

## 6. Kebutuhan Informasi (Tabel KI-xx)
* **KI-01:** Omzet dan jumlah nota per hari dan per bulan.
* **KI-02:** Lima barang terlaris per bulan berdasarkan qty.
* **KI-03:** Barang dengan stok di bawah batas minimum.
* **KI-04:** Sepuluh anggota dengan belanja terbesar per bulan.

## 7. Matriks CRUD
| Proses Bisnis | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | - | - | - | - | - |
| PB-02 Catat penjualan | R | R, U | C | C | - | - |
| PB-03 Pesan ke pemasok | - | R | - | - | R | C |
| PB-04 Terima barang | - | U | - | - | R | U |
| PB-05 Laporan bulanan | R | R | R | R | - | R |

## 8. Kamus Data Awal
| Nama Elemen | Arti / Deskripsi | Contoh Nilai | Aturan / Format | Penanggung Jawab |
|---|---|---|---|---|
| `no_anggota` | Nomor anggota koperasi | `A-0457` | Unik, format A-4 digit | Ketua |
| `nim_anggota` | NIM anggota | `2301010123` | Unik, 10 digit | Ketua |
| `no_hp_anggota` | Nomor HP anggota | `0812xxxx` | Data pribadi, akses terbatas | Ketua |
| `no_nota_penjualan` | Nomor nota penjualan | `PJ-2609-0142` | Unik per nota | Kasir |
| `harga_satuan_detail_penjualan` | Harga jual saat transaksi | `4000` | Bilangan bulat \(\ge 0\) (rupiah) | Kasir |
| `stok_barang` | Jumlah barang tersedia | `35` | Bilangan bulat \(\ge 0\) (AB-03) | Petugas Gudang |

## 9. Kebutuhan Non-Fungsional Data
* **Volume:** Perkiraan \(\pm 150\) nota per hari.
* **Retensi:** Data transaksi disimpan minimal 5 tahun.
* **Privasi:** Nomor HP anggota bersifat rahasia dan hanya dapat diakses oleh ketua koperasi sesuai UU Pelindungan Data Pribadi.

## 10. Isu Kualitas Data yang Diantisipasi
* Potensi inkonsistensi penulisan nama anggota dan ejaan pemasok pada spreadsheet lama yang perlu dibakukan dengan aturan validasi ketat.