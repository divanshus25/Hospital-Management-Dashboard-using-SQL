-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`CITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CITY` (
  `pincode` CHAR(6) NOT NULL,
  `cityname` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`pincode`),
  UNIQUE INDEX `cityname_UNIQUE` (`cityname` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`courses` (
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`department` (
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`faculty` (
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`student` (
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`student_has_courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`student_has_courses` (
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`PATIENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PATIENT` (
  `Patient_id` CHAR(5) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `gender` ENUM('Male', 'Female', 'Other') NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `phone` VARCHAR(10) NOT NULL,
  `address` VARCHAR(255) NULL,
  `email` VARCHAR(100) NULL,
  `blood_group` VARCHAR(45) NULL,
  `emergency_contact` VARCHAR(10) NULL,
  PRIMARY KEY (`Patient_id`),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DEPARTMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DEPARTMENT` (
  `dept_id` CHAR(10) NOT NULL,
  `dept_name` VARCHAR(100) NOT NULL,
  `location` VARCHAR(100) NULL,
  `head_of_dept` INT NULL,
  PRIMARY KEY (`dept_id`),
  UNIQUE INDEX `department_name_UNIQUE` (`dept_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DOCTOR`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DOCTOR` (
  `Doctor_id` CHAR(5) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `specialisation` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(10) NOT NULL,
  `email` VARCHAR(100) NULL,
  `experience_years` INT NOT NULL DEFAULT CHECK(experience_years >= 0),
  `dept_id` INT NOT NULL,
  `DEPARTMENT_dept_id` INT NOT NULL,
  PRIMARY KEY (`Doctor_id`),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_DOCTOR_DEPARTMENT1_idx` (`DEPARTMENT_dept_id` ASC) VISIBLE,
  CONSTRAINT `fk_DOCTOR_DEPARTMENT1`
    FOREIGN KEY (`DEPARTMENT_dept_id`)
    REFERENCES `mydb`.`DEPARTMENT` (`dept_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`APPOINTMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`APPOINTMENT` (
  `appointment_id` CHAR(5) NOT NULL,
  `Patient_id` CHAR(5) NOT NULL,
  `Doctor_id` CHAR(5) NOT NULL,
  `appointment_date` DATE NOT NULL,
  `reason` VARCHAR(255) NULL,
  `status` VARCHAR(45) NOT NULL DEFAULT 'CHECK(status IN (\'Scheduled\',\'Completed\',\'Cancelled\'))',
  `PATIENT_Patient_id` CHAR(5) NOT NULL,
  `DOCTOR_Doctor_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`appointment_id`),
  INDEX `fk_APPOINTMENT_PATIENT1_idx` (`PATIENT_Patient_id` ASC) VISIBLE,
  INDEX `fk_APPOINTMENT_DOCTOR1_idx` (`DOCTOR_Doctor_id` ASC) VISIBLE,
  CONSTRAINT `fk_APPOINTMENT_PATIENT1`
    FOREIGN KEY (`PATIENT_Patient_id`)
    REFERENCES `mydb`.`PATIENT` (`Patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_APPOINTMENT_DOCTOR1`
    FOREIGN KEY (`DOCTOR_Doctor_id`)
    REFERENCES `mydb`.`DOCTOR` (`Doctor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`WARD`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`WARD` (
  `ward_id` CHAR(5) NOT NULL,
  `ward_name` VARCHAR(45) NOT NULL,
  `ward_type` ENUM('General', 'ICU', 'Private') NOT NULL,
  PRIMARY KEY (`ward_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ROOM`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ROOM` (
  `room_id` CHAR(5) NULL,
  `room_number` VARCHAR(10) NOT NULL,
  `room_type` VARCHAR(45) NOT NULL DEFAULT 'CHECK(room_type IN (\'ICU\',\'General\',\'Private\'))',
  `status` VARCHAR(45) NOT NULL DEFAULT 'CHECK (status IN (\'Available\',\'Occupied\'))',
  `charges_per_day` DECIMAL(10,2) NOT NULL,
  `WARD_ward_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`room_id`),
  UNIQUE INDEX `room_number_UNIQUE` (`room_number` ASC) VISIBLE,
  INDEX `fk_ROOM_WARD1_idx` (`WARD_ward_id` ASC) VISIBLE,
  CONSTRAINT `fk_ROOM_WARD1`
    FOREIGN KEY (`WARD_ward_id`)
    REFERENCES `mydb`.`WARD` (`ward_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`VISIT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`VISIT` (
  `visit_id` CHAR(5) NOT NULL,
  `Patient_id` CHAR(5) NOT NULL,
  `Doctor_id` CHAR(5) NOT NULL,
  `appointment_id` CHAR(5) NOT NULL,
  `visit_date` DATETIME NOT NULL,
  `symptoms` VARCHAR(255) NULL,
  `notes` VARCHAR(255) NULL,
  `PATIENT_Patient_id` CHAR(5) NOT NULL,
  `DOCTOR_Doctor_id` CHAR(5) NOT NULL,
  `APPOINTMENT_appointment_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`visit_id`),
  INDEX `fk_VISIT_PATIENT1_idx` (`PATIENT_Patient_id` ASC) VISIBLE,
  INDEX `fk_VISIT_DOCTOR1_idx` (`DOCTOR_Doctor_id` ASC) VISIBLE,
  INDEX `fk_VISIT_APPOINTMENT1_idx` (`APPOINTMENT_appointment_id` ASC) VISIBLE,
  CONSTRAINT `fk_VISIT_PATIENT1`
    FOREIGN KEY (`PATIENT_Patient_id`)
    REFERENCES `mydb`.`PATIENT` (`Patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VISIT_DOCTOR1`
    FOREIGN KEY (`DOCTOR_Doctor_id`)
    REFERENCES `mydb`.`DOCTOR` (`Doctor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_VISIT_APPOINTMENT1`
    FOREIGN KEY (`APPOINTMENT_appointment_id`)
    REFERENCES `mydb`.`APPOINTMENT` (`appointment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`BED`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`BED` (
  `bed_id` CHAR(5) NOT NULL,
  `room_id` CHAR(5) NOT NULL,
  `bed_number` VARCHAR(10) NOT NULL,
  `bed_status` ENUM('Vacant', 'Occupied') NOT NULL,
  `ROOM_room_id` CHAR(10) NOT NULL,
  PRIMARY KEY (`bed_id`),
  INDEX `fk_BED_ROOM1_idx` (`ROOM_room_id` ASC) VISIBLE,
  CONSTRAINT `fk_BED_ROOM1`
    FOREIGN KEY (`ROOM_room_id`)
    REFERENCES `mydb`.`ROOM` (`room_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ADMISSION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ADMISSION` (
  `admission_id` CHAR(5) NULL,
  `Patient_id` CHAR(5) NOT NULL,
  `room_id` CHAR(5) NOT NULL,
  `admit_date` DATETIME NOT NULL,
  `discharge_date` DATETIME NULL,
  `diagnosis` VARCHAR(255) NULL,
  `PATIENT_Patient_id` CHAR(5) NOT NULL,
  `VISIT_visit_id` CHAR(5) NOT NULL,
  `BED_bed_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`admission_id`),
  INDEX `fk_ADMISSION_PATIENT1_idx` (`PATIENT_Patient_id` ASC) VISIBLE,
  INDEX `fk_ADMISSION_VISIT1_idx` (`VISIT_visit_id` ASC) VISIBLE,
  INDEX `fk_ADMISSION_BED1_idx` (`BED_bed_id` ASC) VISIBLE,
  CONSTRAINT `fk_ADMISSION_PATIENT1`
    FOREIGN KEY (`PATIENT_Patient_id`)
    REFERENCES `mydb`.`PATIENT` (`Patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ADMISSION_VISIT1`
    FOREIGN KEY (`VISIT_visit_id`)
    REFERENCES `mydb`.`VISIT` (`visit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ADMISSION_BED1`
    FOREIGN KEY (`BED_bed_id`)
    REFERENCES `mydb`.`BED` (`bed_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TREATMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TREATMENT` (
  `treatment_id` CHAR(5) NOT NULL,
  `admission_id` CHAR(5) NOT NULL,
  `Doctor_id` CHAR(5) NOT NULL,
  `treatment_date` DATETIME NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `cost` DECIMAL(10,2) NOT NULL,
  `DOCTOR_Doctor_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`treatment_id`),
  INDEX `fk_TREATMENT_DOCTOR1_idx` (`DOCTOR_Doctor_id` ASC) VISIBLE,
  CONSTRAINT `fk_TREATMENT_DOCTOR1`
    FOREIGN KEY (`DOCTOR_Doctor_id`)
    REFERENCES `mydb`.`DOCTOR` (`Doctor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PRESCRIPTION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PRESCRIPTION` (
  `prescription_id` CHAR(5) NOT NULL,
  `visit_id` CHAR(5) NOT NULL,
  `prescribed_by` INT NOT NULL,
  `date_prescribed` DATETIME NOT NULL,
  `DOCTOR_Doctor_id` CHAR(5) NOT NULL,
  `VISIT_visit_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`prescription_id`),
  INDEX `fk_PRESCRIPTION_DOCTOR1_idx` (`DOCTOR_Doctor_id` ASC) VISIBLE,
  INDEX `fk_PRESCRIPTION_VISIT1_idx` (`VISIT_visit_id` ASC) VISIBLE,
  CONSTRAINT `fk_PRESCRIPTION_DOCTOR1`
    FOREIGN KEY (`DOCTOR_Doctor_id`)
    REFERENCES `mydb`.`DOCTOR` (`Doctor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRESCRIPTION_VISIT1`
    FOREIGN KEY (`VISIT_visit_id`)
    REFERENCES `mydb`.`VISIT` (`visit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MEDICINE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MEDICINE` (
  `medicine_id` CHAR(5) NOT NULL,
  `medicine_name` VARCHAR(100) NOT NULL,
  `brand` VARCHAR(45) NULL,
  PRIMARY KEY (`medicine_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PRESCRIPTION_ITEM`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PRESCRIPTION_ITEM` (
  `item_id` CHAR(5) NOT NULL,
  `prescription_id` CHAR(5) NOT NULL,
  `medicine_id` CHAR(5) NOT NULL,
  `dosage` VARCHAR(45) NOT NULL,
  `duration_days` INT NOT NULL,
  `PRESCRIPTION_prescription_id` CHAR(5) NOT NULL,
  `MEDICINE_medicine_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `fk_PRESCRIPTION_ITEM_PRESCRIPTION1_idx` (`PRESCRIPTION_prescription_id` ASC) VISIBLE,
  INDEX `fk_PRESCRIPTION_ITEM_MEDICINE1_idx` (`MEDICINE_medicine_id` ASC) VISIBLE,
  CONSTRAINT `fk_PRESCRIPTION_ITEM_PRESCRIPTION1`
    FOREIGN KEY (`PRESCRIPTION_prescription_id`)
    REFERENCES `mydb`.`PRESCRIPTION` (`prescription_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PRESCRIPTION_ITEM_MEDICINE1`
    FOREIGN KEY (`MEDICINE_medicine_id`)
    REFERENCES `mydb`.`MEDICINE` (`medicine_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`INVOICE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`INVOICE` (
  `invoice_id` CHAR(5) NOT NULL,
  `Patient_id` CHAR(5) NOT NULL,
  `visit_id` CHAR(5) NOT NULL,
  `invoice_date` DATETIME NOT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `PATIENT_Patient_id` CHAR(5) NOT NULL,
  `VISIT_visit_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`invoice_id`),
  INDEX `fk_INVOICE_PATIENT1_idx` (`PATIENT_Patient_id` ASC) VISIBLE,
  INDEX `fk_INVOICE_VISIT1_idx` (`VISIT_visit_id` ASC) VISIBLE,
  CONSTRAINT `fk_INVOICE_PATIENT1`
    FOREIGN KEY (`PATIENT_Patient_id`)
    REFERENCES `mydb`.`PATIENT` (`Patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_INVOICE_VISIT1`
    FOREIGN KEY (`VISIT_visit_id`)
    REFERENCES `mydb`.`VISIT` (`visit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`INVOICE_ITEM`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`INVOICE_ITEM` (
  `item_id` CHAR(5) NOT NULL,
  `invoice_id` CHAR(5) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `INVOICE_invoice_id` CHAR(5) NOT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `fk_INVOICE_ITEM_INVOICE1_idx` (`INVOICE_invoice_id` ASC) VISIBLE,
  CONSTRAINT `fk_INVOICE_ITEM_INVOICE1`
    FOREIGN KEY (`INVOICE_invoice_id`)
    REFERENCES `mydb`.`INVOICE` (`invoice_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
