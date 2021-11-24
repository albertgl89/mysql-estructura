-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `optica` ;

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8 ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`adreces`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`adreces` ;

CREATE TABLE IF NOT EXISTS `optica`.`adreces` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `carrer` VARCHAR(60) NOT NULL,
  `numero` VARCHAR(10) NOT NULL,
  `pis` VARCHAR(10) NULL,
  `porta` VARCHAR(10) NULL,
  `ciutat` VARCHAR(60) NOT NULL,
  `codi_postal` VARCHAR(10) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`proveidors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`proveidors` ;

CREATE TABLE IF NOT EXISTS `optica`.`proveidors` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `adreca` INT NOT NULL,
  `telefon` INT NOT NULL,
  `fax` INT NULL,
  `nif` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) ,
  INDEX `FK_PROVADRECA_idx` (`adreca` ASC) ,
  CONSTRAINT `FK_PROVADRECA`
    FOREIGN KEY (`adreca`)
    REFERENCES `optica`.`adreces` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`clients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`clients` ;

CREATE TABLE IF NOT EXISTS `optica`.`clients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) NOT NULL,
  `adreca` INT NOT NULL,
  `telefon` VARCHAR(20) NOT NULL,
  `email` VARCHAR(120) NOT NULL,
  `registrat` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_CLADRECA_idx` (`adreca` ASC) ,
  CONSTRAINT `FK_CLADRECA`
    FOREIGN KEY (`adreca`)
    REFERENCES `optica`.`adreces` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`marques`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`marques` ;

CREATE TABLE IF NOT EXISTS `optica`.`marques` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `marca` VARCHAR(45) NOT NULL,
  `proveidor` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `marca_UNIQUE` (`marca` ASC) ,
  INDEX `FK_MARPROVEIDOR_idx` (`proveidor` ASC) ,
  CONSTRAINT `FK_MARPROVEIDOR`
    FOREIGN KEY (`proveidor`)
    REFERENCES `optica`.`proveidors` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`ulleres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`ulleres` ;

CREATE TABLE IF NOT EXISTS `optica`.`ulleres` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `marca` INT NOT NULL,
  `grad_esq` DECIMAL(4,2) NOT NULL,
  `grad_dreta` DECIMAL(4,2) NOT NULL,
  `muntura` SET('flotant', 'pasta', 'metàl·lica') NOT NULL,
  `color` VARCHAR(45) NOT NULL,
  `color_vidres` VARCHAR(45) NOT NULL,
  `preu` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_ULMARQUES_idx` (`marca` ASC) ,
  CONSTRAINT `FK_ULMARQUES`
    FOREIGN KEY (`marca`)
    REFERENCES `optica`.`marques` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`recomanacions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`recomanacions` ;

CREATE TABLE IF NOT EXISTS `optica`.`recomanacions` (
  `client` INT NOT NULL,
  `recomanat_per` INT NOT NULL,
  PRIMARY KEY (`client`),
  INDEX `FK_RECRECOMANAT_idx` (`recomanat_per` ASC) ,
  CONSTRAINT `FK_RECCLIENT`
    FOREIGN KEY (`client`)
    REFERENCES `optica`.`clients` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_RECRECOMANAT`
    FOREIGN KEY (`recomanat_per`)
    REFERENCES `optica`.`clients` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`empleats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`empleats` ;

CREATE TABLE IF NOT EXISTS `optica`.`empleats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`vendes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `optica`.`vendes` ;

CREATE TABLE IF NOT EXISTS `optica`.`vendes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ulleres` INT NOT NULL,
  `client` INT NOT NULL,
  `empleat` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ulleres_UNIQUE` (`ulleres` ASC) ,
  INDEX `FK_VCLIENT_idx` (`client` ASC) ,
  INDEX `FK_VEMPLEATS_idx` (`empleat` ASC) ,
  CONSTRAINT `FK_VULLERES`
    FOREIGN KEY (`ulleres`)
    REFERENCES `optica`.`ulleres` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_VCLIENT`
    FOREIGN KEY (`client`)
    REFERENCES `optica`.`clients` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_VEMPLEATS`
    FOREIGN KEY (`empleat`)
    REFERENCES `optica`.`empleats` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
