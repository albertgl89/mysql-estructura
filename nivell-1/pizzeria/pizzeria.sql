CREATE SCHEMA `s2_e1_ex1b` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE `s2_e1_ex1b`.`clients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognoms` VARCHAR(80) NOT NULL,
  `adreca` VARCHAR(80) NOT NULL,
  `codi_postal` VARCHAR(5) NOT NULL,
  `localitat` INT NOT NULL,
  `provincia` INT NOT NULL,
  `telefon` INT(20) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `s2_e1_ex1b`.`provincies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `provincia` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `s2_e1_ex1b`.`localitats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `localitat` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `s2_e1_ex1b`.`clients` 
ADD INDEX `FK_LOCALITAT_idx` (`localitat` ASC) ,
ADD INDEX `FK_PROVINCIA_idx` (`provincia` ASC) ;
;
ALTER TABLE `s2_e1_ex1b`.`clients` 
ADD CONSTRAINT `FK_LOCALITAT`
  FOREIGN KEY (`localitat`)
  REFERENCES `s2_e1_ex1b`.`localitats` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `FK_PROVINCIA`
  FOREIGN KEY (`provincia`)
  REFERENCES `s2_e1_ex1b`.`provincies` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `s2_e1_ex1b`.`localitats` 
ADD COLUMN `provincia` INT NOT NULL AFTER `localitat`,
ADD INDEX `FK_PROV_idx` (`provincia` ASC) ;
;
ALTER TABLE `s2_e1_ex1b`.`localitats` 
ADD CONSTRAINT `FK_PROV`
  FOREIGN KEY (`provincia`)
  REFERENCES `s2_e1_ex1b`.`provincies` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `s2_e1_ex1b`.`clients` 
DROP FOREIGN KEY `FK_PROVINCIA`;
ALTER TABLE `s2_e1_ex1b`.`clients` 
ADD INDEX `FK_PROVINCIA_idx` (`provincia` ASC) ,
DROP INDEX `FK_PROVINCIA_idx` ;
;
ALTER TABLE `s2_e1_ex1b`.`clients` 
ADD CONSTRAINT `FK_PROVINCIA`
  FOREIGN KEY (`provincia`)
  REFERENCES `s2_e1_ex1b`.`localitats` (`provincia`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `s2_e1_ex1b`.`linies_comanda` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `producte` INT NOT NULL,
  `quantitat` INT NOT NULL,
  `total` DECIMAL(6,2) NOT NULL COMMENT 'SELECT `productes`.`preu` * `linies_comanda`.`quantitat` WHERE `linies_comanda`.`producte` = `productes`.`id`;',
  PRIMARY KEY (`id`));

CREATE TABLE `s2_e1_ex1b`.`comandes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `client` INT NOT NULL,
  `data_hora` TIMESTAMP NOT NULL COMMENT 'NOW()\n',
  `tipus` SET('domicili', 'recollida') NOT NULL,
  `total` DECIMAL(6,2) NOT NULL COMMENT 'SELECT SUM(`total`) FROM `s2_e1_ex1b`.`linies_comanda` WHERE `s2_e1_ex1b`.`linies_comanda`.`comanda` = `s2_e1_ex1b`.`comandes`.`id`;',
  PRIMARY KEY (`id`),
  INDEX `FK_CLIENT_idx` (`client` ASC) ,
  CONSTRAINT `FK_CLIENT`
    FOREIGN KEY (`client`)
    REFERENCES `s2_e1_ex1b`.`clients` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `s2_e1_ex1b`.`linies_comanda` 
ADD COLUMN `comanda` INT NOT NULL AFTER `total`,
ADD INDEX `FK_COMANDA_idx` (`comanda` ASC) ;
;
ALTER TABLE `s2_e1_ex1b`.`linies_comanda` 
ADD CONSTRAINT `FK_COMANDA`
  FOREIGN KEY (`comanda`)
  REFERENCES `s2_e1_ex1b`.`comandes` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `s2_e1_ex1b`.`productes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(100) NULL,
  `imatge` VARCHAR(300) NULL COMMENT 'Suposem que emmagatzema la URL relativa als fitxers d\'imatge corresponent.',
  `preu` DECIMAL(6,2) NOT NULL,
  `categoria` INT NULL COMMENT 'Categoria si es pizza',
  `tipus` SET('pizza', 'hamburguesa', 'beguda') NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `s2_e1_ex1b`.`linies_comanda` 
CHANGE COLUMN `total` `total` DECIMAL(6,2) NOT NULL COMMENT 'SELECT (`productes`.`preu` * `linies_comanda`.`quantitat`) FROM `s2_e1_ex1b`.`productes` JOIN `s2_e1_ex1b`.`linies_comanda`  WHERE `linies_comanda`.`producte` = `productes`.`id`;' ,
ADD INDEX `FK_PRODUCTE_idx` (`producte` ASC) ;
;
ALTER TABLE `s2_e1_ex1b`.`linies_comanda` 
ADD CONSTRAINT `FK_PRODUCTE`
  FOREIGN KEY (`producte`)
  REFERENCES `s2_e1_ex1b`.`productes` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `s2_e1_ex1b`.`productes` 
ADD INDEX `IDX_PREU` (`preu` ASC) ;
;

ALTER TABLE `s2_e1_ex1b`.`linies_comanda` 
ADD COLUMN `preu_unitari` DECIMAL(6,2) NOT NULL AFTER `comanda`,
ADD CONSTRAINT `FK_PREU_U`
  FOREIGN KEY (`preu_unitari`)
  REFERENCES `s2_e1_ex1b`.`productes` (`preu`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `s2_e1_ex1b`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `s2_e1_ex1b`.`productes` 
ADD INDEX `FK_CAT_PIZZA_idx` (`categoria` ASC) ;
;
ALTER TABLE `s2_e1_ex1b`.`productes` 
ADD CONSTRAINT `FK_CAT_PIZZA`
  FOREIGN KEY (`categoria`)
  REFERENCES `s2_e1_ex1b`.`categories` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `s2_e1_ex1b`.`botigues` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `adreca` VARCHAR(80) NOT NULL,
  `codi_postal` VARCHAR(5) NOT NULL,
  `localitat` INT NOT NULL,
  `provincia` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_LOC_idx` (`localitat` ASC) ,
  INDEX `FK_PROV_idx` (`provincia` ASC) ,
  CONSTRAINT `FK_BLOC`
    FOREIGN KEY (`localitat`)
    REFERENCES `s2_e1_ex1b`.`localitats` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_BPROV`
    FOREIGN KEY (`provincia`)
    REFERENCES `s2_e1_ex1b`.`localitats` (`provincia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `s2_e1_ex1b`.`comandes` 
ADD COLUMN `botiga` INT NOT NULL AFTER `total`,
ADD INDEX `FK_BOTIGA_idx` (`botiga` ASC) ;
;
ALTER TABLE `s2_e1_ex1b`.`comandes` 
ADD CONSTRAINT `FK_BOTIGA`
  FOREIGN KEY (`botiga`)
  REFERENCES `s2_e1_ex1b`.`botigues` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `s2_e1_ex1b`.`empleats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognoms` VARCHAR(80) NOT NULL,
  `telefon` INT(20) NOT NULL,
  `NIF` VARCHAR(12) NOT NULL,
  `rol` SET('cuiner', 'repartidor') NOT NULL,
  `botiga` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_EBOTIGA_idx` (`botiga` ASC) ,
  CONSTRAINT `FK_EBOTIGA`
    FOREIGN KEY (`botiga`)
    REFERENCES `s2_e1_ex1b`.`botigues` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `s2_e1_ex1b`.`comandes` 
ADD COLUMN `repartidor` INT NULL AFTER `botiga`,
ADD INDEX `FK_REPARTIDOR_idx` (`repartidor` ASC) ;
;
ALTER TABLE `s2_e1_ex1b`.`comandes` 
ADD CONSTRAINT `FK_REPARTIDOR`
  FOREIGN KEY (`repartidor`)
  REFERENCES `s2_e1_ex1b`.`empleats` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `s2_e1_ex1b`.`lliuraments_domicili` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `repartidor` INT NOT NULL,
  `data_hora` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_LLREPARTIDOR_idx` (`repartidor` ASC) ,
  CONSTRAINT `FK_LLREPARTIDOR`
    FOREIGN KEY (`repartidor`)
    REFERENCES `s2_e1_ex1b`.`empleats` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `s2_e1_ex1b`.`comandes` 
DROP FOREIGN KEY `FK_REPARTIDOR`;
ALTER TABLE `s2_e1_ex1b`.`comandes` 
CHANGE COLUMN `repartidor` `dades_lliurament_domicili` INT(11) NULL DEFAULT NULL ,
ADD INDEX `FK_LLDOMICILI_idx` (`dades_lliurament_domicili` ASC) ,
DROP INDEX `FK_REPARTIDOR_idx` ;
;
ALTER TABLE `s2_e1_ex1b`.`comandes` 
ADD CONSTRAINT `FK_LLDOMICILI`
  FOREIGN KEY (`dades_lliurament_domicili`)
  REFERENCES `s2_e1_ex1b`.`lliuraments_domicili` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;









