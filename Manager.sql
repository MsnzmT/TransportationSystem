CREATE OR REPLACE function wich_role(id int)
RETURNS role_type AS $$
declare user_role role_type;
BEGIN
    SELECT role into user_role FROM users where user_id = id;
    
    return user_role;
END; $$
language plpgsql;


-- only managers can insert into a travel
CREATE OR REPLACE function add_travel()
    returns TRIGGER AS
$$
BEGIN
    IF wich_role(login('asadi@gmail.com','usofpassword')) <> 'manager' THEN
        RAISE EXCEPTION 'only managers can insert into a travel';
    END IF;
    return NEW;
END; 
$$
LANGUAGE 'plpgsql';




CREATE TRIGGER new_travel
    BEFORE INSERT
    ON travel
    FOR EACH ROW
    when (pg_trigger_depth() < 1)
    execute procedure add_travel();


-- query for add travel
-- INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('meymand', 'tabriz', 234, '2020-11-24', '21:40:00', 10, 1, 1);



--Managers should be able to retrieve information on the top 5 customers with the highest total paid price for travels in a specific month. Include their full name, contact information (email or phone number), total paid price, number of destinations they traveled to in that month, and the name of the city they visited the most.
SELECT first_name, last_name, phone_number, sum(travel_price) as travel_price, count(destination) as destination_count
FROM passenger_travel
NATURAL JOIN travel NATURAL JOIN passenger NATURAL JOIN users
WHERE action_date >= '2021-11-01' and action_date <= '2021-11-30' and status = 'paid'
GROUP BY first_name, last_name, phone_number
ORDER BY sum(travel_price) DESC
LIMIT 5;


-- They can receive needed stats at once, like: Bestselling travels - highest rating
SELECT travel_id, source, destination, count(travel_id) as count, avg(rate) as avg_rate
FROM passenger_travel
NATURAL JOIN travel
GROUP BY travel_id, source, destination
ORDER BY count(travel_id) DESC, avg(rate) DESC;

-- They can receive needed stats at once, like: highest income through the year based on time
SELECT extract(month from action_date) as month, sum(travel_price) as income
FROM passenger_travel
NATURAL JOIN travel
WHERE action_date >= '2021-01-01' and action_date <= '2021-12-31' and status = 'paid'
GROUP BY extract(month from action_date)
ORDER BY sum(travel_price) DESC;

-- They can receive needed stats at once, like: most popular destination
SELECT destination, count(destination) as count
FROM passenger_travel
NATURAL JOIN travel
GROUP BY destination
ORDER BY count(destination) DESC;

-- Managers can filter travels that their agency involved using different filtering parameters such as rating, price, time
SELECT travel_id, source, destination, travel_price, departure_date, departure_time, capacity, rate
FROM passenger_travel
NATURAL JOIN travel
WHERE travel_agency_id = 1 and departure_date >= '2021-11-01' and departure_date <= '2023-11-30' and travel_price<500 and rate = 4
ORDER BY rate DESC, travel_price DESC, departure_date, departure_time;
