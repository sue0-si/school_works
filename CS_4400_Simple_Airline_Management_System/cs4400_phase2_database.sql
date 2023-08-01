-- CS4400: Introduction to Database Systems: Monday, January 30, 2023
-- Flight Management Course Project Database TEMPLATE (v1.0)



/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

drop database if exists flight_management;
create database if not exists flight_management;
use flight_management;


-- Define the database structures and enter the denormalized data

-- Airline Table
DROP TABLE IF EXISTS airline;
CREATE TABLE airline (
  airline_id char(50) NOT NULL,
  revenue decimal(4, 0) NOT NULL,
  PRIMARY KEY (airline_id)

) ENGINE=InnoDB;

-- Airplane Table
DROP TABLE IF EXISTS airplane;
CREATE TABLE airplane (
  airline_id char(50) NOT NULL,
  tail_num char(50) NOT NULL,
  seat_cap int(5) NOT NULL,
  speed int(5) NOT NULL, 
  loc_id char(50) DEFAULT NULL,
  plane_type char(5) DEFAULT NULL,
  skids int(2) DEFAULT NULL,
  props_or_jets int(2) DEFAULT NULL,

  PRIMARY KEY (tail_num, airline_id)
  -- has fk1 (loc_id), fk2 (airline_id)

) ENGINE=InnoDB;


-- Flight Table
DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
  flight_id char(50) NOT NULL,
  tail_num char(50) DEFAULT NULL,
  airline_id char(50) DEFAULT NULL,
  progress int(2) DEFAULT NULL,
  status char(10) DEFAULT NULL,
  next_time char(8) DEFAULT NULL,
  route_id char(50) NOT NULL,
  PRIMARY KEY (flight_id)
   -- has fk3 (tail_num, airline_id) → Airplane((tail_num, airline_id))
   -- has fk4 route_id → Route(route_id)
) ENGINE=InnoDB;



-- Ticket Table
DROP TABLE IF EXISTS ticket;
CREATE TABLE ticket (
  ticket_id char(50) NOT NULL,
  cost int(5) NOT NULL,
  flight_id char(50) NOT NULL,
  airport_id char(3) NOT NULL,
  person_id char(50) NOT NULL,
  PRIMARY KEY (ticket_id)
   -- has fk5 flightID → Flight(flightID)
   -- has airport_id → Airport(airport_id)
   -- has person_id → Person(person_id)

) ENGINE=InnoDB;



-- Person Table
DROP TABLE IF EXISTS person;
CREATE TABLE person (
  person_id char(50) NOT NULL,
  first char(100) NOT NULL,
  last char(100) DEFAULT NULL,
  loc_id char(50) NOT NULL,
  PRIMARY KEY (person_id)
   -- has fk8 location → Location(loc_id)
) ENGINE=InnoDB;



-- Location Table 
DROP TABLE IF EXISTS location;
CREATE TABLE location (
loc_id char(50) NOT NULL,
PRIMARY KEY (loc_id)
) ENGINE=InnoDB;


-- Airport Table
DROP TABLE IF EXISTS airport;
CREATE TABLE airport (
airport_id char(3) NOT NULL,
airport_name char(100) NOT NULL,
city char(50) NOT NULL,
state char(2) NOT NULL,
loc_id char(50) DEFAULT NULL,
PRIMARY KEY (airport_id)
) ENGINE=InnoDB;


-- Pilot Table 
DROP TABLE IF EXISTS pilot;
CREATE TABLE pilot (
person_id char(50) NOT NULL,
tax_id char(50) NOT NULL,
experience int(5) NOT NULL,
airline_id char(50) DEFAULT NULL,
tail_num char(50) DEFAULT NULL,
PRIMARY KEY (person_id),
UNIQUE KEY (tax_id)
) ENGINE=InnoDB;


-- Passenger Table 
DROP TABLE IF EXISTS passenger;
CREATE TABLE passenger (
person_id char(50) NOT NULL,
miles int(5) NOT NULL,
PRIMARY KEY (person_id)
) ENGINE=InnoDB;
-- fk9: person_id -> Person(person_id)


-- License Table 
DROP TABLE IF EXISTS license;
CREATE TABLE license (
pilot_id char(50) NOT NULL,
license char(10) NOT NULL,
PRIMARY KEY (pilot_id, license)
) ENGINE=InnoDB;
-- fk10: pilot_id -> Person(person_id)


-- Seat Table 
DROP TABLE IF EXISTS seat;
CREATE TABLE seat (
ticket_id char(50) NOT NULL,
seat_number char(5) NOT NULL,
PRIMARY KEY (ticket_id, seat_number)
) ENGINE=InnoDB;
-- fk11: ticket_id -> Ticket(ticket_id)


DROP TABLE IF EXISTS route;
CREATE TABLE route (
route_id char(50) NOT NULL,
PRIMARY KEY (route_id)
)	ENGINE = InnoDB;


DROP TABLE IF EXISTS contain;
CREATE TABLE contain (
route_id char(50) NOT NULL,
leg_id char(50) NOT NULL,
sequence int(3) NOT NULL,
PRIMARY KEY (route_id, leg_id, sequence)
)	ENGINE = InnoDB;


DROP TABLE IF EXISTS leg;
CREATE TABLE leg (
leg_id char(50) NOT NULL,
distance int(5) NOT NULL,
departure char(3) NOT NULL,
arrival char(3) NOT NULL,
PRIMARY KEY (leg_id)
)	ENGINE = InnoDB;



-- Define all foreign keys here:
ALTER TABLE airplane ADD CONSTRAINT fk1 FOREIGN KEY (loc_id) REFERENCES location (loc_id);
ALTER TABLE airplane ADD CONSTRAINT fk2 FOREIGN KEY (airline_id) REFERENCES airline (airline_id);
ALTER TABLE flight ADD CONSTRAINT fk3 FOREIGN KEY (tail_num, airline_id) REFERENCES airplane(tail_num, airline_id);
ALTER TABLE flight ADD CONSTRAINT fk4 FOREIGN KEY (route_id) REFERENCES route(route_id);
ALTER TABLE ticket ADD CONSTRAINT fk5 FOREIGN KEY (flight_id) REFERENCES flight(flight_id);
ALTER TABLE ticket ADD CONSTRAINT fk6 FOREIGN KEY (airport_id) REFERENCES airport(airport_id);
ALTER TABLE ticket ADD CONSTRAINT fk7 FOREIGN KEY (person_id) REFERENCES person(person_id);
ALTER TABLE person ADD CONSTRAINT fk8 FOREIGN KEY (loc_id) REFERENCES location(loc_id);
ALTER TABLE airport ADD CONSTRAINT fk18 FOREIGN KEY (loc_id) REFERENCES location(loc_id);
ALTER TABLE pilot ADD CONSTRAINT fk20 FOREIGN KEY (person_id) REFERENCES person(person_id);
ALTER TABLE pilot ADD CONSTRAINT fk60 FOREIGN KEY (tail_num, airline_id) REFERENCES airplane(tail_num, airline_id);
ALTER TABLE passenger ADD CONSTRAINT fk9 FOREIGN KEY (person_id) REFERENCES person(person_id);
ALTER TABLE license ADD CONSTRAINT fk10 FOREIGN KEY (pilot_id) REFERENCES person(person_id);
ALTER TABLE seat ADD CONSTRAINT fk11 FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id);
ALTER TABLE contain ADD CONSTRAINT fk100 FOREIGN KEY (route_id) REFERENCES route(route_id);
ALTER TABLE contain ADD CONSTRAINT fk200 FOREIGN KEY (leg_id) REFERENCES leg(leg_id);
ALTER TABLE leg ADD CONSTRAINT fk300 FOREIGN KEY (departure) REFERENCES airport(airport_id);
ALTER TABLE leg ADD CONSTRAINT fk400 FOREIGN KEY (arrival) REFERENCES airport(airport_id);

INSERT INTO route VALUES
('circle_east_coast'),
('circle_west_coast'),
('eastbound_north_milk_run'),
('eastbound_north_nonstop'),
('eastbound_south_milk_run'),
('hub_xchg_southeast'),
('hub_xchg_southwest'),
('local_texas'),
('northbound_east_coast'),
('northbound_west_coast'),
('southbound_midwest'),
('westbound_north_milk_run'),
('westbound_north_nonstop'),
('westbound_south_nonstop');

INSERT INTO airline VALUES
('Air_France', 25),
('American', 45),
('Delta', 46),
('JetBlue', 8),
('Lufthansa', 31),
('Southwest', 22),
('Spirit', 4),
('United', 40); 

INSERT INTO location VALUES
('plane_1'),
('plane_11'),
('plane_15'),
('plane_2'),
('plane_4'),
('plane_7'),
('plane_8'),
('plane_9'),
('port_1'),
('port_10'),
('port_11'),
('port_13'),
('port_14'),
('port_15'),
('port_17'),
('port_18'),
('port_2'),
('port_3'),
('port_4'),
('port_5'),
('port_7'),
('port_9');

INSERT INTO airplane VALUES
('American', 'n330ss', 4,   200, 'plane_4', 'jet', NULL, 2),
('American', 'n380sd', 5,   400, NULL,  'jet',  NULL, 2),
('Delta',   'n106js', 4,    200, 'plane_1', 'jet', NULL, 2),
('Delta',   'n110jn', 5,    600, 'plane_2', 'jet', NULL, 4),
('Delta',   'n127js', 4,    800, NULL, NULL, NULL, NULL),          
('Delta',   'n156sq', 8,    100, NULL, NULL, NULL, NULL),          
('JetBlue', 'n161fk', 4,    200, NULL, 'jet', NULL, 2),
('JetBlue', 'n337as', 5,    400, NULL, 'jet', NULL, 2),
('Southwest', 'n118fm', 4,  100, 'plane_11', 'prop', 1, 1),
('Southwest', 'n401fj', 4,  200, 'plane_9', 'jet', NULL, 2),
('Southwest', 'n653fk', 6,  400, NULL, 'jet', NULL, 2),
('Southwest', 'n815pw', 3,  200, NULL, 'prop',  0,  2),
('Spirit', 'n256ap', 4,     400, 'plane_15', 'jet', NULL, 2),
('United', 'n451fi', 5,     400, NULL, 'jet', NULL, 4),
('United', 'n517ly', 4,     400, 'plane_7', 'jet', NULL, 2),
('United', 'n616lt', 7,     400, NULL, 'jet', NULL, 4),
('United', 'n620la', 4,     200, 'plane_8', 'prop', 0, 2);


-- Putting in data for Flight Table
INSERT INTO flight VALUES
('AM_1523', 'n330ss', 'American', 2, 'on_ground', '14:30:00', 'circle_west_coast'),
('DL_1174', 'n106js', 'Delta', 0, 'on_ground', '08:00:00', 'northbound_east_coast'),
('DL_1243', 'n110jn', 'Delta', 0, 'on_ground', '09:30:00', 'westbound_north_nonstop'),
('DL_3410', NULL, NULL, NULL, NULL, NULL, 'circle_east_coast'),
('SP_1880', 'n256ap', 'Spirit', 2, 'in_flight', '15:00:00', 'circle_east_coast'),
('SW_1776', 'n401fj', 'Southwest', 2, 'in_flight', '14:00:00', 'hub_xchg_southwest'),
('SW_610', 'n118fm', 'Southwest', 2, 'in_flight', '11:30:00', 'local_texas'),
('UN_1899', 'n517ly', 'United', 0, 'on_ground', '09:30:00', 'eastbound_north_milk_run'),
('UN_523', 'n620la', 'United', 1, 'in_flight', '11:00:00', 'hub_xchg_southeast'),
('UN_717', NULL, NULL, NULL, NULL, NULL, 'circle_west_coast');

INSERT INTO airport VALUES
('ABQ', 'Albuquerque International Sunport', 'Albuquerque', 'NM', NULL),
('ANC', 'Ted Stevens Anchorage International Airport', 'Anchorage', 'AK', NULL),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 'port_1'),
('BDL', 'Bradley International Airport', 'Hartford', 'CT', NULL),
('BFI', 'King County International Airport', 'Seattle', 'WA', 'port_10'),
('BHM', 'Birmingham-Shuttlesworth International Airport', 'Birmingham', 'AL', NULL),
('BNA', 'Nashville International Airport', 'Nashville', 'TN', NULL),
('BOI', 'Boise Airport', 'Boise', 'ID', NULL),
('BOS', 'General Edward Lawrence Logan International Airport', 'Boston', 'MA', NULL),
('BTV', 'Burlington International Airport', 'Burlington', 'VT', NULL),
('BWI', 'Baltimore_Washington International Airport','Baltimore','MD', NULL),
('BZN', 'Bozeman Yellowstone International Airport','Bozeman','MT', NULL),
('CHS', 'Charleston International Airport', 'Charleston','SC', NULL),
('CLE', 'Cleveland Hopkins International Airport','Cleveland','OH', NULL),
('CLT', 'Charlotte Douglas International Airport','Charlotte','NC', NULL),
('CRW', 'Yeager Airport', 'Charleston', 'WV', NULL),
('DAL', 'Dallas Love Field', 'Dallas', 'TX',  'port_7'),
('DCA', 'Ronald Reagan Washington National Airport','Washington', 'DC', 'port_9'),
('DEN', 'Denver International Airport', 'Denver', 'CO', 'port_3'),
('DFW', 'Dallas-Fort Worth International Airport',  'Dallas','TX',  'port_2'),
('DSM', 'Des Moines International Airport', 'Des Moines','IA', NULL),
('DTW', 'Detroit Metro Wayne County Airport','Detroit', 'MI', NULL),   
('EWR', 'Newark Liberty International Airport', 'Newark','NJ', NULL),
('FAR', 'Hector International Airport', 'Fargo','ND', NULL),
('FSD', 'Joe Foss Field','Sioux Falls', 'SD', NULL),
('GSN', 'Saipan International Airport', 'Obyan Saipan Island','MP', NULL),
('GUM', 'Antonio B_Won Pat International Airport','Agana Tamuning','GU', NULL),
('HNL', 'Daniel K. Inouye International Airport','Honolulu Oahu', 'HI', NULL),
('HOU', 'William P_Hobby Airport','Houston','TX','port_18'),
('IAD', 'Washington Dulles International Airport','Washington', 'DC','port_11'),
('IAH', 'George Bush Intercontinental Houston Airport', 'Houston','TX','port_13'),
('ICT', 'Wichita Dwight D_Eisenhower National Airport', 'Wichita','KS', NULL),
('ILG', 'Wilmington Airport','Wilmington',  'DE', NULL),
('IND', 'Indianapolis International Airport','Indianapolis','IN', NULL),
('ISP', 'Long Island MacArthur Airport','New York Islip','NY','port_14'),
('JAC', 'Jackson Hole Airport', 'Jackson','WY', NULL),
('JAN', 'Jackson_Medgar Wiley Evers International Airport', 'Jackson','MS', NULL),
('JFK', 'John F_Kennedy International Airport', 'New York', 'NY','port_15'),
('LAS', 'Harry Reid International Airport', 'Las Vegas','NV', NULL),
('LAX', 'Los Angeles International Airport','Los Angeles','CA','port_5'),
('LGA', 'LaGuardia Airport', 'New York','NY',NULL),
('LIT', 'Bill and Hillary Clinton National Airport','Little Rock','AR', NULL),
('MCO', 'Orlando International Airport','Orlando','FL', NULL),
('MDW', 'Chicago Midway International Airport', 'Chicago',  'IL', NULL),
('MHT', 'Manchester_Boston Regional Airport','Manchester',  'NH', NULL),
('MKE', 'Milwaukee Mitchell International Airport', 'Milwaukee','WI', NULL),
('MRI', 'Merrill Field','Anchorage','AK', NULL),
('MSP', 'Minneapolis_St_Paul International Wold_Chamberlain Airport','Minneapolis Saint Paul','MN', NULL),
('MSY', 'Louis Armstrong New Orleans International Airport','New Orleans','LA', NULL),
('OKC', 'Will Rogers World Airport','Oklahoma City','OK', NULL),
('OMA', 'Eppley Airfield','Omaha','NE', NULL),
('ORD', 'O_Hare International Airport', 'Chicago','IL','port_4'),
('PDX', 'Portland International Airport','Portland','OR', NULL),
('PHL', 'Philadelphia International Airport','Philadelphia','PA', NULL),
('PHX', 'Phoenix Sky Harbor International Airport', 'Phoenix','AZ', NULL),
('PVD', 'Rhode Island T_F_Green International Airport', 'Providence','RI', NULL),
('PWM', 'Portland International Jetport','Portland','ME', NULL),
('SDF', 'Louisville International Airport', 'Louisville','KY', NULL),
('SEA', 'Seattle-Tacoma International Airport','Seattle Tacoma','WA','port_17'),
('SJU', 'Luis Munoz Marin International Airport','San Juan Carolina','PR', NULL),
('SLC', 'Salt Lake City International Airport', 'Salt Lake City','UT', NULL),
('STL', 'St_Louis Lambert International Airport','Saint Louis', 'MO', NULL),
('STT', 'Cyril E_King Airport', 'Charlotte Amalie Saint Thomas','VI', NULL);

-- Putting in data for Person Table
INSERT INTO person VALUES
('p1', 'Jeanne', 'Nelson', 'plane_1'),
('p10', 'Lawrence', 'Morgan', 'plane_9'),
('p11', 'Sandra', 'Cruz', 'plane_9'),
('p12', 'Dan', 'Ball', 'plane_11'),
('p13', 'Bryant', 'Figueroa', 'plane_2'),
('p14', 'Dana', 'Perry', 'plane_2'),
('p15', 'Matt', 'Hunt', 'plane_2'),
('p16', 'Edna', 'Brown', 'plane_15'),
('p17', 'Ruby', 'Burgess', 'plane_15'),
('p18', 'Esther', 'Pittman', 'port_2'),
('p19', 'Doug', 'Fowler', 'port_4'),
('p2', 'Roxanne', 'Byrd', 'plane_1'),
('p20', 'Thomas', 'Olson', 'port_3'),
('p21', 'Mona', 'Harrison', 'port_4'),
('p22', 'Arlene', 'Massey', 'port_2'),
('p23', 'Judith', 'Patrick', 'port_3'),
('p24', 'Reginald', 'Rhodes', 'plane_1'),
('p25', 'Vincent', 'Garcia', 'plane_1'),
('p26', 'Cheryl', 'Moore', 'plane_4'),
('p27', 'Michael', 'Rivera', 'plane_7'),
('p28', 'Luther', 'Matthews', 'plane_8'),
('p29', 'Moses', 'Parks', 'plane_8'),
('p3', 'Tanya', 'Nguyen', 'plane_4'),
('p30', 'Ora', 'Steele', 'plane_9'),
('p31', 'Antonio', 'Flores', 'plane_9'),
('p32', 'Glenn', 'Ross', 'plane_11'),
('p33', 'Irma', 'Thomas', 'plane_11'),
('p34', 'Ann', 'Maldonado', 'plane_2'),
('p35', 'Jeffrey', 'Cruz', 'plane_2'),
('p36', 'Sonya', 'Price', 'plane_15'),
('p37', 'Tracy', 'Hale', 'plane_15'),
('p38', 'Albert', 'Simmons', 'port_1'),
('p39', 'Karen', 'Terry', 'port_9'),
('p4', 'Kendra', 'Jacobs', 'plane_4'),
('p40', 'Glen', 'Kelley', 'plane_4'),
('p41', 'Brooke', 'Little', 'port_4'),
('p42', 'Daryl', 'Nguyen', 'port_3'),
('p43', 'Judy', 'Willis', 'port_1'),
('p44', 'Marco', 'Klein', 'port_2'),
('p45', 'Angelica', 'Hampton', 'port_5'),
('p5', 'Jeff', 'Burton', 'plane_4'),
('p6', 'Randall', 'Parks', 'plane_7'),
('p7', 'Sonya', 'Owens', 'plane_7'),
('p8', 'Bennie', 'Palmer', 'plane_8'),
('p9', 'Marlene', 'Warner', 'plane_8');

INSERT INTO passenger VALUES
('p21', 771),
('p22', 374),
('p23', 414),
('p24', 292),
('p25', 390),
('p26', 302),
('p27', 470),
('p28', 208),
('p29', 292),
('p30', 686),
('p31', 547),
('p32', 257),
('p33', 564),
('p34', 211),
('p35', 233),
('p36', 293),
('p37', 552),
('p38', 812),
('p39', 541),
('p40', 441),
('p41', 875),
('p42', 691),
('p43', 572),
('p44', 572),
('p45', 663);



INSERT INTO pilot VALUES
 ('p1', '330-12-6907', 31 ,'Delta','n106js'),
 ('p10', '769-60-1266', 15 ,'Southwest','n401fj'),
 ('p11', '369-22-9505',	22,'Southwest', 'n401fj'),
 ('p12','680-92-5329', 24, 'Southwest', 'n118fm'),
 ('p13','513-40-4168', 24,'Delta','n110jn'),
 ('p14','454-71-7847', 13,	'Delta','n110jn'),
 ('p15','153-47-8101', 30,	'Delta','n110jn'),
 ('p16','598-47-5172', 28,'Spirit','n256ap'),
 ('p17','865-71-6800', 36,	'Spirit','n256ap'),
 ('p18','250-86-2784', 23, NULL, NULL),
 ('p19','386-39-7881', 2, NULL, NULL),
 ('p2', '842-88-1257',	9, 'Delta',	'n106js'),
 ('p20','522-44-3098',	28, NULL, NULL),
 ('p21','621-34-5755', 2, NULL, NULL),
 ('p22','177-47-9877',	3, NULL, NULL),
 ('p23','528-64-7912', 12, NULL, NULL),
 ('p24','803-30-1789',	34, NULL, NULL),
 ('p25', '986-76-1587', 13, NULL, NULL),
 ('p26','584-77-5105', 20, NULL, NULL),
 ('p3', '750-24-7616',	11, 'American',	'n330ss'),
 ('p4','776-21-8098', 24, 'American','n330ss'),
 ('p5','933-93-2165',	27, 'American',	'n330ss'),
 ('p6','707-84-4555',	38,	'United','n517ly'),
 ('p7','450-25-5617',	13, 'United','n517ly'),
 ('p8','701-38-2179',	12,	'United','n620la'),
 ('p9','936-44-6941',	13,	'United','n620la');

 INSERT INTO license VALUES
('p1', 'jet'),
('p10', 'jet'),
('p11', 'jet'),
('p11', 'prop'),
('p12', 'prop'),
('p13', 'jet'),
('p14', 'jet'),
('p15', 'jet'),
('p15', 'prop'),
('p15', 'testing'),
('p16', 'jet'),
('p17', 'jet'),
('p17', 'prop'),
('p18', 'jet'),
('p19', 'jet'),
('p2', 'jet'),
('p2', 'prop'),
('p20', 'jet'),
('p21', 'jet'),
('p21', 'prop'),
('p22', 'jet'),
('p23', 'jet'),
('p24', 'jet'),
('p24', 'prop'),
('p24', 'testing'),
('p25', 'jet'),
('p26', 'jet'),
('p3', 'jet'),
('p4', 'jet'),
('p4', 'prop'),
('p5', 'jet'),
('p6', 'jet'),
('p6', 'prop'),
('p7', 'jet'),
('p8', 'prop'),
('p9', 'jet'),
('p9', 'prop'),
('p9', 'testing');



-- Putting in data for Ticket Table
INSERT INTO ticket VALUES
('tkt_am_17', 375, 'AM_1523', 'ORD', 'p40'),
('tkt_am_18', 275, 'AM_1523', 'LAX', 'p41'),
('tkt_am_3', 250, 'AM_1523', 'LAX', 'p26'),
('tkt_dl_1', 450, 'DL_1174', 'JFK', 'p24'),
('tkt_dl_11', 500, 'DL_1243', 'LAX', 'p34'),
('tkt_dl_12', 250, 'DL_1243', 'LAX', 'p35'),
('tkt_dl_2', 225, 'DL_1174', 'JFK', 'p25'),
('tkt_sp_13', 225, 'SP_1880', 'ATL', 'p36'),
('tkt_sp_14', 150, 'SP_1880', 'DCA', 'p37'),
('tkt_sp_16', 475, 'SP_1880', 'ATL', 'p39'),
('tkt_sw_10', 425, 'SW_610', 'HOU', 'p33'),
('tkt_sw_7', 400, 'SW_1776', 'ORD', 'p30'),
('tkt_sw_8', 175, 'SW_1776', 'ORD', 'p31'),
('tkt_sw_9', 125, 'SW_610', 'HOU', 'p32'),
('tkt_un_15', 150, 'UN_523', 'ORD', 'p38'),
('tkt_un_4', 175, 'UN_1899', 'DCA', 'p27'),
('tkt_un_5', 225, 'UN_523', 'ATL', 'p28'),
('tkt_un_6', 100, 'UN_523', 'ORD', 'p29');

INSERT INTO seat VALUES
('tkt_dl_1', '1C'),
('tkt_dl_1', '2F'),
('tkt_dl_2', '2D'),
('tkt_am_3', '3B'),
('tkt_un_4', '2B'),
('tkt_un_5', '1A'),    
('tkt_un_6', '3B'),
('tkt_sw_7', '3C'),    
('tkt_sw_8', '3E'),    
('tkt_sw_9', '1C'),
('tkt_sw_10', '1D'),
('tkt_dl_11', '1B'),   
('tkt_dl_11', '1E'),
('tkt_dl_11', '2F'),
('tkt_dl_12', '2A'),
('tkt_sp_13', '1A'),
('tkt_sp_14', '2B'),	
('tkt_un_15', '1B'),	
('tkt_sp_16', '2C'),
('tkt_sp_16', '2E'),
('tkt_am_17', '2B'),
('tkt_am_18', '2A');  

INSERT INTO leg VALUES
('leg_11',600,'IAD','ORD'),
('leg_13',1400,'IAH','LAX'),
('leg_14',2400,'ISP','BFI'),
('leg_15 ',800,'JFK','ATL'),
('leg_2',600,'ATL','IAH'),
('leg_5 ',1000,'BFI','LAX'),
('leg_4', 600, 'ATL', 'ORD'),
('leg_18', 1200, 'LAX', 'DFW'),
('leg_24', 1800, 'SEA', 'ORD'),
('leg_23', 2400, 'SEA', 'JFK'),
('leg_25', 600, 'ORD', 'ATL'),
('leg_22', 800, 'ORD', 'LAX'),
('leg_12', 200, 'IAH', 'DAL'),
('leg_3', 800, 'ATL', 'JFK'),
('leg_21', 800, 'ORD', 'DFW'),
('leg_16', 800, 'JFK', 'ORD'),
('leg_17', 2400, 'JFK', 'SEA'),
('leg_27', 1600, 'ATL', 'LAX'),
('leg_20', 600, 'ORD', 'DCA'),
('leg_10', 800, 'DFW', 'ORD'),
('leg_9', 800, 'DFW', 'ATL'),
('leg_26', 800, 'LAX', 'ORD'),
('leg_6', 200, 'DAL', 'HOU'),
('leg_7', 600, 'DCA', 'ATL'),
('leg_8', 200, 'DCA', 'JFK'),
('leg_1', 600, 'ATL', 'IAD'),
('leg_19', 1000, 'LAX', 'SEA');

INSERT INTO contain VALUES
('circle_east_coast', 'leg_4', 1),
('circle_west_coast', 'leg_18', 1),
('eastbound_north_milk_run', 'leg_24', 1),
('eastbound_north_nonstop', 'leg_23', 1),
('eastbound_south_milk_run', 'leg_18', 1),
('hub_xchg_southeast', 'leg_25', 1),
('hub_xchg_southwest', 'leg_22', 1),
('local_texas', 'leg_12', 1),
('northbound_east_coast', 'leg_3', 1),
('northbound_west_coast', 'leg_19', 1),
('southbound_midwest', 'leg_21', 1),
('westbound_north_milk_run', 'leg_16', 1),
('westbound_north_nonstop', 'leg_17', 1),
('circle_east_coast', 'leg_20', 2),
('circle_west_coast', 'leg_10', 2),
('eastbound_north_milk_run', 'leg_20', 2),
('eastbound_south_milk_run', 'leg_9', 2),
('hub_xchg_southeast', 'leg_4', 2),
('hub_xchg_southwest', 'leg_26', 2),
('local_texas', 'leg_6', 2),
('westbound_north_milk_run', 'leg_22', 2),
('circle_east_coast', 'leg_7', 3),
('circle_west_coast', 'leg_22', 3),
('eastbound_north_milk_run', 'leg_8', 3),
('eastbound_south_milk_run', 'leg_1', 3),
('westbound_north_milk_run', 'leg_19', 3);