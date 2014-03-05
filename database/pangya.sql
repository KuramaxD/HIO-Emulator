/*
MySQL Data Transfer
Source Host: localhost
Source Database: pangya
Target Host: localhost
Target Database: pangya
Date: 5/3/2014 12:59:29
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for py_caddies
-- ----------------------------
CREATE TABLE `py_caddies` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `caddieid` int(11) NOT NULL,
  `dias` int(11) NOT NULL DEFAULT '0',
  `exp` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `payday` int(11) NOT NULL DEFAULT '0',
  `skin` int(11) NOT NULL DEFAULT '0',
  `tempo` int(11) DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_calendario
-- ----------------------------
CREATE TABLE `py_calendario` (
  `data` date NOT NULL,
  `item` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`data`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_chars
-- ----------------------------
CREATE TABLE `py_chars` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `personagem` int(11) NOT NULL,
  `cabelo` int(11) NOT NULL,
  `equip1` int(11) DEFAULT NULL,
  `equip2` int(11) DEFAULT NULL,
  `equip3` int(11) DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_config
-- ----------------------------
CREATE TABLE `py_config` (
  `versao` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_itens
-- ----------------------------
CREATE TABLE `py_itens` (
  `idi` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `itemid` int(11) NOT NULL,
  `pwr` int(11) NOT NULL DEFAULT '0',
  `ctr` int(11) NOT NULL DEFAULT '0',
  `acu` int(11) NOT NULL DEFAULT '0',
  `spn` int(11) NOT NULL DEFAULT '0',
  `crv` int(11) NOT NULL DEFAULT '0',
  `maxpwr` int(11) NOT NULL DEFAULT '0',
  `maxctr` int(11) NOT NULL DEFAULT '0',
  `maxacu` int(11) NOT NULL DEFAULT '0',
  `maxspn` int(11) NOT NULL DEFAULT '0',
  `maxcrv` int(11) NOT NULL DEFAULT '0',
  `quantidade` int(11) NOT NULL DEFAULT '1',
  `tempo` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idi`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_macros
-- ----------------------------
CREATE TABLE `py_macros` (
  `uid` int(11) NOT NULL,
  `macro1` varchar(64) DEFAULT NULL,
  `macro2` varchar(64) DEFAULT NULL,
  `macro3` varchar(64) DEFAULT NULL,
  `macro4` varchar(64) DEFAULT NULL,
  `macro5` varchar(64) DEFAULT NULL,
  `macro6` varchar(64) DEFAULT NULL,
  `macro7` varchar(64) DEFAULT NULL,
  `macro8` varchar(64) DEFAULT NULL,
  `macro9` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_mail
-- ----------------------------
CREATE TABLE `py_mail` (
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `de` varchar(20) NOT NULL,
  `para` varchar(20) NOT NULL,
  `itemid` int(11) NOT NULL,
  `mensagem` int(11) NOT NULL,
  PRIMARY KEY (`mid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_mascots
-- ----------------------------
CREATE TABLE `py_mascots` (
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `mascoteid` int(11) NOT NULL,
  `tempo` timestamp NULL DEFAULT NULL,
  `mensagem` varchar(30) DEFAULT 'Pangya!',
  `dias` int(11) DEFAULT NULL,
  PRIMARY KEY (`mid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_members
-- ----------------------------
CREATE TABLE `py_members` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(16) NOT NULL,
  `senha` varchar(32) NOT NULL,
  `banido` tinyint(1) NOT NULL DEFAULT '0',
  `firstset` tinyint(1) NOT NULL DEFAULT '0',
  `nick` varchar(16) DEFAULT NULL,
  `loginstatus` tinyint(1) DEFAULT '0',
  `gamestatus` tinyint(1) DEFAULT '0',
  `codigo1` varchar(7) NOT NULL,
  `codigo2` varchar(7) NOT NULL,
  `personagemselecionado` int(11) DEFAULT NULL,
  `taco` int(11) NOT NULL,
  `bola` int(11) NOT NULL,
  `calendario` tinyint(1) DEFAULT '0',
  `diasmarcados` int(11) DEFAULT '0',
  `cookies` int(11) DEFAULT '0',
  `gm` tinyint(1) DEFAULT '0',
  `mascote` int(11) DEFAULT NULL,
  `caddie` int(11) DEFAULT NULL,
  `pangs` int(11) DEFAULT '0',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_mochila
-- ----------------------------
CREATE TABLE `py_mochila` (
  `uid` int(11) NOT NULL,
  `item1` int(11) DEFAULT NULL,
  `item2` int(11) DEFAULT NULL,
  `item3` int(11) DEFAULT NULL,
  `item4` int(11) DEFAULT NULL,
  `item5` int(11) DEFAULT NULL,
  `item6` int(11) DEFAULT NULL,
  `item7` int(11) DEFAULT NULL,
  `item8` int(11) DEFAULT NULL,
  `item9` int(11) DEFAULT NULL,
  `item10` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for py_servers
-- ----------------------------
CREATE TABLE `py_servers` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `ip` varchar(16) NOT NULL,
  `porta` int(5) NOT NULL,
  `icone` int(4) NOT NULL,
  `icone_evento` int(4) DEFAULT '0',
  `usuariosonline` int(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records 
-- ----------------------------
