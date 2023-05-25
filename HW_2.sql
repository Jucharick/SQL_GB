USE gb_db;

-- 1. Используя операторы языка SQL, создайте таблицу “sales”. Заполните ее данными.
CREATE TABLE IF NOT EXISTS sales (
  id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  order_date DATE NOT NULL,
  count_product INT UNSIGNED -- UNSIGNED убираем отрицательные значения
);

DESCRIBE sales; -- запрашиваем структуру таблицы

INSERT INTO sales (order_date, count_product)
VALUES 
('2022-01-01', 156),
('2022-01-02', 180),
('2022-01-03', 21),
('2022-01-04', 124),
('2022-01-05', 341);

SELECT * FROM sales;

-- 2. Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва : меньше 100 - Маленький заказ, от 100 до 300 - Средний заказ, больше 300 - Большой заказ
SELECT id AS 'id заказа', -- Перед CASE ставится запятая
CASE
	WHEN count_product < 100 THEN "Маленький заказ"
    WHEN count_product >= 100 AND count_product < 300 THEN "Средний заказ"
	WHEN count_product >= 300 THEN "Большой заказ"
    ELSE "Нет данных"
END AS 'Тип заказа'
FROM sales;
