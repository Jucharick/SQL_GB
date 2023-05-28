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

SELECT * FROM Products
LIMIT 2,3; -- пропускаем 2 записи и выводим 3

SELECT * FROM Products
LIMIT 3; -- выводим 3 (по умолчанию)

/*
Оператор LIMIT
Оператор LIMIT позволяет извлечь определённый диапазон
записей из одной или нескольких таблиц

TOP - SQL Server, MS Access
LIMIT - MySQL, PostgreSQL, SQLite
FETCH FIRST - Oracle
*/


-- Уникальные значения - distinct
SELECT DISTINCT Manufacturer FROM Products;


/*
GROUP BY
Оператор GROUP BY определяет, как строки будут
группироваться.
Например, сгруппируем товары по производителю
*/
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer;
/*
Первый столбец в выражении SELECT - Manufacturer
представляет название группы, а второй столбец - ModelsCount
представляет результат функции Count, которая вычисляет
количество строк в группе.
*/


/*
Агрегатные функции — count, sum, avg, обработка Null
Агрегатные функции вычисляют некоторые скалярные значения
в наборе строк. 
AVG: вычисляет среднее значение
SUM: вычисляет сумму значений
MIN: вычисляет наименьшее значение
MAX: вычисляет наибольшее значение
COUNT: вычисляет количество строк в запросе
*/
SELECT AVG(price) AS Average_price
FROM Products;

SELECT SUM(ProductCount) AS ProductCount
FROM Products;

SELECT MIN(price) AS Average_price
FROM Products;
SELECT MAX(price) AS Average_price
FROM Products;

SELECT MAX(price) AS Average_price_Apple
FROM Products
WHERE Manufacturer = 'Apple';

SELECT COUNT(*) AS Count_line
FROM Products;


/*
Оператор HAVING позволяет выполнить фильтрацию групп, то
есть определяет, какие группы будут включены в выходной
результат.Использование HAVING во многом аналогично
применению WHERE. Только если WHERE применяется для
фильтрации строк, то HAVING - для фильтрации групп.
*/

SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer
HAVING COUNT(*) > 1;

SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM Products
WHERE Price * ProductCount > 80000
GROUP BY Manufacturer
HAVING COUNT(*) > 1;

