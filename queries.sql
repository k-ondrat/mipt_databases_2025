-- Запрос списка клиник с рейтингом выше 4.0, открытых после 2015 года (WHERE, ORDER BY)
SELECT clinic_id, address, rating_on_yandex_maps, year_of_opening
FROM clinics
WHERE rating_on_yandex_maps > 4.0 AND year_of_opening > 2015
ORDER BY rating_on_yandex_maps DESC;

-- Запрос количества врачей по специализациям (GROUP BY, HAVING)
SELECT specialization, COUNT(*) as doctor_count
FROM doctors
GROUP BY specialization
HAVING COUNT(*) > 0
ORDER BY doctor_count DESC;

-- Запрос списка врачей по отделениям с адресом (INNER JOIN)
SELECT d.doctor_name, d.doctor_surname, d.specialization, 
       dep.department_name, c.address
FROM doctors d
INNER JOIN departments dep ON d.department_id = dep.department_id
INNER JOIN clinics c ON dep.clinic_id = c.clinic_id;

-- Запрос списка самых частых пациентов (больше всего записей на приём) (GROUP BY, ORDER BY, LIMIT)
SELECT p.patient_name, p.patient_surname, COUNT(a.appointment_id) as appointment_count
FROM patients p
JOIN appointment a ON p.patients_id = a.patients_id
GROUP BY p.patients_id
ORDER BY appointment_count DESC
LIMIT 5;

-- Запрос направлений на анализы (оконная функция)
SELECT a.analysis_id, a.sample_type, a.target_molecule,
       COUNT(*) OVER (PARTITION BY a.sample_type) as samples_of_type
FROM analysis a
ORDER BY samples_of_type DESC;

-- Запрос самых популярных диагнозов (GROUP BY, HAVING)
SELECT diagnosis, COUNT(*) as diagnosis_count
FROM clinical_note
GROUP BY diagnosis
HAVING COUNT(*) > (SELECT AVG(cnt) FROM (SELECT COUNT(*) as cnt FROM clinical_note GROUP BY diagnosis) as avg_counts)
ORDER BY diagnosis_count DESC;

-- Запрос с пагинацией (пропускаем 12 и выводим 10) (LIMIT, OFFSET)
SELECT patients_id, patient_surname, patient_name, patient_patronymic, date_of_birth
FROM patients
ORDER BY patient_surname, patient_name
LIMIT 10 OFFSET 12;

-- Запрос последней и изменённой версии по врачу с doctor_id = 1 (версионирование)
SELECT * 
FROM doctors 
WHERE original_doctor_id = 1 OR doctor_id = 1
ORDER BY valid_from DESC;

-- Запрос всех записей в порядке возрастания возраста пациента для каждого доктора
WITH YoungestPacients AS (
    select row_number() over (order by date_of_birth) as row, * 
    from patients
) 
select doctor_id, patient_name, patient_surname, date_of_birth, appointment_time 
from YoungestPacients 
JOIN appointment on appointment.patients_id = YoungestPacients.patients_id 
order by doctor_id, row desc;

-- Запрос списка препаратов, которые назначили хотя бы двум людям до 2015 года рождения (не более 10)
select drug_name, count(*) as prescription_count
from prescription
    JOIN appointment on prescription.appointment_id = appointment.appointment_id
    JOIN patients on appointment.patients_id = patients.patients_id
where date_of_birth < DATE '2015-01-01'
group by prescription.drug_name
having count(*) > 1
order by drug_name
limit 10;