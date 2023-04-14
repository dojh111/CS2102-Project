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
CREATE OR REPLACE FUNCTION check_prev_legs_timestamp() RETURNS TRIGGER
AS $$
DECLARE
  prev_legs_end_time TIMESTAMP;
  num_rows INTEGER;
BEGIN
  SELECT l.end_time INTO prev_legs_end_time FROM legs l WHERE l.request_id = NEW.request_id ORDER BY l.leg_id DESC LIMIT 1;
  SELECT COUNT(*) INTO num_rows FROM legs l WHERE l.request_id = NEW.request_id;

  IF (num_rows > 0 AND (prev_legs_end_time IS NULL OR NEW.start_time < prev_legs_end_time)) THEN
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
CREATE OR REPLACE FUNCTION check_if_return_leg_sequential() RETURNS TRIGGER
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

CREATE CONSTRAINT TRIGGER check_if_return_leg_sequential_trigger
AFTER INSERT ON return_legs
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_if_return_leg_sequential();

-----------------------------------------------------------------------------------------------------------------------------------
-- Return_legs Q8
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

  IF (last_leg_end_time IS NULL OR last_leg_end_time > NEW.start_time) THEN
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

-----------------------------------------------------------------------------------------------------------------------------------
-- Procedure 1
CREATE OR REPLACE PROCEDURE submit_request(
    customer_id INTEGER,
    evaluator_id INTEGER,
    pickup_addr TEXT,
    pickup_postal TEXT,
    recipient_name TEXT,
    recipient_addr TEXT,
    recipient_postal TEXT,
    submission_time TIMESTAMP,
    package_num INTEGER,
    reported_height INTEGER [],
    reported_width INTEGER [],
    reported_depth INTEGER [],
    reported_weight INTEGER [],
    content TEXT [],
    estimated_value NUMERIC []
  ) AS $$
DECLARE 
  i INTEGER;
  drid INTEGER;
BEGIN
INSERT INTO delivery_requests(
    customer_id,
    evaluater_id,
    status,
    pickup_addr,
    pickup_postal,
    recipient_name,
    recipient_addr,
    recipient_postal,
    submission_time,
    pickup_date,
    num_days_needed,
    price
  )
VALUES (
    customer_id,
    evaluator_id,
    'submitted',
    pickup_addr,
    pickup_postal,
    recipient_name,
    recipient_addr,
    recipient_postal,
    submission_time,
    NULL,
    NULL,
    NULL
  );

SELECT dr.id INTO drid FROM delivery_requests dr ORDER BY dr.id DESC LIMIT 1;

i := 1;
WHILE i <= package_num LOOP
INSERT INTO packages(
    request_id,
    package_id,
    reported_height,
    reported_width,
    reported_depth,
    reported_weight,
    content,
    estimated_value,
    actual_height,
    actual_width,
    actual_depth,
    actual_weight
  )
VALUES(
    drid,
    i,
    reported_height [i],
    reported_width [i],
    reported_depth [i],
    reported_weight [i],
    content [i],
    estimated_value [i],
    NULL,
    NULL,
    NULL,
    NULL
  );
i := i + 1;
END LOOP;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------
-- Procedure 2
CREATE OR REPLACE PROCEDURE resubmit_request(
    request_id INTEGER,
    evaluator_id INTEGER,
    submission_time TIMESTAMP,
    reported_height INTEGER [],
    reported_width INTEGER [],
    reported_depth INTEGER [],
    reported_weight INTEGER []
  ) AS $$
DECLARE 
  old_request_id INTEGER = request_id;
  package_curs CURSOR FOR (SELECT * FROM packages p WHERE p.request_id = old_request_id ORDER BY package_id ASC);
  r RECORD;
  dr RECORD;
  new_drid INTEGER;
BEGIN
  SELECT * FROM delivery_requests d WHERE d.id = request_id INTO dr;

  INSERT INTO delivery_requests(
      customer_id,
      evaluater_id,
      status,
      pickup_addr,
      pickup_postal,
      recipient_name,
      recipient_addr,
      recipient_postal,
      submission_time,
      pickup_date,
      num_days_needed,
      price
    )
  VALUES (
      dr.customer_id,
      evaluator_id,
      'submitted',
      dr.pickup_addr,
      dr.pickup_postal,
      dr.recipient_name,
      dr.recipient_addr,
      dr.recipient_postal,
      submission_time,
      NULL,
      NULL,
      NULL
    );

  SELECT dr1.id INTO new_drid FROM delivery_requests dr1 ORDER BY dr1.id DESC LIMIT 1;

  OPEN package_curs;  
  LOOP
    FETCH package_curs INTO r;
    EXIT WHEN NOT FOUND;
    
    INSERT INTO packages(
      request_id,
      package_id,
      reported_height,
      reported_width,
      reported_depth,
      reported_weight,
      content,
      estimated_value,
      actual_height,
      actual_width,
      actual_depth,
      actual_weight
    )
    VALUES(
      new_drid,
      r.package_id,
      reported_height[r.package_id],
      reported_width[r.package_id],
      reported_depth[r.package_id],
      reported_weight[r.package_id],
      r.content,
      r.estimated_value,
      NULL,
      NULL,
      NULL,
      NULL
    );
  END LOOP;
  CLOSE package_curs;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------
-- Procedure 3
CREATE OR REPLACE PROCEDURE insert_leg(
    request_id INTEGER,
    handler_id INTEGER,
    start_time TIMESTAMP,
    destination_facility INTEGER
  ) AS $$
DECLARE
  old_request_id INTEGER = request_id;
  max_leg_id INTEGER;
BEGIN
  SELECT COUNT(l.leg_id) INTO max_leg_id FROM legs l WHERE l.request_id = old_request_id;

  INSERT INTO legs(
      request_id,
      leg_id,
      handler_id,
      start_time,
      end_time,
      destination_facility
    )
  VALUES (
      request_id,
      max_leg_id + 1,
      handler_id,
      start_time,
      NULL,
      destination_facility
    );
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------
-- Function 1
CREATE OR REPLACE FUNCTION view_trajectory(IN request_id INTEGER) 
RETURNS TABLE (
    source_addr TEXT,
    destination_addr TEXT,
    start_time TIMESTAMP,
    end_time TIMESTAMP
  ) AS $$
DECLARE
  drid INTEGER = request_id;
  leg_curs CURSOR FOR (SELECT * FROM legs l WHERE l.request_id = drid ORDER BY l.start_time ASC);
  return_curs CURSOR FOR (SELECT * FROM return_legs rl WHERE rl.request_id = drid ORDER BY rl.start_time ASC);
  return_count INTEGER;
  r RECORD;
  prev_addr TEXT;
  next_dest_r TEXT;
BEGIN 
  prev_addr := (SELECT dr.pickup_addr FROM delivery_requests dr WHERE dr.id = drid);
  
  OPEN leg_curs;
  LOOP 
    FETCH leg_curs into r;
    EXIT WHEN NOT FOUND; 
    
    source_addr := prev_addr;
    IF (r.destination_facility IS NULL) THEN
      destination_addr := (SELECT dr.recipient_addr FROM delivery_requests dr WHERE dr.id = drid);
    ELSE
      destination_addr := (SELECT f.address FROM facilities f WHERE f.id = r.destination_facility);
    END IF;
    start_time := r.start_time;
    end_time := r.end_time;
    prev_addr := destination_addr;
    RETURN NEXT;    
  END LOOP;
  CLOSE leg_curs;

  OPEN return_curs;
  LOOP
    FETCH return_curs into r;
    EXIT WHEN NOT FOUND; 
    
    source_addr := (SELECT f.address FROM facilities f WHERE f.id = r.source_facility);
    next_dest_r := (SELECT f.address FROM facilities f WHERE f.id = (SELECT rl.source_facility FROM return_legs rl WHERE rl.leg_id = r.leg_id + 1));

    IF (next_dest_r IS NULL) THEN
      destination_addr := (SELECT dr.pickup_addr FROM delivery_requests dr WHERE dr.id = drid);
    ELSE 
      destination_addr := next_dest_r;
    END IF;
    
    start_time := r.start_time;
    end_time := r.end_time;
    RETURN NEXT; 
  END LOOP;
  CLOSE return_curs;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------
-- Function 2
CREATE OR REPLACE FUNCTION get_top_delivery_persons(IN k INTEGER)
RETURNS TABLE (employee_id INTEGER) AS $$
SELECT T3.employee_id AS employee_id
FROM (
  SELECT T2.id AS employee_id, 0 AS num 
  FROM (
    SELECT ds.id AS id 
    FROM delivery_staff ds
    EXCEPT 
    SELECT DISTINCT T1.employee_id AS id
    FROM (
        SELECT l.handler_id AS employee_id,
          COUNT(*) AS num
        FROM legs l
        GROUP BY l.handler_id
        UNION ALL
        SELECT up.handler_id AS employee_id,
          COUNT(*) AS num
        FROM unsuccessful_pickups up
        GROUP BY up.handler_id
        UNION ALL
        SELECT rl.handler_id AS employee_id,
          COUNT(*) AS num
        FROM return_legs rl
        GROUP BY rl.handler_id
      ) AS T1
  ) AS T2
  UNION ALL
  SELECT l.handler_id AS employee_id,
    COUNT(*) AS num
  FROM legs l
  GROUP BY l.handler_id
  UNION ALL
  SELECT up.handler_id AS employee_id,
    COUNT(*) AS num
  FROM unsuccessful_pickups up
  GROUP BY up.handler_id
  UNION ALL
  SELECT rl.handler_id AS employee_id,
    COUNT(*) AS num
  FROM return_legs rl
  GROUP BY rl.handler_id
) AS T3
GROUP BY T3.employee_id
ORDER BY SUM(num) DESC, T3.employee_id ASC
LIMIT k;
$$ LANGUAGE sql;

-----------------------------------------------------------------------------------------------------------------------------------
-- Function 3
CREATE OR REPLACE FUNCTION get_top_connections(IN k INTEGER) RETURNS TABLE (
    source_facility_id INTEGER,
    destination_facility_id INTEGER
  ) AS $$
SELECT T1.source AS source_facility_id,
  T1.destination AS destination_facility_id
FROM (
    SELECT l1.destination_facility AS source,
      l2.destination_facility AS destination
    FROM legs l1
      JOIN legs l2 ON (
        l2.leg_id = l1.leg_id + 1
        AND l1.request_id = l2.request_id
      )
    WHERE l1.destination_facility IS NOT NULL
      AND l2.destination_facility IS NOT NULL
    UNION ALL
    SELECT rl1.source_facility AS source,
      rl2.source_facility AS destination
    FROM return_legs rl1
      JOIN return_legs rl2 ON (
        rl2.leg_id = rl1.leg_id + 1
        AND rl1.request_id = rl2.request_id
      )
  ) AS T1
GROUP BY (T1.source, T1.destination)
ORDER BY COUNT(*) DESC,
  (T1.source, T1.destination) ASC
LIMIT k;
$$ LANGUAGE sql;
