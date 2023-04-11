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
  -- Previous address is initialised as the customer address
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
SELECT T1.employee_id
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
GROUP BY T1.employee_id
ORDER BY SUM(num) DESC, T1.employee_id ASC
LIMIT k;
$$ LANGUAGE sql;


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