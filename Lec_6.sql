USE gb_db;

-- Транзакция — это набор последовательных операций с базой данных, соединенных в
-- одну логическую единицу.
-- Транзакцией называется атомарная группа запросов SQL, т. е. запросы, которые
-- рассматриваются как единое целое. Если база данных может выполнить всю группу
-- запросов, она делает это, но если любой из них не может быть выполнен в результате
-- Курс базы данных и SQL. Лекция 6 2
-- сбоя или по какой-то другой причине, не будет выполнен ни один запрос группы. Все
-- или ничего.

-- Изоляция — это свойство транзакции, которое позволяет скрывать изменения,
-- внесенные одной операцией транзакции при возникновении явления race condition

-- Процедура - это подпрограмма (например, подпрограмма) на обычном языке
-- сценариев, хранящаяся в базе данных.

-- ACID - это набор из четырех требований к транзакционной системе, обеспечивающих
-- максимально надежную и предсказуемую работу.


DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT,
total DECIMAL (11,2) COMMENT 'Счет',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Счета пользователей и интернет магазина';

INSERT INTO accounts (user_id, total)
VALUES
(4, 5000.00),
(3, 0.00),
(2, 200.00),
(NULL, 25000.00);

SELECT * FROM accounts;


-- -----------------------------------------------------------------------------
START TRANSACTION;
-- Далее выполняем команды, входящие в транзакцию:
SELECT total FROM accounts WHERE user_id = 4;
-- Убеждаемся, что на счету пользователя достаточно средств:
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;
-- Снимаем средства со счета пользователя:
UPDATE accounts SET total = total + 2000 WHERE user_id IS NULL;
-- Чтобы изменения вступили в
-- силу, мы должны выполнить команду COMMIT
COMMIT;
-- cкрипт выполнять полностью: начиная от первой и до самой последней строчки

SELECT * FROM accounts;
-- Если команда проходит без ошибок, изменения фиксируются базой данных 


-- Если мы выясняем, что не можем завершить транзакцию, например, пользователь ее
-- отменяет или происходит еще что-то. Чтобы ее отметить мы можем воспользоваться
-- командой ROLLBACK:

START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;
UPDATE accounts SET total = total + 2000 WHERE user_id IS NULL;
ROLLBACK; -- Откат до исходного состояния


-- Для некоторых операторов нельзя выполнить откат при помощи оператора ROLLBACK.
-- К их числу
-- относят следующие команды:
-- ● CREATE INDEX
-- ● DROP INDEX
-- ● CREATE TABLE
-- ● DROP TABLE
-- ● TRUNCATE TABLE
-- ● ALTER TABLE
-- ● RENAME TABLE
-- ● CREATE DATABASE
-- ● DROP DATABASE
-- ● ALTER DATABASE
-- Не помещайте их в транзакции с другими операторами. Кроме того, существует ряд
-- операторов, которые неявно завершают транзакцию, как если бы был вызван оператор
-- COMMIT:
-- ● ALTER TABLE
-- ● BEGIN
-- ● CREATE INDEX
-- ● CREATE TABLE
-- ● CREATE DATABASE
-- ● DROP DATABASE
-- ● DROP INDEX
-- Курс базы данных и SQL. Лекция 6 5
-- ● DROP TABLE
-- ● DROP DATABASE
-- ● LOAD MASTER DATA
-- ● LOCK TABLES
-- ● RENAME
-- ● SET AUTOCOMMIT=1
-- ● START TRANSACTION
-- ● TRUNCATE TABLE
-- В случае сбоя в транзакции откат можно делать до некой точки сохранения -
-- SAVEPOINT.


-- -----------------------------------------------------------------------------
-- Точка сохранения представляет собой место в последовательности событий
-- транзакции, которое может выступать в качестве промежуточной точки
-- восстановления. Откат текущей транзакции может быть выполнен не к началу
-- транзакции, а к точке сохранения.
-- Для работы с точками сохранения предназначены два оператора:
-- ● SAVEPOINT
-- ● ROLLBACK TO SAVEPOINT

START TRANSACTION;
SELECT total FROM accounts WHERE user_id = 4;
SAVEPOINT accounts_4;
UPDATE accounts SET total = total - 2000 WHERE user_id = 4;
-- Допустим мы хотим отменить транзакцию и вернуться в точку сохранения. В этом случае мы можем
-- воспользоваться оператором ROLLBACK TO SAVEPOINT:
ROLLBACK TO SAVEPOINT accounts_4;
SELECT * FROM accounts;

-- Допускается создание нескольких точек сохранения. Если текущая транзакция имеет
-- точку сохранения с таким же именем, старая точка удаляется и устанавливается новая. Все
-- точки сохранения транзакций удаляются, если выполняется оператор COMMIT или
-- ROLLBACK без указания имени точки сохранения.


-- -----------------------------------------------------------------------------
-- Транзакций недостаточно, если система не удовлетворяет принципу ACID.
-- Аббревиатура ACID расшифровывается как атомарность, согласованность, изолированность и
-- сохраняемость).
-- ● Atomicy — атомарность.
-- ● Consistency — согласованность.
-- ● Isolation — изолированность.
-- ● Durability — сохраняемость.
-- 
-- Атомарность подразумевает, что транзакция должна функционировать как единая
-- неделимая единица. Вся транзакция была либо выполняется, либо отменяется. Когда транзакции
-- атомарны, не существует такого понятия, как частично выполненная транзакция.
-- 
-- При выполнении принципа согласованности база данных должна всегда переходить
-- из одного непротиворечивого состояния в другое непротиворечивое состояние.
-- В нашем примере согласованность гарантирует, что сбой между двумя UPDATEкомандами не приведет к исчезновению 2000 рублей 
-- со счета пользователя. Транзакция просто не будет зафиксирована, и ни одно из изменений в этой транзакции
-- не будет отражено в базе данных.
-- 
-- Изолированность подразумевает, что результаты транзакции обычно невидимы
-- другим транзакциям, пока она не закончена. Это гарантирует, что, если в нашем
-- примере во время транзакции будет выполнен запрос на извлечение средств
-- пользователя, такой запрос по-прежнему будет видеть 2000 рублей на его счету.
-- 
-- Сохраняемость гарантирует, что изменения, внесенные в ходе транзакции, будучи
-- зафиксированными, становятся постоянными. Это означает, что изменения должны
-- быть записаны так, чтобы данные не могли быть потеряны в случае сбоя системы.


-- -----------------------------------------------------------------------------
-- Уровни изоляции

-- Стандарт SQL
-- определяет четыре уровня изоляции с конкретными правилами, устанавливающими,
-- какие изменения видны внутри и вне транзакции, а какие нет:
-- ● READ UNCOMMITTED
-- ● READ COMMITTED
-- ● REPEATABLE READ
-- ● SERIALIZABLE

-- Более низкие уровни изоляции обычно допускают большую степень совместного
-- доступа и вызывают меньше накладных расходов. На первом уровне изоляции, READ
-- UNCOMMITTED, транзакции могут видеть результаты незафиксированных транзакций.
-- На практике READ UNCOMMITTED используется редко, поскольку его
-- производительность не намного выше, чем у других. На этом уровне вы видите
-- промежуточные результаты чужих транзакций, т.е. осуществляете грязное чтение.

-- Уровень READ COMMITTED подразумевает, что транзакция увидит только те
-- изменения, которые были уже зафиксированы другими транзакциями к моменту ее
-- начала. Произведенные ею изменения останутся невидимыми для других транзакций,
-- пока она не будет зафиксирована. На этом уровне возможен феномен
-- невоспроизводимого чтения. Это означает, что вы можете выполнить одну и ту же
-- команду дважды и получить различный результат.

-- Уровень изоляции REPEATABLE READ решает проблемы, которые возникают на
-- уровне READ UNCOMMITTED. Он гарантирует, что любые строки, которые
-- считываются в контексте транзакции, будут выглядеть такими же при
-- последовательных операциях чтения в пределах одной и той же транзакции, однако
-- теоретически на этом уровне возможен феномен фантомного чтения (phantom reads).
-- Он возникает в случае, если вы выбираете некоторый диапазон строк, затем другая
-- транзакция вставляет новую строку в этот диапазон, после чего вы выбираете тот же
-- диапазон снова. В результате вы увидите новую фантомную строку. 

-- Уровень изоляции REPEATABLE READ установлен по умолчанию.
-- Самый высокий уровень изоляции, SERIALIZABLE, решает проблему фантомного
-- чтения, заставляя транзакции выполняться в таком порядке, чтобы исключить
-- возможность конфликта. Уровень SERIALIZABLE блокирует каждую строку, которую
-- транзакция читает.


-- -----------------------------------------------------------------------------
-- Переменные

SELECT @total := COUNT(*) FROM accounts;

-- Объявление переменной начинается с символа @, за которым следует имя
-- переменной. Значения переменным присваиваются посредством оператора SELECT с
-- использованием оператора присваивания :=. В следующих запросах мы получаем
-- возможность обращаться к переменной:

SELECT @total;

-- Переменные также могут объявляться при помощи оператора SET. Команда SET, в
-- отличие от оператора SELECT, не возвращает результирующую таблицу:

SET @last = NOW() - INTERVAL 7 DAY; -- от текущей даты отнять 7 дней
SELECT CURDATE(), @last;


-- -----------------------------------------------------------------------------
-- Временная таблица

-- В MySQL временная таблица — это особый тип таблицы, который позволяет вам
-- сохранить временный набор результатов, который вы можете повторно использовать
-- несколько раз в одном сеансе. Временная таблица очень удобна, когда невозможно запрашивать
-- данные, требующие одного SELECT оператора с JOIN предложениями.
-- 
-- Временная таблица автоматически удаляется по завершении соединения с сервером,
-- а ее имя действительно только в течение данного соединения. Это означает, что два разных
-- клиента могут использовать временные таблицы с одинаковыми именами без
-- конфликта друг с другом или с существующей таблицей с тем же именем.

CREATE TEMPORARY TABLE temp (id INT, name VARCHAR(255));
DESCRIBE temp; -- Показ всех столлбцов в таблице temp


-- -----------------------------------------------------------------------------
-- Хранимые процедуры и функции

-- Хранимые процедуры и функции позволяют сохранить последовательность SQLоператоров и
-- вызывать их по имени функции или процедуры:
-- ● CREATE PROCEDURE procedure_name
-- ● CREATE FUNCTION function_name
-- Разница между процедурой и функцией заключается в том, что функции возвращают
-- значение и их можно встраивать в SQL-запросы, в то время как хранимые процедуры
-- вызываются явно.

-- -----------------------------------------------------------------------------
-- Процедуры
-- DELIMITER {custom delimiter}
-- CREATE PROCEDURE {proc_name}([optional parameters])
-- BEGIN
-- // procedure body...
-- // procedure body...
-- END
-- {custom delimiter}

-- delimiter  - это команда, которая необходима для изменения разделителя SQLинструкций с  ;  на  //  во время определения процедуры. Это позволяет
-- разделитель  ;  использовать в теле процедуры для передачи на сервер.
-- proc_name  - уникальное имя хранимой процедуры, длиной не более 64 символа.

-- Имена процедур не чувствительны к регистру, поэтому в одной схеме не может
-- быть двух событий с именами  procname  и  ProcName ;

-- в процедуру можно передать параметры ( optional_parametrs )

-- IN - Параметр может ссылаться на процедуру. Значение параметра не может быть
-- перезаписано процедурой.
-- OUT - Параметр не может ссылаться на процедуру, но значение параметра может быть
-- перезаписано процедурой.
-- IN OUT - Параметр может ссылаться на процедуру, и значение параметра может быть
-- перезаписано процедурой.

-- процедуру, которая выводит текущую версию MySQL-сервера:
DELIMITER //
CREATE PROCEDURE my_version ()
BEGIN
SELECT VERSION();
END //
-- CALL proc_name;
CALL my_version (); -- Вызов процедуры

-- список хранимых процедур
SHOW PROCEDURE STATUS; -- Все процедуры
SHOW PROCEDURE STATUS LIKE 'my_version%'; -- Конкретная процедура
-- При использовании ключевого слова
-- LIKE можно вывести информацию только о тех процедурах,
-- имена которых удовлетворяют шаблону

DROP PROCEDURE IF EXISTS my_version;

-- -----------------------------------------------------------------------------
-- Функции
CREATE FUNCTION get_version ()
RETURNS TEXT DETERMINISTIC
BEGIN
RETURN VERSION();
END -- Процедура не до конца написана

-- Функция создается командой CREATE FUNCTION, после которой идет имя функции.
-- Хранимая функция встраивается в SQL-запросы, как обычная mysql-функция. Она должна
-- возвращать значение. 
-- 
-- Ключевое слово RETURNS указывает возвращаемый тип,
-- например TEXT мы можем заменить на VARCHAR(255).
-- 
-- Ключевое слово DETERMINISTIC (дэтеминистик) сообщает, что результат функции детерминирован,
-- т.е., при каждом вызове будет возвращаться одно и то же значение, и если его
-- закешировать в рамках запроса, ничего страшного не произойдет. Если значения,
-- которые возвращает функция, каждый раз различны, то перед DETERMINISTIC
-- (дэтеминистик) следует добавить отрицание NOT.
-- 
-- Далее следует тело функции, которое размещается между ключевыми словами BEGIN и END. 
-- 
-- Внутри тела обязательно должно присутствовать ключевое слово RETURN, которое возвращает
-- результат вычисления. В данном случае мы просто возвращаем результат вызова
-- mysql-функции VERSION().

SELECT get_version();


-- -----------------------------------------------------------------------------
-- Ветвление
-- Оператор IF позволяет реализовать ветвление программы по условию. IF принимает
-- значение либо TRUE (истину), либо FALSE (ложь). В MySQL TRUE и FALSE —
-- константы для целочисленных значений 1 и 0. Если логическое выражение истинно, IF
-- Курс базы данных и SQL. Лекция 6 17
-- выполняет SQL-выражения, которые размещаются в теле команды между ключевыми
-- словами THEN и END IF.

DELIMITER //
DROP PROCEDURE IF EXISTS format_now //
CREATE PROCEDURE format_now (format CHAR(4))
BEGIN
IF(format = 'date') THEN
SELECT DATE_FORMAT(NOW(), "%d.%m.%Y") AS format_now;
ELSE
SELECT DATE_FORMAT(NOW(), "%H:%i:%s") AS format_now;
END IF;
END//
CALL format_now('date')//
CALL format_now('time')//


-- -----------------------------------------------------------------------------
-- Циклы

-- WHILE
DELIMITER //
CREATE PROCEDURE while_cycle ()
BEGIN
DECLARE i INT DEFAULT 3;
WHILE i > 0 DO
SELECT NOW();
SET i = i - 1;
END WHILE;
END//

CALL while_cycle()// 


DELIMITER //
DROP PROCEDURE IF EXISTS while_cycle;

CREATE PROCEDURE while_cycle (IN num INT)
BEGIN
DECLARE i INT DEFAULT 0;
IF (num > 0) THEN
WHILE i < num DO
SELECT NOW();
SET i = i + 1;
END WHILE;
ELSE
SELECT 'Ошибочное значение параметра';
END IF;
END//

CALL while_cycle(2)//


-- Оператор REPEAT похож на оператор WHILE

-- Однако условие для покидания цикла располагается не в начале тела цикла, а в конце.
-- В результате тело цикла в любом случае выполняется хотя бы один раз. В конце цикла
-- после ключевого слова UNTIL располагается условие; если оно истинно, работа цикла
-- прекращается, если ложно, происходит еще одна итерация. Эта хранимая процедура
-- должна выполняться в теле цикла три раза.

DELIMITER //
DROP PROCEDURE IF EXISTS repeat_cycle//
CREATE PROCEDURE repeat_cycle ()
BEGIN
DECLARE i INT DEFAULT 3;
REPEAT
SELECT NOW();
SET i = i - 1;
UNTIL i <= 0
END REPEAT;
END//
CALL repeat_cycle()//

-- Цикл LOOP, в отличие от операторов WHILE и REPEAT, не имеет условий выхода.
-- Поэтому он должен обязательно иметь в составе оператор LEAVE.

DELIMITER //
DROP PROCEDURE IF EXISTS loop_cycle//
CREATE PROCEDURE loop_cycle ()
BEGIN
DECLARE i INT DEFAULT 3;
cycle: LOOP
SELECT NOW();
SET i = i - 1;
IF i <= 0 THEN LEAVE cycle;
END IF;
END LOOP cycle;
END//
CALL loop_cycle()//

-- Так как мы используем оператор LEAVE, мы должны разместить перед ключевым
-- словом LOOP и после END LOOP метку. Здесь она называется cycle.