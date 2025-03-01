CREATE TABLE IF NOT exists hw (
    id INTEGER,
    height FLOAT4,
    weight FLOAT4
);

INSERT INTO hw (id, height, weight) VALUES
(1, 68.5, 150.2),
(2, 72.0, 180.5),
(3, 65.0, 120.0),
(4, 70.2, 160.8),
(5, 74.8, 190.3),
(6, 63.5, 110.7),
(7, 69.0, 145.6),
(8, 71.5, 175.4),
(9, 67.0, 130.9),
(10, 73.2, 185.0);

SELECT 
	MIN(height) AS min_height,
	MAX(height) AS max_height,
	MIN(weight) AS min_weight,
	MAX(weight) AS max_weight
FROM hw;

SELECT
    weight / POWER(height, 2) * 703 * 1.0001092375 AS bmi
FROM hw;

SELECT
	count(*) AS underweight_count
FROM hw
WHERE weight / POWER(height, 2) * 703 * 1.0001092375 < 18.5;

SELECT id,
	weight / POWER(height, 2) * 703 * 1.0001092375 AS bmi,
    CASE
        WHEN (weight / POWER(height, 2) * 703 * 1.0001092375) < 18.5 THEN 'underweight'
        WHEN (weight / POWER(height, 2) * 703 * 1.0001092375) < 25 THEN 'normal'
        WHEN (weight / POWER(height, 2) * 703 * 1.0001092375) < 30 THEN 'overweight'
        WHEN (weight / POWER(height, 2) * 703 * 1.0001092375) < 35 THEN 'obese'
        ELSE 'extremely obese'
    END AS type
FROM hw
ORDER BY  bmi DESC;

