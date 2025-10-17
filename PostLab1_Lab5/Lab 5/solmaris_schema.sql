PRAGMA foreign_keys = ON;

-- =======================
-- Tables
-- =======================

CREATE TABLE IF NOT EXISTS Renter (
  renter_id        INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name       TEXT NOT NULL,
  last_name        TEXT NOT NULL,
  phone            TEXT,
  email            TEXT,
  address          TEXT,
  id_number        TEXT,
  notes            TEXT
);

CREATE TABLE IF NOT EXISTS Condo_Unit (
  unit_id          INTEGER PRIMARY KEY AUTOINCREMENT,
  building_name    TEXT,
  unit_number      TEXT NOT NULL,
  bedrooms         INTEGER NOT NULL,
  bathrooms        INTEGER NOT NULL,
  max_occupancy    INTEGER NOT NULL,
  square_feet      INTEGER,
  base_rate        NUMERIC NOT NULL,
  status           TEXT NOT NULL DEFAULT 'Available',
  notes            TEXT,
  CONSTRAINT uq_unit UNIQUE (building_name, unit_number)
);

CREATE TABLE IF NOT EXISTS Rental_Agreement (
  agreement_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  renter_id        INTEGER NOT NULL,
  unit_id          INTEGER NOT NULL,
  start_date       TEXT NOT NULL,  -- ISO date YYYY-MM-DD
  end_date         TEXT NOT NULL,  -- ISO date YYYY-MM-DD (exclusive end or ensure > start)
  rate_applied     NUMERIC NOT NULL,
  security_deposit NUMERIC,
  occupants_count  INTEGER,
  payment_status   TEXT DEFAULT 'Pending',
  agreement_status TEXT DEFAULT 'Active',
  created_at       TEXT DEFAULT (datetime('now')),
  CHECK (date(end_date) > date(start_date)),
  FOREIGN KEY (renter_id) REFERENCES Renter(renter_id) ON DELETE CASCADE,
  FOREIGN KEY (unit_id)  REFERENCES Condo_Unit(unit_id) ON DELETE CASCADE
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS ix_rental_agreement_renter ON Rental_Agreement(renter_id);
CREATE INDEX IF NOT EXISTS ix_rental_agreement_unit ON Rental_Agreement(unit_id);
CREATE INDEX IF NOT EXISTS ix_rental_agreement_dates ON Rental_Agreement(unit_id, start_date, end_date);

-- =======================
-- Trigger to prevent overlapping ACTIVE bookings per unit
-- (SQLite trigger checks on INSERT and UPDATE)
-- =======================
CREATE TRIGGER IF NOT EXISTS trg_no_overlap_insert
BEFORE INSERT ON Rental_Agreement
FOR EACH ROW
WHEN NEW.agreement_status = 'Active'
BEGIN
  -- Check overlap: two ranges [start_date, end_date) intersect if
  -- NEW.start < existing.end AND NEW.end > existing.start
  SELECT
    CASE
      WHEN EXISTS (
        SELECT 1 FROM Rental_Agreement ra
        WHERE ra.unit_id = NEW.unit_id
          AND ra.agreement_status = 'Active'
          AND date(NEW.start_date) < date(ra.end_date)
          AND date(NEW.end_date) > date(ra.start_date)
      )
      THEN RAISE(ABORT, 'Overlapping active booking for this unit')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_no_overlap_update
BEFORE UPDATE ON Rental_Agreement
FOR EACH ROW
WHEN NEW.agreement_status = 'Active'
BEGIN
  SELECT
    CASE
      WHEN EXISTS (
        SELECT 1 FROM Rental_Agreement ra
        WHERE ra.unit_id = NEW.unit_id
          AND ra.agreement_status = 'Active'
          AND ra.agreement_id <> OLD.agreement_id
          AND date(NEW.start_date) < date(ra.end_date)
          AND date(NEW.end_date) > date(ra.start_date)
      )
      THEN RAISE(ABORT, 'Overlapping active booking for this unit')
    END;
END;

-- =======================
-- Sample seed data (optional)
-- =======================
INSERT INTO Renter (first_name, last_name, phone, email, address, id_number)
VALUES
  ('Ava','Lopez','+61 400 000 111','ava@example.com','12 Beach Rd, Solmaris','DL-A1234'),
  ('Noah','Kim','+61 400 000 222','noah@example.com','8 Palm Way, Solmaris','PP-K5678');

INSERT INTO Condo_Unit (building_name, unit_number, bedrooms, bathrooms, max_occupancy, square_feet, base_rate, status, notes)
VALUES
  ('Coral Tower','1203',2,2,4,920,180.00,'Available','Ocean view'),
  ('Reef Villas','B-07',3,2,6,1350,240.00,'Available','Near pool');

INSERT INTO Rental_Agreement (renter_id, unit_id, start_date, end_date, rate_applied, security_deposit, occupants_count, payment_status, agreement_status)
VALUES
  (1, 1, '2025-12-20', '2025-12-27', 180.00, 300.00, 2, 'Paid', 'Active');
