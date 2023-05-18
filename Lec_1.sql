USE gb_myfirstdb;
SELECT *  FROM students;

SELECT fio, pass
FROM students
WHERE login = 'test123';

INSERT INTO students (fio, login, pass, email) VALUES ('Dmitrev Dmitrii Dmitrievich', 'test12345', '12345', 'test12345@gmail.com');
INSERT INTO students (fio, login, pass, email) VALUES ('Fdfsdgf kkkk Dbgfmgm', 'test123456', '123456', 'test123456@gmail.com');
SELECT *  FROM students;

DELETE FROM students WHERE idtest = '7';