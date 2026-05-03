USE bloodbank;


-- Blood Banks
INSERT INTO BloodBank (name, location, contact) VALUES
('City Blood Bank',       'Karachi Central',   '021-11111111'),
('LifeFlow Blood Center', 'Lahore Gulberg',     '042-22222222'),
('National Blood Bank',   'Islamabad F-8',      '051-33333333');

-- Hospitals
INSERT INTO Hospital (name, location, contact) VALUES
('Aga Khan Hospital',     'Stadium Road, Karachi',  '021-99999901'),
('Jinnah Hospital',       'Rafiqui Shaheed Rd, Lahore', '042-99999902'),
('PIMS Hospital',         'G-8, Islamabad',          '051-99999903'),
('Liaquat Hospital',      'Hyderabad',               '022-99999904'),
('Civil Hospital',        'Karachi',                 '021-99999905');

-- Persons (donors, patients, staff)
INSERT INTO Person (name, gender, age, contact) VALUES
('Ali Hassan',       'Male',   28, '0300-1111111'),
('Sara Khan',        'Female', 24, '0300-2222222'),
('Usman Tariq',      'Male',   35, '0300-3333333'),
('Ayesha Malik',     'Female', 30, '0300-4444444'),
('Bilal Ahmed',      'Male',   22, '0300-5555555'),
('Fatima Noor',      'Female', 27, '0300-6666666'),
('Hamza Raza',       'Male',   31, '0300-7777777'),
('Zara Siddiqui',    'Female', 26, '0300-8888888'),
('Omar Farooq',      'Male',   40, '0300-9999999'),
('Nida Hussain',     'Female', 33, '0301-1111111'),
('Kamran Sheikh',    'Male',   29, '0301-2222222'),
('Mehwish Baig',     'Female', 38, '0301-3333333'),
('Tariq Anwar',      'Male',   45, '0301-4444444'),
('Sana Iqbal',       'Female', 23, '0301-5555555'),
('Asad Mehmood',     'Male',   36, '0301-6666666'),
-- Staff persons
('Dr. Rehan Ali',    'Male',   42, '0302-1111111'),
('Nurse Hina Aziz',  'Female', 34, '0302-2222222'),
('Dr. Amna Shah',    'Female', 38, '0302-3333333'),
('Lab Tech Farhan',  'Male',   29, '0302-4444444'),
('Admin Rizwan',     'Male',   31, '0302-5555555');

-- Donors (personID 1–15)
INSERT INTO Donor (personID, bloodGroup) VALUES
(1,  'A+'),
(2,  'B-'),
(3,  'O+'),
(4,  'AB+'),
(5,  'A-'),
(6,  'B+'),
(7,  'O-'),
(8,  'AB-'),
(9,  'A+'),
(10, 'B+'),
(11, 'O+'),
(12, 'A-'),
(13, 'B-'),
(14, 'AB+'),
(15, 'O+');

-- Patients (reuse some persons — patients can overlap with donors in real life)
INSERT INTO Patient (personID, bloodGroup) VALUES
(1,  'A+'),
(3,  'O+'),
(5,  'A-'),
(7,  'O-'),
(9,  'A+'),
(11, 'O+'),
(13, 'B-');

-- Staff
INSERT INTO Staff (personID, role, bloodBankID) VALUES
(16, 'Doctor',            1),
(17, 'Nurse',             1),
(18, 'Doctor',            2),
(19, 'Lab Technician',    2),
(20, 'Administrator',     3);

-- Clinical Analysts (from lab staff)
INSERT INTO ClinicalAnalyst (staffID, staffTraining, labSpecialization) VALUES
(4, 'Hematology Certification',    'Blood Typing'),
(5, 'Pathology Diploma',           'Serology');

-- Storage Locations
INSERT INTO StorageLocation (locationName, capacity, bloodBankID) VALUES
('Fridge A - Block 1', 100, 1),
('Fridge B - Block 2', 150, 1),
('Cold Room 1',        200, 2),
('Cold Room 2',        180, 3);

-- Donations
INSERT INTO Donation (donorID, staffID, donationDate, quantity) VALUES
(1,  1, '2024-01-10', 1),
(2,  2, '2024-01-15', 1),
(3,  1, '2024-02-01', 2),
(4,  3, '2024-02-14', 1),
(5,  2, '2024-03-05', 1),
(6,  1, '2024-03-20', 2),
(7,  4, '2024-04-01', 1),
(8,  3, '2024-04-10', 1),
(9,  2, '2024-05-01', 2),
(10, 1, '2024-05-15', 1),
(11, 5, '2024-06-01', 1),
(12, 4, '2024-06-20', 2),
(13, 3, '2024-07-05', 1),
(14, 2, '2024-07-22', 1),
(15, 1, '2024-08-10', 2);

-- Blood Units
INSERT INTO BloodUnit (donationID, bloodGroup, expiryDate, storageID) VALUES
(1,  'A+',  '2024-02-10', 1),
(2,  'B-',  '2024-02-15', 1),
(3,  'O+',  '2024-03-01', 2),
(4,  'AB+', '2024-03-14', 2),
(5,  'A-',  '2024-04-05', 3),
(6,  'B+',  '2024-04-20', 3),
(7,  'O-',  '2024-05-01', 4),
(8,  'AB-', '2024-05-10', 4),
(9,  'A+',  '2025-06-01', 1),
(10, 'B+',  '2025-06-15', 2),
(11, 'O+',  '2025-07-01', 3),
(12, 'A-',  '2025-07-20', 3),
(13, 'B-',  '2025-08-05', 4),
(14, 'AB+', '2025-08-22', 1),
(15, 'O+',  '2025-09-10', 2);

-- Blood Requests
INSERT INTO BloodRequest (patientID, hospitalID, staffID, requestDate, bloodGroup, status, unitsRequired) VALUES
(1, 1, 1, '2024-06-01', 'A+',  'Approved',  2),
(2, 2, 2, '2024-06-05', 'O+',  'Pending',   1),
(3, 3, 3, '2024-06-10', 'A-',  'Approved',  1),
(4, 1, 4, '2024-06-15', 'O-',  'Rejected',  3),
(5, 4, 5, '2024-07-01', 'A+',  'Pending',   2),
(6, 5, 1, '2024-07-05', 'O+',  'Approved',  1),
(7, 2, 2, '2024-07-10', 'B-',  'Pending',   1);

-- Discard Units (expired ones)
INSERT INTO DiscardUnit (bloodUnitID, discardDate, reason) VALUES
(1, '2024-02-11', 'Expired'),
(2, '2024-02-16', 'Expired'),
(3, '2024-03-02', 'Expired'),
(4, '2024-03-15', 'Contaminated');