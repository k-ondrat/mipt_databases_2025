-- Создание таблицы clinics
CREATE TABLE clinics (
    clinic_id SERIAL PRIMARY KEY,
    address VARCHAR(200) NOT NULL,
    rating_on_yandex_maps FLOAT,
    year_of_opening INTEGER
);

-- Создание таблицы departments
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    clinic_id INTEGER REFERENCES clinics(clinic_id),
    department_name VARCHAR(50) NOT NULL,
    head_of_department VARCHAR(100)
);

-- Создание таблицы doctors
CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY,
    department_id INTEGER REFERENCES departments(department_id),
    doctor_name VARCHAR(50) NOT NULL,
    doctor_patronymic VARCHAR(50) NOT NULL,
    doctor_surname VARCHAR(50) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    alma_mater VARCHAR(100),
    phone_number VARCHAR(20),
    vacation_status BOOLEAN,
    valid_from DATE,
    valid_to DATE
);

-- Создание таблицы patients
CREATE TABLE patients (
    patients_id INTEGER PRIMARY KEY,
    patient_name VARCHAR(50) NOT NULL,
    patient_patronymic VARCHAR(50) NOT NULL,
    patient_surname VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    valid_from DATE,
    valid_to DATE
);

-- Создание таблицы appointment
CREATE TABLE appointment (
    appointment_id SERIAL PRIMARY KEY,
    doctor_id INTEGER REFERENCES doctors(doctor_id),
    patients_id INTEGER REFERENCES patients(patients_id),
    appointment_time TIMESTAMP NOT NULL
);

-- Создание таблицы analysis
CREATE TABLE analysis (
    analysis_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointment(appointment_id),
    sample_type VARCHAR(50) NOT NULL,
    target_molecule VARCHAR(50),
    analysis_method VARCHAR(50)
);

-- Создание таблицы prescription
CREATE TABLE prescription (
    prescription_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointment(appointment_id),
    drug_name VARCHAR(50) NOT NULL,
    dose VARCHAR(50),
    duration INTERVAL
);

-- Создание таблицы clinical_note
CREATE TABLE clinical_note (
    clinical_note_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointment(appointment_id),
    symptoms VARCHAR(200),
    diagnosis VARCHAR(200) NOT NULL
);

