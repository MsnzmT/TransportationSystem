CREATE OR REPLACE FUNCTION random2_string()
RETURNS text AS $$
declare result text;
BEGIN

    SELECT md5(random()::text) INTO result;
    return result;
END;
$$ LANGUAGE plpgsql;

-- a function for login and return user_id
CREATE OR REPLACE function login(submit_email varchar, pass varchar)
    returns int AS
$$
declare userid int;
BEGIN
    IF EXISTS (SELECT user_id FROM users where email = submit_email and password = crypt(pass, password) and is_active = TRUE) 
    OR EXISTS (SELECT user_id FROM users where phone_number = submit_email and password = crypt(pass, password) and is_active = TRUE) 
    THEN
        SELECT user_id into userid FROM users where email = email and password = crypt(pass, password);
    ELSE
        RAISE EXCEPTION 'email or password is incorrect or account has not verified yet !';
    END IF;
    return userid;
END;
$$
language plpgsql;

CREATE OR REPLACE FUNCTION add_user()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.role = 'passenger' THEN
        INSERT INTO passenger (user_id) VALUES (NEW.user_id);
    ELSIF NEW.role = 'manager' THEN
        INSERT INTO manager (user_id) VALUES (NEW.user_id);
    END IF;
    INSERT INTO otp (otp_code, user_id) VALUES (random2_string(), NEW.user_id);
    return NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER new_user
    AFTER INSERT
    ON users
    FOR EACH ROW
    when (pg_trigger_depth() < 1)
    execute procedure add_user();


-- INSERT INTO users(
--             user_id, 
--             first_name,
--             last_name,
--             national_code,
--             nationality,
--             phone_number, 
--             email, 
--             role,
--             username,
--             password
-- )
-- VALUES (
--             7, 
--             'ali',
--             'alavi',
--             1234561890,
--             'iranian',
--             '09123456189', 
--             'aw@b.com',
--             'manager',
--             'aliiw',
--             crypt('123456', gen_salt('bf'))
-- );



-- active user and check expiration date
CREATE OR REPLACE procedure active_user(otpcode varchar, userid int)
    AS
$$
BEGIN
    IF EXISTS (SELECT otp_code FROM otp where otp_code = otpcode and user_id = userid and expiration_date>now()) THEN
        UPDATE users SET is_active = true WHERE user_id = userid;
        DELETE FROM otp WHERE user_id = userid;
    ELSE
        RAISE EXCEPTION 'otp code is not valid or expired';
    END IF;
END;
$$
language plpgsql;

--call active_user('b6e36407954ba67ca91e1bd4e4e6526a', 4);


