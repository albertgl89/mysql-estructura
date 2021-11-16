CREATE SCHEMA `youtube` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE `youtube`.`usuaris` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `nom_usuari` VARCHAR(45) NOT NULL,
  `data_naix` DATE NOT NULL,
  `sexe` SET('masculi', 'femeni', 'altres') NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `youtube`.`videos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(120) NOT NULL,
  `descripcio` MEDIUMTEXT NULL,
  `grandaria` DECIMAL(10,2) NOT NULL,
  `nom_arxiu` VARCHAR(45) NOT NULL,
  `durada` TIME NOT NULL,
  `thumbnail` VARCHAR(250) NOT NULL,
  `reproduccions` INT NOT NULL DEFAULT 0,
  `likes` INT NOT NULL DEFAULT 0,
  `dislikes` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`));


CREATE TABLE `youtube`.`etiquetes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));

ALTER TABLE `youtube`.`videos` 
ADD COLUMN `estat` SET('public', 'ocult', 'privat') NOT NULL AFTER `dislikes`;

CREATE TABLE `youtube`.`videos_etiquetats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `video` INT NOT NULL,
  `etiqueta` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_VIDEO_idx` (`video` ASC) ,
  INDEX `FK_ETIQUETA_idx` (`etiqueta` ASC) ,
  CONSTRAINT `FK_VIDEO`
    FOREIGN KEY (`video`)
    REFERENCES `youtube`.`videos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ETIQUETA`
    FOREIGN KEY (`etiqueta`)
    REFERENCES `youtube`.`etiquetes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `youtube`.`publicacio` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuari` INT NOT NULL,
  `video` INT NOT NULL,
  `data_hora` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_USUARI_idx` (`usuari` ASC) ,
  INDEX `FK_PVIDEO_idx` (`video` ASC) ,
  CONSTRAINT `FK_USUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `youtube`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PVIDEO`
    FOREIGN KEY (`video`)
    REFERENCES `youtube`.`videos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `youtube`.`canals` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `descripcio` MEDIUMTEXT NULL,
  `creat` DATE NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`));

CREATE TABLE `youtube`.`subscripcions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuari` INT NOT NULL,
  `canal` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_SUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_SCANAL_idx` (`canal` ASC) ,
  CONSTRAINT `FK_SUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `youtube`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_SCANAL`
    FOREIGN KEY (`canal`)
    REFERENCES `youtube`.`canals` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `youtube`.`likes_dislikes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuari` INT NOT NULL,
  `video` INT NOT NULL,
  `status` SET('like', 'dislike') NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_LUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_LVIDEO_idx` (`video` ASC) ,
  UNIQUE INDEX `usuari_UNIQUE` (`usuari` ASC) ,
  UNIQUE INDEX `video_UNIQUE` (`video` ASC) ,
  CONSTRAINT `FK_LUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `youtube`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_LVIDEO`
    FOREIGN KEY (`video`)
    REFERENCES `youtube`.`videos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `youtube`.`likes_dislikes` 
ADD COLUMN `data_hora` TIMESTAMP NOT NULL DEFAULT NOW() AFTER `status`;

CREATE TABLE `youtube`.`playlists` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `creada` DATE NOT NULL DEFAULT NOW(),
  `estat` SET('publica', 'privada') NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE `youtube`.`playlist_usuaris` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuari` INT NOT NULL,
  `playlist` INT NOT NULL,
  `video` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_PLUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_PLPLAYLIST_idx` (`playlist` ASC) ,
  INDEX `FK_PLVIDEO_idx` (`video` ASC) ,
  CONSTRAINT `FK_PLUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `youtube`.`usuaris` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PLPLAYLIST`
    FOREIGN KEY (`playlist`)
    REFERENCES `youtube`.`playlists` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PLVIDEO`
    FOREIGN KEY (`video`)
    REFERENCES `youtube`.`videos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `youtube`.`playlist_usuaris` 
DROP FOREIGN KEY `FK_PLPLAYLIST`,
DROP FOREIGN KEY `FK_PLUSUARI`,
DROP FOREIGN KEY `FK_PLVIDEO`;
ALTER TABLE `youtube`.`playlist_usuaris` 
ADD CONSTRAINT `FK_PLPLAYLIST`
  FOREIGN KEY (`playlist`)
  REFERENCES `youtube`.`playlists` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `FK_PLUSUARI`
  FOREIGN KEY (`usuari`)
  REFERENCES `youtube`.`usuaris` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `FK_PLVIDEO`
  FOREIGN KEY (`video`)
  REFERENCES `youtube`.`videos` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `youtube`.`videos_etiquetats` 
DROP FOREIGN KEY `FK_ETIQUETA`,
DROP FOREIGN KEY `FK_VIDEO`;
ALTER TABLE `youtube`.`videos_etiquetats` 
ADD CONSTRAINT `FK_ETIQUETA`
  FOREIGN KEY (`etiqueta`)
  REFERENCES `youtube`.`etiquetes` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `FK_VIDEO`
  FOREIGN KEY (`video`)
  REFERENCES `youtube`.`videos` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;


ALTER TABLE `youtube`.`subscripcions` 
DROP FOREIGN KEY `FK_SCANAL`,
DROP FOREIGN KEY `FK_SUSUARI`;
ALTER TABLE `youtube`.`subscripcions` 
ADD CONSTRAINT `FK_SCANAL`
  FOREIGN KEY (`canal`)
  REFERENCES `youtube`.`canals` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `FK_SUSUARI`
  FOREIGN KEY (`usuari`)
  REFERENCES `youtube`.`usuaris` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;


ALTER TABLE `youtube`.`publicacio` 
DROP FOREIGN KEY `FK_PVIDEO`,
DROP FOREIGN KEY `FK_USUARI`;
ALTER TABLE `youtube`.`publicacio` 
ADD CONSTRAINT `FK_PVIDEO`
  FOREIGN KEY (`video`)
  REFERENCES `youtube`.`videos` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `FK_USUARI`
  FOREIGN KEY (`usuari`)
  REFERENCES `youtube`.`usuaris` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `youtube`.`likes_dislikes` 
DROP FOREIGN KEY `FK_LUSUARI`,
DROP FOREIGN KEY `FK_LVIDEO`;
ALTER TABLE `youtube`.`likes_dislikes` 
ADD CONSTRAINT `FK_LUSUARI`
  FOREIGN KEY (`usuari`)
  REFERENCES `youtube`.`usuaris` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `FK_LVIDEO`
  FOREIGN KEY (`video`)
  REFERENCES `youtube`.`videos` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;


CREATE TABLE `youtube`.`comentari` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comentari` MEDIUMTEXT NOT NULL,
  `data_hora` TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`));

CREATE TABLE `youtube`.`comentaris_video` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuari` INT NOT NULL,
  `comentari` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FK_CUSUARI_idx` (`usuari` ASC) ,
  INDEX `FK_CCOMENTARI_idx` (`comentari` ASC) ,
  CONSTRAINT `FK_CUSUARI`
    FOREIGN KEY (`usuari`)
    REFERENCES `youtube`.`usuaris` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_CCOMENTARI`
    FOREIGN KEY (`comentari`)
    REFERENCES `youtube`.`comentari` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);



CREATE TABLE `youtube`.`comentaris_likes_dislikes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuari` int(11) NOT NULL,
  `comentari` int(11) NOT NULL,
  `status` set('like','dislike') NOT NULL,
  `data_hora` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuari_UNIQUE` (`usuari`),
  UNIQUE KEY `comentari_UNIQUE` (`comentari`),
  KEY `FK_CLUSUARI_idx` (`usuari`),
  KEY `FK_CLCOMENTARI_idx` (`comentari`),
  CONSTRAINT `FK_CLUSUARI` FOREIGN KEY (`usuari`) REFERENCES `usuaris` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CLCOMENTARI` FOREIGN KEY (`comentari`) REFERENCES `comentari` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `youtube`.`canals` 
ADD COLUMN `usuari` INT NOT NULL AFTER `creat`,
ADD INDEX `FK_CAUSUARI_idx` (`usuari` ASC) ;
;
ALTER TABLE `youtube`.`canals` 
ADD CONSTRAINT `FK_CAUSUARI`
  FOREIGN KEY (`usuari`)
  REFERENCES `youtube`.`usuaris` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `youtube`.`publicacio` 
ADD COLUMN `canal` INT NOT NULL AFTER `data_hora`,
ADD INDEX `FK_CANALPUB_idx` (`canal` ASC) ;
;
ALTER TABLE `youtube`.`publicacio` 
ADD CONSTRAINT `FK_CANALPUB`
  FOREIGN KEY (`canal`)
  REFERENCES `youtube`.`canals` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `youtube`.`canals` 
ADD UNIQUE INDEX `usuari_UNIQUE` (`usuari` ASC) ;
;

ALTER TABLE `youtube`.`comentaris_video` 
ADD COLUMN `video` INT NOT NULL AFTER `comentari`,
ADD INDEX `FK_CVIDEO_idx` (`video` ASC) ;
;
ALTER TABLE `youtube`.`comentaris_video` 
ADD CONSTRAINT `FK_CVIDEO`
  FOREIGN KEY (`video`)
  REFERENCES `youtube`.`videos` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;


