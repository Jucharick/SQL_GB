show databases;
use gb_db;

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
