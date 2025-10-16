
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS ClassSession;
DROP TABLE IF EXISTS AdventureClass;
DROP TABLE IF EXISTS Guide;
DROP TABLE IF EXISTS Participant;

CREATE TABLE Participant (
  ParticipantID INTEGER PRIMARY KEY AUTOINCREMENT,
  LastName TEXT NOT NULL,
  FirstName TEXT NOT NULL,
  Address TEXT,
  City TEXT,
  State TEXT,
  PostalCode TEXT,
  Telephone TEXT,
  DateOfBirth DATE
);

CREATE TABLE Guide (
  GuideID INTEGER PRIMARY KEY AUTOINCREMENT,
  LastName TEXT NOT NULL,
  FirstName TEXT NOT NULL,
  Phone TEXT,
  Email TEXT,
  HireDate DATE
);

CREATE TABLE AdventureClass (
  ClassID INTEGER PRIMARY KEY AUTOINCREMENT,
  ClassDescription TEXT NOT NULL,
  MaxPeople INTEGER NOT NULL DEFAULT 0,
  ClassFee REAL NOT NULL DEFAULT 0.0
);

CREATE TABLE ClassSession (
  SessionID INTEGER PRIMARY KEY AUTOINCREMENT,
  ClassID INTEGER NOT NULL,
  SessionDate DATE NOT NULL,
  GuideID INTEGER, -- can be NULL until assigned
  Location TEXT,
  Notes TEXT,
  FOREIGN KEY (ClassID) REFERENCES AdventureClass(ClassID),
  FOREIGN KEY (GuideID) REFERENCES Guide(GuideID),
  UNIQUE (SessionDate) -- enforce one class per day company-wide
);

CREATE TABLE Enrollment (
  EnrollmentID INTEGER PRIMARY KEY AUTOINCREMENT,
  ParticipantID INTEGER NOT NULL,
  SessionID INTEGER NOT NULL,
  EnrollmentDate DATE DEFAULT (date('now')),
  PaymentAmount REAL DEFAULT 0.0,
  FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID),
  FOREIGN KEY (SessionID) REFERENCES ClassSession(SessionID),
  UNIQUE (ParticipantID, SessionID)
);

-- Sample data: Participants (5)
INSERT INTO Participant (LastName, FirstName, Address, City, State, PostalCode, Telephone, DateOfBirth) VALUES
('Garcia', 'Ana', '123 Pine St', 'Cebu', 'CEB', '6000', '09171234567', '1990-04-12'),
('Reyes', 'Miguel', '45 Mango Ave', 'Iloilo', 'ILO', '5000', '09179876543', '1985-09-08'),
('Lopez', 'Carla', '78 Oak Blvd', 'Davao', 'DAV', '8000', '09171239876', '1995-02-20'),
('Santos', 'Daniel', '12 Rizal Rd', 'Manila', 'MNL', '1000', '09175551234', '1992-07-01'),
('Tan', 'Grace', '9 Bamboo Ln', 'Bacolod', 'BAC', '6100', '09170001111', '1988-12-05');

-- Sample data: Guides (3)
INSERT INTO Guide (LastName, FirstName, Phone, Email, HireDate) VALUES
('Cruz', 'Mark', '09172223333', 'mark.cruz@colonial.com', '2018-06-01'),
('Velasco', 'Rosa', '09173334444', 'rosa.velasco@colonial.com', '2019-03-15'),
('Delos', 'Luis', '09174445555', 'luis.delos@colonial.com', '2020-11-10');

-- Sample data: AdventureClass types (2)
INSERT INTO AdventureClass (ClassDescription, MaxPeople, ClassFee) VALUES
('Intro to Hiking', 12, 25.00),
('Beginner Paddling', 8, 30.00);

-- Sample data: Class sessions (3)
-- SessionDate chosen to be distinct to respect UNIQUE(SessionDate)
INSERT INTO ClassSession (ClassID, SessionDate, GuideID, Location, Notes) VALUES
(1, '2025-11-01', 1, 'Mountain Trailhead', 'Bring hiking boots'),
(2, '2025-11-02', 2, 'Lake Marina', 'Life jackets provided'),
(1, '2025-11-03', NULL, 'Coastal Path', 'Guide to be assigned day-of');

-- Sample data: Enrollments (6)
INSERT INTO Enrollment (ParticipantID, SessionID, EnrollmentDate, PaymentAmount) VALUES
(1, 1, '2025-10-20', 25.00),
(2, 1, '2025-10-22', 25.00),
(3, 2, '2025-10-25', 30.00),
(4, 2, '2025-10-26', 30.00),
(5, 3, '2025-10-27', 25.00),
(1, 3, '2025-10-27', 25.00);
