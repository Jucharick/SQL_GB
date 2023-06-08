CREATE DATABASE home_work_5;
USE home_work_5;

CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

-- LOAD DATA INFILE
--     'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\test_db.csv' 
-- INTO TABLE
--     cars 
-- FIELDS TERMINATED BY ';' -- разделитель полей
-- ENCLOSED BY '"' -- обрамление полей
-- LINES TERMINATED BY '\n' -- конец строки
-- IGNORE 1 ROWS; -- первую строку пропускаем, в ней заголовки
-- 
-- SELECT * FROM cars;
-- 
-- show variables like 'secure_file_priv';

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT * FROM cars;

-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
DROP VIEW IF EXISTS view_cars;
CREATE VIEW view_cars 
AS SELECT * 
FROM cars
WHERE cost < 25000;

SELECT * FROM view_cars;

-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW view_cars 
AS SELECT * 
FROM cars
WHERE cost < 30000;

SELECT * FROM view_cars;










