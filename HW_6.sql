DROP DATABASE IF EXISTS home_work_6;
CREATE DATABASE home_work_6;
USE home_work_6;

-- 1. Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней часов. 
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

DROP FUNCTION IF EXISTS return_daytime;

DELIMITER //
CREATE FUNCTION return_daytime (in_value INT)
RETURNS TEXT
NO SQL
BEGIN
  DECLARE d INT;
  DECLARE h INT;
  DECLARE m INT;
  DECLARE s INT;
  DECLARE res TEXT;

  SET d = floor(in_value / (24 * 3600));
  SET in_value = in_value % (24 * 3600);
  SET h = floor(in_value / 3600);
  SET in_value = in_value % 3600;
  SET m = floor(in_value / 60);
  SET in_value = in_value % 60;
  SET s = in_value;
  
  SET res = CONCAT(d, ' days ', h, ' hours ', m, ' minutes ', s, ' seconds');
  RETURN res;
END //
DELIMITER ;

SELECT return_daytime(123456);
SELECT return_daytime(123456789);


-- 2. Выведите только четные числа от 1 до 10 (Через цикл).
-- Пример: 2,4,6,8,10

DROP FUNCTION IF EXISTS even_numbers;

DELIMITER //
CREATE FUNCTION even_numbers (num INT)
RETURNS TEXT
NO SQL
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE res TEXT DEFAULT '';
  
  IF (num > 0) THEN
	WHILE i <= num DO
      SET i = i + 1;
	  IF (i % 2 = 0) THEN
        SET res = CONCAT(res, i, ', ');
	  END IF;
	END WHILE;
  END IF;
  
  RETURN SUBSTRING(res, 1, LENGTH(res) - 2);
END //
DELIMITER ;

SELECT even_numbers(10) as even;
SELECT even_numbers(100) as even;
