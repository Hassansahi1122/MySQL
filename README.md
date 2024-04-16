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

