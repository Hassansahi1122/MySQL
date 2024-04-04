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
