-- Each passenger should have their own panel with personal information
SELECT first_name, last_name, phone_number, source, destination, travel_price
FROM passenger_travel
NATURAL JOIN passenger
NATURAL JOIN travel
NATURAL JOIN users
WHERE passenger_id = 1
GROUP BY first_name, last_name, phone_number, source, destination, travel_price;



CREATE OR REPLACE function what_is_passenger_id(userid int)
    returns int AS
$$
declare passengerid int;
BEGIN
    IF EXISTS (SELECT passenger_id FROM passenger where user_id = userid) THEN
        SELECT passenger_id into passengerid FROM passenger where user_id = userid;
    ELSE
        RAISE EXCEPTION 'this user is not a passenger';
    END IF;
    return passengerid;
END;
$$
language plpgsql;





-- only passengers can reserve a ticket
CREATE OR REPLACE function add_passenger_travel()
    returns TRIGGER AS
$$
BEGIN
    IF wich_role(login('msn.zmt81@gmail.com', 'mohsenpassword')) <> 'passenger' THEN
        RAISE EXCEPTION 'only passengers can insert into a passenger_travel';
    END IF;
    return NEW;
END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER new_passenger_travel
   BEFORE INSERT
   ON passenger_travel
   FOR EACH ROW
   when (pg_trigger_depth() < 1)
   execute procedure add_passenger_travel();


-- query for reserve a ticket
--INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (what_is_passenger_id(login('msn.zmt81@gmail.com', 'mohsenpassword')), 12, NOW(), NOW());


-- procedure for change status to paid
CREATE OR REPLACE procedure change_status_to_paid(travelid int, codee int)

    AS
$$
BEGIN
    IF EXISTS (SELECT capacity FROM travel where travel_id = travelid and capacity = 0) THEN
        RAISE EXCEPTION 'capacity is full';
    ELSE
        UPDATE passenger_travel SET status = 'paid', action_date=now(), action_time=now() WHERE code=codee;
        UPDATE travel SET capacity = capacity - 1 WHERE travel_id = travelid;
    END IF;
END;
$$
LANGUAGE 'plpgsql';


--call change_status_to_paid(12,13);





-- rate a travel
CREATE OR REPLACE procedure rate_a_travel(codee int, ratee int)

    AS
$$
BEGIN
    IF EXISTS (SELECT code FROM passenger_travel NATURAL JOIN travel where code = codee and departure_date < now()) THEN
        UPDATE passenger_travel SET rate = ratee WHERE code = codee;
    ELSE
        RAISE EXCEPTION 'travel must be passed';
    END IF;
END;
$$
LANGUAGE 'plpgsql';



--call rate_a_travel(13, 2);



-- query to execute rating of travel_agency
SELECT travel_agency_id, avg(rate) as avg_rate
FROM passenger_travel
NATURAL JOIN travel
GROUP BY travel_agency_id
ORDER BY avg_rate DESC;

-- query to filter ticket by source and destination and departure date and price
SELECT source, destination, departure_date, departure_time, travel_price
FROM travel
WHERE source = 'meymand' and destination = 'tabriz' and departure_date = '2020-11-24' and travel_price <= 234;



