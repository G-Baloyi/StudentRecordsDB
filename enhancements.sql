USE StudentRecordsDB;
GO

/* ============================================================
   ENHANCEMENTS FOR STUDENT RECORDS DB
   Author: Goitsemang Baloyi
   ============================================================ */

---------------------------------------------------------------
-- 1. Indexes
---------------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_Students_StudentNumber
ON Students(student_number);

CREATE NONCLUSTERED INDEX IX_Courses_CourseCode
ON Courses(course_code);

CREATE NONCLUSTERED INDEX IX_Students_ProgramId
ON Students(program_id);

---------------------------------------------------------------
-- 2. Stored Procedures
---------------------------------------------------------------
-- Enroll a student in a section
CREATE PROCEDURE EnrollStudent
    @StudentId INT,
    @SectionId INT
AS
BEGIN
    INSERT INTO Enrollments (student_id, section_id, status)
    VALUES (@StudentId, @SectionId, 'Enrolled');
END;
GO

-- Generate grade report for a student
CREATE PROCEDURE GetStudentGrades
    @StudentId INT
AS
BEGIN
    SELECT c.course_code, c.title, e.grade
    FROM Enrollments e
    JOIN Sections sec ON e.section_id = sec.section_id
    JOIN Courses c ON sec.course_id = c.course_id
    WHERE e.student_id = @StudentId;
END;
GO

---------------------------------------------------------------
-- 3. Views
---------------------------------------------------------------
CREATE VIEW vw_StudentProgramDepartment AS
SELECT s.student_number, s.first_name, s.last_name,
       p.name AS program_name,
       d.name AS department_name
FROM Students s
JOIN Programs p ON s.program_id = p.program_id
JOIN Departments d ON p.department_id = d.department_id;

---------------------------------------------------------------
-- 4. Triggers
---------------------------------------------------------------
-- Prevent enrollment if prerequisites not met
CREATE TRIGGER trg_CheckPrerequisites
ON Enrollments
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Enrollments e
        JOIN Sections sec ON e.section_id = sec.section_id
        JOIN CoursePrerequisites cp ON sec.course_id = cp.course_id
        WHERE e.student_id IN (SELECT student_id FROM inserted)
          AND NOT EXISTS (
              SELECT 1
              FROM Enrollments e2
              JOIN Sections sec2 ON e2.section_id = sec2.section_id
              WHERE e2.student_id = e.student_id
                AND sec2.course_id = cp.prerequisite_course_id
                AND e2.grade IS NOT NULL
          )
    )
    BEGIN
        RAISERROR ('Prerequisite not satisfied', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

---------------------------------------------------------------
-- 5. Constraints
---------------------------------------------------------------
ALTER TABLE Enrollments
ADD CONSTRAINT CK_Enrollments_Grade
CHECK (grade IN ('A','B','C','D','E','F'));

ALTER TABLE Courses
ADD CONSTRAINT CK_Courses_Credits
CHECK (credits > 0);

---------------------------------------------------------------
-- 6. Audit Tables
---------------------------------------------------------------
CREATE TABLE GradeAudit (
    audit_id INT IDENTITY PRIMARY KEY,
    student_id INT,
    course_id INT,
    old_grade CHAR(1),
    new_grade CHAR(1),
    changed_at DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_AuditGrades
ON Enrollments
AFTER UPDATE
AS
BEGIN
    IF UPDATE(grade)
    BEGIN
        INSERT INTO GradeAudit (student_id, course_id, old_grade, new_grade)
        SELECT e.student_id, sec.course_id, d.grade, e.grade
        FROM Enrollments e
        JOIN Sections sec ON e.section_id = sec.section_id
        JOIN deleted d ON e.enrollment_id = d.enrollment_id;
    END
END;
GO

---------------------------------------------------------------
-- 7. Security Roles
---------------------------------------------------------------
CREATE ROLE InstructorRole;
GRANT SELECT ON Sections TO InstructorRole;
GRANT SELECT ON Enrollments TO InstructorRole;

CREATE ROLE AdminRole;
GRANT CONTROL ON DATABASE::StudentRecordsDB TO AdminRole;

---------------------------------------------------------------
-- 8. Analytics Queries
---------------------------------------------------------------
-- Instructor workload
SELECT i.first_name, i.last_name,
       COUNT(sec.section_id) AS sections_taught
FROM Instructors i
JOIN Sections sec ON i.instructor_id = sec.instructor_id
GROUP BY i.first_name, i.last_name;

