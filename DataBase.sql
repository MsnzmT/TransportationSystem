-- CREATE DATABASE transportation_system;


CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE vehicle_type AS ENUM('bus', 'train', 'airplane');
CREATE TYPE role_type AS ENUM('superadmin', 'manager', 'passenger');
CREATE TYPE orderstatus_type AS ENUM('reserved', 'paid', 'error');
CREATE TYPE travel_type AS ENUM('abroad', 'domestic');

CREATE TABLE IF NOT EXISTS vehicle (
    vehicle_id SERIAL PRIMARY KEY,
	model VARCHAR(50),
	year INT,
	color VARCHAR(50),
	fuel_type VARCHAR(20),
	type vehicle_type,
	vehicle_price INT,
    number_of_seats INT
);

CREATE TABLE IF NOT EXISTS travel_agency (
    travel_agency_id serial PRIMARY KEY,
    name varchar(50),
    address varchar(100),
    number varchar(15) UNIQUE
);

create table IF NOT EXISTS travel (
	travel_id serial PRIMARY KEY,
	source VARCHAR(50),
	destination VARCHAR(50),
    travel_price INT,
    departure_date DATE,
    departure_time TIME,
    capacity INT,
    vehicle_id INT,
    travel_agency_id INT,
    abroad_or_domestic travel_type,
    CONSTRAINT fk_vehicle_id FOREIGN KEY(vehicle_id) REFERENCES vehicle(vehicle_id),
    CONSTRAINT fk_travel_agency_id FOREIGN KEY(travel_agency_id) REFERENCES travel_agency(travel_agency_id)
);

CREATE TABLE IF NOT EXISTS users (
    user_id serial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    national_code BIGINT UNIQUE,
    nationality varchar(50),
    phone_number varchar(11) UNIQUE,
    email varchar(50) UNIQUE,
    role role_type,
    username varchar(50) UNIQUE,
    password TEXT NOT NULL,
    is_active BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS passenger(
    passenger_id serial PRIMARY KEY,
    user_id INT,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS manager(
    manager_id serial PRIMARY KEY,
    user_id INT,
    travel_agency_id INT,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_travel_agency_id FOREIGN KEY (travel_agency_id) REFERENCES travel_agency(travel_agency_id)
);



CREATE TABLE IF NOT EXISTS passenger_travel (
    passenger_id INT,
    travel_id INT,
    status orderstatus_type DEFAULT 'reserved',
    action_date date,
    action_time time,
    rate int,
    code serial PRIMARY KEY,
    CONSTRAINT fk_passenger_id FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id),
    CONSTRAINT fk_travel_id FOREIGN KEY (travel_id) REFERENCES travel(travel_id)
);

CREATE TABLE otp (
    otp_id serial PRIMARY KEY,
    otp_code varchar(60),
    expiration_date date DEFAULT CURRENT_DATE + INTERVAL '1 day',
    user_id INT UNIQUE,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE IF NOT EXISTS supporting_ticket(
    ticket_id serial PRIMARY KEY,
    problem_content text,
    answer_content text,
    creator_id INT,
    recipient_id INT,
    answer_date date,
    answer_time time,
    is_seen BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_recipient_id FOREIGN KEY (recipient_id) REFERENCES users(user_id),
    CONSTRAINT fk_creator_id FOREIGN KEY (creator_id) REFERENCES users(user_id)
);





insert into vehicle (model, year, color, fuel_type, type, vehicle_price, number_of_seats) values ('Mercedes-Benz Citaro', 1998, 'Yellow', 'Electric', 'bus', 27491,112);
insert into vehicle (model, year, color, fuel_type, type, vehicle_price, number_of_seats) values ('Bombardier CRJ200', 2001, 'Red', 'Electric', 'airplane', 81498 ,234);
insert into vehicle (model, year, color, fuel_type, type, vehicle_price, number_of_seats) values ('RailMax', 1999, 'Violet', 'Hybrid', 'train', 69137 ,56);

INSERT INTO users (first_name, last_name, national_code, nationality, phone_number, email, role, username, password) values ('usof', 'asadi', 2560509467, 'Persian', '09351985194', 'asadi@gmail.com','manager', 'usof85', crypt('usofpassword', gen_salt('bf')));
INSERT INTO users (first_name, last_name, national_code, nationality, phone_number, email, role, username, password) values ('mohsen', 'zahmatkesh', 2560509466, 'American', '09351985193', 'msn.zmt81@gmail.com','passenger', 'MsnzmT', crypt('mohsenpassword', gen_salt('bf')));
INSERT INTO users (first_name, last_name, national_code, nationality, phone_number, email, role, username, password) values ('mehdi', 'mortazavian', 2560509468, 'yasuji', '09351985195', 'mortazavian@gmail.com','passenger', 'mori', crypt('mehdipassword', gen_salt('bf')));
INSERT INTO users (first_name, last_name, national_code, nationality, phone_number, email, role, username, password) values ('lionel', 'messi', 2284591255, 'argentina', '0417619041', 'lionelmessi@gmail.com','superadmin', 'leomessi', crypt('messipassword', gen_salt('bf')));

INSERT INTO passenger (user_id) VALUES (2);
INSERT INTO passenger (user_id) VALUES (3);



INSERT INTO travel_agency (name,address,number) VALUES ('mahan', 'zaferanie', '021457893');

INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'tehran', 100, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'fasa', 353, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'jam', 672, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'ahvaz', 454, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'qom', 167, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'yasuj', 323, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'borazjan', 767, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'siraf', 121, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'kazerub', 953, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'firuzabad', 999, '2023-11-23', '20:30:00', 112, 1, 1);
INSERT INTO travel (source, destination, travel_price, departure_date, departure_time, capacity, vehicle_id, travel_agency_id) VALUES ('shiraz', 'meymand', 111, '2023-11-23', '20:30:00', 112, 1, 1);

INSERT INTO manager (user_id, travel_agency_id) VALUES (1,1);

INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (1, 1,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (2, 1,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (1, 3,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (2, 4,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (1, 5,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (2, 6,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (1, 7,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (2, 8,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (1, 9,  '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (2, 10, '2021-11-23', '20:30:00');
INSERT INTO passenger_travel (passenger_id, travel_id, action_date, action_time) VALUES (1, 11, '2021-11-23', '20:30:00');