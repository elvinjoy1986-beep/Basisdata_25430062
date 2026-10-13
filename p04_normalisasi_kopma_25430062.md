# Dokumen Normalisasi Koperasi Mahasiswa Sejahtera (Kopma)

**Penyusun:** Elvin Purna Hidayat 
**NPM**: 25430062
**Kelas**: C
**Mata Kuliah**: Basis Data  

---

## 1. Relasi Unnormalized Form (UNF)
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, { kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan }, jumlah_penjualan, diskon_penjualan, total_penjualan)

## 2. Relasi First Normal Form (1NF)
Menghilangkan grup berulang, membuat kunci komposit (no_nota_penjualan, kode_barang):
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)

## 3. Dependensi Fungsional (FD) Berbasis Aturan Bisnis
* **FD1:** `no_nota_penjualan` -> `tgl_penjualan`, `kode_petugas`, `no_anggota` (AB-01)
* **FD2:** `kode_petugas` -> `nama_petugas`
* **FD3:** `no_anggota` -> `nama_anggota` (AB-05)
* **FD4:** `kode_barang` -> `nama_barang`
* **FD5:** (`no_nota_penjualan`, `kode_barang`) -> `qty_detail_penjualan`, `harga_satuan_detail_penjualan` (AB-04)
* **FD6 (Turunan):** (`qty_detail_penjualan`, `harga_satuan_detail_penjualan`) -> `subtotal_detail_penjualan`

## 4. Second Normal Form (2NF)
Menghilangkan ketergantungan parsial pada kunci komposit:
* `PENJUALAN` ($\underline{\text{no\_nota\_penjualan}}$, `tgl_penjualan`, `kode_petugas`, `no_anggota`, `nama_petugas`, `nama_anggota`)
* `DETAIL_PENJUALAN` ($\underline{\text{no\_nota\_penjualan}^*}$, $\underline{\text{kode\_barang}^*}$, `qty_detail_penjualan`, `harga_satuan_detail_penjualan`)
* `BARANG` ($\underline{\text{kode\_barang}}$, `nama_barang`)

## 5. Third Normal Form (3NF) & BCNF
Menghilangkan ketergantungan transitif (`kode_petugas` -> `nama_petugas` dan `no_anggota` -> `nama_anggota`) serta menghapus kolom turunan (`subtotal`, `total`):
* `PENJUALAN` ($\underline{\text{no\_nota\_penjualan}}$, `tgl_penjualan`, `kode_petugas^*`, `no_anggota^*`, `bayar_penjualan`)
* `DETAIL_PENJUALAN` ($\underline{\text{no\_nota\_penjualan}^*}$, $\underline{\text{kode\_barang}^*}$, `qty_detail_penjualan`, `harga_satuan_detail_penjualan`)
* `BARANG` ($\underline{\text{kode\_barang}}$, `nama_barang`, `kategori_barang`, `harga_jual_barang`, `stok_barang`, `stok_min_barang`)
* `PETUGAS` ($\underline{\text{kode\_petugas}}$, `nama_petugas`, `peran_petugas`)
* `ANGGOTA` ($\underline{\text{no\_anggota}}$, `nim_anggota`, `nama_anggota`, `prodi_anggota`, `no_hp_anggota`, `status_anggota`)

**Pemeriksaan BCNF:** Seluruh penentu (*determinant*) pada setiap relasi di atas merupakan kunci kandidat (*candidate key*), sehingga skema telah memenuhi BCNF.