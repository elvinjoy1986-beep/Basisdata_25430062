# Laporan Audit dan Pengelolaan Kualitas Data - Modul 15

**Nama:** Elvin Purna Hidayat    
**NIM:** 25430062  
**Proyek:** Viinjay Store G62 (`toko_062`)  

---

## 1. Kerangka Kerja Kualitas Data

| Dimensi Kualitas | Definisi Organisasi | Target Toleransi |
| :--- | :--- | :--- |
| **Kelengkapan** | Kolom wajib (`nama_pelanggan`, `email_pelanggan`) terisi 100% | 0% Toleransi Kosong |
| **Validitas** | Format email baku dan nomor HP diawali `08` (10–13 digit) | < 2% Penyimpangan |
| **Keunikan** | Email pelanggan bersifat unik (AB-05 / Anti-Duplikasi) | 100% Unik |
| **Konsistensi** | Nama diawali huruf kapital dan email menggunakan *lowercase* | 100% Konsisten |

## 2. Profil Masalah Data Impor Awal (10 Baris Sample)

| Masalah Ditemukan | Dimensi | Jumlah Kasus | Dampak Bisnis |
| :--- | :--- | :--- | :--- |
| Nama Kosong | Kelengkapan | 1 baris | **Tinggi:** Gagal identifikasi pembeli |
| Format Email Invalid | Validitas | 1 baris | **Tinggi:** Notifikasi invoice tidak terkirim |
| Nomor HP Tidak Baku (`+62`, `62`, non-08) | Validitas | 3 baris | **Sedang:** Kegagalan WhatsApp Gateway |
| Duplikasi Email dalam Berkas | Keunikan | 1 baris | **Tinggi:** Akun ganda / promo berulang |
| Penulisan Huruf Kecil/Spasi Liar | Konsistensi | 2 baris | **Rendah:** Tampilan tidak rapi |

## 3. Matriks Prioritas dan Tindakan Perbaikan

1. **Prioritas 1 (Tolak Data):** Baris dengan `nama` kosong atau `email` tidak valid ditolak dan dikembalikan ke tim pendaftaran.
2. **Prioritas 2 (Pembersihan Otomatis):** Standarisasi format HP (`62` / `+62` dipangkas menjadi `08`) dan *trimming* spasi pada nama/email.
3. **Prioritas 3 (De-duplikasi):** Mengambil baris pertama berdasarkan `ROW_NUMBER() OVER (PARTITION BY email)` untuk menyaring data ganda.

## 4. Hasil Pengukuran Setelah Perbaikan Data

* **Total Baris Diimpor:** 10 Baris
* **Baris Lolos ke Tabel Utama (`pelanggan`):** 7 Baris
* **Baris Ditolak / Dieliminasi:** 3 Baris (1 Nama Kosong, 1 Email Invalid, 1 Duplikat Berkas)
* **Tingkat Kualitas Akhir:** 100% Data yang Masuk Bersih dan Valid.

## 5. Daftar Baris yang Ditolak (Log Audit)
* **Baris #2:** Ditolak karena `nama` kosong.
* **Baris #3:** Ditolak karena format email `galeh.invalid-email` tidak memenuhi `REGEXP`.
* **Baris #6:** Ditolak karena duplikasi email `dewi@gmail.com` dalam berkas impor.