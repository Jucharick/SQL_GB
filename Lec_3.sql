use gb_db;

SELECT * FROM Products
ORDER BY Price;

SELECT ProductName, ProductCount * Price AS TotalSum
FROM Products
ORDER BY TotalSum;

SELECT ProductName, Price, ProductCount
FROM Products
ORDER BY ProductCount * Price;

/*
ASC
Необязательный. ASC сортирует результирующий набор в
порядке возрастания по expressions. Это поведение по
умолчанию, если модификатор не указан.
DESC
Необязательный. DESC сортирует результирующий набор в
порядке убывания по expressions
*/

/*
Оператор LIMIT
Оператор LIMIT позволяет извлечь определённый диапазон
записей из одной или нескольких таблиц

TOP - SQL Server, MS Access
LIMIT - MySQL, PostgreSQL, SQLite
FETCH FIRST - Oracle
*/

SELECT * FROM Products
LIMIT 2,3; -- пропускаем 2 записи и выводим 3

SELECT * FROM Products
LIMIT 3; -- выводим 3 (по умолчанию)
