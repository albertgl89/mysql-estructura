CREATE SCHEMA `s2_e1_ex1` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE `s2_e1_ex1`.`proveidors` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `carrer` VARCHAR(150) NOT NULL,
  `numero` VARCHAR(5) NOT NULL,
  `pis` VARCHAR(5) NULL,
  `porta` VARCHAR(5) NULL,
  `ciutat` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(15) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `telefon` INT(20) NOT NULL,
  `fax` INT(20) NULL,
  `NIF` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `NIF_UNIQUE` (`NIF` ASC));

CREATE TABLE `s2_e1_ex1`.`ulleres` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `marca` VARCHAR(45) NOT NULL,
  `grad_esq` DECIMAL(4,2) NOT NULL,
  `grad_dreta` DECIMAL(4,2) NOT NULL,
  `tipus` SET('flotant', 'pasta', 'metàl·lica') NOT NULL,
  `color_muntura` VARCHAR(25) NOT NULL,
  `color_v_esq` VARCHAR(25) NOT NULL,
  `color_v_dret` VARCHAR(25) NOT NULL,
  `preu` DECIMAL(6,4) NOT NULL,
  PRIMARY KEY (`id`));


ALTER TABLE `s2_e1_ex1`.`ulleres` 
ADD COLUMN `proveidor` INT NOT NULL AFTER `preu`,
ADD INDEX `FK_PROVEIDOR_idx` (`proveidor` ASC);
;
ALTER TABLE `s2_e1_ex1`.`ulleres` 
ADD CONSTRAINT `FK_PROVEIDOR`
  FOREIGN KEY (`proveidor`)
  REFERENCES `s2_e1_ex1`.`proveidors` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `s2_e1_ex1`.`clients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `adreca` VARCHAR(250) NOT NULL,
  `telefon` INT(20) NOT NULL,
  `email` VARCHAR(80) NOT NULL,
  `alta_registre` DATE NOT NULL,
  `recomanat` INT NULL,
  `ates` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `s2_e1_ex1`.`clients` 
ADD INDEX `FK_RECOMANACIO_idx` (`recomanat` ASC);
;
ALTER TABLE `s2_e1_ex1`.`clients` 
ADD CONSTRAINT `FK_RECOMANACIO`
  FOREIGN KEY (`recomanat`)
  REFERENCES `s2_e1_ex1`.`clients` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `s2_e1_ex1`.`ulleres` 
ADD COLUMN `client` INT NULL AFTER `proveidor`,
ADD INDEX `FK_CLIENT_idx` (`client` ASC) ;
;
ALTER TABLE `s2_e1_ex1`.`ulleres` 
ADD CONSTRAINT `FK_CLIENT`
  FOREIGN KEY (`client`)
  REFERENCES `s2_e1_ex1`.`clients` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

