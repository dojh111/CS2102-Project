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
DECLARE i INTEGER;
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
  max_leg_id INTEGER;
BEGIN
  SELECT COUNT(l.leg_id) INTO max_leg_id FROM legs l WHERE l.request_id = request_id;

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