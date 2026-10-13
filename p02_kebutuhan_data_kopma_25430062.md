# Dokumen Kebutuhan Data Koperasi Mahasiswa Sejahtera (Kopma)

**Penyusun:** Elvin Purna Hidayat (25430062)  
**Mata Kuliah:** Praktikum Basis Data  

---

## 1. Latar Belakang dan Aktivitas Organisasi
Kopma bergerak di bidang retail skala kampus yang menyediakan alat tulis, makanan ringan, dan minuman. Aktivitas utama mencakup pendaftaran anggota, transaksi penjualan harian di kasir, pengecekan stok gudang, pemesanan dan penerimaan barang dari pemasok, serta pelaporan kinerja bulanan kepada ketua koperasi.

## 2. Aktor dan Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan Anggota | Kasir | Mahasiswa mengajukan pendaftaran |
| PB-02 | Mencatat Penjualan | Kasir | Pembeli melakukan pembayaran |
| PB-03 | Memesan Barang ke Pemasok | Petugas Gudang | Stok barang di bawah batas minimum |
| PB-04 | Menerima Barang dari Pemasok | Petugas Gudang | Barang & faktur tiba di gudang |
| PB-05 | Menyusun Laporan Bulanan | Ketua Koperasi | Rekapitulasi awal bulan |
| PB-06 | Mengelola Data Pemasok | Petugas Gudang | Adanya pemasok baru/perubahan data |

## 3. Dokumen Sumber yang Dianalisis
* Formulir Pendaftaran Anggota (NIM, Nama, Prodi, No HP)
* Nota Penjualan (`No Nota`, `Tanggal`, `Kasir`, `Anggota`, `Barang`, `Qty`, `Harga Satuan`)
* Faktur Pembelian Pemasok (`No Faktur`, `Pemasok`, `Tanggal`, `Barang`, `Qty`, `Harga Beli`)

## 4. Entitas Kandidat dan Elemen Data
* **Anggota:** `no_anggota`, `nim_anggota`, `nama_anggota`, `prodi_anggota`, `no_hp_anggota`, `status_aktif_anggota`
* **Barang:** `kode_barang`, `nama_barang`, `kategori_barang`, `harga_jual_barang`, `stok_barang`, `batas_minimum_barang`
* **Penjualan:** `no_nota_penjualan`, `tgl_penjualan`, `kode_petugas`, `no_anggota`, `bayar_penjualan`
* **Detail Penjualan:** `no_nota_penjualan`, `kode_barang`, `qty_detail_penjualan`, `harga_satuan_detail_penjualan`
* **Petugas:** `kode_petugas`, `nama_petugas`, `peran_petugas`
* **Pemasok:** `kode_pemasok`, `nama_pemasok`, `telepon_pemasok`, `alamat_pemasok`
* **Pembelian:** `no_faktur_pembelian`, `tgl_pembelian`, `kode_pemasok`, `kode_petugas`
* **Detail Pembelian:** `no_faktur_pembelian`, `kode_barang`, `qty_detail_pembelian`, `harga_beli_detail_pembelian`

## 5. Aturan Bisnis
* **AB-01:** Setiap transaksi penjualan memiliki nomor nota unik dan minimal memuat 1 item barang.
* **AB-02:** Penjualan dapat dilakukan tanpa anggota; jika pembeli adalah anggota aktif, diberikan diskon 5%.
* **AB-03:** Nilai `stok_barang` tidak boleh bernilai negatif ($>= 0$).
* **AB-04:** Harga jual pada nota penjualan dicatat per baris transaksi dan tidak berubah jika harga katalog berubah di kemudian hari.
* **AB-05:** `nim_anggota` bersifat unik untuk tiap mahasiswa.
* **AB-06:** Pemesanan barang dilakukan bila `stok_barang` $<$ `batas_minimum_barang`.

## 6. Kebutuhan Informasi
* **KI-01:** Total omzet dan jumlah nota harian/bulanan.
* **KI-02:** 5 barang terlaris per bulan berdasarkan total kuantitas terjual.
* **KI-03:** Daftar barang dengan nilai stok di bawah batas minimum.
* **KI-04:** 10 anggota dengan akumulasi belanja terbesar per bulan.

## 7. Matriks CRUD
| Proses Bisnis | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian | Detail Pembelian |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| PB-01 Daftar Anggota | C | - | - | - | - | - | - |
| PB-02 Catat Penjualan | R | R, U | C | C | - | - | - |
| PB-03 Pesan Barang | - | R | - | - | R | C | C |
| PB-04 Terima Barang | - | U | - | - | R | U | U |
| PB-05 Laporan Bulanan | R | R | R | R | - | R | R |
| PB-06 Kelola Pemasok | - | - | - | - | C, U, D | - | - |

## 8. Kamus Data Awal
| Elemen Data | Arti | Contoh | Aturan | Penanggung Jawab |
|---|---|---|---|---|
| `no_anggota` | Nomor ID Anggota Kopma | A-0457 | Unik, Format A-4Digit | Ketua Koperasi |
| `nim_anggota` | NIM Mahasiswa | 25430062 | Unik, 8-10 digit angka | Ketua Koperasi |
| `no_hp_anggota` | Nomor Telepon Anggota | 081234567890 | Data Pribadi Terbatas | Ketua Koperasi |
| `no_nota_penjualan` | Nomor Transaksi Penjualan | PJ-2609-0142 | Unik per transaksi | Kasir |
| `harga_satuan_detail_penjualan` | Harga Jual saat Transaksi | 4000 | Bilangan Bulat $>= 0$ | Kasir |
| `stok_barang` | Kuantitas Barang Tersedia | 35 | Bilangan Bulat $>= 0$ | Petugas Gudang |

## 9. Kebutuhan Non-Fungsional Data
* **Volume:** Perkiraan 150 transaksi nota per hari.
* **Retensi:** Data transaksi wajib disimpan minimal 5 tahun untuk keperluan audit keuangan.
* **Keamanan/Privasi:** Nomor HP anggota tergolong data pribadi terbatas dan hanya boleh diakses oleh Ketua Koperasi.

## 10. Isu Kualitas Data yang Dianalis
* Penomoran nota ganda akibat pencatatan manual.
* Ketidaksesuaian jumlah fisik barang di gudang dengan catatan akibat stok bernilai negatif.