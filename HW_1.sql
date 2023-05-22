use gb_db;
SELECT * FROM phones;

-- 2. Выведите название, производителя и цену для товаров, количество которых превышает 2 
select ProductName, Manufacturer, Price
from phones
where ProductCount > 2;

-- 3. Выведите весь ассортимент товаров марки “Samsung”
select *
from phones
where Manufacturer = 'Samsung';

-- 4. С помощью регулярных выражений найти:
	-- Товары, в которых есть упоминание "Iphone"
select * from phones where ProductName like '%Iphone%';

	-- "Samsung"
select * from phones where ProductName like '%Samsung%';

	-- Товары, в которых есть ЦИФРЫ
select * from phones where ProductName regexp '[0-9]';

	-- Товары, в которых есть ЦИФРА "8"  
select * from phones where ProductName regexp '[8]';


-- оператор REGEXP выполняет сопоставление string_column с шаблоном pattern
		-- ^	соответствует позиции в начале искомой строки
		-- $	соответствует позиции в конце искомой строки
		-- […]	соответствует любому символу, указанному в квадратных скобках
		-- [^ …]	соответствует любому символу, не указанному в квадратных скобках