DROP DATABASE IF EXISTS lesson4;
CREATE DATABASE lesson4;
USE lesson4;

-- Создадим две таблицы — tbl1 и tbl2, которые будут содержать единственный столбец value:
CREATE TABLE tbl1 (
  value VARCHAR(255)
);
INSERT INTO tbl1
VALUES ('fst1'), ('fst2'), ('fst3');

CREATE TABLE tbl2 (
  value VARCHAR(255)
);
INSERT INTO tbl2
VALUES ('snd1'), ('snd2'), ('snd3');


-- Посмотрим содержимое таблиц.
SELECT * FROM tbl1;
SELECT * FROM tbl2;

-- Чтобы создать соединение этих двух таблиц, 
-- их имена следует перечислить после ключевого слова FROM через запятую.

SELECT * FROM tbl1, tbl2; -- это cross join
SELECT * FROM tbl1 JOIN tbl2; -- это cross join
SELECT * FROM tbl1 CROSS JOIN tbl2; -- это cross join


-- Если мы попробуем явно запросить поле value, мы получим сообщение об ошибке:
SELECT value FROM tbl1, tbl2;

-- СУБД не может определить, столбец какой таблицы — tbl1 или tbl2 — имеется в виду. 
-- Чтобы исключить неоднозначность, можно использовать квалификационные имена:

SELECT tbl1.value, tbl2.value FROM tbl1, tbl2;


-- Для символа звездочки также можно использовать квалификационное имя:
SELECT tbl1.*, tbl2.* FROM tbl1, tbl2;


-- -----------------------------
-- Поработаем с двумя таблицами
CREATE TABLE IF NOT EXISTS teacher
(	
	id INT NOT NULL PRIMARY KEY,
    surname VARCHAR(45),
    salary INT
);

INSERT teacher
VALUES
	(1, "Авдеев", 17000),
    (2, "Гущенко", 27000),
    (3, "Пчелкин", 32000),
    (4, "Питошин", 15000),
    (5, "Вебов", 45000),
    (6, "Шарпов", 30000),
    (7, "Шарпов", 40000),
    (8, "Питошин", 30000);;
    

CREATE TABLE IF NOT EXISTS lesson
(	
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    course VARCHAR(45),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teacher(id)
);

INSERT INTO lesson(course,teacher_id)
VALUES
	("Знакомство с веб-технологиями", 1),
    ("Знакомство с веб-технологиями", 2),
    ("Знакомство с языками программирования", 3),
    ("Базы данных и SQL", 4); -- Учитель, который ведет данный предмет, временно отстутствует

SELECT * FROM teacher;
SELECT * FROM lesson;


SELECT t.surname, l.course, l.teacher_id, t.id
FROM 
  teacher t -- teacher = t
JOIN 
  lesson l; -- lesson = l
# нет условия - получаем cross join
  
-- Нам редко требуется выводить всевозможные комбинации строк соединяемых таблиц. 
-- Чаще количество строк в результирующей таблице ограничивается при помощи условия

-- Получим инфо о учителях и курсах, которые они ведут 
SELECT t.surname, l.course, l.teacher_id, t.id
FROM teacher t -- teacher = t
JOIN lesson l -- lesson = l
WHERE l.teacher_id =  t.id; -- Условие сое-я


-- При использовании соединения вместо WHERE-условия используется ON:
-- Получим инфо о учителях и курсах, которые они ведут 
SELECT t.surname, l.course, l.teacher_id, t.id
FROM teacher t -- teacher = t
JOIN lesson l -- lesson = l
ON l.teacher_id =  t.id; -- Условие сое-я

-- Получим фамилию учителей, зп и курсы, которые они ведут в 1 строчке
SELECT 
    CONCAT(t.surname, ", зп: ", t.salary, ", ведет курс: ", l.course) AS "Информация"
FROM teacher t -- teacher = t
JOIN lesson l -- lesson = l
ON l.teacher_id =  t.id; -- Условие сое-я


-- Неявное соединение таблиц 
SELECT 
	CONCAT(t.surname, ", зп: ", t.salary, ", ведет курс: ", l.course) AS "Информация"
FROM teacher t, lesson l
WHERE l.teacher_id =  t.id;


-- Получим всех учителей, даже если они ничего не ведут
SELECT t.surname, l.course, l.teacher_id, t.id
FROM teacher t -- teacher = t
LEFT JOIN lesson l -- lesson = l
ON l.teacher_id =  t.id; -- Условие сое-я


-- Получим учителей, которые халявничают
SELECT t.surname, l.course, l.teacher_id, t.id
FROM teacher t -- teacher = t
LEFT JOIN lesson l -- lesson = l
ON l.teacher_id = t.id
WHERE l.teacher_id IS NULL;


UPDATE teacher t -- teacher = t
LEFT JOIN lesson l -- lesson = l
ON l.teacher_id = t.id
SET t.surname = CONCAT(t.surname, " ", "(Он вообще ничего не сделал)"),
t.salary = t.salary - t.salary * 0.25
WHERE l.teacher_id IS NULL;

SELECT * FROM teacher;


-- Получим учителей, которые ведут "Знакомство с веб-технологиями"
-- 1. JOIN
SELECT t.surname, l.course, l.teacher_id, t.id
FROM teacher t 
JOIN lesson l
ON l.teacher_id = t.id
WHERE l.course = "Знакомство с веб-технологиями";

SELECT * FROM lesson;
SELECT * FROM teacher;


-- Если мы не хотим удалять из таблицы teacher записи, 
-- то после ключевого слова DELETE мы должны указать только одну таблицу lesson.
DELETE t, l
FROM teacher t 
JOIN lesson l
ON l.teacher_id = t.id
WHERE l.course = "Базы данных и SQL";


-- Подзапрос  
SELECT t.*, w_l.*
FROM teacher t 
JOIN (SELECT course, teacher_id 
FROM lesson WHERE course = "Знакомство с веб-технологиями") AS w_l
ON t.id = w_l.teacher_id;

SELECT *
FROM lesson 
WHERE course = "Знакомство с веб-технологиями";

SELECT *
FROM (SELECT * FROM lesson WHERE course = "Знакомство с веб-технологиями" ) l;

SELECT t.*, l.*
FROM teacher t
CROSS JOIN lesson l;

SELECT id
FROM teacher -- id = 1 - 8 (первые 8 строчек - id из таблицы teacher)
UNION ALL
SELECT teacher_id
FROM lesson; -- id = 1-4



-- UNION

create table users
(
    id  int auto_increment primary key,
    login varchar(255) null,
    pass  varchar(255) null,
    male  tinyint      null
);

create table clients
(
    id    int auto_increment primary key,
    login varchar(255) null,
    pass  varchar(255) null,
    male  tinyint      null
);

INSERT INTO users (login, pass, male) VALUES ('alex', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);
INSERT INTO users (login, pass, male) VALUES ('Mikle', '$ws$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);
INSERT INTO users (login, pass, male) VALUES ('Olia', '$2y$10$88zbBCKLJklStIgTqBKIluijJUnbeZ5WqJI4RJgkksnFZon5kH14y', 2);
INSERT INTO users (login, pass, male) VALUES ('Tom', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH20y', 1);
INSERT INTO users (login, pass, male) VALUES ('Margaret', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ4wqIu4RJgkksnFZon5kH20y', 2);
INSERT INTO users (login, pass, male) VALUES ('alex', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);

INSERT INTO clients (login, pass, male) VALUES ('alexander', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);
INSERT INTO clients (login, pass, male) VALUES ('Mikle', '$ws$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);
INSERT INTO clients (login, pass, male) VALUES ('Olia', '$2y$10$88zbBCKLJklStIgTqBKIluijJUnbeZ5WqJI4RJgkksnFZon5kH14y', 2);
INSERT INTO clients (login, pass, male) VALUES ('Dmitry', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH20y', 1);
INSERT INTO clients (login, pass, male) VALUES ('Margaret', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ4wqIu4RJgkksnFZon5kH20y', 2);
INSERT INTO clients (login, pass, male) VALUES ('Leonid', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);
INSERT INTO clients (login, pass, male) VALUES ('Mikle', '$ws$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);
INSERT INTO clients (login, pass, male) VALUES ('Olga', '$2y$10$88zbBCKLJklStIgTqBKIluijJUnbeZ5WqJI4RJgkksnFZon5kH14y', 2);
INSERT INTO clients (login, pass, male) VALUES ('Tom', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH20y', 1);
INSERT INTO clients (login, pass, male) VALUES ('Masha', '$2y$20$6SzbBCNRNklStIgTqBKIluijJUnbeZ4wqIu4RJgkksnFZon5kH20y', 2);
INSERT INTO clients (login, pass, male) VALUES ('alex', '$2y$10$6SzbBCMENklStIgTqBKIluijJUnbeZ5WqIu4RJgkksnFZon5kH14y', 1);


-- Задание на EXISTS
CREATE TABLE Employee (
  Id INT PRIMARY KEY,
  Name VARCHAR(45) NOT NULL,
  Department VARCHAR(45) NOT NULL,
  Salary FLOAT NOT NULL,
  Gender VARCHAR(45) NOT NULL,
  Age INT NOT NULL,
  City VARCHAR(45) NOT NULL
);
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1001, 'John Doe', 'IT', 35000, 'Male', 25, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1002, 'Mary Smith', 'HR', 45000, 'Female', 27, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1003, 'James Brown', 'Finance', 50000, 'Male', 28, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1004, 'Mike Walker', 'Finance', 50000, 'Male', 28, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1005, 'Linda Jones', 'HR', 75000, 'Female', 26, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1006, 'Anurag Mohanty', 'IT', 35000, 'Male', 25, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1007, 'Priyanla Dewangan', 'HR', 45000, 'Female', 27, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1008, 'Sambit Mohanty', 'IT', 50000, 'Male', 28, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1009, 'Pranaya Kumar', 'IT', 50000, 'Male', 28, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1010, 'Hina Sharma', 'HR', 75000, 'Female', 26, 'Mumbai');
CREATE TABLE Projects (
 ProjectId INT PRIMARY KEY AUTO_INCREMENT,
      Title VARCHAR(200) NOT NULL,
     ClientId INT,
 EmployeeId INT,
     StartDate DATETIME,
     EndDate DATETIME
);
INSERT INTO Projects ( Title, ClientId, EmployeeId, StartDate, EndDate) VALUES 
('Develop ecommerse website from scratch', 1, 1003, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
('WordPress website for our company', 1, 1002, NOW(), DATE_ADD(NOW(), INTERVAL 45 DAY)),
('Manage our company servers', 2, 1007, NOW(), DATE_ADD(NOW(), INTERVAL 45 DAY)),
('Hosting account is not working', 3, 1009, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
('MySQL database from my desktop application', 4, 1010, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY)),
('Develop new WordPress plugin for my business website', 2, NULL, NOW(), DATE_ADD(NOW(), INTERVAL 10 DAY)),
('Migrate web application and database to new server', 2, NULL, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY)),
('Android Application development', 4, 1004, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY));

-- Собеседования
CREATE TABLE  AUTO 
(       
	REGNUM VARCHAR(10) PRIMARY KEY, 
	MARK VARCHAR(10), 
	COLOR VARCHAR(15),
	RELEASEDT DATE, 
	PHONENUM VARCHAR(15)
);


CREATE TABLE  CITY 
(	
    CITYCODE INT PRIMARY KEY,
	CITYNAME VARCHAR(50), 
	PEOPLES INT 
);


CREATE TABLE  MAN 
(	
	PHONENUM VARCHAR(15) PRIMARY KEY , 
	FIRSTNAME VARCHAR(50),
	LASTNAME VARCHAR(50),  
	CITYCODE INT, 
	YEAROLD INT	 
);


 -- AUTO
INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111114,'LADA', 'КРАСНЫЙ', date'2008-01-01', '9152222221');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111115,'VOLVO', 'КРАСНЫЙ', date'2013-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111116,'BMW', 'СИНИЙ', date'2015-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111121,'AUDI', 'СИНИЙ', date'2009-01-01', '9173333332');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111122,'AUDI', 'СИНИЙ', date'2011-01-01', '9213333336');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111113,'BMW', 'ЗЕЛЕНЫЙ', date'2007-01-01', '9214444444');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111126,'LADA', 'ЗЕЛЕНЫЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111117,'BMW', 'СИНИЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111119,'LADA', 'СИНИЙ', date'2017-01-01', 9213333331);


 -- CITY
INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(1,'Москва', 10000000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(2,'Владимир', 500000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(3, 'Орел', 300000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(4,'Курск', 200000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(5, 'Казань', 2000000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(7, 'Котлас', 110000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(8, 'Мурманск', 400000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(9, 'Ярославль', 500000);

-- MAN
INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9152222221','Андрей','Николаев', 1, 22);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9152222222','Максим','Москитов', 1, 31);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9153333333','Олег','Денисов', 3, 34);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9173333334','Алиса','Никина', 4, 31);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9173333335','Таня','Иванова', 4, 31);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9213333336','Алексей','Иванов', 7, 25);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9213333331','Андрей','Некрасов', 2, 27);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9213333332','Миша','Рогозин', 2, 21);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9214444444','Алексей','Галкин', 1, 38);


