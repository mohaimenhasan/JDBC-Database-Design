SET SEARCH_PATH TO carschema;
drop table if exists q1 cascade;

-- find all the cancelled customers
-- need to use row number right now

CREATE VIEW cancelled_customers AS
	SELECT *, row_number() over (partition by Customer_email) as cancel
	FROM customer_reservation join reservation on Reservation_id = reservation.id 
	WHERE status='Cancelled'
	ORDER BY Customer_email;

-- find the max cancellations per customer
CREATE VIEW find_max AS
	SELECT Customer_email, MAX(cancel)
	FROM cancelled_customers
	GROUP BY Customer_email
	ORDER BY Customer_email;

-- find the max 

-- the answer to the query 
insert into q1;