USE StudentRecordsDB;
GO

/* ============================================================
   QUERIES FOR STUDENT RECORDS DB
   Author: Goitsemang Baloyi
   ============================================================ */

-- 1. List students with their program and department
SELECT s.student_number, s.first_name, s.last_name,
       p.name AS program_name,
       d.name AS department_name
FROM Students s
JOIN Programs p ON s.program_id = p.program_id
JOIN Departments d ON p.department_id = d.department_id
ORDER BY d.name, p.name;

-- 2. Find students who completed a course with grade A
SELECT s.student_number, s.first_name, s.last_name,
       c.course_code, c.title, e.grade
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Sections sec ON e.section_id = sec.section_id
JOIN Courses c ON sec.course_id = c.course_id
WHERE e.grade = 'A';

-- 3. Count students per program
SELECT p.program_code, p.name AS program_name,
       COUNT(s.student_id) AS student_count
FROM Programs p
LEFT JOIN Students s ON p.program_id = s.program_id
GROUP BY p.program_code, p.name
ORDER BY student_count DESC;

-- 4. Show course prerequisites
SELECT c.course_code AS course,
       p.course_code AS prerequisite
FROM CoursePrerequisites cp
JOIN Courses c ON cp.course_id = c.course_id
JOIN Courses p ON cp.prerequisite_course_id = p.course_id
ORDER BY c.course_code;

-- 5. Students missing prerequisites
SELECT s.student_number, s.first_name, s.last_name,
       c.course_code, c.title
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Sections sec ON e.section_id = sec.section_id
JOIN Courses c ON sec.course_id = c.course_id
JOIN CoursePrerequisites cp ON c.course_id = cp.course_id
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e2
    JOIN Sections sec2 ON e2.section_id = sec2.section_id
    WHERE e2.student_id = s.student_id
      AND sec2.course_id = cp.prerequisite_course_id
      AND e2.grade IS NOT NULL
);

