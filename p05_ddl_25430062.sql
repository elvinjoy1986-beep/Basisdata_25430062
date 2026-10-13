-- ============================================================================
-- Berkas : p05_ddl_25430062.sql
-- NAMA   : Elvin Purna Hidayat (NIM: 25430062)
-- TEMA   : Toko Daring (Viinjay Store) - Modul 5
-- ============================================================================

USE toko_062;

-- Urutan Hapus Wajib dari Anak ke Induk
DROP TABLE IF EXISTS pengiriman;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS pelanggan;

-- ----------------------------------------------------------------------------
-- 2. TABEL MASTER (INDUK)
-- ----------------------------------------------------------------------------

-- Tabel 1: PELANGGAN
CREATE TABLE pelanggan (
  id_pelanggan INT NOT NULL AUTO_INCREMENT,
  nama_pelanggan VARCHAR(100) NOT NULL,
  email_pelanggan VARCHAR(100) NOT NULL,
  no_hp_pelanggan VARCHAR(15) NOT NULL,
  alamat_pelanggan TEXT NOT NULL,
  PRIMARY KEY (id_pelanggan),
  CONSTRAINT uq_pelanggan_email UNIQUE (email_pelanggan) -- AB-05
) ENGINE=InnoDB;

-- Tabel 2: KATEGORI
CREATE TABLE kategori (
  id_kategori INT NOT NULL AUTO_INCREMENT,
  nama_kategori VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_kategori),
  CONSTRAINT uq_kategori_nama UNIQUE (nama_kategori)
) ENGINE=InnoDB;

-- Tabel 3: PRODUK
CREATE TABLE produk (
  id_produk INT NOT NULL AUTO_INCREMENT,
  id_kategori INT NOT NULL,
  kode_produk VARCHAR(15) NOT NULL,
  nama_produk VARCHAR(100) NOT NULL,
  harga_produk DECIMAL(12,2) NOT NULL,
  stok_produk INT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_produk),
  CONSTRAINT uq_produk_kode UNIQUE (kode_produk),
  CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori) REFERENCES kategori (id_kategori),
  CONSTRAINT ck_produk_harga CHECK (harga_produk >= 0),
  CONSTRAINT ck_produk_stok CHECK (stok_produk >= 0) -- AB-03
) ENGINE=InnoDB;

-- ----------------------------------------------------------------------------
-- 3. TABEL TRANSAKSI
-- ----------------------------------------------------------------------------

-- Tabel 4: PESANAN
CREATE TABLE pesanan (
  id_pesanan INT NOT NULL AUTO_INCREMENT,
  no_invoice_pesanan VARCHAR(30) NOT NULL,
  id_pelanggan INT NOT NULL,
  tgl_pesanan DATETIME NOT NULL,
  alamat_pengiriman TEXT NOT NULL, -- AB-08
  ongkir_pesanan DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  diskon_pesanan DECIMAL(5,2) NOT NULL DEFAULT 9.00, -- AB-02: Diskon P = 9%
  status_pesanan ENUM('MENUNGGU_BAYAR', 'LUNAS', 'DIBATALKAN') NOT NULL DEFAULT 'MENUNGGU_BAYAR',
  PRIMARY KEY (id_pesanan),
  CONSTRAINT uq_pesanan_invoice UNIQUE (no_invoice_pesanan), -- AB-01
  CONSTRAINT fk_pesanan_pelanggan FOREIGN KEY (id_pelanggan) REFERENCES pelanggan (id_pelanggan),
  CONSTRAINT ck_pesanan_ongkir CHECK (ongkir_pesanan >= 0),
  CONSTRAINT ck_pesanan_diskon CHECK (diskon_pesanan >= 0 AND diskon_pesanan <= 100)
) ENGINE=InnoDB;

-- Tabel 5: DETAIL_PESANAN
CREATE TABLE detail_pesanan (
  id_pesanan INT NOT NULL,
  id_produk INT NOT NULL,
  qty_detail_pesanan SMALLINT NOT NULL,
  harga_satuan_detail_pesanan DECIMAL(12,2) NOT NULL, -- AB-04
  PRIMARY KEY (id_pesanan, id_produk),
  CONSTRAINT fk_detail_pesanan_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_pesanan_produk FOREIGN KEY (id_produk) REFERENCES produk (id_produk),
  -- Catatan Parameter P: Limit maksimal 11 item per baris transaksi (CHECK 1 baris)
  CONSTRAINT ck_detail_pesanan_qty CHECK (qty_detail_pesanan > 0 AND qty_detail_pesanan <= 11), 
  CONSTRAINT ck_detail_pesanan_harga CHECK (harga_satuan_detail_pesanan >= 0)
) ENGINE=InnoDB;

-- Tabel 6: PEMBAYARAN
CREATE TABLE pembayaran (
  id_pembayaran INT NOT NULL AUTO_INCREMENT,
  id_pesanan INT NOT NULL,
  tgl_pembayaran DATETIME NOT NULL,
  metode_pembayaran ENUM('TRANSFER_BANK', 'E_WALLET', 'KARTU_KREDIT') NOT NULL,
  jumlah_pembayaran DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_pembayaran),
  CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan) ON DELETE CASCADE,
  CONSTRAINT ck_pembayaran_jumlah CHECK (jumlah_pembayaran > 0)
) ENGINE=InnoDB;

-- Tabel 7: PENGIRIMAN
CREATE TABLE pengiriman (
  id_pengiriman INT NOT NULL AUTO_INCREMENT,
  id_pesanan INT NOT NULL,
  no_resi_pengiriman VARCHAR(50) NULL, -- AB-07
  tgl_pengiriman DATETIME NULL,
  status_pengiriman ENUM('DIPROSES', 'DIKIRIM', 'SELESAI') NOT NULL DEFAULT 'DIPROSES',
  PRIMARY KEY (id_pengiriman),
  CONSTRAINT fk_pengiriman_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan) ON DELETE CASCADE
) ENGINE=InnoDB;