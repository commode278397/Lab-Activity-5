-- Start clean (optional if the table doesn’t exist yet)
DROP TABLE IF EXISTS ADVENTURE_TRIP;

-- Create the table with the requested types/structure
CREATE TABLE ADVENTURE_TRIP (
  TRIP_ID        DECIMAL(3,0) NOT NULL PRIMARY KEY,
  TRIP_NAME      VARCHAR(75),
  START_LOCATION CHAR(50),
  STATE          CHAR(2),
  DISTANCE       NUMBER(4,0),
  MAX_GRP_SIZE   NUMBER(4,0),
  TYPE           CHAR(20),
  SEASON         CHAR(20)
);

-- Describe the layout/characteristics (SQLite doesn’t support DESCRIBE; use PRAGMA)
PRAGMA table_info('ADVENTURE_TRIP');

-- (Optional) See the exact DDL SQLite stored
SELECT sql FROM sqlite_schema WHERE type='table' AND name='ADVENTURE_TRIP';

-- (Optional, sqlite3 CLI only)
.schema ADVENTURE_TRIP