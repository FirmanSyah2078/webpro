/*
 * STREET SUSHI DATABASE MASTER SCRIPT
 * Version: 2.0 (Professional Data Seed)
 * Database System: MySQL 8.0+
 * Default Collation: utf8mb4_0900_ai_ci (Emoji Supported, Case Insensitive)
 */

-- ==========================================
-- BAGIAN 1: DATABASE INITIALIZATION
-- ==========================================

-- Hapus database lama jika ada (Reset Total)
DROP DATABASE IF EXISTS `sushi_db`;

-- Buat Database baru dengan konfigurasi karakter lengkap
CREATE DATABASE `sushi_db`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

-- Gunakan Database
USE `sushi_db`;

-- Matikan cek foreign key sementara untuk kelancaran pembuatan tabel
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+07:00"; -- Set Timezone Indonesia (WIB)

-- ==========================================
-- BAGIAN 2: TABLE STRUCTURE (DDL)
-- ==========================================

-- 1. Kategori Menu
CREATE TABLE `categories` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB;

-- 2. Varian Rasa (Flavor/Cooking Style)
CREATE TABLE `variants` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `extra_price` decimal(10,2) DEFAULT '0.00',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- 3. Add-ons (Condiments)
CREATE TABLE `addons` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `price` decimal(10,2) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- 4. Menu Utama
CREATE TABLE `menu_items` (
    `id` int NOT NULL AUTO_INCREMENT,
    `category_id` int DEFAULT NULL,
    `name` varchar(100) NOT NULL,
    `description` text,
    `base_price` decimal(10,2) NOT NULL,
    `image` varchar(255) DEFAULT 'default_menu.jpg',
    `is_available` tinyint(1) DEFAULT '1',
    PRIMARY KEY (`id`),
    KEY `fk_menu_category` (`category_id`),
    CONSTRAINT `fk_menu_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. Role Pekerjaan
CREATE TABLE `job_roles` (
    `id` int NOT NULL AUTO_INCREMENT,
    `role_name` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- 6. Shift Kerja
CREATE TABLE `work_shifts` (
    `id` int NOT NULL AUTO_INCREMENT,
    `shift_name` varchar(50) DEFAULT NULL,
    `start_time` time DEFAULT NULL,
    `end_time` time DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- 7. Karyawan
CREATE TABLE `employees` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` varchar(100) DEFAULT NULL,
    `role_id` int DEFAULT NULL,
    `shift_id` int DEFAULT NULL,
    `keterangan` varchar(100) DEFAULT '-',
    PRIMARY KEY (`id`),
    KEY `role_id` (`role_id`),
    KEY `shift_id` (`shift_id`),
    CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `job_roles` (`id`) ON DELETE SET NULL,
    CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`shift_id`) REFERENCES `work_shifts` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 8. Admin / Users
CREATE TABLE `admins` (
    `id` int NOT NULL AUTO_INCREMENT,
    `username` varchar(50) NOT NULL,
    `password` varchar(255) NOT NULL,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    `last_session_id` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB;

-- 9. Transaksi Order
CREATE TABLE `orders` (
    `id` int NOT NULL AUTO_INCREMENT,
    `customer_name` varchar(100) NOT NULL,
    `customer_phone` varchar(20) NOT NULL,
    `order_type` enum('delivery','pickup') DEFAULT 'delivery',
    `delivery_address` text NOT NULL,
    `payment_method` enum('cod','transfer','wallet') NOT NULL,
    `payment_proof` varchar(255) DEFAULT NULL,
    `total_amount` decimal(10,2) NOT NULL,
    `status` enum('pending','confirmed','cooking','delivery','completed','cancelled') DEFAULT 'pending',
    `notes_general` text,
    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- 10. Detail Order
CREATE TABLE `order_details` (
    `id` int NOT NULL AUTO_INCREMENT,
    `order_id` int NOT NULL,
    `menu_item_id` int NOT NULL,
    `variant_id` int DEFAULT NULL,
    `addon_id` int DEFAULT NULL,
    `quantity` int NOT NULL,
    `subtotal` decimal(10,2) NOT NULL,
    `notes` text,
    PRIMARY KEY (`id`),
    KEY `order_id` (`order_id`),
    KEY `menu_item_id` (`menu_item_id`),
    KEY `variant_id` (`variant_id`),
    KEY `addon_id` (`addon_id`),
    CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
    CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`),
    CONSTRAINT `order_details_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `variants` (`id`),
    CONSTRAINT `order_details_ibfk_4` FOREIGN KEY (`addon_id`) REFERENCES `addons` (`id`)
) ENGINE=InnoDB;

-- 11. Jadwal Toko
CREATE TABLE `store_schedule` (
    `id` int NOT NULL AUTO_INCREMENT,
    `day_name` varchar(20) DEFAULT NULL,
    `open_time` time DEFAULT NULL,
    `close_time` time DEFAULT NULL,
    `is_closed` tinyint(1) DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- 12. Tanggal Khusus
CREATE TABLE `special_dates` (
    `id` int NOT NULL AUTO_INCREMENT,
    `date` date NOT NULL,
    `description` varchar(255) DEFAULT NULL,
    `is_holiday` tinyint(1) DEFAULT '1',
    PRIMARY KEY (`id`),
    UNIQUE KEY `date` (`date`)
) ENGINE=InnoDB;

-- 13. System Settings
CREATE TABLE `system_settings` (
    `id` int NOT NULL DEFAULT '1',
    `store_name` varchar(100) DEFAULT 'Street Sushi',
    `total_tables` int DEFAULT '10',
    `force_status` enum('auto','close','open') DEFAULT 'auto',
    `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- ==========================================
-- BAGIAN 3: DATA SEEDING (PROFESSIONAL DUMMY DATA)
-- ==========================================

-- Seed: Categories
INSERT INTO `categories` (`name`) VALUES
('Maki'),
('Nigiri'),
('Uramaki'),
('Gunkan'),
('Sashimi'),
('Beverages');

-- Seed: Variants
INSERT INTO `variants` (`name`, `extra_price`) VALUES
('Original', 0.00),
('Spicy Mayo', 2500.00),
('Mentai Sauce', 3500.00),
('Flamed (Aburi)', 2000.00),
('Cheese Melt', 4000.00);

-- Seed: Addons
INSERT INTO `addons` (`name`, `price`) VALUES
('No Extra', 0.00),
('Extra Wasabi', 1000.00),
('Extra Soy Sauce', 500.00),
('Extra Ginger (Gari)', 1500.00),
('Chili Powder (Togarashi)', 500.00);

-- Seed: Menu Items (10 Items Professional)
INSERT INTO `menu_items` (`category_id`, `name`, `description`, `base_price`, `image`, `is_available`) VALUES
(1, 'Salmon Maki', 'Nasi sushi dengan isian salmon segar dibalut nori klasik.', 25000.00, 'salmon_maki.jpg', 1),
(1, 'Tamago Maki', 'Sushi roll sederhana dengan isian telur dadar Jepang manis.', 18000.00, 'tamago_maki.jpg', 1),
(2, 'Salmon Nigiri', 'Potongan salmon segar di atas kepalan nasi cuka.', 28000.00, 'salmon_nigiri.jpg', 1),
(2, 'Ebi Nigiri', 'Udang rebus premium di atas nasi sushi.', 26000.00, 'ebi_nigiri.jpg', 1),
(3, 'California Roll', 'Sushi roll balik dengan isian crabstick, alpukat, dan timun tabur wijen.', 32000.00, 'california_roll.jpg', 1),
(3, 'Dragon Roll', 'Roll udang tempura dengan topping alpukat menyerupai naga.', 45000.00, 'dragon_roll.jpg', 1),
(4, 'Spicy Salmon Gunkan', 'Nori cup berisi cincangan salmon dengan saus pedas spesial.', 30000.00, 'spicy_gunkan.jpg', 1),
(4, 'Tobiko Gunkan', 'Nori cup dengan topping telur ikan terbang yang renyah.', 35000.00, 'tobiko_gunkan.jpg', 1),
(5, 'Salmon Sashimi (3 pcs)', 'Tiga potong salmon segar tanpa nasi, kualitas grade A.', 48000.00, 'sashimi_3pcs.jpg', 1),
(6, 'Ocha (Cold/Hot)', 'Teh hijau Jepang otentik, bisa isi ulang.', 10000.00, 'ocha.jpg', 1);

-- Seed: Job Roles
INSERT INTO `job_roles` (`role_name`) VALUES
('Manager'),
('Head Chef'),
('Kitchen Staff'),
('Waitress/Cashier');

-- Seed: Shifts
INSERT INTO `work_shifts` (`id`, `shift_name`, `start_time`, `end_time`) VALUES
(1, 'Shift Pagi', '07:30:00', '15:20:00'),
(2, 'Shift Sore', NULL, NULL),
(3, 'Shift Malam', NULL, NULL);

-- Seed: Employees (Professional Names)
INSERT INTO `employees` (`name`, `role_id`, `shift_id`, `keterangan`) VALUES
('Budi Santoso', 1, 1, 'Store Manager'),
('Siti Aminah', 2, 1, 'Head Chef'),
('Rizky Pratama', 3, 2, '-'),
('Dewi Lestari', 4, 2, '-');

-- Seed: Admins (Password hash tetap sama agar Anda tetap bisa login)
INSERT INTO `admins` (`username`, `password`, `created_at`) VALUES
('superadmin', '$2y$12$rBTE7IcApfFuDT52wq4xm.tJW5fC3NnjKs4K7pQdJQX64Sf5c6Ci6', NOW()),
('staff_entry', '$2y$12$gU7D5duCjBgIioNLCZgNK..yMW4ZrkgZegDmIcWLbOCTmVjhGTWDa', NOW());

-- Seed: Orders (Contoh Transaksi Realistis)
INSERT INTO `orders` (`customer_name`, `customer_phone`, `order_type`, `delivery_address`, `payment_method`, `total_amount`, `status`, `notes_general`) VALUES
('Andi Wijaya', '08123456789', 'pickup', '-', 'wallet', 87000.00, 'completed', 'Minta sumpit 3 pasang'),
('Citra Kirana', '08198765432', 'delivery', 'Jl. Sudirman No. 45, Komplek Elite', 'transfer', 93000.00, 'cooking', 'Bel rumah mati, tolong telepon');

-- Seed: Order Details
-- Order Andi: 2 Salmon Maki + 1 California Roll
INSERT INTO `order_details` (`order_id`, `menu_item_id`, `variant_id`, `addon_id`, `quantity`, `subtotal`, `notes`) VALUES
(1, 1, 1, 1, 2, 50000.00, 'Potong jadi 8'),
(1, 5, 2, 2, 1, 37000.00, 'Extra spicy mayo'); -- Base 32k + Varian 2.5k + Addon 1k + Wasabi 1k = ~36.5k (dibulatkan manual di dummy ini)

-- Order Citra: 1 Dragon Roll + 1 Sashimi
INSERT INTO `order_details` (`order_id`, `menu_item_id`, `variant_id`, `addon_id`, `quantity`, `subtotal`, `notes`) VALUES
(2, 6, 1, 1, 1, 45000.00, ''),
(2, 9, 1, 3, 1, 48000.00, 'Soy sauce banyakin');

-- Seed: Store Schedule
INSERT INTO `store_schedule` (`day_name`, `open_time`, `close_time`, `is_closed`) VALUES
('Senin', '10:00:00', '22:00:00', 0),
('Selasa', '10:00:00', '22:00:00', 0),
('Rabu', '10:00:00', '22:00:00', 0),
('Kamis', '10:00:00', '22:00:00', 0),
('Jumat', '13:00:00', '23:00:00', 0),
('Sabtu', '10:00:00', '23:00:00', 0),
('Minggu', '10:00:00', '23:00:00', 0);

-- Seed: Special Dates
INSERT INTO `special_dates` (`date`, `description`, `is_holiday`) VALUES
('2026-01-01', 'Tahun Baru Masehi', 1),
('2026-02-12', 'Maintenance Kitchen Bulanan', 1);

-- Seed: System Settings
INSERT INTO `system_settings` (`store_name`, `total_tables`, `force_status`) VALUES
('Street Sushi Premium', 20, 'auto');

-- Aktifkan kembali Foreign Key Checks
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;