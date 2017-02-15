SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP DATABASE IF EXISTS citadel;
CREATE DATABASE citadel;
USE citadel;

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `firstseen` datetime NOT NULL,
  `lastseen` datetime NOT NULL,
  `ip` varchar(18) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `lastadminrank` varchar(32) NOT NULL DEFAULT 'Player',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `slot` int(2) NOT NULL,
  `metadata` mediumtext NOT NULL,
  `real_name` varchar(45) NOT NULL,
  `be_random_name` tinyint(1) NOT NULL,
  `be_random_body` tinyint(1) NOT NULL,
  `gender` varchar(11) NOT NULL,
  `age` smallint(4) NOT NULL,
  `pref_species` varchar(45) NOT NULL,
  `features` varchar(512) NOT NULL,
  `custom_names` varchar(255) NOT NULL,
  `hair_style` varchar(45) NOT NULL,
  `facial_hair_style` varchar(45) NOT NULL,
  `skin_tone` smallint(4) NOT NULL,
  `facial_hair_color` varchar(255) NOT NULL,
  `eye_color` smallint(4) NOT NULL,
  `hair_color` smallint(4) NOT NULL,
  `socks` mediumtext NOT NULL,
  `underwear` mediumtext NOT NULL,
  `undershirt` mediumtext NOT NULL,
  `backbag` varchar(16) NOT NULL,
  `joblessrole` varchar(16) NOT NULL,
  `job_civilian_high` mediumint(8) NOT NULL,
  `job_civilian_med` mediumint(8) NOT NULL,
  `job_civilian_low` mediumint(8) NOT NULL,
  `job_medsci_high` mediumint(8) NOT NULL,
  `job_medsci_med` mediumint(8) NOT NULL,
  `job_medsci_low` mediumint(8) NOT NULL,
  `job_engsec_high` mediumint(8) NOT NULL,
  `job_engsec_med` mediumint(8) NOT NULL,
  `job_engsec_low` mediumint(8) NOT NULL,
  `flavor_text` mediumtext NOT NULL,
  `prefered_security_department` varchar(64) NOT NULL,
  `belly_prefs` mediumtext NOT NULL,
  `devourable` tinyint(1) NOT NULL,
  `digestable` tinyint(1) NOT NULL,
  `size_scale` tinyint(1) NOT NULL,
  `default_slot` smallint(2) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `rank` varchar(32) NOT NULL DEFAULT 'Administrator',
  `level` int(2) NOT NULL DEFAULT '0',
  `flags` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `admin_log`;
CREATE TABLE `admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `adminckey` varchar(32) NOT NULL,
  `adminip` varchar(18) NOT NULL,
  `log` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `admin_ranks`;
CREATE TABLE `admin_ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank` varchar(40) NOT NULL,
  `flags` int(16) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into admin_ranks (rank, flags) values ('Moderator',2);
insert into admin_ranks (rank, flags) values ('Admin Candidate',2);
insert into admin_ranks (rank, flags) values ('Trial Admin',5638);
insert into admin_ranks (rank, flags) values ('Badmin',5727);
insert into admin_ranks (rank, flags) values ('Game Admin',8063);
insert into admin_ranks (rank, flags) values ('Game Master',65535);
insert into admin_ranks (rank, flags) values ('Host',65535);
insert into admin_ranks (rank, flags) values ('Coder',5168);

DROP TABLE IF EXISTS `ban`;
CREATE TABLE `ban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bantime` datetime NOT NULL,
  `serverip` varchar(32) NOT NULL,
  `bantype` varchar(32) NOT NULL,
  `reason` text NOT NULL,
  `job` varchar(32) DEFAULT NULL,
  `duration` int(11) NOT NULL,
  `rounds` int(11) DEFAULT NULL,
  `expiration_time` datetime NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `computerid` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `a_ckey` varchar(32) NOT NULL,
  `a_computerid` varchar(32) NOT NULL,
  `a_ip` varchar(32) NOT NULL,
  `who` text NOT NULL,
  `adminwho` text NOT NULL,
  `edits` text,
  `unbanned` tinyint(1) DEFAULT NULL,
  `unbanned_datetime` datetime DEFAULT NULL,
  `unbanned_ckey` varchar(32) DEFAULT NULL,
  `unbanned_computerid` varchar(32) DEFAULT NULL,
  `unbanned_ip` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `connection_log`;
CREATE TABLE `connection_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime DEFAULT NULL,
  `serverip` varchar(45) DEFAULT NULL,
  `ckey` varchar(45) DEFAULT NULL,
  `ip` varchar(18) DEFAULT NULL,
  `computerid` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `customuseritems`;
CREATE TABLE `customuseritems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cuiCKey` varchar(36) NOT NULL,
  `cuiRealName` varchar(60) NOT NULL,
  `cuiPath` varchar(255) NOT NULL,
  `cuiItemName` text,
  `cuiDescription` text,
  `cuiReason` text,
  `cuiPropAdjust` text,
  `cuiJobMask` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `death`;
CREATE TABLE `death` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pod` text NOT NULL COMMENT 'Place of death',
  `coord` text NOT NULL COMMENT 'X, Y, Z POD',
  `mapname` text NOT NULL,
  `server` text NOT NULL,
  `tod` datetime NOT NULL COMMENT 'Time of death',
  `job` text NOT NULL,
  `special` text NOT NULL,
  `name` text NOT NULL,
  `byondkey` text NOT NULL,
  `laname` text NOT NULL COMMENT 'Last attacker name',
  `lakey` text NOT NULL COMMENT 'Last attacker key',
  `gender` text NOT NULL,
  `bruteloss` int(11) NOT NULL,
  `brainloss` int(11) NOT NULL,
  `fireloss` int(11) NOT NULL,
  `oxyloss` int(11) NOT NULL,
  `arousalloss` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `donators`;
CREATE TABLE `donators` (
  `patreon_name` varchar(32) NOT NULL,
  `ckey` varchar(32) DEFAULT NULL COMMENT 'Manual Field',
  `start_date` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` datetime NOT NULL,
  `round_id` int(8) NOT NULL,
  `var_name` varchar(32) NOT NULL,
  `var_value` int(16) DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ipintel`;
CREATE TABLE `ipintel` (
`ip` INT UNSIGNED NOT NULL ,
`date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL ,
`intel` REAL NOT NULL DEFAULT  '0',
PRIMARY KEY (  `ip` )
) ENGINE = INNODB;

DROP TABLE IF EXISTS `legacy_population`;
CREATE TABLE `legacy_population` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playercount` int(11) DEFAULT NULL,
  `admincount` int(11) DEFAULT NULL,
  `time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `library`;
CREATE TABLE `library` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(45) NOT NULL,
  `title` varchar(45) NOT NULL,
  `content` text NOT NULL,
  `category` varchar(45) NOT NULL,
  `ckey` varchar(45) DEFAULT 'LEGACY',
  `datetime` datetime DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT ,
  `type` varchar(32) NOT NULL ,
  `targetckey` varchar(32) NOT NULL ,
  `adminckey` varchar(32) NOT NULL ,
  `text` text NOT NULL ,
  `timestamp` datetime NOT NULL ,
  `server` varchar(32) NULL ,
  `secret` tinyint(1) NULL DEFAULT 1 ,
  `lasteditor` varchar(32) NULL ,
  `edits` text NULL ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mentor`;
CREATE TABLE `mentor` (
  `ckey` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `mentor_memo`;
CREATE TABLE `mentor_memo` (
  `ckey` varchar(32) NOT NULL,
  `memotext` text NOT NULL,
  `timestamp` datetime NOT NULL,
  `last_editor` varchar(32) DEFAULT NULL,
  `edits` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `poll_option`;
CREATE TABLE `poll_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pollid` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `percentagecalc` tinyint(1) NOT NULL DEFAULT '1',
  `minval` int(3) DEFAULT NULL,
  `maxval` int(3) DEFAULT NULL,
  `descmin` varchar(32) DEFAULT NULL,
  `descmid` varchar(32) DEFAULT NULL,
  `descmax` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `poll_question`;
CREATE TABLE `poll_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `polltype` varchar(16) NOT NULL DEFAULT 'OPTION',
  `starttime` datetime NOT NULL,
  `endtime` datetime NOT NULL,
  `question` varchar(255) NOT NULL,
  `adminonly` tinyint(1) DEFAULT '0',
  `multiplechoiceoptions` int(2) DEFAULT NULL,
  `createdby_ckey` varchar(45) NULL DEFAULT NULL,
  `createdby_ip` varchar(45) NULL DEFAULT NULL,
  `for_trialmin` varchar(45) NULL DEFAULT NULL,
  `dontshow` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `poll_textreply`;
CREATE TABLE `poll_textreply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `ckey` varchar(32) NOT NULL,
  `ip` varchar(18) NOT NULL,
  `replytext` text NOT NULL,
  `adminrank` varchar(32) NOT NULL DEFAULT 'Player',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `poll_vote`;
CREATE TABLE `poll_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `pollid` int(11) NOT NULL,
  `optionid` int(11) NOT NULL,
  `ckey` varchar(255) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `adminrank` varchar(32) NOT NULL,
  `rating` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `preferences`;
CREATE TABLE `preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ckey` varchar(32) NOT NULL,
  `ooccolor` varchar(7) DEFAULT '#b82e00',
  `UI_style` varchar(10) DEFAULT 'Midnight',
  `hotkeys` smallint(1) NOT NULL,
  `tgui_fancy` smallint(1) DEFAULT '1',
  `be_special` mediumtext NOT NULL,
  `chat_toggles` varchar(64) NOT NULL,
  `toggles` mediumint(8) DEFAULT '383',
  `ghost_orbit` varchar(25) NOT NULL,
  `ghost_form` varchar(20) NOT NULL,
  `ghost_accs` varchar(20) NOT NULL,
  `ghost_others` varchar(20) NOT NULL,
  `preferred_map` varchar(20) NOT NULL,
  `ignoring` varchar(20) NOT NULL,
  `ghost_hud` smallint(1) DEFAULT '1',
  `inquisitive_ghost` smallint(1) DEFAULT '1',
  `uses_glasses_colour` smallint(1) DEFAULT '1',
  `clientfps` smallint(4) NOT NULL,
  `parallax` varchar(16) NOT NULL,
  `uplink_spawn_loc` smallint(4) NOT NULL,
  `arousable` smallint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ckey` (`ckey`)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
