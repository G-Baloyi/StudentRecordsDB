## 📘 StudentRecordsDB

### 📖 Overview
The **StudentRecordsDB** project is a SQL Server database schema designed to manage student, program, course, and enrollment information for a university. It demonstrates relational design, constraints, and indexing best practices.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 📂 File Structure
```
StudentRecordsDB_Assignment/
│
├── StudentRecordsDB.sql   # Schema: CREATE DATABASE + tables + indexes
├── sample_data.sql        # Sample INSERT statements for testing
└── README.md              # Documentation
```

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 🚀 How to Run
1. Open **SQL Server Management Studio (SSMS)**.  
2. Load `StudentRecordsDB.sql` → Execute to create the database and tables.  
3. Load `sample_data.sql` → Execute to insert test data.  
4. Verify by running:
   ```sql
   USE StudentRecordsDB;
   SELECT * FROM Programs;
   ```

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 🧪 Example Queries
```sql
-- List all programs with their department names
SELECT p.program_code, p.name AS program_name, d.name AS department_name
FROM Programs p
JOIN Departments d ON p.department_id = d.department_id;

-- Show students with their enrolled programs
SELECT s.student_number, s.first_name, s.last_name, p.name AS program_name
FROM Students s
LEFT JOIN Programs p ON s.program_id = p.program_id;

-- Count enrollments per course section
SELECT section_id, COUNT(*) AS total_enrolled
FROM Enrollments
GROUP BY section_id;
```

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 📌 Notes
- Designed for **SQL Server 2019+**.  
- Uses constraints, foreign keys, and indexes for integrity and performance.  
- Sample data provided for quick testing.  

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
