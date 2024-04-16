# MySQL
## Query
```
CREATE VIEW Sir_Hashim
AS
SELECT stu.student_id,
stu.name 'Student Name',
stu.email AS 'Student Email',
t.Name AS Teacher,
de.department_name Department,
s.section_name Section,
GROUP_CONCAT(DISTINCT bo.book_name SEPARATOR ', ') as Course,
GROUP_CONCAT(DISTINCT wee.day_name SEPARATOR '/') AS days
FROM assign a JOIN
class_department_section class ON a.class_department_section_id = class.id 
JOIN sections s ON class.section_id = s.section_id
JOIN departments de ON class.department_id = de.department_id
JOIN book_author ba ON a.book_author_id = ba.id
JOIN books bo ON ba.book_id = bo.book_id 
JOIN teachers t USING (teacher_id) 
JOIN timings_weekday ti on a.timings_weekday_id = ti.id
JOIN weekday wee ON ti.day_id = wee.day_id
JOIN students_admission stu ON
a.class_department_section_id = stu.id
WHERE a.class_department_section_id = 20 && t.Name = 'MUhammad Hashim'
GROUP by stu.student_id;
```
## Table
| student_id | Student Name      | Student Email            | Teacher         | Department | Section | Course                   | days                      |
|------------|-------------------|--------------------------|-----------------|------------|---------|--------------------------|---------------------------|
| 1          | Shehbaz           | Shehbaz@gmail.com        | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 2          | Abdul Rehman      | AbdulRehman@gmail.com    | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 3          | Arslan            | Arslan@gmail.com         | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 4          | RajaHaider ali    | RajaHaider@gmail.com     | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 5          | Noman Nadeem      | NomanNadeem@gmail.com    | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 6          | Salman Ahmad      | SalmanAhmad@gmail.com    | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 7          | Shaukat           | shaukat39@gmail.com      | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 8          | Asif Ahmad Khan   | Asif20772@gmail.com      | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 9          | Soban Farooq      | sobiii777@gmail.com      | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 10         | Huzaifa Kaleem    | HuzaifaTheSpirited@gmail.com | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 11         | Hadiya            | hadiya727@gmail.com      | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 12         | Laraib Ishtiaq    | Laraib7426@gmail.com     | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 13         | Zainab Mehboob    | The_Zealous@gmail.com    | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 14         | Umair Hassan      | oatitude3310@gmail.com   | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 15         | Inam Ul Haq       | cyber-fanatic@gmail.com  | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 16         | Hunzilah          | Hunzilah16@gmail.com     | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 17         | Hamza Ahmed       | DryRunHamza@gmail.com    | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
| 18         | Uzair             | uzair-py@gmail.com       | Muhammad Hashim | Science    | A       | JavaScript, MySql, Python| Monday/Tuesday/Wednesday  |
## Create Procedure
```
DROP PROCEDURE IF EXISTS Access;
DELIMITER $$
CREATE PROCEDURE Access(IN Email VARCHAR(255), IN class INT, IN section VARCHAR(5), IN department VARCHAR(15))
BEGIN
      DECLARE cmsg VARCHAR(255);
      DECLARE name VARCHAR(50);
      SELECT t.Name INTO name FROM teachers t WHERE t.Email = Email; 
    -- Check if the email is null or empty
    IF Email IS NULL OR Email = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email cannot be null or empty';
    -- Check if the email exists in the table
    ELSEIF NOT EXISTS (SELECT 1 FROM teachers t WHERE t.Email = Email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email does not exist';

    -- Check if the class and section are null
    ELSEIF class IS NULL AND (section IS NULL OR section = '') AND (department IS NULL OR department = '') THEN
        -- Show all class and section related to the email
     SELECT 
    c.class_name AS Classes, 
    s.section_name Section, 
    d.department_name AS Departments,
    b.book_name AS courses
FROM 
    assign assi
    JOIN class_department_section cds ON assi.class_department_section_id = cds.id
    JOIN classes c ON cds.class_id = c.class_id
    JOIN departments d ON cds.department_id = d.department_id
    JOIN sections s ON cds.section_id = s.section_id
    JOIN book_author ba ON assi.book_author_id = ba.id
    JOIN books b USING(book_id)
    JOIN teachers t USING(teacher_id)
WHERE 
    t.Email = 'HashimThePassionate@gmail.com'
GROUP BY
    c.class_name, 
    s.section_name, 
    d.department_name,
    b.book_name;
     
    ELSEIF class IS NOT NULL AND (section IS NULL OR section = '') AND (department IS NULL OR department = '') THEN
    IF NOT EXISTS (SELECT 1 FROM assign a JOIN teachers t USING(teacher_id) JOIN
  class_department_section cds ON a.class_department_section_id = cds.id
  JOIN classes c USING(class_id)
  WHERE t.Email = Email AND c.class_id = class) THEN
   SET cmsg = CONCAT_WS(' ','The Class',class,'not assign to',name);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = cmsg;
    END IF;
    ELSEIF class IS NOT NULL AND (section IS NOT NULL OR section <> '') AND (department IS NOT NULL OR department <> '') THEN
         SELECT 
    c.class_name AS Classes, 
    s.section_name Section, 
    d.department_name AS Departments,
    b.book_name AS courses
FROM 
    assign assi
    JOIN class_department_section cds ON assi.class_department_section_id = cds.id
    JOIN classes c ON cds.class_id = c.class_id
    JOIN departments d ON cds.department_id = d.department_id
    JOIN sections s ON cds.section_id = s.section_id
    JOIN book_author ba ON assi.book_author_id = ba.id
    JOIN books b USING(book_id)
    JOIN teachers t USING(teacher_id)
WHERE 
    t.Email = 'HashimThePassionate@gmail.com' AND c.class_id = class AND s.section_name = section AND d.department_name = department
GROUP BY
    c.class_name, 
    s.section_name, 
    d.department_name,
    b.book_name;
    END IF;
END$$
DELIMITER ;
```
