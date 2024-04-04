# MySQL
## Query
```
CREATE VIEW Student_record 
AS
SELECT stu.student_id,stu.name 'Student Name',stu.email AS 'Student Email',t.Name AS Teacher,de.department_name,s.section_name,GROUP_CONCAT(DISTINCT bo.book_name SEPARATOR ', ') as Course FROM assign a JOIN
class_department_section class ON a.class_department_section_id = class.id 
JOIN sections s ON class.section_id = s.section_id
JOIN departments de ON class.department_id = de.department_id
JOIN book_author ba ON a.book_author_id = ba.id
JOIN books bo ON ba.book_id = bo.book_id 
JOIN teachers t USING (teacher_id) 
JOIN timings_weekday ti on a.timings_weekday_id = ti.id
JOIN students_admission stu ON
a.class_department_section_id = stu.id
GROUP BY stu.student_id ;
```
## Table
| Name            | Email                        | Teacher        | Subject | Grade | Course                     |
|-----------------|------------------------------|----------------|---------|-------|--------------------------|
| Shehbaz         | Shehbaz@gmail.com            | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Abdul Rehman    | AbdulRehman@gmail.com        | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Arslan          | Arslan@gmail.com             | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| RajaHaider ali  | RajaHaider@gmail.com         | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Noman Nadeem    | NomanNadeem@gmail.com        | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Salman Ahmad    | SalmanAhmad@gmail.com        | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Shaukat         | shaukat39@gmail.com          | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Asif Ahmad Khan | Asif20772@gmail.com          | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Soban Farooq    | sobiii777@gmail.com          | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Huzaifa Kaleem  | HuzaifaTheSpirited@gmail.com | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Hadiya          | hadiya727@gmail.com          | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Laraib Ishtiaq  | Laraib7426@gmail.com         | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Zainab Mehboob  | The_Zealous@gmail.com        | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Umair Hassan    | oatitude3310@gmail.com       | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Inam Ul Haq     | cyber-fanatic@gmail.com      | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Hunzilah        | Hunzilah16@gmail.com         | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Hamza Ahmed     | DryRunHamza@gmail.com        | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|
| Uzair           | uzair-py@gmail.com           | Muhammad Hashim| Science | A     | JavaScript, MySql, Python|

