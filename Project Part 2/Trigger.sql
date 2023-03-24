-- Delivery_requests related Q1
CREATE OR REPLACE FUNCTION check_at_least_one_package() RETURNS TRIGGER
AS $$
DECLARE
  packages_count INTEGER;
BEGIN
  SELECT COUNT(p.package_id) FROM packages p WHERE p.request_id = NEW.id INTO packages_count;

  IF (packages_count < 1) THEN
    RAISE EXCEPTION 'Each delivery request must have at least one package';
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER at_least_one_package_trigger
AFTER INSERT ON delivery_requests
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_at_least_one_package();

-----------------------------------------------------------------------------------------------------------------------------------
-- Package related Q2
-- On packages table, group by request id, then order by increasing, using cursor run 
-- through each of this and check if its sequential, if its not sequential, throw error
CREATE OR REPLACE FUNCTION check_if_package_sequential() RETURNS TRIGGER
AS $$
DECLARE
  curs CURSOR FOR (SELECT p.package_id, p.request_id FROM packages p GROUP BY p.request_id, p.package_id ORDER BY p.package_id ASC);
  r RECORD;
  prev_package_id INTEGER;
BEGIN
  prev_package_id = 0;
  OPEN curs;
  
  LOOP
    FETCH curs INTO r;
    EXIT WHEN NOT FOUND;
    
    IF (r.package_id <> prev_package_id + 1) THEN
      RAISE EXCEPTION 'Package ID must be sequential!';
      RETURN NULL;
    END IF;

    RETURN NULL;
    prev_package_id = r.package_id;
  END LOOP;
  CLOSE curs;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_if_package_sequential_trigger
AFTER INSERT ON packages
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_if_package_sequential();

-----------------------------------------------------------------------------------------------------------------------------------
-- Unsuccessful_pickup Related Q3
CREATE OR REPLACE FUNCTION check_if_unsuccessful_sequential() RETURNS TRIGGER
AS $$
DECLARE
  curs CURSOR FOR (SELECT up.pickup_id, up.request_id FROM unsuccessful_pickups up GROUP BY up.request_id, up.pickup_id ORDER BY up.pickup_id ASC);
  r RECORD;
  prev_pickup_id INTEGER;
BEGIN
  prev_pickup_id = 0;
  OPEN curs;
  
  LOOP
    FETCH curs INTO r;
    EXIT WHEN NOT FOUND;
    
    IF (r.pickup_id <> prev_pickup_id + 1) THEN
      RAISE EXCEPTION 'Unsuccessful Pickup ID must be sequential!';
      RETURN NULL;
    END IF;

    RETURN NULL;
    prev_pickup_id = r.pickup_id;
  END LOOP;
  CLOSE curs;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_if_unsuccessful_sequential_trigger
AFTER INSERT ON unsuccessful_pickups
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_if_unsuccessful_sequential();

-----------------------------------------------------------------------------------------------------------------------------------
-- Unsuccessful_pickup Related Q4
CREATE OR REPLACE FUNCTION check_if_unsuccessful_sequential_timestamp() RETURNS TRIGGER
AS $$
DECLARE
  submission_time TIMESTAMP;
  previous_unsuccessful_time TIMESTAMP;
BEGIN
  SELECT dr.submission_time FROM delivery_requests dr WHERE dr.id = NEW.id INTO submission_time;
  SELECT MAX(up.previous_unsuccessful_time) FROM unsuccessful_pickups up WHERE up.request_id = NEW.id INTO previous_unsuccessful_time;

  IF (submission_time >= NEW.pickup_time) THEN
    RAISE EXCEPTION 'Unsuccessful Pickup time must be later than submission time!';
    RETURN NULL;
  END IF;

  IF (previous_unsuccessful_time >= NEW.pickup_time) THEN
    RAISE EXCEPTION 'Unsuccessful Pickup time must be later than previous pickup time!';
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_if_unsuccessful_sequential_timestamp_trigger
BEFORE INSERT ON unsuccessful_pickups
FOR EACH ROW
EXECUTE FUNCTION check_if_unsuccessful_sequential_timestamp();

-----------------------------------------------------------------------------------------------------------------------------------
-- Legs Related Q1
CREATE OR REPLACE FUNCTION check_if_leg_sequential() RETURNS TRIGGER
AS $$
DECLARE
  curs CURSOR FOR (SELECT l.leg_id, l.request_id FROM legs l GROUP BY l.request_id, l.leg_id ORDER BY l.leg_id ASC);
  r RECORD;
  prev_leg_id INTEGER;
BEGIN
  prev_leg_id = 0;
  OPEN curs;
  
  LOOP
    FETCH curs INTO r;
    EXIT WHEN NOT FOUND;
    
    IF (r.leg_id <> prev_leg_id + 1) THEN
      RAISE EXCEPTION 'Leg ID must be sequential!';
      RETURN NULL;
    END IF;

    RETURN NULL;
    prev_leg_id = r.leg_id;
  END LOOP;
  CLOSE curs;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_if_leg_sequential_trigger
AFTER INSERT ON legs
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_if_leg_sequential();

-----------------------------------------------------------------------------------------------------------------------------------
-- Legs Related Q2
-- Test whether this works for empty unsuccessful tries
CREATE OR REPLACE FUNCTION check_first_legs_timestamp() RETURNS TRIGGER
AS $$
DECLARE
  submission_time TIMESTAMP;
  previous_unsuccessful_time TIMESTAMP;
BEGIN
  SELECT dr.submission_time FROM delivery_requests dr WHERE dr.id = NEW.request_id INTO submission_time;
  SELECT MAX(up.previous_unsuccessful_time) FROM unsuccessful_pickups up WHERE up.request_id = NEW.request_id INTO previous_unsuccessful_time;

  IF (NEW.start_time <= submission_time) THEN
    RAISE EXCEPTION 'First legs start time must be later than submission time!';
    RETURN NULL;
  END IF;

  IF (NEW.start_time <= previous_unsuccessful_time) THEN
    RAISE EXCEPTION 'First legs start time must be later than previous pickup time!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_first_leg_timestamp_trigger
BEFORE INSERT ON legs
FOR EACH ROW
WHEN (NEW.leg_id = 1)
EXECUTE FUNCTION check_first_legs_timestamp();

-----------------------------------------------------------------------------------------------------------------------------------
-- Legs Related Q3
-- Test whether this works for empty unsuccessful tries
CREATE OR REPLACE FUNCTION check_prev_legs_timestamp() RETURNS TRIGGER
AS $$
DECLARE
  prev_legs_end_time TIMESTAMP;
BEGIN
  SELECT l.end_time FROM legs l WHERE l.request_id = NEW.request_id ORDER BY l.leg_id DESC LIMIT 1 INTO prev_legs_end_time;

  IF (prev_legs_end_time IS NULL OR NEW.start_time <= prev_legs_end_time) THEN
    RAISE EXCEPTION 'Legs start time must be later than previous leg end time and it cannot be NULL!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_prev_legs_timestamp_trigger
BEFORE INSERT ON legs
FOR EACH ROW
EXECUTE FUNCTION check_prev_legs_timestamp();

-----------------------------------------------------------------------------------------------------------------------------------
-- Unsuccessful_deliveries Related Q4
CREATE OR REPLACE FUNCTION check_unsuccessful_delivery_timestamp() RETURNS TRIGGER
AS $$
DECLARE
  l_start_time TIMESTAMP;
BEGIN
  SELECT l.start_time INTO l_start_time FROM legs l WHERE l.leg_id = NEW.leg_id AND l.request_id = NEW.request_id;

  IF (NEW.attempt_time <= l_start_time) THEN
    RAISE EXCEPTION 'Attempt time must be after start time of the leg!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_unsuccessful_delivery_timestamp_trigger
BEFORE INSERT ON unsuccessful_deliveries
FOR EACH ROW
EXECUTE FUNCTION check_unsuccessful_delivery_timestamp();

-----------------------------------------------------------------------------------------------------------------------------------
-- Unsuccessful_deliveries Related Q5
-- Test this statement out INSERT INTO ud VALUES (1), (2), (3), (4)
CREATE OR REPLACE FUNCTION check_max_ud_limit() RETURNS TRIGGER
AS $$
DECLARE
  ud_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO ud_count FROM unsuccessful_deliveries ud WHERE ud.request_id = NEW.request_id;

  IF (ud_count >= 3) THEN
    RAISE EXCEPTION 'Maximum number of unsuccessful deliveries is 3!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_max_ud_limit_trigger
BEFORE INSERT ON unsuccessful_deliveries
FOR EACH ROW
EXECUTE FUNCTION check_max_ud_limit();

-----------------------------------------------------------------------------------------------------------------------------------
-- Cancelled_requests Related Q6
CREATE OR REPLACE FUNCTION check_valid_cancellation_time() RETURNS TRIGGER
AS $$
DECLARE
  submission_time TIMESTAMP;
BEGIN
  SELECT dr.submission_time INTO submission_time FROM delivery_requests dr WHERE dr.id = NEW.id;

  IF (NEW.cancel_time <= submission_time) THEN
    RAISE EXCEPTION 'Cancellation time cannot be earlier than submission time!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER check_valid_cancellation_time_trigger
BEFORE INSERT ON cancelled_requests
FOR EACH ROW
EXECUTE FUNCTION check_valid_cancellation_time();

-----------------------------------------------------------------------------------------------------------------------------------
-- Return_legs Q7
-- Check this with prof: Does this question mean overriding the the return_leg id or just throwing exception when the return_id is not valid?
CREATE OR REPLACE FUNCTION override_return_leg_id() RETURNS TRIGGER
AS $$
DECLARE
  leg_count INTEGER;
BEGIN
  SELECT COUNT(*) FROM return_legs rl WHERE rl.request_id = NEW.request_id INTO leg_count;
  NEW.leg_id = leg_count + 1;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER override_return_leg_id_trigger
BEFORE INSERT ON return_legs
FOR EACH ROW
EXECUTE FUNCTION override_return_leg_id();


