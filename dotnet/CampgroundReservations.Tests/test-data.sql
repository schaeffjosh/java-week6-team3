﻿BEGIN TRANSACTION;

DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS site;
DROP TABLE IF EXISTS campground;
DROP TABLE IF EXISTS park;

CREATE TABLE park (
  park_id integer identity NOT NULL,
  name varchar(80) NOT NULL,          -- Name of the park
  location varchar(50) NOT NULL,      -- State name(s) where park is located
  establish_date date NOT NULL,       -- Date park was established
  area integer NOT NULL,              -- Area in acres
  visitors integer NOT NULL,          -- Latest recorded number of annual visitors
  description varchar(500) NOT NULL,
  CONSTRAINT pk_park_park_id PRIMARY KEY (park_id)
);

CREATE TABLE campground (
  campground_id integer identity NOT NULL,
  park_id integer NOT NULL,            -- ID of park the campground is at
  name varchar(80) NOT NULL,           -- Name of the campground
  open_from_mm integer NOT NULL,       -- Campground is open from month: 1=January, 2=February, ... 12=December
  open_to_mm integer NOT NULL,         -- Campground is open to month: 1=January, 2=February, ... 12=December
  daily_fee decimal(13,2) NOT NULL,
  CONSTRAINT pk_campground_campground_id PRIMARY KEY (campground_id),
  CONSTRAINT fk_campground_park FOREIGN KEY (park_id) REFERENCES park(park_id)
);

CREATE TABLE site (
  site_id integer identity NOT NULL,
  campground_id integer NOT NULL,			            -- ID of campground the site is at
  site_number integer NOT NULL,                   -- Site numbers are arbitrarily assigned by the campground
  max_occupancy integer NOT NULL DEFAULT 6,       -- Sites are limited to 6 people, however some sites are "doubled" (12 people)
  accessible bit NOT NULL DEFAULT 0,              -- Accessible site, reserved for campers with disabilities
  max_rv_length integer NOT NULL DEFAULT 0,       -- The maximum RV/Trailer length that the campsite can fit. RVs/Trailers not permitted if length is 0
  utilities bit NOT NULL DEFAULT 0,               -- Indicates whether or not the campsite provides access to utility hookup
  CONSTRAINT pk_site_site_number_campground_id PRIMARY KEY (site_id),
  CONSTRAINT fk_site_campground FOREIGN KEY (campground_id) REFERENCES campground(campground_id)
);

CREATE TABLE reservation (
  reservation_id integer identity NOT NULL,
  site_id integer NOT NULL,							      -- ID of site the reservation is at
  name varchar(80) NOT NULL,						      -- Name for the reservation
  from_date date NOT NULL,							      -- Start date of reservation
  to_date date NOT NULL,							        -- End date of reservation
  create_date DATETIME DEFAULT GETDATE(),			-- Date the reservation was booked
  CONSTRAINT pk_reservation_reservation_id PRIMARY KEY (reservation_id),
  CONSTRAINT fk_reservation_site FOREIGN KEY (site_id) REFERENCES site(site_id)
);


-- test parks
INSERT INTO park (name, location, establish_date, area, visitors, description)
VALUES ('Park 1', 'Pennsylvania', '1/1/1970', 1024, 512, 'Test description 1')
DECLARE @parkId1 int = (SELECT @@IDENTITY);

INSERT INTO park (name, location, establish_date, area, visitors, description)
VALUES ('Park 2', 'Ohio', '1/1/1970', 2048, 1024, 'Test description 2')


-- test campgrounds
INSERT INTO campground(park_id, name, open_from_mm, open_to_mm, daily_fee)
VALUES (@parkId1, 'Test Campground', 1, 12, 35);
DECLARE @campgroundId int = (SELECT @@IDENTITY);

INSERT INTO campground(park_id, name, open_from_mm, open_to_mm, daily_fee)
VALUES (@parkId1, 'Test Campground', 1, 12, 35);


-- test sites
---- accepts RVs
INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 1, 10, 1, 33, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 2, 10, 1, 30, 1);

---- doesn't accept RVs
INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 3, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 4, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 5, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 6, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 7, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 8, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 9, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 10, 10, 1, 0, 1);

INSERT INTO site(campground_id, site_number, max_occupancy, accessible, max_rv_length, utilities)
VALUES (@campgroundId, 11, 10, 1, 0, 1);
DECLARE @siteId int = (SELECT @@IDENTITY);

-- test reservations
/** site 1 reservations in past only */
/**** past to past */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (1, 'Amy Adams', GETDATE() - 18, GETDATE() - 11, GETDATE() - 23);  

INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (1, 'Bob Billings', GETDATE() - 2, GETDATE() - 1, GETDATE() - 3); 

/** site 2 reservations */
/**** past to past */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (2, 'Carl Cook', GETDATE() - 15, GETDATE() - 10, GETDATE() - 20); 

/** site 3 reservations */
/**** past to past */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (3, 'Denise Davies', GETDATE() - 3, GETDATE() - 1, GETDATE() - 10); 

/** site 4 reservations */
/**** past to current */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (4, 'Eddie Eddies', GETDATE() - 5, GETDATE(), GETDATE() - 10); 

/** site 5 reservations */
/**** past to current */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (5, 'Fred Funston', GETDATE() - 1, GETDATE(), GETDATE() - 10); 

/** site 6 reservations */
/**** past to future */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (6, 'Gina Garbot', GETDATE() - 1, GETDATE() + 1, GETDATE() - 10); 

/** site 7 reservations */
/**** past to future */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (7, 'Hank Howard', GETDATE() - 10, GETDATE() + 10, GETDATE() - 15); 

/** site 8 reservations */
/**** current to future */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (8, 'Jen Johnson', GETDATE(), GETDATE() + 1, GETDATE() - 10); 

/** site 9 reservations */
/**** current to future */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (9, 'Leonard Leonardson', GETDATE(), GETDATE() + 10, GETDATE() - 10); 

/** site 10 reservations */
/**** future to future */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (10, 'Mark Mandel', GETDATE() + 1, GETDATE() + 2, GETDATE() - 10); 

/** site 11 reservations */
/**** future to future */
INSERT INTO reservation(site_id, name, from_date, to_date, create_date)
VALUES (11, 'Nancy Norbert', GETDATE() + 5, GETDATE() + 10, GETDATE() - 10); 
DECLARE @reservationId int = (SELECT @@IDENTITY);

COMMIT TRANSACTION;
