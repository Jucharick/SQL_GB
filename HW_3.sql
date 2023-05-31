use gb_db;

-- Часть 1

-- Создание таблицы
CREATE TABLE IF NOT EXISTS salespeople (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  snum INT, 
  sname VARCHAR(45), 
  city VARCHAR(45), 
  comm FLOAT
);

-- Заполнение данными

INSERT INTO salespeople(snum, sname, city, comm)
VALUES
(1001, "Peel", "London", 0.12),
(1002, "Serres", "San Jose", 0.13),
(1004, "Motika", "London", 0.11),
(1007, "Rifkin", "Barcelona", 0.15),
(1003, "Axelrod", "New York", 0.10);

SELECT * FROM salespeople;

-- Создание таблицы
CREATE TABLE IF NOT EXISTS customers (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  cnum INT, 
  cname VARCHAR(45), 
  city VARCHAR(45), 
  rating INT,
  snum INT NOT NULL
);

-- Заполнение данными
INSERT INTO customers(cnum, cname, city, rating, snum)
VALUES
(2001, "Hoffman", "London", 100, 1001),
(2002, "Giovanni", "Rome", 200, 1003),
(2003, "Liu", "SanJose", 200, 1002),
(2004, "Grass", "Berlin", 300, 1002),
(2006, "Clemens", "London", 100, 1001),
(2008, "Cisneros", "SanJose", 300, 1007),
(2007, "Pereira", "Rome", 100, 1004);

SELECT * FROM customers;

-- Создание таблицы
DROP TABLE orders;
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  onum INT, 
  amt FLOAT,
  odate DATE,
  cnum INT NOT NULL,
  snum INT NOT NULL
);

-- Заполнение данными
INSERT INTO orders(onum, amt, odate, cnum, snum)
VALUES
(3001, 18.69, '1990-03-10', 2008, 1007),
(3003, 767.19, '1990-03-10', 2001, 1001),
(3002, 1900.10, '1990-03-10', 2007, 1004),
(3005, 5160.45, '1990-03-10', 2003, 1002),
(3006, 1098.16, '1990-03-10', 2008, 1007),
(3009, 1713.23, '1990-04-10', 2002, 1003),
(3007, 75.75, '1990-04-10', 2004, 1002),
(3008, 4723.00, '1990-05-10', 2006, 1001),
(3010, 1309.95, '1990-06-10', 2004, 1002),
(3011, 9891.88, '1990-06-10', 2006, 1001);

SELECT * FROM orders;

-- 1. Напишите запрос, который вывел бы таблицу со столбцами в следующем порядке: city, sname,
-- snum, comm. (к первой или второй таблице, используя SELECT)
SELECT city, sname, snum, comm 
FROM salespeople;

-- 2. Напишите команду SELECT, которая вывела бы оценку(rating), сопровождаемую именем
-- каждого заказчика в городе San Jose. (“заказчики”)
SELECT rating, cname
FROM customers
WHERE city = 'SanJose';

-- 3. Напишите запрос, который вывел бы значения snum всех продавцов из таблицы заказов без
-- каких бы то ни было повторений. (уникальные значения в “snum“ “Продавцы”)
SELECT DISTINCT snum
FROM orders;


-- 4*. Напишите запрос, который бы выбирал заказчиков, чьи имена начинаются с буквы G.
-- Используется оператор "LIKE": (“заказчики”) https://dev.mysql.com/doc/refman/8.0/en/string-comparisonfunctions.html
SELECT *
FROM customers
WHERE cname LIKE 'G%';

-- 5. Напишите запрос, который может дать вам все заказы со значениями суммы выше чем $1,000.
-- (“Заказы”, “amt” - сумма)
SELECT *
FROM orders
WHERE amt > 1000;


-- 6. Напишите запрос который выбрал бы наименьшую сумму заказа.
-- (Из поля “amt” - сумма в таблице “Заказы” выбрать наименьшее значение)
SELECT MIN(amt) AS Min_order
FROM orders;

-- 7. Напишите запрос к таблице “Заказчики”, который может показать всех заказчиков, у которых
-- рейтинг больше 100 и они находятся не в Риме.
SELECT * 
FROM customers
WHERE rating > 100 AND city != 'Rome';


-- Часть 2

-- Создание таблицы
CREATE TABLE IF NOT EXISTS staff (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  first_name VARCHAR(45), 
  last_name VARCHAR(45), 
  post VARCHAR(45), 
  seniority INT, 
  -- DECIMAL(общее количество знаков, количество знаков после запятой)
  -- DECIMAL(5,2) будут числа от -999.99 до 999.99
  salary DECIMAL(8, 2), 
  -- это числа от -999999.99 до 999999.99
  age INT
);

-- Заполнение данными

INSERT  staff (first_name, last_name, post, seniority, salary, age)
VALUES
	 ('Вася', 'Петров', 'Начальник', 40, 100000, 60),
	 ('Петр', 'Власов', 'Начальник', 8, 70000, 30),
	 ('Катя', 'Катина', 'Инженер', 2, 70000, 25),
	 ('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
	 ('Иван', 'Петров', 'Рабочий', 40, 30000, 59),
	 ('Петр', 'Петров', 'Рабочий', 20, 55000, 60),
	 ('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
	 ('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
	 ('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
	 ('Максим', 'Петров', 'Рабочий', 2, 11000, 19),
	 ('Юрий', 'Петров', 'Рабочий', 3, 12000, 24),
	 ('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);
 
SELECT * FROM staff;

-- 1. Отсортируйте поле “зарплата” в порядке убывания и возрастания
SELECT * 
FROM staff
ORDER BY salary DESC;

SELECT * 
FROM staff
ORDER BY salary;


-- 2. ** Отсортируйте по возрастанию поле “Зарплата” и выведите 5 строк с
-- наибольшей заработной платой (возможен подзапрос)
SELECT * 
FROM (SELECT * FROM staff ORDER BY salary DESC LIMIT 5) AS salary 
ORDER BY salary;


-- 3. Выполните группировку всех сотрудников по специальности ,
-- суммарная зарплата которых превышает 100000
SELECT 
	MIN(salary) AS "Мин зп",
    MAX(salary) AS "Макс зп",
    ROUND(AVG(salary),2) AS "Средняя зп",
    COUNT(salary) AS "Количество сотрудников",
    SUM(salary) AS "Суммарная зп"
FROM staff
GROUP BY post
HAVING SUM(salary) > 100000;
