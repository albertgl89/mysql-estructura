-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `spotify` ;

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8 ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`artistes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`artistes` ;

CREATE TABLE IF NOT EXISTS `spotify`.`artistes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(60) NOT NULL,
  `imatge` VARCHAR(250) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`album` ;

CREATE TABLE IF NOT EXISTS `spotify`.`album` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NOT NULL,
  `any` INT(4) NOT NULL,
  `portada` VARCHAR(250) NOT NULL,
  `artista` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_ALARTISTA_idx` (`artista` ASC) ,
  CONSTRAINT `FK_ALARTISTA`
    FOREIGN KEY (`artista`)
    REFERENCES `spotify`.`artistes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`usuaris`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`usuaris` ;

CREATE TABLE IF NOT EXISTS `spotify`.`usuaris` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(80) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `nom_usuari` VARCHAR(45) NOT NULL,
  `data_naixement` DATE NOT NULL,
  `sexe` SET('masculi', 'femeni', 'altres') NOT NULL,
  `codi_postal` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`albums_favorits`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`albums_favorits` ;

CREATE TABLE IF NOT EXISTS `spotify`.`albums_favorits` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuari` INT(11) NOT NULL,
  `album` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_AFUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_AFALBUM_idx` (`album` ASC) ,
  CONSTRAINT `FK_AFALBUM`
    FOREIGN KEY (`album`)
    REFERENCES `spotify`.`album` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_AFUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`artistes_relacionats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`artistes_relacionats` ;

CREATE TABLE IF NOT EXISTS `spotify`.`artistes_relacionats` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `artista1` INT(11) NOT NULL,
  `artista2` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_ARTSEG1_idx` (`artista1` ASC) ,
  INDEX `FK_ARTSEG1_idx1` (`artista2` ASC) ,
  CONSTRAINT `FK_ARTSEG1`
    FOREIGN KEY (`artista1`)
    REFERENCES `spotify`.`artistes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ARTSEG2`
    FOREIGN KEY (`artista2`)
    REFERENCES `spotify`.`artistes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`cancons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`cancons` ;

CREATE TABLE IF NOT EXISTS `spotify`.`cancons` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NOT NULL,
  `durada` TIME NOT NULL,
  `reproduccions` BIGINT(20) NOT NULL,
  `album` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_CALBUM_idx` (`album` ASC) ,
  CONSTRAINT `FK_CALBUM`
    FOREIGN KEY (`album`)
    REFERENCES `spotify`.`album` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`cancons_favorites`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`cancons_favorites` ;

CREATE TABLE IF NOT EXISTS `spotify`.`cancons_favorites` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuari` INT(11) NOT NULL,
  `canco` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_CFUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_CFCANCO_idx` (`canco` ASC) ,
  CONSTRAINT `FK_CFCANCO`
    FOREIGN KEY (`canco`)
    REFERENCES `spotify`.`cancons` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_CFUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`u_premium`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`u_premium` ;

CREATE TABLE IF NOT EXISTS `spotify`.`u_premium` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuari` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_UPREMIUM_idx` (`usuari` ASC) ,
  CONSTRAINT `FK_UPREMIUM`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`subscripcions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`subscripcions` ;

CREATE TABLE IF NOT EXISTS `spotify`.`subscripcions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `data_inici` DATE NOT NULL,
  `data_renovacio` DATE NOT NULL,
  `forma_pagament` SET('paypal', 'targetes_credit') NOT NULL,
  `usuari` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_SUSUARI_idx` (`usuari` ASC) ,
  CONSTRAINT `FK_SUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`u_premium` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`pagaments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`pagaments` ;

CREATE TABLE IF NOT EXISTS `spotify`.`pagaments` (
  `num_ordre` INT(11) NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  `total` DECIMAL(4,2) NOT NULL,
  `subscripcio` INT(11) NOT NULL,
  PRIMARY KEY (`num_ordre`),
  INDEX `FK_PSUBSCRIPCIO_idx` (`subscripcio` ASC) ,
  CONSTRAINT `FK_PSUBSCRIPCIO`
    FOREIGN KEY (`subscripcio`)
    REFERENCES `spotify`.`subscripcions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`paypal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`paypal` ;

CREATE TABLE IF NOT EXISTS `spotify`.`paypal` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `paypal_user` VARCHAR(80) NOT NULL,
  `usuari` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_PPUSUARI_idx` (`usuari` ASC) ,
  CONSTRAINT `FK_PPUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`u_premium` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`playlists_eliminades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`playlists_eliminades` ;

CREATE TABLE IF NOT EXISTS `spotify`.`playlists_eliminades` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `data` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`playlists`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`playlists` ;

CREATE TABLE IF NOT EXISTS `spotify`.`playlists` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NOT NULL,
  `num_cancons` INT(11) NOT NULL,
  `data_creacio` DATE NOT NULL,
  `eliminada` INT(11) NULL DEFAULT NULL,
  `usuari` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_PLUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_ELIMINADA_idx` (`eliminada` ASC) ,
  CONSTRAINT `FK_ELIMINADA`
    FOREIGN KEY (`eliminada`)
    REFERENCES `spotify`.`playlists_eliminades` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PLUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`playlists_compartides`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`playlists_compartides` ;

CREATE TABLE IF NOT EXISTS `spotify`.`playlists_compartides` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `playlist` INT(11) NOT NULL,
  `usuari` INT(11) NOT NULL,
  `data_addicio` DATE NOT NULL,
  `canco` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_PCPLAYLIST_idx` (`playlist` ASC) ,
  INDEX `FK_PCUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_PCCANCO_idx` (`canco` ASC) ,
  CONSTRAINT `FK_PCCANCO`
    FOREIGN KEY (`canco`)
    REFERENCES `spotify`.`cancons` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PCPLAYLIST`
    FOREIGN KEY (`playlist`)
    REFERENCES `spotify`.`playlists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PCUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`targetes_credit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`targetes_credit` ;

CREATE TABLE IF NOT EXISTS `spotify`.`targetes_credit` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(30) NOT NULL,
  `mes_any_cad` VARCHAR(7) NOT NULL,
  `codi_seg` INT(5) NOT NULL,
  `usuari` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_TCUSUARI_idx` (`usuari` ASC) ,
  CONSTRAINT `FK_TCUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`u_premium` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`u_free`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`u_free` ;

CREATE TABLE IF NOT EXISTS `spotify`.`u_free` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuari` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_UFREE_idx` (`usuari` ASC) ,
  CONSTRAINT `FK_UFREE`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `spotify`.`usuari_segueix_artista`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `spotify`.`usuari_segueix_artista` ;

CREATE TABLE IF NOT EXISTS `spotify`.`usuari_segueix_artista` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuari` INT(11) NOT NULL,
  `artista_seguit` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_SUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_ARTSEGUIT_idx` (`artista_seguit` ASC) ,
  CONSTRAINT `FK_ARTSEGUIT`
    FOREIGN KEY (`artista_seguit`)
    REFERENCES `spotify`.`artistes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_SEGUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `spotify`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
