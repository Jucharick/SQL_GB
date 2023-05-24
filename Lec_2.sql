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


-- Логические операторы

CREATE TABLE Products
(
Id INT AUTO_INCREMENT PRIMARY KEY,
ProductName VARCHAR(30) NOT NULL,
Manufacturer VARCHAR(20) NOT NULL,
ProductCount INT DEFAULT 0,
Price DECIMAL
);

-- AND: операция логического И
SELECT * FROM Products
WHERE Manufacturer = 'Samsung' AND Price > 50000;

-- OR: операция логического ИЛИ
SELECT * FROM Products
WHERE Manufacturer = 'Samsung' OR Price > 50000;

-- NOT: операция логического отрицания
SELECT * FROM Products
WHERE NOT Manufacturer = 'Samsung';



