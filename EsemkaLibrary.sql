-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 27, 2025 at 05:50 AM
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
-- Database: `EsemkaLibrary`
--

-- --------------------------------------------------------

--
-- Table structure for table `Book`
--

CREATE TABLE `Book` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `author` varchar(200) NOT NULL,
  `publish_date` date DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Book`
--

INSERT INTO `Book` (`id`, `title`, `author`, `publish_date`, `stock`, `created_at`, `deleted_at`) VALUES
(1, 'The Hunger Games Collections', 'Suzanne Collins', NULL, 1, '2025-02-27 11:04:56', NULL),
(2, 'Harry Potter Collections', 'J.K. Rowling', '2003-06-21', 1, '2025-02-27 11:04:56', NULL),
(3, 'To Kill a Mockingbird', 'Harper Lee', '1960-07-11', 3, '2025-02-27 11:04:56', NULL),
(4, 'Pride and Prejudice', 'Jane Austen, Anna Quindlen', '2013-01-28', 3, '2025-02-27 11:04:56', NULL),
(5, 'Twilight', 'Stephenie Meyer', '2005-10-05', 3, '2025-02-27 11:04:57', NULL),
(6, 'The Book Thief', 'Markus Zusak', '2005-09-01', 3, '2025-02-27 11:04:57', NULL),
(7, 'The Chronicles of Narnia', 'C.S. Lewis, Pauline Baynes', '1956-10-28', 3, '2025-02-27 11:04:57', NULL),
(8, 'J.R.R. Tolkien 4-Book Boxed Set: The Hobbit and The Lord of the Rings', 'J.R.R. Tolkien', '1955-10-20', 1, '2025-02-27 11:04:57', NULL),
(9, 'Gone with the Wind', 'Margaret Mitchell', '1936-06-30', 5, '2025-02-27 11:04:57', NULL),
(10, 'The Fault in Our Stars', 'John Green', NULL, 3, '2025-02-27 11:04:57', NULL),
(11, 'The Hitchhiker\'s Guide to the Galaxy', 'Douglas Adams', '1979-10-12', 3, '2025-02-27 11:04:57', NULL),
(12, 'The Giving Tree', 'Shel Silverstein', '1964-10-28', 3, '2025-02-27 11:04:57', NULL),
(13, 'Wuthering Heights', 'Emily Bronta', '1947-12-28', 3, '2025-02-27 11:04:57', NULL),
(14, 'The Da Vinci Code', 'Dan Brown', '2003-03-18', 10, '2025-02-27 11:04:57', NULL),
(15, 'Memoirs of a Geisha', 'Arthur Golden', '1997-09-23', 3, '2025-02-27 11:04:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `BookGenre`
--

CREATE TABLE `BookGenre` (
  `id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BookGenre`
--

INSERT INTO `BookGenre` (`id`, `book_id`, `genre_id`, `created_at`, `deleted_at`) VALUES
(1, 1, 1, '2025-02-27 11:04:57', NULL),
(2, 1, 2, '2025-02-27 11:04:57', NULL),
(3, 1, 5, '2025-02-27 11:04:57', NULL),
(4, 1, 6, '2025-02-27 11:04:57', NULL),
(5, 2, 2, '2025-02-27 11:04:58', NULL),
(6, 2, 3, '2025-02-27 11:04:58', NULL),
(7, 2, 4, '2025-02-27 11:04:58', NULL),
(8, 2, 5, '2025-02-27 11:04:58', NULL),
(9, 2, 6, '2025-02-27 11:04:58', NULL),
(10, 3, 4, '2025-02-27 11:04:58', NULL),
(11, 3, 6, '2025-02-27 11:04:58', NULL),
(12, 3, 7, '2025-02-27 11:04:58', NULL),
(13, 4, 4, '2025-02-27 11:04:58', NULL),
(14, 4, 6, '2025-02-27 11:04:58', NULL),
(15, 4, 7, '2025-02-27 11:04:58', NULL),
(16, 4, 9, '2025-02-27 11:04:58', NULL),
(17, 5, 5, '2025-02-27 11:04:58', NULL),
(18, 5, 6, '2025-02-27 11:04:58', NULL),
(19, 5, 9, '2025-02-27 11:04:58', NULL),
(20, 6, 4, '2025-02-27 11:04:58', NULL),
(21, 6, 6, '2025-02-27 11:04:58', NULL),
(22, 6, 7, '2025-02-27 11:04:59', NULL),
(23, 7, 2, '2025-02-27 11:04:59', NULL),
(24, 7, 3, '2025-02-27 11:04:59', NULL),
(25, 7, 4, '2025-02-27 11:04:59', NULL),
(26, 7, 5, '2025-02-27 11:04:59', NULL),
(27, 7, 6, '2025-02-27 11:04:59', NULL),
(28, 8, 2, '2025-02-27 11:04:59', NULL),
(29, 8, 4, '2025-02-27 11:04:59', NULL),
(30, 8, 5, '2025-02-27 11:04:59', NULL),
(31, 8, 6, '2025-02-27 11:04:59', NULL),
(32, 9, 4, '2025-02-27 11:04:59', NULL),
(33, 9, 6, '2025-02-27 11:04:59', NULL),
(34, 9, 7, '2025-02-27 11:04:59', NULL),
(35, 9, 9, '2025-02-27 11:04:59', NULL),
(36, 10, 6, '2025-02-27 11:04:59', NULL),
(37, 10, 9, '2025-02-27 11:04:59', NULL),
(38, 11, 2, '2025-02-27 11:04:59', NULL),
(39, 11, 4, '2025-02-27 11:04:59', NULL),
(40, 11, 5, '2025-02-27 11:04:59', NULL),
(41, 11, 6, '2025-02-27 11:05:00', NULL),
(42, 12, 3, '2025-02-27 11:05:00', NULL),
(43, 12, 4, '2025-02-27 11:05:00', NULL),
(44, 12, 5, '2025-02-27 11:05:00', NULL),
(45, 12, 6, '2025-02-27 11:05:00', NULL),
(46, 13, 4, '2025-02-27 11:05:00', NULL),
(47, 13, 6, '2025-02-27 11:05:00', NULL),
(48, 13, 7, '2025-02-27 11:05:00', NULL),
(49, 13, 9, '2025-02-27 11:05:00', NULL),
(50, 14, 2, '2025-02-27 11:05:00', NULL),
(51, 14, 6, '2025-02-27 11:05:00', NULL),
(52, 15, 4, '2025-02-27 11:05:00', NULL),
(53, 15, 6, '2025-02-27 11:05:00', NULL),
(54, 15, 7, '2025-02-27 11:05:00', NULL),
(55, 15, 9, '2025-02-27 11:05:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Borrowing`
--

CREATE TABLE `Borrowing` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `borrow_date` datetime NOT NULL,
  `return_date` datetime DEFAULT NULL,
  `fine` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Borrowing`
--

INSERT INTO `Borrowing` (`id`, `member_id`, `book_id`, `borrow_date`, `return_date`, `fine`, `created_at`, `deleted_at`) VALUES
(1, 18, 1, '2024-04-08 00:00:00', '2024-04-15 00:00:00', 0.00, '2024-04-20 00:00:00', NULL),
(2, 18, 2, '2024-04-08 00:00:00', '2024-04-21 00:00:00', 12000.00, '2024-04-20 00:00:00', NULL),
(3, 18, 3, '2024-04-08 00:00:00', '2024-04-15 00:00:00', 0.00, '2024-04-20 00:00:00', NULL),
(4, 2, 5, '2024-04-11 00:00:00', '2024-04-15 00:00:00', NULL, '2024-04-11 00:00:00', NULL),
(5, 4, 12, '2024-04-12 00:00:00', '2024-04-13 00:00:00', NULL, '2024-04-12 00:00:00', NULL),
(6, 9, 9, '2024-04-13 00:00:00', '2024-04-20 00:00:00', NULL, '2024-04-13 00:00:00', NULL),
(7, 11, 1, '2024-04-17 00:00:00', NULL, NULL, '2024-04-17 00:00:00', NULL),
(8, 16, 11, '2024-04-17 00:00:00', NULL, NULL, '2024-04-17 00:00:00', NULL),
(9, 11, 2, '2024-04-18 00:00:00', NULL, NULL, '2024-04-18 00:00:00', NULL),
(10, 18, 14, '2024-04-22 00:00:00', NULL, NULL, '2024-04-22 00:00:00', NULL),
(11, 11, 7, '2024-04-23 00:00:00', NULL, NULL, '2024-04-23 00:00:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `BorrowingHistory`
--

CREATE TABLE `BorrowingHistory` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `borrow_date` datetime NOT NULL,
  `return_date` datetime DEFAULT NULL,
  `fine` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `Genre`
--

CREATE TABLE `Genre` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Genre`
--

INSERT INTO `Genre` (`id`, `name`, `created_at`, `deleted_at`) VALUES
(1, 'Action', '2025-02-27 11:04:56', NULL),
(2, 'Adventure', '2025-02-27 11:04:56', NULL),
(3, 'Childrens', '2025-02-27 11:04:56', NULL),
(4, 'Classics', '2025-02-27 11:04:56', NULL),
(5, 'Fantasy', '2025-02-27 11:04:56', NULL),
(6, 'Fiction', '2025-02-27 11:04:56', NULL),
(7, 'Historical', '2025-02-27 11:04:56', NULL),
(8, 'Horror', '2025-02-27 11:04:56', NULL),
(9, 'Romance', '2025-02-27 11:04:56', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Member`
--

CREATE TABLE `Member` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Member`
--

INSERT INTO `Member` (`id`, `name`, `email`, `created_at`, `deleted_at`) VALUES
(1, 'Yvon Blackaller', 'yblackaller0@meetup.com', '2023-11-30 00:00:00', '2023-12-13 00:00:00'),
(2, 'Cyrill McAnellye', 'cmcanellye1@marriott.com', '2023-02-24 00:00:00', NULL),
(3, 'Gussie Wattingham', 'gwattingham2@csmonitor.com', '2024-03-25 00:00:00', NULL),
(4, 'Lyndsey Adamkiewicz', 'ladamkiewicz3@etsy.com', '2023-06-08 00:00:00', NULL),
(5, 'Riordan Spittle', 'rspittle4@macromedia.com', '2023-05-29 00:00:00', NULL),
(6, 'Shelly Beddo', 'sbeddo5@bbc.co.uk', '2023-09-15 00:00:00', '2023-10-23 00:00:00'),
(7, 'Harrison Pullinger', 'hpullinger6@prnewswire.com', '2023-11-23 00:00:00', '2024-01-10 00:00:00'),
(8, 'Trueman Tolfrey', 'ttolfrey7@illinois.edu', '2024-03-17 00:00:00', NULL),
(9, 'Marybeth Matschek', 'mmatschek8@timesonline.co.uk', '2023-02-02 00:00:00', NULL),
(10, 'Stephine McColm', 'smccolm9@amazon.com', '2023-07-30 00:00:00', '2024-01-07 00:00:00'),
(11, 'Serge Risborough', 'srisborougha@miibeian.gov.cn', '2023-03-01 00:00:00', NULL),
(12, 'Rosemary Grimmer', 'rgrimmerb@ebay.com', '2023-09-09 00:00:00', NULL),
(13, 'Lucila Brixey', 'lbrixeyc@sakura.ne.jp', '2023-01-18 00:00:00', '2024-01-17 00:00:00'),
(14, 'Fairfax Wilsone', 'fwilsoned@ft.com', '2024-03-13 00:00:00', '2024-03-01 00:00:00'),
(15, 'Valerye Quartley', 'vquartleye@nymag.com', '2024-04-19 00:00:00', NULL),
(16, 'Megan Calderon', 'mcalderonf@ustream.tv', '2023-05-15 00:00:00', NULL),
(17, 'Minta Covendon', 'mcovendong@cpanel.net', '2024-03-11 00:00:00', NULL),
(18, 'Irwin Acheson', 'iachesonh@noaa.gov', '2023-12-28 00:00:00', NULL),
(19, 'Rina Iacofo', 'riacofoi@people.com.cn', '2024-02-19 00:00:00', NULL),
(20, 'Clint Huckerby', 'chuckerbyj@skype.com', '2024-03-12 00:00:00', '2024-12-13 00:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Book`
--
ALTER TABLE `Book`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `BookGenre`
--
ALTER TABLE `BookGenre`
  ADD PRIMARY KEY (`id`),
  ADD KEY `book_id` (`book_id`),
  ADD KEY `genre_id` (`genre_id`);

--
-- Indexes for table `Borrowing`
--
ALTER TABLE `Borrowing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `BorrowingHistory`
--
ALTER TABLE `BorrowingHistory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `Genre`
--
ALTER TABLE `Genre`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Member`
--
ALTER TABLE `Member`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Book`
--
ALTER TABLE `Book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `BookGenre`
--
ALTER TABLE `BookGenre`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `Borrowing`
--
ALTER TABLE `Borrowing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `BorrowingHistory`
--
ALTER TABLE `BorrowingHistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Genre`
--
ALTER TABLE `Genre`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `Member`
--
ALTER TABLE `Member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `BookGenre`
--
ALTER TABLE `BookGenre`
  ADD CONSTRAINT `BookGenre_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `Book` (`id`),
  ADD CONSTRAINT `BookGenre_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `Genre` (`id`);

--
-- Constraints for table `Borrowing`
--
ALTER TABLE `Borrowing`
  ADD CONSTRAINT `Borrowing_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`),
  ADD CONSTRAINT `Borrowing_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `Book` (`id`);

--
-- Constraints for table `BorrowingHistory`
--
ALTER TABLE `BorrowingHistory`
  ADD CONSTRAINT `BorrowingHistory_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`),
  ADD CONSTRAINT `BorrowingHistory_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `Book` (`id`);

ALTER TABLE Borrowing ADD COLUMN due_date DATE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
