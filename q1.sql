SET SEARCH_PATH TO carschema;
drop table if exists q1 cascade;



-- Create answer table:
create table q1(
	CUSTOMER_EMAIL VARCHAR(100),
	CANCEL_RATIO decimal
);



-- find all the ones where there was no old reservation
-- find the numerator:


-- find the old reservation ids
-- this can be used to filter out the IDs that were previously cancelled 
CREATE VIEW old_id as
	select old_reservation
	from reservation 
	where old_reservation is NOT NULL; 


-- find the reservation ids <> old reservation ids
-- Old reservation was changed
-- Status = Cancelled
CREATE VIEW cancelled_ID AS
	select ID 
	from reservation where status = 'Cancelled'
	except
	select old_reservation
	from old_id;


-- Customer ids with no old resrevations taken into account
CREATE VIEW cancel_no_old AS
	SELECT Customer_email, ID, row_number() over (partition by Customer_email order by Customer_email) as cancel
	FROM cancelled_ID join customer_reservation on ID = Reservation_id
	ORDER BY Customer_email;

-- find the max cancellations per customer

CREATE VIEW find_max AS
	SELECT Customer_email, MAX(cancel)::decimal as cancel
	FROM cancel_no_old
	GROUP BY Customer_email
	ORDER BY Customer_email;

-- find denominator of the fraction A/B
CREATE VIEW total_reservation as
	select f.Customer_email, row_number() over(partition by f.Customer_email) as total
	from find_max as f join customer_reservation as c on f.Customer_email = c.Customer_email join reservation as r on c.Reservation_id = r.id 
	where status <> 'Cancelled' order by Customer_email;  

-- find denominator max 
-- find the max
CREATE VIEW total_max AS
	SELECT Customer_email, MAX(total)::decimal as total
	FROM total_reservation
	GROUP BY Customer_email
	ORDER BY Customer_email;


-- find the ratio per customer
-- this filters out customers along with their email, and cancel ratio from largest to smallest
CREATE VIEW ratio as 
	SELECT f.Customer_email as CUSTOMER_EMAIL, (f.cancel/t.total) as CANCEL_RATIO
	FROM find_max as f JOIN total_max as t on t.Customer_email = f.Customer_email
	ORDER BY CANCEL_RATIO desc, CUSTOMER_EMAIL; 

-- Returns the top two results from ratio
CREATE VIEW answer1 as
	SELECT * from ratio limit 2;

-- the answer to the query 
insert into q1 (SELECT * from answer1);