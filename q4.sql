SET SEARCH_PATH TO carschema;
drop table if exists q4 cascade;

-- CREATE a table for the query
CREATE TABLE q4(
	CUSTOMER_EMAIL VARCHAR(100)
);


-- find people who are below 30 
CREATE VIEW under_age AS
	SELECT Email
	FROM customer
	WHERE Age <= 30;


-- find the old reservation ids
-- changing old_id_haha so that it doesn't confuse runner.txt when run
-- same as q1.sql but adding date with it
CREATE VIEW old_id_haha AS
	SELECT old_reservation, From_date
	FROM reservation 
	WHERE old_reservation IS NOT NULL; 

-- Check only past 18 months
CREATE VIEW changed AS
	SELECT old_reservation
	FROM old_id_haha
	WHERE (current_date - 540)<=From_date;


-- Check people who are below 30 among these resrvations
CREATE VIEW changed_under30 AS
	SELECT Email, count(*) as Count 
	FROM changed JOIN customer_reservation
		ON old_reservation = Reservation_id
		JOIN under_age
		ON Email = Customer_email
	GROUP BY Email;

-- just check count to count >= 2
CREATE VIEW answer4 AS
	SELECT Email 
	FROM changed_under30
	WHERE count >= 2;

-- the answer to the query 
insert into q4 (SELECT * from answer4);


SELECT * from q4;