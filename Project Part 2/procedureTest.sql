DELETE FROM customers;
DELETE FROM employees;
DELETE FROM delivery_staff;
DELETE FROM packages;
DELETE FROM facilities;
DELETE FROM legs;

INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');

INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO facilities VALUES(1, 'Bedok HeartBeat', 'S895511');
INSERT INTO facilities VALUES(2, 'Serangoon', 'S901122');

-- Q1 Test Case
-- PASS:
CALL submit_request(1,1,'fasdf','fasdf','fasdf','fasdf','fasdf','2011-01-01 00:00:00'::TIMESTAMP,2,ARRAY [1, 2],ARRAY [1, 2],ARRAY [1, 2],ARRAY [1, 2],ARRAY ['test1', 'test2'],ARRAY [1.0, 2.0]);
CALL submit_request(2,1,'hey','one','two','three','four','2012-01-01 00:00:00'::TIMESTAMP,3,ARRAY [1, 2, 3],ARRAY [1, 2, 3],ARRAY [1, 2, 3],ARRAY [1, 2, 3],ARRAY ['test1', 'test2', 'test 3'], ARRAY [1.0, 2.0, 3.0]);
-- FAIL:
CALL submit_request(0,1,'fasdf','fasdf','fasdf','fasdf','fasdf','2011-01-01 00:00:00'::TIMESTAMP,2,ARRAY [1, 2],ARRAY [1, 2],ARRAY [1, 2],ARRAY [1, 2],ARRAY ['test1', 'test2'],ARRAY [1.0, 2.0]);

-- Q2 Test case
-- PASS:inserts new request for request id 1 + 2 packages
CALL resubmit_request(1,4,'2012-01-20 00:00:00'::TIMESTAMP,ARRAY [8888888, 88888888],ARRAY [8888888, 88888888],ARRAY [8888888, 88888888],ARRAY [8888888, 88888888]);
-- PASS:inserts new request for request id 2 + 3 packages
CALL resubmit_request(2,3,'2012-01-20 00:00:00'::TIMESTAMP,ARRAY [8888, 8888, 8888],ARRAY [8888, 8888, 8888],ARRAY [8888, 8888, 8888],ARRAY [8888, 8888, 8888]);

-- FAIL:
CALL resubmit_request(0,4,'2024-01-01 00:00:00'::TIMESTAMP,ARRAY [50000, 50000],ARRAY [50000, 50000],ARRAY [50000, 50000],ARRAY [50000, 50000]);

-- Q3 Test case
-- PASS: inserts 2 legs for request id 1
CALL insert_leg(1, 2, '2020-01-21 00:00:00'::TIMESTAMP, 1); --(cust, 1)
CALL insert_leg(1, 2, '2020-01-01 00:00:00'::TIMESTAMP, 2); --(1,2)

-- FAIL: 
CALL insert_leg(0, 2, '2022-01-01 00:00:00'::TIMESTAMP, 1);