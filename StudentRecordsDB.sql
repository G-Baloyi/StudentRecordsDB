CREATE DATABASE [StudentRecordsDB];
GO

USE [StudentRecordsDB];
GO

-- Departments
CREATE TABLE [Departments] (
    [department_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [department_code] NVARCHAR(20) NOT NULL UNIQUE,
    [name] NVARCHAR(200) NOT NULL,
    [description] NVARCHAR(1000) NULL,
    [created_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    [created_by] NVARCHAR(100) NULL
);
GO

-- Programs
CREATE TABLE [Programs] (
    [program_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [program_code] NVARCHAR(20) NOT NULL UNIQUE,
    [name] NVARCHAR(200) NOT NULL,
    [department_id] INT NOT NULL,
    [degree_level] NVARCHAR(50) NOT NULL 
        CHECK ([degree_level] IN ('Associate','Bachelor','Master','Doctorate','Certificate')),
    [duration_months] INT NULL CHECK ([duration_months] >= 0),
    [created_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [fk_program_department] FOREIGN KEY ([department_id]) 
        REFERENCES [Departments]([department_id]) ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

-- Students
CREATE TABLE [Students] (
    [student_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [student_number] NVARCHAR(30) NOT NULL UNIQUE,
    [first_name] NVARCHAR(100) NOT NULL,
    [middle_name] NVARCHAR(100) NULL,
    [last_name] NVARCHAR(100) NOT NULL,
    [preferred_name] NVARCHAR(100) NULL,
    [date_of_birth] DATE NOT NULL,
    [email] NVARCHAR(320) NULL UNIQUE,
    [phone] NVARCHAR(50) NULL,
    [program_id] INT NULL,
    [enrollment_year] INT NULL CHECK ([enrollment_year] >= 1900 AND [enrollment_year] <= YEAR(GETDATE()) + 10),
    [student_metadata] NVARCHAR(MAX) NULL,
    [is_active] BIT NOT NULL DEFAULT 1,
    [created_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    [created_by] NVARCHAR(100) NULL,
    [modified_at] DATETIME2 NULL,
    [modified_by] NVARCHAR(100) NULL,
    CONSTRAINT [fk_student_program] FOREIGN KEY ([program_id]) 
        REFERENCES [Programs]([program_id]) ON UPDATE NO ACTION ON DELETE SET NULL,
    CONSTRAINT [chk_student_email] CHECK ([email] IS NULL OR [email] LIKE '_%@_%._%')
);
GO

CREATE UNIQUE INDEX [ix_students_studentnumber] ON [Students]([student_number]);
GO

-- Instructors
CREATE TABLE [Instructors] (
    [instructor_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [employee_number] NVARCHAR(30) NOT NULL UNIQUE,
    [first_name] NVARCHAR(100) NOT NULL,
    [last_name] NVARCHAR(100) NOT NULL,
    [email] NVARCHAR(320) NULL UNIQUE,
    [department_id] INT NULL,
    [profile] NVARCHAR(MAX) NULL,
    [is_active] BIT NOT NULL DEFAULT 1,
    [created_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT [fk_instructor_department] FOREIGN KEY ([department_id]) 
        REFERENCES [Departments]([department_id]) ON UPDATE NO ACTION ON DELETE SET NULL
);
GO

-- Student Addresses
CREATE TABLE [StudentAddresses] (
    [address_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [student_id] INT NOT NULL,
    [address_type] NVARCHAR(20) NOT NULL CHECK ([address_type] IN ('home','mailing','billing','other')),
    [line1] NVARCHAR(250) NOT NULL,
    [line2] NVARCHAR(250) NULL,
    [city] NVARCHAR(100) NOT NULL,
    [state] NVARCHAR(100) NULL,
    [postal_code] NVARCHAR(30) NULL,
    [country] NVARCHAR(100) NOT NULL DEFAULT 'USA',
    [is_primary] BIT NOT NULL DEFAULT 0,
    CONSTRAINT [fk_address_student] FOREIGN KEY ([student_id]) REFERENCES [Students]([student_id]) 
        ON DELETE CASCADE ON UPDATE NO ACTION
);
GO

CREATE INDEX [ix_studentaddresses_studentid] ON [StudentAddresses]([student_id]);
GO

-- Courses
CREATE TABLE [Courses] (
    [course_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [course_code] NVARCHAR(50) NOT NULL UNIQUE,
    [title] NVARCHAR(300) NOT NULL,
    [description] NVARCHAR(2000) NULL,
    [credits] DECIMAL(4,2) NOT NULL CHECK ([credits] >= 0),
    [department_id] INT NOT NULL,
    [course_metadata] NVARCHAR(MAX) NULL,
    CONSTRAINT [fk_course_department] FOREIGN KEY ([department_id]) REFERENCES [Departments]([department_id]) 
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

-- Course prerequisites
CREATE TABLE [CoursePrerequisites] (
    [course_id] INT NOT NULL,
    [prerequisite_course_id] INT NOT NULL,
    PRIMARY KEY ([course_id], [prerequisite_course_id]),
    CONSTRAINT [fk_prereq_course] FOREIGN KEY ([course_id]) REFERENCES [Courses]([course_id]) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT [fk_prereq_required] FOREIGN KEY ([prerequisite_course_id]) REFERENCES [Courses]([course_id]) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT [chk_prereq_not_self] CHECK ([course_id] <> [prerequisite_course_id])
);
GO

-- Sections
CREATE TABLE [Sections] (
    [section_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [course_id] INT NOT NULL,
    [section_code] NVARCHAR(30) NOT NULL,
    [term] NVARCHAR(20) NOT NULL,
    [year] INT NOT NULL CHECK ([year] >= 1900 AND [year] <= YEAR(GETDATE()) + 3),
    [instructor_id] INT NULL,
    [capacity] INT NOT NULL DEFAULT 0 CHECK ([capacity] >= 0),
    [schedule] NVARCHAR(MAX) NULL,
    [location] NVARCHAR(200) NULL,
    CONSTRAINT [fk_section_course] FOREIGN KEY ([course_id]) REFERENCES [Courses]([course_id]) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT [fk_section_instructor] FOREIGN KEY ([instructor_id]) REFERENCES [Instructors]([instructor_id]) ON UPDATE NO ACTION ON DELETE SET NULL,
    CONSTRAINT [uq_section_course_term] UNIQUE ([course_id], [section_code], [term], [year])
);
GO

CREATE INDEX [ix_sections_courseid] ON [Sections]([course_id]);
GO

-- Enrollments
CREATE TABLE [Enrollments] (
    [enrollment_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [student_id] INT NOT NULL,
    [section_id] INT NOT NULL,
    [enrolled_at] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    [status] NVARCHAR(20) NOT NULL CHECK ([status] IN ('enrolled','waitlisted','dropped','completed','withdrawn')),
    [grade] NVARCHAR(10) NULL CHECK ([grade] IS NULL OR [grade] IN ('A','B','C','D','F','P','NP','I','W','A+','A-','B+','B-','C+','C-','D+','D-','F+','F-')),
    [transcript] NVARCHAR(MAX) NULL,
    [grade_updated_at] DATETIME2 NULL,
    CONSTRAINT [fk_enrollment_student] FOREIGN KEY ([student_id]) REFERENCES [Students]([student_id]) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT [fk_enrollment_section] FOREIGN KEY ([section_id]) REFERENCES [Sections]([section_id]) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT [uq_student_section] UNIQUE ([student_id], [section_id])
);
GO

CREATE INDEX [ix_enrollments_studentid] ON [Enrollments]([student_id]);
CREATE INDEX [ix_enrollments_sectionid] ON [Enrollments]([section_id]);
GO

-- System users
CREATE TABLE [SystemUsers] (
    [user_id] INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    [username] NVARCHAR(150) NOT NULL UNIQUE,
    [password_hash] NVARCHAR(500) NOT NULL,
    [display_name] NVARCHAR(200) NULL,
    [student_id] INT NULL UNIQUE,
    [instructor_id] INT NULL UNIQUE,
    [roles] NVARCHAR(MAX) NULL,  -- JSON stored as NVARCHAR(MAX)
    [is_locked] BIT NOT NULL DEFAULT 0,
    CONSTRAINT [fk_user_student] FOREIGN KEY ([student_id]) REFERENCES [Students]([student_id]) ON DELETE SET NULL,
    CONSTRAINT [fk_user_instructor] FOREIGN KEY ([instructor_id]) REFERENCES [Instructors]([instructor_id]) ON DELETE SET NULL
);
GO

-- Helpful additional indexes
CREATE INDEX [ix_students_programid] ON [Students]([program_id]);
CREATE INDEX [ix_programs_departmentid] ON [Programs]([department_id]);
CREATE INDEX [ix_courses_departmentid] ON [Courses]([department_id]);
GO
