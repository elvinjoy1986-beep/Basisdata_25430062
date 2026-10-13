-- ============================================================================
-- Berkas : p05_ddl_kopma_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TOPIK  : Skrip DDL Kanonik Koperasi Mahasiswa (Kopma_062) - Modul 5
-- ============================================================================

USE kopma_062;

-- ----------------------------------------------------------------------------
-- 1. PENGHAPUSAN TABEL (Urutan dari Anak ke Induk)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ----------------------------------------------------------------------------
-- 2. PEMBUATAN TABEL MASTER (TABEL INDUK)
-- ----------------------------------------------------------------------------

-- Tabel 1: PETUGAS
CREATE TABLE petugas (
  id_petugas SMALLINT NOT NULL AUTO_INCREMENT,
  kode_petugas CHAR(3) NOT NULL,
  nama_petugas VARCHAR(100) NOT NULL,
  peran_petugas ENUM('kasir', 'gudang', 'ketua') NOT NULL,
  PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

-- Tabel 2: ANGGOTA
CREATE TABLE anggota (
  id_anggota INT NOT NULL AUTO_INCREMENT,
  no_anggota VARCHAR(10) NOT NULL,
  nim_anggota CHAR(10) NOT NULL,
  nama_anggota VARCHAR(100) NOT NULL,
  prodi_anggota VARCHAR(50) NOT NULL,
  no_hp_anggota VARCHAR(15) NULL,
  status_anggota ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
  tgl_daftar_anggota DATE NOT NULL,
  PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no UNIQUE (no_anggota),
  CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota) -- AB-05
) ENGINE=InnoDB;

-- Tabel 3: BARANG
CREATE TABLE barang (
  id_barang INT NOT NULL AUTO_INCREMENT,
  kode_barang VARCHAR(10) NOT NULL,
  nama_barang VARCHAR(100) NOT NULL,
  kategori_barang ENUM('ATK', 'makanan', 'minuman') NOT NULL,
  harga_jual_barang DECIMAL(12,2) NOT NULL,
  stok_barang INT NOT NULL DEFAULT 0,
  stok_min_barang INT NOT NULL DEFAULT 5,
  PRIMARY KEY (id_barang),
  CONSTRAINT uq_barang_kode UNIQUE (kode_barang),
  CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0), -- AB-03
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0),
  CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0)
) ENGINE=InnoDB;

-- Tabel 4: PEMASOK
CREATE TABLE pemasok (
  id_pemasok INT NOT NULL AUTO_INCREMENT,
  nama_pemasok VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(15) NOT NULL,
  alamat_pemasok TEXT NOT NULL,
  PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 3. PEMBUATAN TABEL TRANSAKSI (TABEL ANAK & DETAIL)
-- ----------------------------------------------------------------------------

-- Tabel 5: PENJUALAN
CREATE TABLE penjualan (
  id_penjualan INT NOT NULL AUTO_INCREMENT,
  no_nota_penjualan CHAR(12) NOT NULL,
  tgl_penjualan DATETIME NOT NULL,
  id_petugas SMALLINT NOT NULL,
  id_anggota INT NULL, -- AB-02: Boleh NULL untuk pembeli umum
  bayar_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan),
  CONSTRAINT uq_penjualan_nota UNIQUE (no_nota_penjualan), -- AB-01
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota) ON DELETE SET NULL,
  CONSTRAINT ck_penjualan_bayar CHECK (bayar_penjualan >= 0)
) ENGINE=InnoDB;

-- Tabel 6: DETAIL_PENJUALAN
CREATE TABLE detail_penjualan (
  id_penjualan INT NOT NULL,
  id_barang INT NOT NULL,
  qty_detail_penjualan SMALLINT NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL, -- AB-04
  PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_detail_penjualan_penjualan FOREIGN KEY (id_penjualan) REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_penjualan_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_penjualan_qty CHECK (qty_detail_penjualan > 0),
  CONSTRAINT ck_detail_penjualan_harga CHECK (harga_satuan_detail_penjualan >= 0)
) ENGINE=InnoDB;

-- Tabel 7: PEMBELIAN
CREATE TABLE pembelian (
  id_pembelian INT NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(30) NOT NULL,
  tgl_pembelian DATE NOT NULL,
  id_pemasok INT NOT NULL,
  id_petugas SMALLINT NOT NULL,
  status_pembelian ENUM('dipesan', 'diterima') NOT NULL DEFAULT 'dipesan',
  PRIMARY KEY (id_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok),
  CONSTRAINT fk_pembelian_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

-- Tabel 8: DETAIL_PEMBELIAN
CREATE TABLE detail_pembelian (
  id_pembelian INT NOT NULL,
  id_barang INT NOT NULL,
  qty_detail_pembelian SMALLINT NOT NULL,
  harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_detail_pembelian_pembelian FOREIGN KEY (id_pembelian) REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
  CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_pembelian_qty CHECK (qty_detail_pembelian > 0),
  CONSTRAINT ck_detail_pembelian_harga CHECK (harga_beli_detail_pembelian >= 0)
) ENGINE=InnoDB;