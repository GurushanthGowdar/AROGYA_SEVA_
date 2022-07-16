-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jan 20, 2022 at 06:35 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `arogya_seva`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `doctorroutine`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `doctorroutine` ()  SELECT * from doctor
        GROUP By email
        order by ddept ASC$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
CREATE TABLE IF NOT EXISTS `doctor` (
  `doctorid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(40) NOT NULL,
  `dname` varchar(40) NOT NULL,
  `dlname` varchar(40) NOT NULL,
  `doctor_gender` varchar(40) NOT NULL,
  `ddept` varchar(40) NOT NULL,
  `dphno` varchar(40) NOT NULL,
  PRIMARY KEY (`doctorid`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

--
-- RELATIONSHIPS FOR TABLE `doctor`:
--   `email`
--       `user` -> `email`
--

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`doctorid`, `email`, `dname`, `dlname`, `doctor_gender`, `ddept`, `dphno`) VALUES
(2, 'mahadeva@gmail.com', 'Mahadev', 'Raghuvamshi', 'Male', 'cardiologist', '9852963941'),
(4, 'Lakshman@gmail.com', 'Lakshman', 'Sharma', 'Male', 'Dermatologists', '9875236415');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
CREATE TABLE IF NOT EXISTS `patients` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `fname` varchar(50) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `slot` varchar(50) NOT NULL,
  `disease` varchar(50) NOT NULL,
  `time` time(6) NOT NULL,
  `date` date NOT NULL,
  `dept` varchar(50) NOT NULL,
  `phno` varchar(50) NOT NULL,
  `lname` varchar(50) NOT NULL,
  PRIMARY KEY (`pid`),
  KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;

--
-- RELATIONSHIPS FOR TABLE `patients`:
--   `email`
--       `user` -> `email`
--

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`pid`, `email`, `fname`, `gender`, `slot`, `disease`, `time`, `date`, `dept`, `phno`, `lname`) VALUES
(16, 'Lakshman@gmail.com', 'Lakshman', 'Male', 'morning', 'Regular Heart Checkup', '08:20:00.000000', '2022-02-01', 'cardiologist', '9875296341', 'Sharma'),
(17, 'guru22ca@gmail.com', 'guru', 'Male', 'evening', 'Skin Allergy', '08:00:00.000000', '2022-02-02', 'cardiologist', '9852147525', 'Sharma');

--
-- Triggers `patients`
--
DROP TRIGGER IF EXISTS `patientdeleted`;
DELIMITER $$
CREATE TRIGGER `patientdeleted` BEFORE DELETE ON `patients` FOR EACH ROW INSERT INTO triger VALUES(null,OLD.pid,OLD.email,OLD.fname,OLD.dept,'PATIENT DELETED',NOW())
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `patientinsertion`;
DELIMITER $$
CREATE TRIGGER `patientinsertion` AFTER INSERT ON `patients` FOR EACH ROW INSERT INTO triger VALUES(null,NEW.pid,NEW.email,NEW.fname,NEW.dept,'PATIENT INSERTED',NOW())
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `patientupdated`;
DELIMITER $$
CREATE TRIGGER `patientupdated` AFTER UPDATE ON `patients` FOR EACH ROW INSERT INTO triger VALUES(null,NEW.pid,NEW.email,NEW.fname,NEW.dept,'PATIENT UPDATED',NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
CREATE TABLE IF NOT EXISTS `test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- RELATIONSHIPS FOR TABLE `test`:
--

-- --------------------------------------------------------

--
-- Table structure for table `triger`
--

DROP TABLE IF EXISTS `triger`;
CREATE TABLE IF NOT EXISTS `triger` (
  `trigerID` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `email` varchar(40) NOT NULL,
  `fname` varchar(40) NOT NULL,
  `dept` varchar(40) NOT NULL,
  `action` varchar(40) NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY (`trigerID`),
  KEY `triger_ibfk_1` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;

--
-- RELATIONSHIPS FOR TABLE `triger`:
--   `email`
--       `user` -> `email`
--

--
-- Dumping data for table `triger`
--

INSERT INTO `triger` (`trigerID`, `pid`, `email`, `fname`, `dept`, `action`, `timestamp`) VALUES
(10, 13, 'mahadeva@gmail.com', 'Mahadeva', 'Select Doctor Department', 'PATIENT INSERTED', '2022-01-19 19:29:46'),
(11, 14, 'mahadeva@gmail.com', 'guru', 'cardiologist', 'PATIENT INSERTED', '2022-01-19 19:55:23'),
(12, 14, 'mahadeva@gmail.com', 'guru', 'cardiologist', 'PATIENT DELETED', '2022-01-19 19:55:32'),
(13, 13, 'mahadeva@gmail.com', 'Mahadeva', 'Select Doctor Department', 'PATIENT UPDATED', '2022-01-19 20:12:28'),
(14, 13, 'mahadeva@gmail.com', 'Mahadeva', 'Select Doctor Department', 'PATIENT DELETED', '2022-01-19 20:12:48'),
(15, 15, 'mahadeva@gmail.com', 'zc', 'cardiologist', 'PATIENT INSERTED', '2022-01-19 20:13:40'),
(16, 15, 'mahadeva@gmail.com', 'zc', 'cardiologist', 'PATIENT DELETED', '2022-01-19 20:13:49'),
(17, 16, 'Lakshman@gmail.com', 'Lakshman', 'cardiologist', 'PATIENT INSERTED', '2022-01-19 20:19:58'),
(18, 17, 'guru22ca@gmail.com', 'guru', 'cardiologist', 'PATIENT INSERTED', '2022-01-20 00:02:28');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  `password` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

--
-- RELATIONSHIPS FOR TABLE `user`:
--

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password`) VALUES
(8, 'guru', 'guru22ca@gmail.com', 'pbkdf2:sha256:260000$siPAoyMqnUCEXgHl$a6cbdc72fd5419710fbba56c652f7b048ce5b91625786966538e58dc5720c482'),
(9, 'mahadeva', 'mahadeva@gmail.com', 'pbkdf2:sha256:260000$xb9gSHLcWEBdMaqA$21c5bf24aa41c834bfeb1e456423ab8c8837188c7fd4bfd5524094272619b706'),
(10, 'Lakshman', 'Lakshman@gmail.com', 'pbkdf2:sha256:260000$VU4OWGnr27DsVgRp$35dc31ae6ee9a4169e9ec9e5a6f54493196cfb2c242778c800a22255fdd16aec');

-- --------------------------------------------------------

--
-- Table structure for table `vaccine`
--

DROP TABLE IF EXISTS `vaccine`;
CREATE TABLE IF NOT EXISTS `vaccine` (
  `vid` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(40) NOT NULL,
  `fname` varchar(40) NOT NULL,
  `lname` varchar(40) NOT NULL,
  `gender` varchar(40) NOT NULL,
  `vaccine` varchar(40) NOT NULL,
  `dose` varchar(40) NOT NULL,
  `age` varchar(40) NOT NULL,
  `slot` varchar(40) NOT NULL,
  `time` time(6) NOT NULL,
  `date` date NOT NULL,
  `phno` varchar(40) NOT NULL,
  PRIMARY KEY (`vid`),
  KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

--
-- RELATIONSHIPS FOR TABLE `vaccine`:
--   `email`
--       `user` -> `email`
--

--
-- Dumping data for table `vaccine`
--

INSERT INTO `vaccine` (`vid`, `email`, `fname`, `lname`, `gender`, `vaccine`, `dose`, `age`, `slot`, `time`, `date`, `phno`) VALUES
(7, 'mahadeva@gmail.com', 'guru', 'gowdar', 'Male', 'covaxin', 'dose1', '20', 'morning', '08:00:00.000000', '2022-02-01', '7894561234'),
(8, 'mahadeva@gmail.com', 'guru', 'gowdar', 'Male', 'covaxin', 'dose1', '20', 'evening', '04:00:00.000000', '2022-02-22', '9852985264'),
(9, 'Lakshman@gmail.com', 'Lakshman', 'Kishore', 'Male', 'covishield', 'dose1', '20', 'morning', '08:00:00.000000', '2022-02-02', '987523614');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `doctor`
--
ALTER TABLE `doctor`
  ADD CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`email`) REFERENCES `user` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`email`) REFERENCES `user` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `triger`
--
ALTER TABLE `triger`
  ADD CONSTRAINT `triger_ibfk_1` FOREIGN KEY (`email`) REFERENCES `user` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `vaccine`
--
ALTER TABLE `vaccine`
  ADD CONSTRAINT `vaccine_ibfk_1` FOREIGN KEY (`email`) REFERENCES `user` (`email`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
