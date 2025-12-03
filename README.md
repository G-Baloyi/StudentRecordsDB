## 📘 StudentRecordsDB

### 📖 Overview
StudentRecordsDB is a SQL Server database project designed to manage student, program, course, and enrollment information for a university. It demonstrates relational design, constraints, indexing best practices, advanced query logic, and professional enhancements such as stored procedures, triggers, and analytics.
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
│
├── StudentRecordsDB.sql     # Full schema: CREATE DATABASE + tables + constraints
├── data_dump.sql            # Raw SQL data dump: INSERT statements for all tables
├── queries.sql              # Advanced SQL queries for analysis and validation
├── enhancements.sql         # Indexes, views, triggers, procedures, roles, and analytics queries
├── sample_data.sql          # Optional sample inserts for quick testing
└── README.md                # Project documentation

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 🚀 How to Run
1. Open SQL Server Management Studio (SSMS).
2. Execute StudentRecordsDB.sql to create the database and schema.
3. Execute data_dump.sql to populate all tables with realistic data.
4. Run queries.sql to explore advanced relationships and validation logic.
5. Run enhancements.sql to add indexes, views, triggers, stored procedures, roles, and analytics queries.
6. Verify setup with a quick test:

USE StudentRecordsDB;
SELECT * FROM Programs;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 🧪 Queries
- See queries.sql for advanced queries such as:
- Students with their program and department.
- Students who completed courses with grade A.
- Student counts per program.
- Course prerequisites.
- Students missing prerequisites.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### 📌 Notes
Designed for SQL Server 2019+.
Uses constraints, foreign keys, and indexes for integrity and performance.
Includes realistic sample data, advanced queries, and enhancements for testing and demonstration.
Ideal for showcasing relational design, query optimization, and automation.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
