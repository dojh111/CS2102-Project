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

-- Need to reset prev_package_id = 0 when request_id changes, since we doing on entire table
CREATE OR REPLACE FUNCTION check_if_package_sequential() RETURNS TRIGGER
AS $$
DECLARE
  package_sequential_curs CURSOR FOR (SELECT p.package_id FROM packages p WHERE p.request_id = NEW.request_id ORDER BY p.package_id ASC);
  r RECORD;
  prev_package_id INTEGER;
BEGIN
  prev_package_id = 0;
  OPEN package_sequential_curs;
  
  LOOP
    FETCH package_sequential_curs INTO r;
    EXIT WHEN NOT FOUND;

    IF (r.package_id <> prev_package_id + 1) THEN
      RAISE EXCEPTION 'Package ID must be sequential!';
      RETURN NULL;
    END IF;

    prev_package_id = r.package_id;
  END LOOP;
  CLOSE package_sequential_curs;
  RETURN NULL;
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
  pickup_curs CURSOR FOR (SELECT up.pickup_id FROM unsuccessful_pickups up WHERE up.request_id = NEW.request_id ORDER BY up.pickup_id ASC);
  r RECORD;
  prev_pickup_id INTEGER;
BEGIN
  prev_pickup_id = 0;
  OPEN pickup_curs;
  
  LOOP
    FETCH pickup_curs INTO r;
    EXIT WHEN NOT FOUND;
    
    IF (r.pickup_id <> prev_pickup_id + 1) THEN
      RAISE EXCEPTION 'Unsuccessful Pickup ID must be sequential!';
      RETURN NULL;
    END IF;

    prev_pickup_id = r.pickup_id;
  END LOOP;
  CLOSE pickup_curs;
  RETURN NULL;
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
  SELECT dr.submission_time INTO submission_time FROM delivery_requests dr WHERE dr.id = NEW.request_id;
  SELECT MAX(up.pickup_time) INTO previous_unsuccessful_time FROM unsuccessful_pickups up WHERE up.request_id = NEW.request_id;

  IF (submission_time >= NEW.pickup_time) THEN
    RAISE EXCEPTION 'Unsuccessful Pickup time must be later than submission time!';
    RETURN NULL;
  END IF;

  IF (previous_unsuccessful_time >= NEW.pickup_time) THEN
    RAISE EXCEPTION 'Unsuccessful Pickup time must be later than previous pickup time!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_if_unsuccessful_sequential_timestamp_trigger
BEFORE INSERT ON unsuccessful_pickups
FOR EACH ROW
EXECUTE FUNCTION check_if_unsuccessful_sequential_timestamp();

-----------------------------------------------------------------------------------------------------------------------------------
-- Legs Related Q1
CREATE OR REPLACE FUNCTION check_if_leg_sequential() RETURNS TRIGGER
AS $$
DECLARE
  leg_curs CURSOR FOR (SELECT l.leg_id FROM legs l WHERE l.request_id = NEW.request_id ORDER BY l.leg_id ASC);
  r RECORD;
  prev_leg_id INTEGER;
BEGIN
  prev_leg_id = 0;
  OPEN leg_curs;
  
  LOOP
    FETCH leg_curs INTO r;
    EXIT WHEN NOT FOUND;
    
    IF (r.leg_id <> prev_leg_id + 1) THEN
      RAISE EXCEPTION 'Leg ID must be sequential!';
      RETURN NULL;
    END IF;

    prev_leg_id = r.leg_id;
  END LOOP;
  CLOSE leg_curs;
  RETURN NULL;
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
  SELECT MAX(up.pickup_time) FROM unsuccessful_pickups up WHERE up.request_id = NEW.request_id INTO previous_unsuccessful_time;

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

CREATE TRIGGER check_first_leg_timestamp_trigger
BEFORE INSERT ON legs
FOR EACH ROW
WHEN (NEW.leg_id = 1)
EXECUTE FUNCTION check_first_legs_timestamp();

-----------------------------------------------------------------------------------------------------------------------------------
-- Legs Related Q3
-- Test whether this works for empty unsuccessful tries: Check if NULL if empty legs table
CREATE OR REPLACE FUNCTION check_prev_legs_timestamp() RETURNS TRIGGER
AS $$
DECLARE
  prev_legs_end_time TIMESTAMP;
  num_rows INTEGER;
BEGIN
  SELECT l.end_time INTO prev_legs_end_time FROM legs l WHERE l.request_id = NEW.request_id ORDER BY l.leg_id DESC LIMIT 1;
  SELECT COUNT(*) INTO num_rows FROM legs l WHERE l.request_id = NEW.request_id;

  IF (num_rows > 0 AND (prev_legs_end_time IS NULL OR NEW.start_time <= prev_legs_end_time)) THEN
    RAISE EXCEPTION 'Legs start time must be later than previous leg end time and it cannot be NULL!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_prev_legs_timestamp_trigger
BEFORE INSERT ON legs
FOR EACH ROW
EXECUTE FUNCTION check_prev_legs_timestamp();

-----------------------------------------------------------------------------------------------------------------------------------
-- Unsuccessful_deliveries Related Q4
-- Need test when leg_id or request_id of inserted does not exist in the table
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

CREATE TRIGGER check_unsuccessful_delivery_timestamp_trigger
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

CREATE TRIGGER check_max_ud_limit_trigger
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

CREATE TRIGGER check_valid_cancellation_time_trigger
BEFORE INSERT ON cancelled_requests
FOR EACH ROW
EXECUTE FUNCTION check_valid_cancellation_time();

-----------------------------------------------------------------------------------------------------------------------------------
-- Return_legs Q7
-- Check this with prof: Does this question mean overriding the the return_leg id or just throwing exception when the return_id is not valid?
CREATE OR REPLACE FUNCTION override_return_leg_id() RETURNS TRIGGER
AS $$
DECLARE
  return_leg_curs CURSOR FOR (SELECT rl.leg_id FROM return_legs rl WHERE rl.request_id = NEW.request_id ORDER BY rl.leg_id ASC);
  r RECORD;
  prev_return_leg_id INTEGER;
BEGIN
  prev_return_leg_id = 0;
  OPEN return_leg_curs;
  
  LOOP
    FETCH return_leg_curs INTO r;
    EXIT WHEN NOT FOUND;
    
    IF (r.leg_id <> prev_return_leg_id + 1) THEN
      RAISE EXCEPTION 'Return Leg ID must be sequential!';
      RETURN NULL;
    END IF;

    prev_return_leg_id = r.leg_id;
  END LOOP;
  CLOSE return_leg_curs;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER override_return_leg_id_trigger
AFTER INSERT ON return_legs
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION override_return_leg_id();

-----------------------------------------------------------------------------------------------------------------------------------
-- Return_legs Q8
-- Check that the trigger should go through if there is no cancellation request
-- Need to add if leg_id = 1? SELECT MAX(l.end_time) instead?
CREATE OR REPLACE FUNCTION check_valid_first_return_leg() RETURNS TRIGGER
AS $$
DECLARE
  last_leg_count INTEGER;
  last_leg_end_time TIMESTAMP;
  cancelled_time TIMESTAMP;
BEGIN
  SELECT COUNT(*) INTO last_leg_count FROM legs l WHERE l.request_id = NEW.request_id;
  SELECT l.end_time INTO last_leg_end_time FROM legs l WHERE l.request_id = NEW.request_id ORDER BY l.leg_id DESC LIMIT 1;
  SELECT cr.cancel_time INTO cancelled_time FROM cancelled_requests cr WHERE cr.id = NEW.request_id;

  IF (last_leg_count < 1) THEN
    RAISE EXCEPTION 'There is no existing leg for this delivery request!';
    RETURN NULL;
  END IF;

  IF (last_leg_end_time IS NULL OR last_leg_end_time >= NEW.start_time) THEN
    RAISE EXCEPTION 'The start time of return leg cannot be earlier than the end time of the last leg!';
    RETURN NULL;
  END IF;

  IF (cancelled_time >= NEW.start_time) then
    RAISE EXCEPTION 'The start time of return leg cannot be earlier than the cancellation time!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_valid_first_return_leg_trigger
BEFORE INSERT ON return_legs
FOR EACH ROW
WHEN (NEW.leg_id = 1)
EXECUTE FUNCTION check_valid_first_return_leg();

-----------------------------------------------------------------------------------------------------------------------------------
-- Return_legs Q9
CREATE OR REPLACE FUNCTION check_max_unsuccessful_return_deliveries() RETURNS TRIGGER
AS $$
DECLARE
  urd_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO urd_count FROM unsuccessful_return_deliveries urd WHERE urd.request_id = NEW.request_id;

  IF (urd_count >= 3) THEN
    RAISE EXCEPTION 'Each delivery request can only have at most 3 unsuccessful return deliveries!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_max_unsuccessful_return_deliveries_trigger
BEFORE INSERT ON unsuccessful_return_deliveries
FOR EACH ROW
EXECUTE FUNCTION check_max_unsuccessful_return_deliveries();

-----------------------------------------------------------------------------------------------------------------------------------
-- Unsuccessful_return_deliveries Q10
CREATE OR REPLACE FUNCTION check_valid_unsuccessful_return_deliveries_time() RETURNS TRIGGER
AS $$
DECLARE
  return_start_time TIMESTAMP;
BEGIN
  SELECT rl.start_time INTO return_start_time FROM return_legs rl WHERE rl.leg_id = NEW.leg_id AND rl.request_id = NEW.request_id;

  IF (NEW.attempt_time <= return_start_time) THEN
    RAISE EXCEPTION 'Attempt time for unsuccessful return deliveries cannot be earlier than return leg start time!';
    RETURN NULL;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_valid_unsuccessful_return_deliveries_time_trigger
BEFORE INSERT ON unsuccessful_return_deliveries
FOR EACH ROW
EXECUTE FUNCTION check_valid_unsuccessful_return_deliveries_time();
