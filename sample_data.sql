USE [StudentRecordsDB];
GO

-- Departments
INSERT INTO Departments (department_code, name, description, created_by)
VALUES 
('CS', 'Computer Science', 'Department of Computer Science', 'admin'),
('ENG', 'Engineering', 'Department of Engineering', 'admin'),
('BUS', 'Business', 'School of Business', 'admin');

-- Programs
INSERT INTO Programs (program_code, name, department_id, degree_level, duration_months)
VALUES
('CS101', 'BSc Computer Science', 1, 'Bachelor', 36),
('ENG201', 'MSc Mechanical Engineering', 2, 'Master', 24),
('BUS301', 'MBA Business Administration', 3, 'Master', 18);

-- Students
INSERT INTO Students (student_number, first_name, last_name, date_of_birth, email, program_id, enrollment_year, student_metadata, created_by)
VALUES
('STU001', 'Alice', 'Mokoena', '2002-05-14', 'alice.mokoena@example.com', 1, 2021, '{"preferred_name":"Ali","visa_status":"Citizen"}', 'admin'),
('STU002', 'Brian', 'Nkosi', '2000-11-02', 'brian.nkosi@example.com', 2, 2020, '{"preferred_name":"Bri","visa_status":"Resident"}', 'admin'),
('STU003', 'Cynthia', 'Dlamini', '2001-03-22', 'cynthia.dlamini@example.com', 3, 2022, '{"preferred_name":"Cyn","visa_status":"International"}', 'admin');

-- Instructors
INSERT INTO Instructors (employee_number, first_name, last_name, email, department_id, profile)
VALUES
('EMP001', 'David', 'Smith', 'david.smith@example.com', 1, '{"office":"Room 101","rank":"Professor"}'),
('EMP002', 'Emma', 'Johnson', 'emma.johnson@example.com', 2, '{"office":"Lab 3","rank":"Lecturer"}');

-- Courses
INSERT INTO Courses (course_code, title, description, credits, department_id, course_metadata)
VALUES
('CS101A', 'Intro to Programming', 'Fundamentals of programming in C++', 12, 1, '{"learning_outcomes":["variables","loops","functions"]}'),
('ENG201B', 'Thermodynamics', 'Advanced concepts in mechanical engineering', 10, 2, '{"learning_outcomes":["heat transfer","energy balance"]}'),
('BUS301C', 'Strategic Management', 'Business strategy and leadership', 8, 3, '{"learning_outcomes":["planning","execution","evaluation"]}');

-- Sections
INSERT INTO Sections (course_id, section_code, term, year, instructor_id, capacity, schedule, location)
VALUES
(1, 'CS101-01', 'Fall', 2025, 1, 50, '{"days":["Mon","Wed"],"start_time":"09:00","end_time":"10:30"}', 'Building A'),
(2, 'ENG201-01', 'Spring', 2025, 2, 40, '{"days":["Tue","Thu"],"start_time":"11:00","end_time":"12:30"}', 'Engineering Lab'),
(3, 'BUS301-01', 'Fall', 2025, NULL, 60, '{"days":["Fri"],"start_time":"14:00","end_time":"17:00"}', 'Business Hall');

-- Enrollments
INSERT INTO Enrollments (student_id, section_id, status, grade, transcript)
VALUES
(1, 1, 'enrolled', 'A', '{"degree_audit":"complete","notes":"Excellent performance"}'),
(2, 2, 'enrolled', 'B+', '{"degree_audit":"in progress","notes":"Solid understanding"}'),
(3, 3, 'waitlisted', NULL, '{"degree_audit":"pending","notes":"Awaiting seat"}');

-- Student Addresses
INSERT INTO StudentAddresses (student_id, address_type, line1, city, country, is_primary)
VALUES
(1, 'home', '123 Main Street', 'Pretoria', 'South Africa', 1),
(2, 'mailing', '456 Oak Avenue', 'Johannesburg', 'South Africa', 1),
(3, 'billing', '789 Pine Road', 'Durban', 'South Africa', 1);

-- System Users
INSERT INTO SystemUsers (username, password_hash, display_name, student_id, roles)
VALUES
('alice_user', 'hashed_password_123', 'Alice Mokoena', 1, '["student","user"]'),
('brian_user', 'hashed_password_456', 'Brian Nkosi', 2, '["student","user"]');
