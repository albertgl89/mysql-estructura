-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pizzeria` ;

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`localitats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`localitats` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`localitats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`provincies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`provincies` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`provincies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`localitats_provincia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`localitats_provincia` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`localitats_provincia` (
  `localitat` INT NOT NULL,
  `provincia` INT NOT NULL,
  PRIMARY KEY (`localitat`),
  INDEX `FK_LPPROVINCIA_idx` (`provincia` ASC) ,
  CONSTRAINT `FK_LPLOCALITAT`
    FOREIGN KEY (`localitat`)
    REFERENCES `pizzeria`.`localitats` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_LPPROVINCIA`
    FOREIGN KEY (`provincia`)
    REFERENCES `pizzeria`.`provincies` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`client` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`client` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognoms` VARCHAR(90) NOT NULL,
  `adreca` VARCHAR(90) NOT NULL,
  `codi_postal` INT NOT NULL,
  `localitat_provincia` INT NOT NULL,
  `telefon` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_CLLOCALITATPRO_idx` (`localitat_provincia` ASC) ,
  CONSTRAINT `FK_CLLOCALITATPRO`
    FOREIGN KEY (`localitat_provincia`)
    REFERENCES `pizzeria`.`localitats_provincia` (`localitat`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`comandes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`comandes` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`comandes` (
  `num_comanda` INT NOT NULL AUTO_INCREMENT,
  `data_hora` TIMESTAMP NOT NULL,
  `tipus` SET('domicili', 'recollir') NOT NULL,
  `preu_total` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`num_comanda`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`realitza_comandes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`realitza_comandes` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`realitza_comandes` (
  `comanda` INT NOT NULL,
  `client` INT NOT NULL,
  PRIMARY KEY (`comanda`),
  INDEX `FK_RCCLIENT_idx` (`client` ASC) ,
  CONSTRAINT `FK_RCCOMANDA`
    FOREIGN KEY (`comanda`)
    REFERENCES `pizzeria`.`comandes` (`num_comanda`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_RCCLIENT`
    FOREIGN KEY (`client`)
    REFERENCES `pizzeria`.`client` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`productes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`productes` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`productes` (
  `producte` INT NOT NULL,
  `descripcio` VARCHAR(250) NOT NULL,
  `imatge` VARCHAR(120) NOT NULL,
  `preu` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`producte`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`linies_comanda`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`linies_comanda` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`linies_comanda` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `producte` INT NOT NULL,
  `quantitat` INT NOT NULL,
  `total_linia` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_LCPRODUCTE_idx` (`producte` ASC) ,
  CONSTRAINT `FK_LCPRODUCTE`
    FOREIGN KEY (`producte`)
    REFERENCES `pizzeria`.`productes` (`producte`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`categories_pizza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`categories_pizza` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`categories_pizza` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pizzes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`pizzes` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`pizzes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `categoria` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_PICATEGORIA_idx` (`categoria` ASC) ,
  CONSTRAINT `FK_PIPRODUCTE`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria`.`productes` (`producte`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `FK_PICATEGORIA`
    FOREIGN KEY (`categoria`)
    REFERENCES `pizzeria`.`categories_pizza` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`hamburgueses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`hamburgueses` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`hamburgueses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_HAPRODUCTE`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria`.`productes` (`producte`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`begudes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`begudes` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`begudes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_BEPRODUCTE`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria`.`productes` (`producte`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`botiga`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`botiga` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`botiga` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `adreca` VARCHAR(90) NOT NULL,
  `codi_postal` INT NOT NULL,
  `localitat_provincia` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_BOADRECA_idx` (`localitat_provincia` ASC) ,
  CONSTRAINT `FK_BOADRECA`
    FOREIGN KEY (`localitat_provincia`)
    REFERENCES `pizzeria`.`localitats_provincia` (`localitat`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`gestiona_comandes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`gestiona_comandes` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`gestiona_comandes` (
  `comanda` INT NOT NULL,
  `botiga` INT NOT NULL,
  PRIMARY KEY (`comanda`),
  INDEX `FK_GCBOTIGA_idx` (`botiga` ASC) ,
  CONSTRAINT `FK_GCCOMANDA`
    FOREIGN KEY (`comanda`)
    REFERENCES `pizzeria`.`comandes` (`num_comanda`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_GCBOTIGA`
    FOREIGN KEY (`botiga`)
    REFERENCES `pizzeria`.`botiga` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`empleats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`empleats` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`empleats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognoms` VARCHAR(90) NOT NULL,
  `nif` VARCHAR(15) NOT NULL,
  `telefon` INT NOT NULL,
  `rol` SET('cuiner', 'repartidor') NOT NULL,
  `botiga` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) ,
  INDEX `FK_EMBOTIGA_idx` (`botiga` ASC) ,
  CONSTRAINT `FK_EMBOTIGA`
    FOREIGN KEY (`botiga`)
    REFERENCES `pizzeria`.`botiga` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`reparteix`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`reparteix` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`reparteix` (
  `comanda` INT NOT NULL,
  `empleat` INT NOT NULL,
  `data_hora` TIMESTAMP NOT NULL,
  PRIMARY KEY (`comanda`),
  INDEX `FK_REEMPLEAT_idx` (`empleat` ASC) ,
  CONSTRAINT `FK_RECOMANDA`
    FOREIGN KEY (`comanda`)
    REFERENCES `pizzeria`.`gestiona_comandes` (`comanda`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_REEMPLEAT`
    FOREIGN KEY (`empleat`)
    REFERENCES `pizzeria`.`empleats` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`tickets`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pizzeria`.`tickets` ;

CREATE TABLE IF NOT EXISTS `pizzeria`.`tickets` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comanda` INT NOT NULL,
  `linia` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `linia_UNIQUE` (`linia` ASC) ,
  UNIQUE INDEX `comanda_UNIQUE` (`comanda` ASC) ,
  CONSTRAINT `FK_TICOMANDA`
    FOREIGN KEY (`comanda`)
    REFERENCES `pizzeria`.`comandes` (`num_comanda`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_TILINIA`
    FOREIGN KEY (`linia`)
    REFERENCES `pizzeria`.`linies_comanda` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
