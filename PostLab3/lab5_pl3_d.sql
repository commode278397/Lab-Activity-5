-- Turn on FK enforcement
PRAGMA foreign_keys = ON;

-- Drop in child→parent order
DROP TABLE IF EXISTS TRIP_GUIDES;
DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS TRIP;
DROP TABLE IF EXISTS GUIDE;
DROP TABLE IF EXISTS CUSTOMER;

BEGIN TRANSACTION;

-- CUSTOMER
CREATE TABLE CUSTOMER (
  CUSTOMER_NUM INTEGER PRIMARY KEY,
  LAST_NAME    CHAR(30),
  FIRST_NAME   CHAR(30),
  ADDRESS      CHAR(50),
  CITY         CHAR(30),
  STATE        CHAR(2),
  POSTAL_CODE  CHAR(10),
  PHONE        CHAR(14)
);

-- GUIDE
CREATE TABLE GUIDE (
  GUIDE_NUM   CHAR(4) PRIMARY KEY,
  LAST_NAME   CHAR(30),
  FIRST_NAME  CHAR(30),
  ADDRESS     CHAR(50),
  CITY        CHAR(30),
  STATE       CHAR(2),
  POSTAL_CODE CHAR(10),
  PHONE_NUM   CHAR(14),
  HIRE_DATE   CHAR(10)
);

-- TRIP
CREATE TABLE TRIP (
  TRIP_ID        INTEGER PRIMARY KEY,
  TRIP_NAME      CHAR(75),
  START_LOCATION CHAR(50),
  STATE          CHAR(2),
  DISTANCE       INTEGER,
  MAX_GRP_SIZE   INTEGER,
  TYPE           CHAR(20),
  SEASON         CHAR(20)
);

-- RESERVATION
CREATE TABLE RESERVATION (
  RESERVATION_ID INTEGER PRIMARY KEY,
  TRIP_ID        INTEGER NOT NULL,
  TRIP_DATE      CHAR(10),
  NUM_PERSONS    INTEGER,
  TRIP_PRICE     NUMERIC,
  OTHER_FEES     NUMERIC,
  CUSTOMER_NUM   INTEGER NOT NULL,
  FOREIGN KEY (TRIP_ID) REFERENCES TRIP(TRIP_ID),
  FOREIGN KEY (CUSTOMER_NUM) REFERENCES CUSTOMER(CUSTOMER_NUM)
);

-- TRIP_GUIDES
CREATE TABLE TRIP_GUIDES (
  TRIP_ID    INTEGER NOT NULL,
  GUIDE_NUM  CHAR(4) NOT NULL,
  PRIMARY KEY (TRIP_ID, GUIDE_NUM),
  FOREIGN KEY (TRIP_ID) REFERENCES TRIP(TRIP_ID),
  FOREIGN KEY (GUIDE_NUM) REFERENCES GUIDE(GUIDE_NUM)
);

-- DATA: GUIDE
INSERT INTO GUIDE (GUIDE_NUM,LAST_NAME,FIRST_NAME,ADDRESS,CITY,STATE,POSTAL_CODE,PHONE_NUM,HIRE_DATE) VALUES
('AM01','Abrams','Miles','54 Quest Ave.','Williamsburg','MA','01096','617-555-6032','6/3/2012'),
('BR01','Boyers','Rita','140 Oakton Rd.','Jaffrey','NH','03452','603-555-2134','3/4/2012'),
('DH01','Devon','Harley','25 Old Ranch Rd.','Sunderland','MA','01375','781-555-7767','1/8/2012'),
('GZ01','Gregory','Zach','7 Moose Head Rd.','Dummer','NH','03588','603-555-8765','11/4/2012'),
('KS01','Kiley','Susan','943 Oakton Rd.','Jaffrey','NH','03452','603-555-1230','4/8/2013'),
('KS02','Kelly','Sam','9 Congaree Ave.','Franconia','NH','03580','603-555-0003','6/10/2013'),
('MR01','Marston','Ray','24 Shenandoah Rd.','Springfield','MA','01101','781-555-2323','9/14/2015'),
('RH01','Rowan','Hal','12 Heather Rd.','Mount Desert','ME','04660','207-555-9009','6/2/2014'),
('SL01','Stevens','Lori','15 Riverton Rd.','Coventry','VT','05825','802-555-3339','9/5/2014'),
('UG01','Unser','Glory','342 Pineview St.','Danbury','CT','06810','203-555-8534','2/2/2015');

-- DATA: TRIP
INSERT INTO TRIP (TRIP_ID,TRIP_NAME,START_LOCATION,STATE,DISTANCE,MAX_GRP_SIZE,TYPE,SEASON) VALUES
(1,'Arethusa Falls','Harts Location','NH',5,10,'Hiking','Summer'),
(2,'Mt Ascutney - North Peak','Weathersfield','VT',5,6,'Hiking','Late Spring'),
(3,'Mt Ascutney - West Peak','Weathersfield','VT',6,10,'Hiking','Early Fall'),
(4,'Bradbury Mountain Ride','Lewiston-Auburn','ME',25,8,'Biking','Early Fall'),
(5,'Baldpate Mountain','North Newry','ME',6,10,'Hiking','Late Spring'),
(6,'Blueberry Mountain','Batchelders Grant','ME',8,8,'Hiking','Early Fall'),
(7,'Bloomfield-Maidstone','Bloomfield','CT',10,6,'Paddling','Late Spring'),
(8,'Black Pond','Lincoln','NH',8,12,'Hiking','Summer'),
(9,'Big Rock Cave','Tamworth','NH',6,10,'Hiking','Summer'),
(10,'Mt. Cardigan - Firescrew','Orange','NH',7,8,'Hiking','Summer'),
(11,'Chocorua Lake Tour','Tamworth','NH',12,15,'Paddling','Summer'),
(12,'Cadillac Mountain Ride','Bar Harbor','ME',8,16,'Biking','Early Fall'),
(13,'Cadillac Mountain','Bar Harbor','ME',7,8,'Hiking','Late Spring'),
(14,'Cannon Mtn','Franconia','NH',6,6,'Hiking','Early Fall'),
(15,'Crawford Path Presidential Hike','Crawford Notch','NH',16,4,'Hiking','Summer'),
(16,'Cherry Pond','Whitefield','NH',6,16,'Hiking','Spring'),
(17,'Huguenot Head Hike','Bar Harbor','ME',5,10,'Hiking','Early Fall'),
(18,'Low Bald Spot Hike','Pinkham Notch','NH',6,6,'Hiking','Early Fall'),
(19,'Mason''s Farm','North Stratford','CT',12,7,'Paddling','Late Spring'),
(20,'Lake Memphremagog Tour','Newport','VT',8,15,'Paddling','Late Spring'),
(21,'Long Pond','Rutland','MA',8,12,'Hiking','Summer');

-- DATA: CUSTOMER
INSERT INTO CUSTOMER (CUSTOMER_NUM,LAST_NAME,FIRST_NAME,ADDRESS,CITY,STATE,POSTAL_CODE,PHONE) VALUES
(101,'Northfold','Liam','9 Old Mill Rd.','Londonderry','NH','03053','603-555-7563'),
(102,'Ocean','Arnold','2332 South St. Apt 3','Springfield','MA','01101','413-555-3212'),
(103,'Kasuma','Sujata','132 Main St. #1','East Hartford','CT','06108','860-555-0703'),
(104,'Goff','Ryan','164A South Bend Rd.','Lowell','MA','01854','781-555-8423'),
(105,'McLean','Kyle','345 Lower Ave.','Wolcott','NY','14590','585-555-5321'),
(106,'Morontoia','Joseph','156 Scholar St.','Johnston','RI','02919','401-555-4848'),
(107,'Marchand','Quinn','76 Cross Rd.','Bath','NH','03740','603-555-0436'),
(108,'Rolf','Uschi','32 Sheep Stop St.','Edinboro','PA','16412','814-555-5521'),
(109,'Caron','Jean Luc','10 Greenfield St.','Rome','ME','04963','207-555-9643'),
(110,'Bers','Martha','65 Granite St.','York','NY','14592','585-555-0111'),
(112,'Jones','Laura','373 Highland Ave.','Somerville','MA','02143','857-555-6238'),
(115,'Vaccari','Adam','1282 Ocean Walk','Ocean City','NJ','08226','609-555-5231'),
(116,'Murakami','Iris','7 Cherry Blossom St.','Weymouth','MA','02188','617-555-6665'),
(119,'Chau','Clement','18 Ark Ledge Ln.','Londonderry','VT','05148','802-555-3096'),
(120,'Gernowski','Sadie','24 Stump Rd.','Athens','ME','04912','207-555-4507'),
(121,'Bretton-Borak','Siam','10 Old Main St.','Cambridge','VT','05444','802-555-3443'),
(122,'Hefferson','Orlauth','132 South St. Apt 27','Manchester','NH','03101','603-555-3476'),
(123,'Barnett','Larry','25 Stag Rd.','Fairfield','CT','06824','860-555-9876'),
(124,'Busa','Karen','12 Foster St.','South Windsor','CT','06074','857-555-5532'),
(125,'Peterson','Becca','51 Fredrick St.','Albion','NY','14411','585-555-0900'),
(126,'Brown','Brianne','154 Central St.','Vernon','CT','06066','860-555-3234');

-- DATA: RESERVATION
INSERT INTO RESERVATION (RESERVATION_ID,TRIP_ID,TRIP_DATE,NUM_PERSONS,TRIP_PRICE,OTHER_FEES,CUSTOMER_NUM) VALUES
(1600004,2,'10/6/2016',1,15.00,15.00,101),
(1600005,1,'1/25/2016',2,55.00,0.00,105),
(1600006,12,'1/18/2016',1,80.00,20.00,106),
(1600007,2,'1/9/2016',8,18.00,10.00,107),
(1600009,20,'9/11/2016',2,90.00,40.00,109),
(1600010,18,'5/11/2016',3,10.00,0.00,102),
(1600011,2,'1/15/2011',3,25.00,0.00,112),
(1600012,1,'6/12/2016',4,15.00,0.00,115),
(1600100,1,'7/1/2016',4,20.00,0.00,116);

-- DATA: TRIP_GUIDES
INSERT INTO TRIP_GUIDES (TRIP_ID,GUIDE_NUM) VALUES
(1,'GZ01'),
(2,'SL01'),
(4,'BR01'),
(5,'KS01'),
(5,'UG01'),
(8,'BR01'),
(9,'RH01'),
(10,'GZ01'),
(12,'BR01'),
(13,'RH01'),
(14,'KS02'),
(18,'KS02');

COMMIT;