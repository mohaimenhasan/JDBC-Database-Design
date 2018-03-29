SET SEARCH_PATH TO carschema;
drop table if exists q3 cascade;

-- This query returns the car models based on reservations
-- so if there's a different reservation it would return a different car



-- CREATE a table for the query
CREATE TABLE q3(
	CAR_MODEL VARCHAR(100)
);


-- Find the most frequently rented car model in Toronto, where the reservation started and was fully completed in the year 2017.
CREATE VIEW all2017Res AS
	SELECT Car_id
	FROM reservation
	WHERE From_date >= '2017-01-01 00:00:00'
	and To_date <= '2017-12-31 23:59:59'
	and status = 'Completed';

-- Get model numbers
CREATE VIEW model_num AS
	SELECT Model_id, Station_code, count (*) as Count
	FROM all2017Res JOIN car on Car_id = ID
	GROUP BY Model_id, Station_code;


-- Get Toronto Cars
CREATE VIEW toronto_cars AS
	SELECT Model_id, Count
	FROM model_num JOIN rentalstation
	ON model_num.Station_code = rentalstation.Station_code
	WHERE rentalstation.City = 'Toronto';


-- get model name
CREATE VIEW model_name AS
	SELECT Name, Count
	FROM toronto_cars JOIN model on Model_id = ID
	ORDER BY Count DESC, Name;

CREATE VIEW answer3 AS
	SELECT Name 
	FROM model_name limit 1;

-- the answer to the query 
insert into q3 (SELECT * from answer3);

SELECT * from q3;
