## 📘 StudentRecordsDB

### 📖 Overview
StudentRecordsDB is a SQL Server database project designed to manage student, program, course, and enrollment information for a university. It demonstrates relational design, constraints, indexing best practices, and advanced query logic. The project is ideal for showcasing database design and SQL mastery in a portfolio setting.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 🛠 Features
- **[Departments]**: Stores department codes, names, and descriptions.  
- **[Programs]**: Links academic programs to departments with degree levels and durations.  
- **[Students]**: Captures student details, enrollment year, and program associations.  
- **[Instructors]**: Manages faculty records tied to departments.  
- **[StudentAddresses]**: Supports multiple address types per student.  
- **[Courses]**: Defines courses with credits and departmental ownership.  
- **[CoursePrerequisites]**: Enforces prerequisite relationships between courses.  
- **[Sections]**: Represents course offerings by term, year, and instructor.  
- **[Enrollments]**: Tracks student registrations, grades, and statuses.  
- **[SystemUsers]**: Provides authentication and role management for students and instructors.  

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 📂 File Structure
```
StudentRecordsDB_Assignment/
StudentRecordsDB_Assignment/
│
├── StudentRecordsDB.sql     # Full schema: CREATE DATABASE + tables + constraints
├── data_dump.sql            # Raw SQL data dump: INSERT statements for all tables
├── queries.sql              # Advanced SQL queries for analysis and validation
├── sample_data.sql          # Optional sample inserts for quick testing
└── README.md                # Project documentation

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 🚀 How to Run
Open SQL Server Management Studio (SSMS).

Execute StudentRecordsDB.sql to create the database and schema.

Execute data_dump.sql to populate all tables with realistic data.

Run queries.sql to explore advanced relationships and validation logic.

Verify setup with a quick test:

sql
USE StudentRecordsDB;
SELECT * FROM Programs;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 🧪 Queries
```sql
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

```

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 📌 Notes
Designed for SQL Server 2019+.

Uses constraints, foreign keys, and indexes for integrity and performance.

Includes realistic sample data and advanced queries for testing and demonstration.

Ideal for showcasing relational design, query optimization, and portfolio projects.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
