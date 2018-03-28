-- 1. What constraints from the domain could not be enforced?
-- Every customer in the car will have to have their driver's licence. This could not be enforced because of passenger limitations and age restrictions

-- 2. What constraints that could have been enforced were not enforced? Why not? 
--- Same person can not reserve more than one car at the same time. This can be contained within the relational schema when making a call
-- Same car can not be reserved more than once at the same date. This requires triggers using the following condition:
-- CHECK (From_date NOT IN (SELECT From_date FROM reservation as r WHERE r.Car_id = Car_id and (r.status != 'Cancelled' or r.status != 'Completed')))


-- Schema for storing a subset of car rental

DROP SCHEMA if exists carschema cascade;
CREATE SCHEMA carschema;

SET search_path to carschema;


-- Schema for registering a customer
-- Contains Name, Age & Email
-- None of the attributes can be empty
-- Assuming two customers can have the same name, age 
-- Two customers can't have the same email_id

CREATE TABLE customer(
  -- Email Address of the customer
  -- Stored as a primary key as two customers can not have the same email address when they sign up
  -- Since it is a primary key, it can't be NULL
  Email VARCHAR(100) PRIMARY KEY,
	-- Full name of a customer
  -- Assuming name would fit within 100 characters
	Name VARCHAR(100) NOT NULL,
  -- Can not be anything other than an integer
  Age INT NOT NULL,
  -- Age can't be less than 17
  check (Age>=17)
);


-- Model for a car as defined by car-data.txt
-- Contains ID, Name, Vehicle, Model Number, Capacity 
-- Relation doesn't depend on anything
-- Two cars can not have the same ID

CREATE TABLE model(
-- ID for the car
-- Defined as the primary key as no two cars can have the same Car_id
  ID INT PRIMARY KEY,
-- Car model (such as Toyota, Mitshubishi) of the car 
  Name VARCHAR(100) NOT NULL, 
-- Type of the vehicle 
  Vehicle_type VARCHAR(100) NOT NULL, 
-- Model number of the car
-- two cars can have the same model number
  Model_number INT NOT NULL, 
-- max number of seats of the car
  Capacity INT NOT NULL
);


--- RENTALSTATION -----
-- Two stations can have the same station name
-- Can't have the same ID
-- Can't be located at the same region of a city
CREATE TABLE rentalstation(
-- Primary key as the station ID
  Station_code INT PRIMARY KEY,
-- Assuming two stations can have the same name
  Name VARCHAR(100),
-- Every station has a unique address
  Adress VARCHAR(100) NOT NULL UNIQUE,
  Area_code VARCHAR(100) NOT NULL UNIQUE,
-- Assumed can have multiple locations on the same city
  City VARCHAR(100) NOT NULL
);

--- CAR -----
-- Uses an unique ID, Plate Number
-- Can have multiple model ID
CREATE TABLE car(
-- Unique ID to identify each car
  ID INT PRIMARY KEY,
  Licence_plate_number VARCHAR(100) NOT NULL UNIQUE,
-- Station codes are used as a foreign key from rental stations 
  Station_code INT REFERENCES rentalstation(Station_code),
-- Two different cars can have the same model IDs
  Model_id INT REFERENCES model(ID)
);

---- RESERVATION ----
-- Has a unique reservation ID

CREATE TABLE reservation(
 -- Unique ID per reservation
 ID INT PRIMARY KEY, 
 -- Date of reservation: If someone has a reservation in specific time, other people can not reserve same car at the same time
 From_date TIMESTAMP NOT NULL,
 -- To Date > than from date 
 To_date TIMESTAMP NOT NULL CHECK (To_date >= From_date),
 Car_id INT REFERENCES car(ID),
 Old_reservation INT,
 Status VARCHAR(10) CHECK (Status in ('Confirmed', 'Ongoing', 'Completed', 'Cancelled'))
);


--- CUSTOMER_RESERVATION ---

CREATE TABLE customer_reservation(
  Reservation_id INT REFERENCES reservation(ID),
  Customer_email VARCHAR(100) REFERENCES customer(Email)
  );

