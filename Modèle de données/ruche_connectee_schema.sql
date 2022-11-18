-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ruche_connectee
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ruche_connectee
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ruche_connectee` DEFAULT CHARACTER SET utf8 ;
USE `ruche_connectee` ;

-- -----------------------------------------------------
-- Table `ruche_connectee`.`Utilisateur`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruche_connectee`.`Utilisateur` ;

CREATE TABLE IF NOT EXISTS `ruche_connectee`.`Utilisateur` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `prenom` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `pwd` VARCHAR(512) NOT NULL,
  `telephone` VARCHAR(45) NULL,
  `adresse` VARCHAR(1000) NULL,
  `is_admin` TINYINT NULL,
  `is_active` TINYINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruche_connectee`.`Rucher`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruche_connectee`.`Rucher` ;

CREATE TABLE IF NOT EXISTS `ruche_connectee`.`Rucher` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  `latitude` DECIMAL(6,4) NOT NULL,
  `longitude` DECIMAL(7,4) NOT NULL,
  `date_creation` DATE NOT NULL,
  `date_fin_rucher` DATE NULL,
  `commentaire` TEXT NULL,
  `is_active` TINYINT NULL,
  `id_utilisateur` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Rucher_Utilisateur1_idx` (`id_utilisateur` ASC) VISIBLE,
  CONSTRAINT `fk_Rucher_Utilisateur1`
    FOREIGN KEY (`id_utilisateur`)
    REFERENCES `ruche_connectee`.`Utilisateur` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruche_connectee`.`Ruche`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruche_connectee`.`Ruche` ;

CREATE TABLE IF NOT EXISTS `ruche_connectee`.`Ruche` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NULL,
  `latitude` DECIMAL(8,6) NOT NULL,
  `longitude` DECIMAL(9,6) NOT NULL,
  `altitude_en_m` INT NOT NULL,
  `orientation` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `type_abeille` VARCHAR(45) NOT NULL,
  `poids_initial_en_g` INT NOT NULL,
  `date_achat` DATE NOT NULL,
  `nb_hausse` INT NULL,
  `commentaire` TEXT NULL,
  `is_active` TINYINT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruche_connectee`.`Capteur`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruche_connectee`.`Capteur` ;

CREATE TABLE IF NOT EXISTS `ruche_connectee`.`Capteur` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ref` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `is_active` TINYINT NULL,
  `id_ruche` INT UNSIGNED NULL,
  `id_rucher` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_CapteurUnitaire_Ruche1_idx` (`id_ruche` ASC) VISIBLE,
  INDEX `fk_CapteurUnitaire_Rucher1_idx` (`id_rucher` ASC) VISIBLE,
  CONSTRAINT `fk_CapteurUnitaire_Ruche1`
    FOREIGN KEY (`id_ruche`)
    REFERENCES `ruche_connectee`.`Ruche` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CapteurUnitaire_Rucher1`
    FOREIGN KEY (`id_rucher`)
    REFERENCES `ruche_connectee`.`Rucher` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruche_connectee`.`Mesure`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruche_connectee`.`Mesure` ;

CREATE TABLE IF NOT EXISTS `ruche_connectee`.`Mesure` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `valeur` DECIMAL(7,4) NOT NULL,
  `date_mesure` DATE NOT NULL,
  `heure_mesure` TIME NOT NULL,
  `unite` VARCHAR(45) NOT NULL,
  `id_capteur` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Mesure_CapteurUnitaire1_idx` (`id_capteur` ASC) VISIBLE,
  CONSTRAINT `fk_Mesure_CapteurUnitaire1`
    FOREIGN KEY (`id_capteur`)
    REFERENCES `ruche_connectee`.`Capteur` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruche_connectee`.`Rucher_has_Ruche`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruche_connectee`.`Rucher_has_Ruche` ;

CREATE TABLE IF NOT EXISTS `ruche_connectee`.`Rucher_has_Ruche` (
  `id_rucher` INT UNSIGNED NOT NULL,
  `id_ruche` INT UNSIGNED NOT NULL,
  `date_mise_en_place` DATE NOT NULL,
  `date_enlevement` DATE NULL,
  PRIMARY KEY (`id_rucher`, `id_ruche`),
  INDEX `fk_Rucher_has_Ruche_Ruche1_idx` (`id_ruche` ASC) VISIBLE,
  INDEX `fk_Rucher_has_Ruche_Rucher1_idx` (`id_rucher` ASC) VISIBLE,
  CONSTRAINT `fk_Rucher_has_Ruche_Rucher1`
    FOREIGN KEY (`id_rucher`)
    REFERENCES `ruche_connectee`.`Rucher` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Rucher_has_Ruche_Ruche1`
    FOREIGN KEY (`id_ruche`)
    REFERENCES `ruche_connectee`.`Ruche` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ruche_connectee`.`ConfigAlerte`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ruche_connectee`.`ConfigAlerte` ;

CREATE TABLE IF NOT EXISTS `ruche_connectee`.`ConfigAlerte` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_alerte` VARCHAR(45) NOT NULL,
  `limite_haute` DECIMAL(5,2) NULL,
  `limite_basse` DECIMAL(5,2) NULL,
  `variation` DECIMAL(4,2) NULL,
  `intervalle` INT NULL,
  `intervalle_unite` VARCHAR(16) NULL,
  `id_capteur` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_ConfigAlerte_CapteurUnitaire1_idx` (`id_capteur` ASC) VISIBLE,
  CONSTRAINT `fk_ConfigAlerte_CapteurUnitaire1`
    FOREIGN KEY (`id_capteur`)
    REFERENCES `ruche_connectee`.`Capteur` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
