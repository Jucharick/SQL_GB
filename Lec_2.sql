show databases;
use gb_db;

# здесь комментарий

-- здесь комментарий

/* и здесь тоже комментарий 
на несколько
строк*/

/*CREATE TABLE table_name
(
column_name_1 column_type_1,
column_name_2 column_type_2,
column_name_N column_type_N,
);*/

-- table_name — имя таблицы;
-- column_name — имя столбца;
-- column_type — тип данных столбца.

CREATE TABLE Customers
(
Id INT PRIMARY KEY AUTO_INCREMENT, -- первичный уникальный ключ
Age INT,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
Phone VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Orders
(
Id INT PRIMARY KEY AUTO_INCREMENT, -- первичный уникальный ключ
CustomerId INT,
CreatedAt Date,
FOREIGN KEY (CustomerId) REFERENCES Customers (Id) -- внешний ключ из таблицы Customer
);

-- Арифметические операции

SELECT 3+5;
SELECT 3-5;
SELECT 3*5;
SELECT 3/5;
SELECT 102/0;

CREATE TABLE Products
(
Id INT AUTO_INCREMENT PRIMARY KEY,
ProductName VARCHAR(30) NOT NULL,
Manufacturer VARCHAR(20) NOT NULL,
ProductCount INT DEFAULT 0,
Price DECIMAL
);

-- Логические операторы

-- AND: операция логического И
SELECT * FROM Products
WHERE Manufacturer = 'Samsung' AND Price > 50000;

-- OR: операция логического ИЛИ
SELECT * FROM Products
WHERE Manufacturer = 'Samsung' OR Price > 50000;

-- NOT: операция логического отрицания
SELECT * FROM Products
WHERE NOT Manufacturer = 'Samsung';

-- Приоритет операций
SELECT * FROM Products
WHERE Manufacturer ='Samsung' OR NOT Price > 30000 AND ProductCount > 2;
--  1. NOT Price > 30000   2. NOT Price > 30000 AND ProductCount > 2   3. оператор OR

-- переопределили приоритет операций
SELECT * FROM Products
WHERE Manufacturer ='Samsung' OR NOT (Price > 30000 AND ProductCount > 2);
--  1. Price > 30000 AND ProductCount > 2   2. NOT   3. оператор OR

-- Оператор CASE
SELECT ProductName, ProductCount,
CASE
	WHEN ProductCount = 1
		THEN 'Товар заканчивается'
	WHEN ProductCount = 2
		THEN 'Мало товара'
	WHEN ProductCount = 3
		THEN 'Есть в наличии'
	ELSE 'Много товара'
END AS Category
FROM Products;

-- Функция IF
/* Если условие, передаваемое в качестве первого параметра,
верно, то возвращается первое значение, иначе возвращается
второе значение. */
SELECT ProductName, Manufacturer,
IF(ProductCount > 3, 'Много товара', 'Мало товара')
FROM Products;

-- Запросы изменения данных (insert, update, delete)

-- INSERT – вставка новых данных
INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8', 'Samsung', 1, 41000),
('P20 Pro', 'Huawei', 5, 36000);

-- Команда UPDATE - обновление данных
UPDATE Products
SET Price = Price + 3000;

-- отключить безопасный режим SET SQL_SAFE_UPDATES = 0;

-- Команда DELETE - удаление данных
DELETE FROM Products
WHERE Manufacturer='Huawei';


-- оператор IN / NOT IN
select * from Products;

select * from Products
where Manufacturer in ('Apple','Samsung');

select * from Products
where Manufacturer not in ('Apple','Samsung');
	-- аналогично
select * from Products
where not Manufacturer in ('Apple','Samsung');