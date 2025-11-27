-- ================================
-- USER INPUT: ENTER SCHEMA NAME
-- ================================
SET @schema_name = 'mydb';     -- <<< CHANGE THIS ONLY
SET @sql_create = CONCAT('CREATE SCHEMA IF NOT EXISTS `', @schema_name, '` DEFAULT CHARACTER SET utf8mb3;');
SET @sql_use    = CONCAT('USE `', @schema_name, '`;');

PREPARE stmt FROM @sql_create;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

PREPARE stmt FROM @sql_use;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- ================================
-- TABLE: PATIENT
-- ================================
CREATE TABLE IF NOT EXISTS PATIENT (
  Patient_id INT PRIMARY KEY,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  gender ENUM('Male','Female','Other') NOT NULL,
  date_of_birth DATE NOT NULL,
  phone VARCHAR(10) UNIQUE NOT NULL,
  address VARCHAR(255),
  email VARCHAR(100) UNIQUE,
  blood_group VARCHAR(45),
  emergency_contact VARCHAR(10)
);


-- ================================
-- TABLE: DEPARTMENT
-- ================================
CREATE TABLE IF NOT EXISTS DEPARTMENT (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(100) UNIQUE NOT NULL,
  location VARCHAR(100),
  head_of_dept INT
);


-- ================================
-- TABLE: DOCTOR
-- ================================
CREATE TABLE IF NOT EXISTS DOCTOR (
  Doctor_id INT PRIMARY KEY,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  specialisation VARCHAR(100) NOT NULL,
  phone VARCHAR(10) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE,
  experience_years INT CHECK (experience_years >= 0),
  dept_id INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);


-- ================================
-- TABLE: APPOINTMENT
-- ================================
CREATE TABLE IF NOT EXISTS APPOINTMENT (
  appointment_id INT PRIMARY KEY,
  Patient_id INT NOT NULL,
  Doctor_id INT NOT NULL,
  appointment_date DATE NOT NULL,
  reason VARCHAR(255),
  status ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
  FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id),
  FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id)
);


-- ================================
-- TABLE: WARD
-- ================================
CREATE TABLE IF NOT EXISTS WARD (
  ward_id INT PRIMARY KEY,
  ward_name VARCHAR(45) NOT NULL,
  ward_type ENUM('General','ICU','Private') NOT NULL
);


-- ================================
-- TABLE: ROOM
-- ================================
CREATE TABLE IF NOT EXISTS ROOM (
  room_id INT PRIMARY KEY,
  room_number VARCHAR(10) UNIQUE NOT NULL,
  room_type ENUM('ICU','General','Private') NOT NULL,
  status ENUM('Available','Occupied') NOT NULL,
  charges_per_day DECIMAL(10,2) NOT NULL,
  ward_id INT NOT NULL,
  FOREIGN KEY (ward_id) REFERENCES WARD(ward_id)
);


-- ================================
-- TABLE: VISIT
-- ================================
CREATE TABLE IF NOT EXISTS VISIT (
  visit_id INT PRIMARY KEY,
  Patient_id INT NOT NULL,
  Doctor_id INT NOT NULL,
  appointment_id INT NOT NULL,
  visit_date DATETIME NOT NULL,
  symptoms VARCHAR(255),
  notes VARCHAR(255),
  FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id),
  FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id),
  FOREIGN KEY (appointment_id) REFERENCES APPOINTMENT(appointment_id)
);


-- ================================
-- TABLE: BED
-- ================================
CREATE TABLE IF NOT EXISTS BED (
  bed_id INT PRIMARY KEY,
  room_id INT NOT NULL,
  bed_number VARCHAR(10) NOT NULL,
  bed_status ENUM('Vacant','Occupied') NOT NULL,
  FOREIGN KEY (room_id) REFERENCES ROOM(room_id)
);


-- ================================
-- TABLE: ADMISSION
-- ================================
CREATE TABLE IF NOT EXISTS ADMISSION (
  admission_id INT PRIMARY KEY,
  Patient_id INT NOT NULL,
  room_id INT NOT NULL,
  admit_date DATETIME NOT NULL,
  discharge_date DATETIME,
  diagnosis VARCHAR(255),
  visit_id INT NOT NULL,
  bed_id INT NOT NULL,
  FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id),
  FOREIGN KEY (visit_id) REFERENCES VISIT(visit_id),
  FOREIGN KEY (bed_id) REFERENCES BED(bed_id)
);


-- ================================
-- TABLE: TREATMENT
-- ================================
CREATE TABLE IF NOT EXISTS TREATMENT (
  treatment_id INT PRIMARY KEY,
  admission_id INT NOT NULL,
  Doctor_id INT NOT NULL,
  treatment_date DATETIME NOT NULL,
  description VARCHAR(255) NOT NULL,
  cost DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (Doctor_id) REFERENCES DOCTOR(Doctor_id),
  FOREIGN KEY (admission_id) REFERENCES ADMISSION(admission_id)
);


-- ================================
-- TABLE: PRESCRIPTION
-- ================================
CREATE TABLE IF NOT EXISTS PRESCRIPTION (
  prescription_id INT PRIMARY KEY,
  visit_id INT NOT NULL,
  prescribed_by INT NOT NULL,
  date_prescribed DATETIME NOT NULL,
  FOREIGN KEY (visit_id) REFERENCES VISIT(visit_id),
  FOREIGN KEY (prescribed_by) REFERENCES DOCTOR(Doctor_id)
);


-- ================================
-- TABLE: MEDICINE
-- ================================
CREATE TABLE IF NOT EXISTS MEDICINE (
  medicine_id INT PRIMARY KEY,
  medicine_name VARCHAR(100) NOT NULL,
  brand VARCHAR(45)
);


-- ================================
-- TABLE: PRESCRIPTION_ITEM
-- ================================
CREATE TABLE IF NOT EXISTS PRESCRIPTION_ITEM (
  item_id INT PRIMARY KEY,
  prescription_id INT NOT NULL,
  medicine_id INT NOT NULL,
  dosage VARCHAR(45) NOT NULL,
  duration_days INT NOT NULL,
  FOREIGN KEY (prescription_id) REFERENCES PRESCRIPTION(prescription_id),
  FOREIGN KEY (medicine_id) REFERENCES MEDICINE(medicine_id)
);


-- ================================
-- TABLE: INVOICE
-- ================================
CREATE TABLE IF NOT EXISTS INVOICE (
  invoice_id INT PRIMARY KEY,
  Patient_id INT NOT NULL,
  visit_id INT NOT NULL,
  invoice_date DATETIME NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (Patient_id) REFERENCES PATIENT(Patient_id),
  FOREIGN KEY (visit_id) REFERENCES VISIT(visit_id)
);


-- ================================
-- TABLE: INVOICE_ITEM
-- ================================
CREATE TABLE IF NOT EXISTS INVOICE_ITEM (
  item_id INT PRIMARY KEY,
  invoice_id INT NOT NULL,
  description VARCHAR(255) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (invoice_id) REFERENCES INVOICE(invoice_id)
);

