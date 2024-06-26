-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 16, 2024 at 09:49 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `school_management_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Access` (IN `Email` VARCHAR(255), IN `class` INT, IN `section` VARCHAR(5), IN `department` VARCHAR(15))   BEGIN
      DECLARE cmsg VARCHAR(255);
      DECLARE name VARCHAR(50);
      SELECT t.Name INTO name FROM teachers t WHERE t.Email = Email; 
    -- Check if the email is null or empty
    IF Email IS NULL OR Email = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email cannot be null or empty';
    -- Check if the email exists in the table
    ELSEIF NOT EXISTS (SELECT 1 FROM teachers t WHERE t.Email = Email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email does not exist';

    -- Check if the class and section are null
    ELSEIF class IS NULL AND (section IS NULL OR section = '') AND (department IS NULL OR department = '') THEN
        -- Show all class and section related to the email
     SELECT 
    c.class_name AS Classes, 
    s.section_name Section, 
    d.department_name AS Departments,
    b.book_name AS courses
FROM 
    assign assi
    JOIN class_department_section cds ON assi.class_department_section_id = cds.id
    JOIN classes c ON cds.class_id = c.class_id
    JOIN departments d ON cds.department_id = d.department_id
    JOIN sections s ON cds.section_id = s.section_id
    JOIN book_author ba ON assi.book_author_id = ba.id
    JOIN books b USING(book_id)
    JOIN teachers t USING(teacher_id)
WHERE 
    t.Email = 'HashimThePassionate@gmail.com'
GROUP BY
    c.class_name, 
    s.section_name, 
    d.department_name,
    b.book_name;
     
    ELSEIF class IS NOT NULL AND (section IS NULL OR section = '') AND (department IS NULL OR department = '') THEN
    IF NOT EXISTS (SELECT 1 FROM assign a JOIN teachers t USING(teacher_id) JOIN
  class_department_section cds ON a.class_department_section_id = cds.id
  JOIN classes c USING(class_id)
  WHERE t.Email = Email AND c.class_id = class) THEN
   SET cmsg = CONCAT_WS(' ','The Class',class,'not assign to',name);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = cmsg;
    END IF;
    ELSEIF class IS NOT NULL AND (section IS NOT NULL OR section <> '') AND (department IS NOT NULL OR department <> '') THEN
         SELECT 
    c.class_name AS Classes, 
    s.section_name Section, 
    d.department_name AS Departments,
    b.book_name AS courses
FROM 
    assign assi
    JOIN class_department_section cds ON assi.class_department_section_id = cds.id
    JOIN classes c ON cds.class_id = c.class_id
    JOIN departments d ON cds.department_id = d.department_id
    JOIN sections s ON cds.section_id = s.section_id
    JOIN book_author ba ON assi.book_author_id = ba.id
    JOIN books b USING(book_id)
    JOIN teachers t USING(teacher_id)
WHERE 
    t.Email = 'HashimThePassionate@gmail.com' AND c.class_id = class AND s.section_name = section AND d.department_name = department
GROUP BY
    c.class_name, 
    s.section_name, 
    d.department_name,
    b.book_name;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `assign`
--

CREATE TABLE `assign` (
  `id` int(11) NOT NULL,
  `class_department_section_id` int(11) NOT NULL,
  `book_author_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `timings_weekday_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assign`
--

INSERT INTO `assign` (`id`, `class_department_section_id`, `book_author_id`, `teacher_id`, `timings_weekday_id`) VALUES
(6, 13, 1, 10, 18),
(1, 20, 1, 10, 4),
(5, 20, 2, 1, 18),
(2, 20, 5, 10, 9),
(3, 20, 6, 10, 13),
(4, 20, 7, 10, 13);

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `author_id` int(11) NOT NULL,
  `author_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`author_id`, `author_name`) VALUES
(1, 'Guido Van Rossum'),
(2, 'Tim Berners-Lee'),
(3, 'Eric A. Meyer'),
(4, 'Rachel Andrew'),
(5, 'Ulf Michael Widenius'),
(6, 'Mark Otto'),
(7, 'Jacob Thornton'),
(8, 'Lawrence Journal'),
(9, 'Brendan Eich'),
(10, 'David flanagan');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `book_id` int(11) NOT NULL,
  `book_name` varchar(100) NOT NULL,
  `Version` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_id`, `book_name`, `Version`) VALUES
(1, 'Python', 'Version 1'),
(2, 'HTML', 'Version 5'),
(3, 'CSS', 'Version 3'),
(4, 'MySql', 'Version 1'),
(5, 'JavaScript', 'Version 1'),
(6, 'BootStrap', 'Version 1'),
(7, 'Django', 'Version 1'),
(8, 'Book 9', 'Version 1'),
(9, 'Book 10', 'Version 1');

-- --------------------------------------------------------

--
-- Table structure for table `book_author`
--

CREATE TABLE `book_author` (
  `id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book_author`
--

INSERT INTO `book_author` (`id`, `book_id`, `author_id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 3, 4),
(5, 4, 5),
(6, 5, 9),
(7, 5, 10);

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `class_id` int(11) NOT NULL,
  `class_name` varchar(100) NOT NULL,
  `total_sections` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`class_id`, `class_name`, `total_sections`) VALUES
(1, 'One', 1),
(2, 'Two', 1),
(3, 'Three', 1),
(4, '4TH', 1),
(5, '5TH', 1),
(6, '6TH', 2),
(7, '7TH', 3),
(8, '8TH', 2),
(9, '9TH', 7),
(10, '10TH', 7);

-- --------------------------------------------------------

--
-- Table structure for table `class_department_section`
--

CREATE TABLE `class_department_section` (
  `id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `class_department_section`
--

INSERT INTO `class_department_section` (`id`, `class_id`, `department_id`, `section_id`) VALUES
(1, 1, 3, 1),
(2, 2, 3, 1),
(3, 3, 3, 1),
(4, 4, 3, 1),
(5, 5, 3, 1),
(6, 6, 3, 1),
(7, 6, 3, 2),
(8, 7, 3, 1),
(9, 7, 3, 2),
(10, 7, 3, 3),
(11, 8, 3, 1),
(12, 8, 3, 2),
(13, 9, 1, 1),
(14, 9, 1, 2),
(15, 9, 1, 3),
(16, 9, 1, 4),
(17, 9, 2, 5),
(18, 9, 2, 6),
(19, 9, 2, 7),
(20, 10, 1, 1),
(21, 10, 1, 2),
(22, 10, 1, 3),
(23, 10, 1, 4),
(24, 10, 2, 5),
(25, 10, 2, 6),
(26, 10, 2, 7);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `department_id` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`department_id`, `department_name`) VALUES
(1, 'Science'),
(2, 'Arts'),
(3, 'No');

-- --------------------------------------------------------

--
-- Table structure for table `principal`
--

CREATE TABLE `principal` (
  `Principal_id` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Qualification` varchar(50) NOT NULL,
  `Phone_number` varchar(20) NOT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  `join_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `principal`
--

INSERT INTO `principal` (`Principal_id`, `Name`, `Email`, `Qualification`, `Phone_number`, `Gender`, `join_date`) VALUES
(1, 'Principal Name', 'principal@example.com', 'Ph.D. in Education', '123-456-7890', 'Male', '2020-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `section_id` int(11) NOT NULL,
  `section_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`section_id`, `section_name`) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E'),
(6, 'F'),
(7, 'G');

-- --------------------------------------------------------

--
-- Stand-in structure for view `sir_hashim`
-- (See below for the actual view)
--
CREATE TABLE `sir_hashim` (
`student_id` int(11)
,`Student Name` varchar(100)
,`Student Email` varchar(100)
,`Teacher` varchar(100)
,`Department` varchar(100)
,`Section` varchar(100)
,`Course` mediumtext
,`days` mediumtext
);

-- --------------------------------------------------------

--
-- Table structure for table `students_admission`
--

CREATE TABLE `students_admission` (
  `Admission_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `date_of_birth` date NOT NULL,
  `address` varchar(50) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `admission_date` date NOT NULL,
  `grade` varchar(2) DEFAULT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students_admission`
--

INSERT INTO `students_admission` (`Admission_id`, `student_id`, `name`, `date_of_birth`, `address`, `phone_number`, `email`, `gender`, `admission_date`, `grade`, `id`) VALUES
(1, 1, 'Shehbaz', '1985-01-01', '123 Main St', '555-5555', 'Shehbaz@gmail.com', 'Male', '2024-02-12', 'A', 20),
(2, 2, 'Abdul Rehman', '2000-01-01', '123 Main St', '555-5555', 'AbdulRehman@gmail.com', 'Male', '2024-02-12', 'A', 20),
(3, 3, 'Arslan', '2000-01-01', '123 Main St', '555-5555', 'Arslan@gmail.com', 'Male', '2024-02-12', 'A', 20),
(4, 4, 'RajaHaider ali', '2000-01-01', '123 Main St', '555-5555', 'RajaHaider@gmail.com', 'Male', '2024-02-12', 'A', 20),
(5, 5, 'Noman Nadeem', '2000-01-01', '123 Main St', '555-5555', 'NomanNadeem@gmail.com', 'Male', '2024-02-12', 'A', 20),
(6, 6, 'Salman Ahmad', '2000-01-01', '123 Main St', '555-5555', 'SalmanAhmad@gmail.com', 'Male', '2024-02-12', 'A', 20),
(7, 7, 'Shaukat', '2000-01-01', '123 Main St', '555-5555', 'shaukat39@gmail.com', 'Male', '2024-02-12', 'A', 20),
(8, 8, 'Asif Ahmad Khan', '2000-01-01', '123 Main St', '555-5555', 'Asif20772@gmail.com', 'Male', '2024-02-12', 'A', 20),
(9, 9, 'Soban Farooq', '2000-01-01', '123 Main St', '555-5555', 'sobiii777@gmail.com', 'Male', '2024-02-12', 'A', 20),
(10, 10, 'Huzaifa Kaleem', '2000-01-01', '123 Main St', '555-5555', 'HuzaifaTheSpirited@gmail.com', 'Male', '2024-02-12', 'A', 20),
(11, 11, 'Hadiya', '2000-01-01', '123 Main St', '555-5555', 'hadiya727@gmail.com', 'Female', '2024-02-12', 'A', 20),
(12, 12, 'Laraib Ishtiaq', '2000-01-01', '123 Main St', '555-5555', 'Laraib7426@gmail.com', 'Female', '2024-02-12', 'A', 20),
(13, 13, 'Zainab Mehboob', '2000-01-01', '123 Main St', '555-5555', 'The_Zealous@gmail.com', 'Female', '2024-02-12', 'A', 20),
(14, 14, 'Umair Hassan', '2000-01-01', '123 Main St', '555-5555', 'oatitude3310@gmail.com', 'Male', '2024-02-12', 'A', 20),
(15, 15, 'Inam Ul Haq', '2000-01-01', '123 Main St', '555-5555', 'cyber-fanatic@gmail.com', 'Male', '2024-02-12', 'A', 20),
(16, 16, 'Hunzilah', '2000-01-01', '123 Main St', '555-5555', 'Hunzilah16@gmail.com', 'Male', '2024-02-12', 'A', 20),
(17, 17, 'Hamza Ahmed', '2000-01-01', '123 Main St', '555-5555', 'DryRunHamza@gmail.com', 'Male', '2024-02-12', 'A', 20),
(18, 18, 'Uzair', '2000-01-01', '123 Main St', '555-5555', 'uzair-py@gmail.com', 'Male', '2024-02-12', 'A', 20),
(19, 1, 'Ahmad', '2005-03-15', '123 Main St', '1234567890', 'ahmad@example.com', 'Male', '2024-04-16', 'A', 13),
(20, 2, 'Fatima', '2006-04-20', '456 Elm St', '2345678901', 'fatima@example.com', 'Female', '2024-04-16', 'A', 13),
(21, 3, 'Muhammad', '2007-05-25', '789 Oak St', '3456789012', 'muhammad@example.com', 'Male', '2024-04-16', 'A', 13),
(22, 4, 'Ayesha', '2008-06-30', '321 Pine St', '4567890123', 'ayesha@example.com', 'Female', '2024-04-16', 'A', 13),
(23, 5, 'Ali', '2009-07-05', '654 Cedar St', '5678901234', 'ali@example.com', 'Male', '2024-04-16', 'A', 13),
(24, 6, 'Zainab', '2010-08-10', '987 Birch St', '6789012345', 'zainab@example.com', 'Female', '2024-04-16', 'A', 13),
(25, 7, 'Mustafa', '2011-09-15', '147 Maple St', '7890123456', 'mustafa@example.com', 'Male', '2024-04-16', 'A', 13),
(26, 8, 'Khadija', '2012-10-20', '258 Walnut St', '8901234567', 'khadija@example.com', 'Female', '2024-04-16', 'A', 13),
(27, 9, 'Hassan', '2013-11-25', '369 Pine St', '9012345678', 'hassan@example.com', 'Male', '2024-04-16', 'A', 13),
(28, 10, 'Amina', '2014-12-30', '741 Oak St', '0123456789', 'amina@example.com', 'Female', '2024-04-16', 'A', 13),
(29, 11, 'Omar', '2005-01-15', '852 Elm St', '1234567890', 'omar@example.com', 'Male', '2024-04-16', 'A', 13),
(30, 12, 'Safiya', '2006-02-20', '963 Cedar St', '2345678901', 'safiya@example.com', 'Female', '2024-04-16', 'A', 13),
(31, 13, 'Bilal', '2007-03-25', '159 Birch St', '3456789012', 'bilal@example.com', 'Male', '2024-04-16', 'B', 13),
(32, 14, 'Aisha', '2008-04-30', '357 Walnut St', '4567890123', 'aisha@example.com', 'Female', '2024-04-16', 'B', 13),
(33, 15, 'Yusuf', '2009-05-05', '468 Pine St', '5678901234', 'yusuf@example.com', 'Male', '2024-04-16', 'B', 13),
(34, 16, 'Sara', '2010-06-10', '579 Oak St', '6789012345', 'sara@example.com', 'Female', '2024-04-16', 'B', 13),
(35, 17, 'Ibrahim', '2011-07-15', '753 Cedar St', '7890123456', 'ibrahim@example.com', 'Male', '2024-04-16', 'B', 13),
(36, 18, 'Zahra', '2012-08-20', '951 Birch St', '8901234567', 'zahra@example.com', 'Female', '2024-04-16', 'B', 13),
(37, 19, 'Hamza', '2013-09-25', '357 Walnut St', '9012345678', 'hamza@example.com', 'Male', '2024-04-16', 'B', 13),
(38, 20, 'Maryam', '2014-10-30', '468 Pine St', '0123456789', 'maryam@example.com', 'Female', '2024-04-16', 'B', 13),
(39, 21, 'Khalid', '2015-11-04', '579 Oak St', '1234567890', 'khalid@example.com', 'Male', '2024-04-16', 'B', 13),
(40, 22, 'Layla', '2016-12-09', '753 Cedar St', '2345678901', 'layla@example.com', 'Female', '2024-04-16', 'B', 13),
(41, 23, 'Amir', '2017-01-14', '951 Birch St', '3456789012', 'amir@example.com', 'Male', '2024-04-16', 'B', 13),
(42, 24, 'Nadia', '2018-02-19', '357 Walnut St', '4567890123', 'nadia@example.com', 'Female', '2024-04-16', 'B', 13),
(43, 25, 'Jamil', '2019-03-24', '468 Pine St', '5678901234', 'jamil@example.com', 'Male', '2024-04-16', 'B', 13);

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone_number` varchar(20) NOT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  `Hire_date` date NOT NULL,
  `Salary` decimal(9,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`teacher_id`, `Name`, `Email`, `Phone_number`, `Gender`, `Hire_date`, `Salary`) VALUES
(1, 'John Doe', 'john.doe@example.com', '1234567890', 'Male', '2022-01-01', 9999.99),
(2, 'Jane Smith', 'jane.smith@example.com', '9876543210', 'Female', '2022-01-02', 9999.99),
(3, 'Michael Johnson', 'michael.johnson@example.com', '5555555555', 'Male', '2022-01-03', 9999.99),
(4, 'Emily Davis', 'emily.davis@example.com', '1111111111', 'Female', '2022-01-04', 9999.99),
(5, 'Robert Brown', 'robert.brown@example.com', '2222222222', 'Male', '2022-01-05', 9999.99),
(6, 'Amanda Wilson', 'amanda.wilson@example.com', '3333333333', 'Female', '2022-01-06', 9999.99),
(7, 'Daniel Martinez', 'daniel.martinez@example.com', '4444444444', 'Male', '2022-01-07', 9999.99),
(8, 'Jessica Lee', 'jessica.lee@example.com', '6666666666', 'Female', '2022-01-08', 9999.99),
(9, 'Christopher Anderson', 'christopher.anderson@example.com', '7777777777', 'Male', '2022-01-09', 9999.99),
(10, 'MUhammad Hashim', 'HashimThePassionate@gmail.com', '+923075239903', 'Male', '2024-02-12', 200000.99);

-- --------------------------------------------------------

--
-- Table structure for table `timings`
--

CREATE TABLE `timings` (
  `timing_id` int(11) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `timings`
--

INSERT INTO `timings` (`timing_id`, `start_time`, `end_time`) VALUES
(1, '08:00:00', '09:00:00'),
(2, '09:00:00', '10:00:00'),
(3, '10:00:00', '11:30:00'),
(4, '11:30:00', '13:30:00'),
(5, '13:30:00', '15:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `timings_weekday`
--

CREATE TABLE `timings_weekday` (
  `id` int(11) NOT NULL,
  `timing_id` int(11) NOT NULL,
  `day_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `timings_weekday`
--

INSERT INTO `timings_weekday` (`id`, `timing_id`, `day_id`) VALUES
(1, 1, 1),
(6, 1, 2),
(10, 1, 3),
(15, 1, 4),
(20, 1, 5),
(2, 2, 1),
(7, 2, 2),
(11, 2, 3),
(16, 2, 4),
(21, 2, 5),
(3, 3, 1),
(8, 3, 2),
(12, 3, 3),
(17, 3, 4),
(22, 3, 5),
(4, 4, 1),
(9, 4, 2),
(13, 4, 3),
(18, 4, 4),
(23, 4, 5),
(5, 5, 1),
(14, 5, 3),
(19, 5, 4),
(24, 5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `vice_principal`
--

CREATE TABLE `vice_principal` (
  `vice_principal_id` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Phone_number` varchar(20) NOT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  `Qualification` varchar(255) DEFAULT NULL,
  `join_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vice_principal`
--

INSERT INTO `vice_principal` (`vice_principal_id`, `Name`, `Email`, `Phone_number`, `Gender`, `Qualification`, `join_date`) VALUES
(1, 'Ahtisham', 'Ahtisham@example.com', '123-456-7890', 'Male', 'MS in Education', '2020-06-01');

-- --------------------------------------------------------

--
-- Table structure for table `weekday`
--

CREATE TABLE `weekday` (
  `day_id` int(11) NOT NULL,
  `day_name` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weekday`
--

INSERT INTO `weekday` (`day_id`, `day_name`, `status`) VALUES
(1, 'Monday', 'Active'),
(2, 'Tuesday', 'Active'),
(3, 'Wednesday', 'Active'),
(4, 'Thursday', 'Active'),
(5, 'Friday', 'Active'),
(6, 'Saturday', 'Off'),
(7, 'Sunday', 'Off');

-- --------------------------------------------------------

--
-- Structure for view `sir_hashim`
--
DROP TABLE IF EXISTS `sir_hashim`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sir_hashim`  AS SELECT `stu`.`student_id` AS `student_id`, `stu`.`name` AS `Student Name`, `stu`.`email` AS `Student Email`, `t`.`Name` AS `Teacher`, `de`.`department_name` AS `Department`, `s`.`section_name` AS `Section`, group_concat(distinct `bo`.`book_name` separator ', ') AS `Course`, group_concat(distinct `wee`.`day_name` separator '/') AS `days` FROM (((((((((`assign` `a` join `class_department_section` `class` on(`a`.`class_department_section_id` = `class`.`id`)) join `sections` `s` on(`class`.`section_id` = `s`.`section_id`)) join `departments` `de` on(`class`.`department_id` = `de`.`department_id`)) join `book_author` `ba` on(`a`.`book_author_id` = `ba`.`id`)) join `books` `bo` on(`ba`.`book_id` = `bo`.`book_id`)) join `teachers` `t` on(`a`.`teacher_id` = `t`.`teacher_id`)) join `timings_weekday` `ti` on(`a`.`timings_weekday_id` = `ti`.`id`)) join `weekday` `wee` on(`ti`.`day_id` = `wee`.`day_id`)) join `students_admission` `stu` on(`a`.`class_department_section_id` = `stu`.`id`)) WHERE `a`.`class_department_section_id` = 20 AND `t`.`Name` = 'MUhammad Hashim' GROUP BY `stu`.`student_id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assign`
--
ALTER TABLE `assign`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `your_custom_name_here` (`class_department_section_id`,`book_author_id`,`teacher_id`,`timings_weekday_id`),
  ADD KEY `book_author_id` (`book_author_id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `timings_weekday_id` (`timings_weekday_id`);

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`author_id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`);

--
-- Indexes for table `book_author`
--
ALTER TABLE `book_author`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_book_author` (`book_id`,`author_id`),
  ADD KEY `book_author_ibfk_2` (`author_id`);

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`class_id`);

--
-- Indexes for table `class_department_section`
--
ALTER TABLE `class_department_section`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_class_department_section` (`class_id`,`department_id`,`section_id`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`);

--
-- Indexes for table `principal`
--
ALTER TABLE `principal`
  ADD PRIMARY KEY (`Principal_id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`section_id`);

--
-- Indexes for table `students_admission`
--
ALTER TABLE `students_admission`
  ADD PRIMARY KEY (`Admission_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`);

--
-- Indexes for table `timings`
--
ALTER TABLE `timings`
  ADD PRIMARY KEY (`timing_id`);

--
-- Indexes for table `timings_weekday`
--
ALTER TABLE `timings_weekday`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_timing_day` (`timing_id`,`day_id`),
  ADD KEY `day_id` (`day_id`);

--
-- Indexes for table `vice_principal`
--
ALTER TABLE `vice_principal`
  ADD PRIMARY KEY (`vice_principal_id`);

--
-- Indexes for table `weekday`
--
ALTER TABLE `weekday`
  ADD PRIMARY KEY (`day_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assign`
--
ALTER TABLE `assign`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `author`
--
ALTER TABLE `author`
  MODIFY `author_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `book_author`
--
ALTER TABLE `book_author`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `class_department_section`
--
ALTER TABLE `class_department_section`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `principal`
--
ALTER TABLE `principal`
  MODIFY `Principal_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `section_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `students_admission`
--
ALTER TABLE `students_admission`
  MODIFY `Admission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `timings`
--
ALTER TABLE `timings`
  MODIFY `timing_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `timings_weekday`
--
ALTER TABLE `timings_weekday`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `vice_principal`
--
ALTER TABLE `vice_principal`
  MODIFY `vice_principal_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `weekday`
--
ALTER TABLE `weekday`
  MODIFY `day_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assign`
--
ALTER TABLE `assign`
  ADD CONSTRAINT `assign_ibfk_1` FOREIGN KEY (`class_department_section_id`) REFERENCES `class_department_section` (`id`),
  ADD CONSTRAINT `assign_ibfk_2` FOREIGN KEY (`book_author_id`) REFERENCES `book_author` (`id`),
  ADD CONSTRAINT `assign_ibfk_3` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`),
  ADD CONSTRAINT `assign_ibfk_4` FOREIGN KEY (`timings_weekday_id`) REFERENCES `timings_weekday` (`id`);

--
-- Constraints for table `book_author`
--
ALTER TABLE `book_author`
  ADD CONSTRAINT `book_author_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `book_author_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `author` (`author_id`) ON UPDATE CASCADE;

--
-- Constraints for table `class_department_section`
--
ALTER TABLE `class_department_section`
  ADD CONSTRAINT `class_department_section_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`),
  ADD CONSTRAINT `class_department_section_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`),
  ADD CONSTRAINT `class_department_section_ibfk_3` FOREIGN KEY (`section_id`) REFERENCES `sections` (`section_id`);

--
-- Constraints for table `students_admission`
--
ALTER TABLE `students_admission`
  ADD CONSTRAINT `students_admission_ibfk_1` FOREIGN KEY (`id`) REFERENCES `class_department_section` (`id`);

--
-- Constraints for table `timings_weekday`
--
ALTER TABLE `timings_weekday`
  ADD CONSTRAINT `timings_weekday_ibfk_1` FOREIGN KEY (`timing_id`) REFERENCES `timings` (`timing_id`),
  ADD CONSTRAINT `timings_weekday_ibfk_2` FOREIGN KEY (`day_id`) REFERENCES `weekday` (`day_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
