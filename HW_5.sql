CREATE DATABASE home_work_5;
USE home_work_5;

DROP TABLE IF EXISTS cars;

CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

show variables like 'secure_file_priv';

-- загружаю данные из файла
LOAD DATA INFILE
    'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\test_db.csv' 
INTO TABLE cars 
FIELDS TERMINATED BY ',' -- разделитель полей
ENCLOSED BY '"' -- обрамление полей
LINES TERMINATED BY '\n' -- конец строки
IGNORE 1 ROWS; -- первую строку пропускаем, в ней заголовки

SELECT * FROM cars;

-- INSERT cars
-- VALUES
-- 	   (1, "Audi", 52642),
--     (2, "Mercedes", 57127 ),
--     (3, "Skoda", 9000 ),
--     (4, "Volvo", 29000),
-- 	   (5, "Bentley", 350000),
--     (6, "Citroen ", 21000 ), 
--     (7, "Hummer", 41400), 
--     (8, "Volkswagen ", 21600);

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

-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
DROP VIEW IF EXISTS audi_skoda;

CREATE VIEW audi_skoda 
AS SELECT * 
FROM cars
WHERE name IN ("Audi ","Skoda "); -- как применить TRIM ?

SELECT * FROM audi_skoda;

-- 4. Добавьте новый столбец под названием «время до следующей станции»
DROP TABLE IF EXISTS trains;
CREATE TABLE trains
(
	train_id INT,
    station VARCHAR(45),
    station_time TIME
);

INSERT INTO trains 
VALUES (110,'San Francisco','10:00:00'),
	   (110,'Redwood City','10:54:00'),
	   (110,'Palo Alto','11:02:00'),
	   (110,'San Jose','12:35:00'),
	   (120,'San Francisco','11:00:00'),
	   (120,'Palo Alto','12:49:00'),
	   (120,'San Jose','13:30:00');

SELECT * FROM trains;

SELECT
  train_id,
  station,
  station_time,
  SUBTIME(LEAD(station_time) OVER(PARTITION BY train_id ), station_time) AS time_to_next_station
FROM trains;

