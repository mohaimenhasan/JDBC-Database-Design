SET SEARCH_PATH TO carschema;
drop table if exists q2 cascade;


CREATE TABLE q2(
	CUSTOMER_EMAIL VARCHAR(100),
	NUM_SHARED_RESERVATIONS INT
);

-- No Cancelled Reservation
CREATE VIEW no_cancelled AS
	SELECT ID
	FROM reservation
	WHERE Status <> 'Cancelled';


-- Count drivers with the same resrvation ID
CREATE VIEW counter AS
	SELECT Reservation_id, count(*) AS Count
	FROM customer_reservation JOIN no_cancelled
        ON Reservation_id = ID
	GROUP BY Reservation_id;

-- Find groups
CREATE VIEW together AS
	SELECT Reservation_id
	FROM counter WHERE Count >= 2;

-- Find the drivers from groups
CREATE VIEW drivers AS
	SELECT Customer_email, count(*) as times
	FROM together JOIN customer_reservation
        ON together.Reservation_id = customer_reservation.Reservation_id
	GROUP BY Customer_email;

-- Answer
CREATE VIEW answer AS
	SELECT Customer_email, times
	FROM (SELECT row_number() over (ORDER BY (times) DESC, Customer_email) AS rank, Customer_email, times
        from drivers) AS ranking
	WHERE rank <=2;


insert into q2 (SELECT * FROM answer);
