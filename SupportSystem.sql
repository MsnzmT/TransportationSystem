-- trigger to check if the creator of supporting ticket is passenger or manager
CREATE OR REPLACE FUNCTION check_supporting_ticket() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.creator_id IN (SELECT user_id FROM users WHERE role='passenger' OR role='manager'))  THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'creator of supporting ticket must be passenger or manager';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_supporting_ticket_trigger
   BEFORE INSERT ON supporting_ticket
   FOR EACH ROW EXECUTE PROCEDURE check_supporting_ticket();




-- query for create supporting ticket
--INSERT INTO supporting_ticket(problem_content, creator_id) VALUES ('salam man yek soal daram', 1);



-- procedure to seen and accept supporting ticket
CREATE OR REPLACE PROCEDURE accept_supporting_ticket(ticketid INT) AS $$
BEGIN
    if (login('lionelmessi@gmail.com','messipassword') NOT IN (SELECT user_id FROM users WHERE role='superadmin')) THEN
        RAISE EXCEPTION 'recipient of supporting ticket must be superadmin';
    ELSE
        UPDATE supporting_ticket SET is_seen = TRUE, recipient_id = login('lionelmessi@gmail.com','messipassword')
        WHERE ticket_id = ticketid;
    END IF;
END;
$$
language plpgsql;


--call accept_supporting_ticket(3);



-- answer to supporting ticket
CREATE OR REPLACE PROCEDURE answer_supporting_ticket(ticketid INT, answercontent VARCHAR) AS $$
BEGIN
    if (login('lionelmessi@gmail.com','messipassword')  = (SELECT recipient_id FROM supporting_ticket WHERE ticket_id = ticketid)) THEN
        UPDATE supporting_ticket SET answer_content = answercontent, answer_date = now(), answer_time = now()
        WHERE ticket_id = ticketid;
    ELSE
        RAISE EXCEPTION 'you are not recipient of this supporting ticket';
    END IF;
END;
$$
language plpgsql;


--call answer_supporting_ticket(3, 'hala barresi mikonam');