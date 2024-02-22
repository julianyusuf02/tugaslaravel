-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 22, 2024 at 03:00 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `penjualan`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `hargajual` (`hargaModal` INT UNSIGNED, `keuntungan` DECIMAL(10,2)) RETURNS INT(11) DETERMINISTIC BEGIN
DECLARE besarKeuntungan INT UNSIGNED;
SET besarKeuntungan = hargaModal * (keuntungan/100);
RETURN (hargaModal+besarKeuntungan);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hargaTotal` (`hargaSatuan` INT UNSIGNED, `jumlah` INT UNSIGNED) RETURNS INT(11) DETERMINISTIC BEGIN
RETURN (hargaSatuan*jumlah);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hargaTotalKeuntungan` (`hargaModal` INT UNSIGNED, `total` INT UNSIGNED, `keuntungan` DECIMAL(10,2)) RETURNS INT(11) DETERMINISTIC BEGIN
DECLARE hargaModalTotal INT UNSIGNED;
DECLARE besarKeuntungan INT UNSIGNED;
SET hargaModalTotal = hargaModal * total;
SET besarKeuntungan = hargaModalTotal * (keuntungan/100);
RETURN (hargaModalTotal + besarKeuntungan); 
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `insertBarang` (`namaBarang` VARCHAR(100), `kodeBarang` VARCHAR(200), `harga` INT UNSIGNED) RETURNS INT(11) DETERMINISTIC BEGIN
INSERT INTO BARANG (nama_barang,kode,harga) VALUES (namaBarang,kodeBarang,harga);
return 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(10) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `kode` varchar(200) NOT NULL,
  `harga` int(20) NOT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `nama_barang`, `kode`, `harga`, `keterangan`) VALUES
(1, 'motor', 'nnfnfnjdnf', 20000000, NULL),
(2, 'pensil', 'tjjttkjt', 2000, NULL),
(3, 'pulpen', 'ddrdtrtr', 3500, NULL),
(9, 'knalpot', 'pppppugdg', 1500000, NULL),
(10, 'penghapus', 'BYWEBVY6', 3000, NULL),
(11, 'penggaris', 'TQF2637', 5000, NULL),
(12, '67', '7', 6887, NULL),
(13, 'koyo', '8980', 70000, NULL);

--
-- Triggers `barang`
--
DELIMITER $$
CREATE TRIGGER `BarangStokInsert` AFTER INSERT ON `barang` FOR EACH ROW BEGIN
INSERT INTO stok (id_barang,jumlah) VALUES (new.id_barang, 0);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `NambahStok` AFTER INSERT ON `barang` FOR EACH ROW BEGIN
insert into logs(pesan,tanggal) VALUES (CONCAT('Item Di tambah',new.nama_barang,
' dengan id = ',
new.id_barang,' dengan harga ',new.harga),current_timestamp());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `beli`
--

CREATE TABLE `beli` (
  `id_beli` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah_beli` int(10) NOT NULL,
  `tanggal` date NOT NULL,
  `harga` int(10) NOT NULL,
  `total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `beli`
--

INSERT INTO `beli` (`id_beli`, `id_barang`, `jumlah_beli`, `tanggal`, `harga`, `total`) VALUES
(8, 3, 20, '2024-02-05', 3500, 91000);

--
-- Triggers `beli`
--
DELIMITER $$
CREATE TRIGGER `BeliBarang` AFTER INSERT ON `beli` FOR EACH ROW BEGIN
insert into logs (pesan,tanggal) VALUES (CONCAT('Item Baru Di Beli ',
(SELECT br.nama_barang from barang br where br.id_barang=new.id_barang),
' beli sebanyak ',new.jumlah_beli,
' dengan harga ',new.harga,' dan total ',new.total,' dilakukan pada tanggal '),
current_timestamp());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeliStok` AFTER INSERT ON `beli` FOR EACH ROW BEGIN
UPDATE stok SET jumlah = jumlah + new.jumlah_beli WHERE id_barang =
new.id_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jual`
--

CREATE TABLE `jual` (
  `id_jual` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah_jual` int(10) NOT NULL,
  `tanggal` date NOT NULL,
  `harga` int(10) NOT NULL,
  `total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jual`
--

INSERT INTO `jual` (`id_jual`, `id_barang`, `jumlah_jual`, `tanggal`, `harga`, `total`) VALUES
(4, 3, 5, '2024-02-05', 3500, 22750),
(6, 9, 8, '2024-02-05', 1950000, 15600000);

--
-- Triggers `jual`
--
DELIMITER $$
CREATE TRIGGER `JualStok` AFTER INSERT ON `jual` FOR EACH ROW BEGIN
UPDATE stok SET jumlah = jumlah - new.jumlah_jual WHERE id_barang =
new.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `jualBarang` AFTER INSERT ON `jual` FOR EACH ROW BEGIN
insert into logs (pesan,tanggal) VALUES (CONCAT('Item Baru Terjual',
(SELECT br.nama_barang from barang br where br.id_barang=new.id_barang),
' beli sebanyak ',new.jumlah_jual,
' dengan harga ',new.harga,' dan total ',new.total,' dilakukan pada tanggal '),
current_timestamp());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id_logs` int(10) NOT NULL,
  `pesan` text NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id_logs`, `pesan`, `tanggal`) VALUES
(1, 'Item Baru Di Beli pulpen beli sebanyak 12 dengan harga 3500 dan total 70000 dilakukan pada tanggal ', '2024-02-05'),
(2, 'Item Baru Di Beli pulpen beli sebanyak 20 dengan harga 3500 dan total 70000 dilakukan pada tanggal ', '2024-02-05'),
(3, 'Item Baru Di Beli pulpen beli sebanyak 20 dengan harga 3500 dan total 91000 dilakukan pada tanggal ', '2024-02-05'),
(4, 'Item Baru Terjualpulpen beli sebanyak 5 dengan harga 3500 dan total 22750 dilakukan pada tanggal ', '2024-02-05'),
(5, 'Item Baru Terjualknalpot beli sebanyak 8 dengan harga 1620000 dan total 15600000 dilakukan pada tanggal ', '2024-02-05'),
(6, 'Item Baru Terjualknalpot beli sebanyak 8 dengan harga 1950000 dan total 15600000 dilakukan pada tanggal ', '2024-02-05'),
(7, 'Item Di tambahpenghapus dengan id = 10 dengan harga 3000', '2024-02-05'),
(8, 'Item Di tambahpenggaris dengan id = 11 dengan harga 5000', '2024-02-05'),
(9, 'Item Di tambah67 dengan id = 12 dengan harga 6887', '2024-02-22'),
(10, 'Item Di tambahkoyo dengan id = 13 dengan harga 70000', '2024-02-22');

-- --------------------------------------------------------

--
-- Table structure for table `stok`
--

CREATE TABLE `stok` (
  `id_stok` int(10) NOT NULL,
  `id_barang` int(10) DEFAULT NULL,
  `jumlah` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stok`
--

INSERT INTO `stok` (`id_stok`, `id_barang`, `jumlah`) VALUES
(1, 1, 9),
(2, 2, 24),
(3, 3, 47),
(4, 9, 154),
(5, 10, 0),
(6, 11, 0),
(7, 12, 0),
(8, 13, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`);

--
-- Indexes for table `beli`
--
ALTER TABLE `beli`
  ADD PRIMARY KEY (`id_beli`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `jual`
--
ALTER TABLE `jual`
  ADD PRIMARY KEY (`id_jual`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id_logs`);

--
-- Indexes for table `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`id_stok`),
  ADD UNIQUE KEY `id_barang` (`id_barang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `beli`
--
ALTER TABLE `beli`
  MODIFY `id_beli` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `jual`
--
ALTER TABLE `jual`
  MODIFY `id_jual` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id_logs` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `stok`
--
ALTER TABLE `stok`
  MODIFY `id_stok` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `beli`
--
ALTER TABLE `beli`
  ADD CONSTRAINT `beli_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`);

--
-- Constraints for table `jual`
--
ALTER TABLE `jual`
  ADD CONSTRAINT `jual_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`);

--
-- Constraints for table `stok`
--
ALTER TABLE `stok`
  ADD CONSTRAINT `stok_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
