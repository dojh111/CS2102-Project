------------------------------------------------------------------------------------------
-- TESTS: Delivery_requests related Q1 (Each delivery must have at least 1 package)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);
COMMIT;

-- Test 1: Valid test case
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

-- Test 2: Valid test case, multiple packages
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 4, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 2, 5.0, 5.0, 5.0, 2.5, 'artwork1', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 3, 5.0, 5.0, 5.0, 2.5, 'artwork2', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork3', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 2, 5.0, 5.0, 5.0, 2.5, 'lemons2', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 3, 5.0, 5.0, 5.0, 2.5, 'lemons3', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

-- Test 3: Invalid, request 2 missing 1 package
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork3', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
COMMIT;

-- Test 4: Invalid, missing package
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork3', 30.0, 5.0, 5.0, 5.0, 2.5);

------------------------------------------------------------------------------------------
-- TESTS: Package related Q2 (Package IDs in ascending order)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);
COMMIT;

-- Test 1: Valid
-- Need to split the test case out??? CHECK WITH PROF WHAT IS HAPPENINGGGGGGG
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

-- Test 2: Valid, multiple packages
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 3, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 2, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 4, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 2, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 3, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

-- Test 3: Valid, separated insert
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;
INSERT INTO packages VALUES(1, 2, 5.0, 5.0, 5.0, 2.5, 'artwork2', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 3, 5.0, 5.0, 5.0, 2.5, 'artwork3', 30.0, 5.0, 5.0, 5.0, 2.5);

-- Test 4: Invalid, non consecutive running for delivery_request id 2
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 4, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 3, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

-- Test 5: Invalid, not starting from 1
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 4, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

-- Test 6: Invalid, starts from 0
BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 1, 'submitted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 0, 5.0, 5.0, 5.0, 2.5, 'artwork1', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 2, 5.0, 5.0, 5.0, 2.5, 'artwork2', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

------------------------------------------------------------------------------------------
-- TESTS: Unsuccessful_pickups related Q3 (consecutive increasing IDs from 1)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);
COMMIT;

-- Test 1: Valid
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-28 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 1, 3, '2023-03-22 17:30:00', 'Not home');

-- Test 2: Valid, multiple inserts
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-28 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-29 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 3, 3, '2023-01-30 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 1, 3, '2023-03-22 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 2, 3, '2023-03-23 17:30:00', 'Not home');

-- Test 3: Valid, transaction based, multiple insert, out of order
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(1, 3, 3, '2023-01-30 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-28 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-29 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 1, 3, '2023-03-22 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 2, 3, '2023-03-23 17:30:00', 'Not home');
COMMIT;

-- Test 4: Invalid, not starting from 1 for id 1
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(2, 1, 3, '2023-03-22 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 2, 3, '2023-03-23 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 4, 3, '2023-01-30 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 3, 3, '2023-01-29 17:30:00', 'Not home');
COMMIT;

-- Test 5: Invalid, non consecutive (Test with and without transaction)
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-30 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 3, 3, '2023-01-28 17:30:00', 'Not home');
COMMIT;

-- Test 4: Invalid, not starts from 0
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(1, 0, 3, '2023-01-30 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-28 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-29 17:30:00', 'Not home');
COMMIT;

------------------------------------------------------------------------------------------
-- TESTS: Unsuccessful_pickups related Q4 - Timestamp of FIRST unsuccessful pickup > submission time for delivery request + new unsuccessful pickup > previous timestamp
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);
COMMIT;

-- Test 1: Valid, unsuccessful pickup AFTER submission of Delivery Request (NO PREVIOUS UNSUCCESSFUL)
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');

-- Test 2: Valid, unsuccessful pickup AFTER submission of Delivery Request and AFTER previous unsuccessful pickup
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 16:30:00', 'Not home');

-- Test 3: Valid, multiple unsuccessful pickups for multiple delivery requests
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 3, 3, '2023-01-28 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 1, 3, '2023-03-20 17:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(2, 2, 3, '2023-03-23 17:30:00', 'Not home');
COMMIT;

-- Test 4: Invalid, unsuccessful pickup BEFORE submission of Delivery Request (NO PREVIOUS UNSUCCESSFUL)
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-25 16:30:00', 'Not home');

-- Test 5: Invalid, unsucessful pickup AFTER submission of Delivery Request but BEFORE submission of previous unsuccessful
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-29 16:30:00', 'Not home'); -- This one is valid
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 16:30:00', 'Not home'); -- Timestamp is BEFORE previous unsuccessful
COMMIT;

-- Test 6: Invalid, unsuccessful pickup time before everything
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-29 16:30:00', 'Not home'); -- This one is valid
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-22 16:30:00', 'Not home'); -- Timestamp is BEFORE everything
COMMIT;

-- Test 7: Invalid, pickup time == submission time
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-26 16:30:00', 'Not home');

-- Test 8: Invalid, pickup time > submission time but == previous unsuccessful
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-27 16:30:00', 'Not home');

------------------------------------------------------------------------------------------
-- TESTS: Legs related Q1 - Leg ID consecutive integers from 1
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
COMMIT;

-- Test 1: Valid
BEGIN TRANSACTION;
INSERT INTO legs VALUES(1, 1, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(2, 2, 4, '2023-03-22 17:30:00', '2023-03-22 18:30:00', 3);
INSERT INTO legs VALUES(2, 1, 4, '2023-03-21 17:30:00', '2023-03-21 18:30:00', 3);
COMMIT;

-- Test 2: Valid, non transaction based
INSERT INTO legs VALUES(1, 1, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(2, 1, 4, '2023-03-21 17:30:00', '2023-03-21 18:30:00', 3);
INSERT INTO legs VALUES(2, 2, 4, '2023-03-22 17:30:00', '2023-03-22 18:30:00', 3);

-- Test 3: Invalid, non transaction based not sequential
INSERT INTO legs VALUES(1, 1, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);

-- Test 4: Invalid, non-sequential missing leg
BEGIN TRANSACTION;
INSERT INTO legs VALUES(1, 1, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(2, 2, 4, '2023-03-22 17:30:00', '2023-03-22 18:30:00', 3);
INSERT INTO legs VALUES(2, 1, 4, '2023-03-21 17:30:00', '2023-03-21 18:30:00', 3);
INSERT INTO legs VALUES(2, 4, 4, '2023-03-21 17:30:00', '2023-03-21 18:30:00', 3); -- Skipped 3
COMMIT;

-- Test 5: Invalid, start from 0
BEGIN TRANSACTION;
INSERT INTO legs VALUES(1, 0, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
COMMIT;

-- Test 6: Invalid, non transaction start from 0
INSERT INTO legs VALUES(1, 0, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);

------------------------------------------------------------------------------------------
-- TESTS: Legs related Q2 (FIRST LEG > submission of delivery request AND LAST unsuccessful pickup)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
COMMIT;

-- Test 1: Valid, start time after submission of delivery request (No previous unsuccessful pickup)
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);

-- Test 2: Valid, start time after submission of delivery request + last unsuccessful pickup
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 16:30:00', 'Not home');
INSERT INTO legs VALUES(1, 1, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1);

-- Test 3: Valid, multiple legs but checking first leg (Have to disable other legs related triggers)
BEGIN TRANSACTION;
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 16:30:00', 'Not home');
INSERT INTO legs VALUES(1, 1, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-25 17:30:00', '2023-01-25 18:30:00', 1); -- This one is invalid, but should not be checked
COMMIT;

-- Test 4: Invalid, start time BEFORE submission of delivery request (No previous unsuccessful pickup)
INSERT INTO legs VALUES(1, 1, 4, '2023-01-26 14:30:00', '2023-01-27 16:30:00', 1);

-- Test 5: Invalid, start time AFTER submission of delivery request but BEFORE last unsuccessful pickup
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 16:30:00', 'Not home');
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);

-- Test 6: Invalid, start time == submission time of delivery request
INSERT INTO legs VALUES(1, 1, 4, '2023-01-26 16:30:00', '2023-01-27 16:30:00', 1);

-- Test 7: Invalid, start AFTER submission of delivery request but == last unsuccessful pickup
INSERT INTO unsuccessful_pickups VALUES(1, 1, 3, '2023-01-27 16:30:00', 'Not home');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 3, '2023-01-28 16:30:00', 'Not home');
INSERT INTO legs VALUES(1, 1, 4, '2023-01-28 16:30:00', '2023-01-28 17:30:00', 1);

------------------------------------------------------------------------------------------
-- TESTS: Legs related Q3 (Cannot insert leg if start time < end time of previous OR previous end == NULL)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
COMMIT;

-- Test 1, valid, first leg to be inserted into legs table for request_id
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);

-- Test 2, valid, second leg has start time > end time of previous
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 19:30:00', '2023-01-27 20:30:00', 1);

-- Test 3, invalid, leg start time < end time of previous
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 19:30:00', '2023-01-29 20:30:00', 1);

-- Test 4, invalid, second leg has start time == end time of previous
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 18:30:00', '2023-01-27 20:30:00', 1);

-- Test 5, invalid, previous leg start time == NULL
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', NULL, 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-27 19:30:00', '2023-01-27 20:30:00', 1);

------------------------------------------------------------------------------------------
-- TESTS: Unsuccessful_deliveries related Q4 (Timestamp of unsuccessful_delivery > start_time of corresponding leg)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-20 16:30:00', '2023-01-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
COMMIT;

-- Test 1, valid
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1);
INSERT INTO legs VALUES(2, 1, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES(1, 1, 'Recipient not home', '2023-01-27 18:30:00');
INSERT INTO unsuccessful_deliveries VALUES(1, 3, 'Recipient not home', '2023-01-31 12:30:00');
INSERT INTO unsuccessful_deliveries VALUES(2, 1, 'Recipient not home', '2023-01-26 19:30:00');

-- Test 2, invalid, time stamp BEFORE start time of corresponding leg
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES(1, 1, 'Recipient not home', '2023-01-27 14:30:00');

-- Test 3, invalid, time stamp == start time of corresponding leg
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES(1, 1, 'Recipient not home', '2023-01-27 17:30:00');

-- Test 4, invalid, leg id does not exist
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES(1, 4, 'Recipient not home', '2023-01-29 14:30:00');

------------------------------------------------------------------------------------------
-- TESTS: Unsuccessful_deliveries related Q5 (Max 3 unsuccessful delivery for each delivery request)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-20 16:30:00', '2023-01-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
COMMIT;

-- Test 1, valid (Can insert up to 3 with no issue)
BEGIN TRANSACTION;
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES(1, 1, 'Recipient not home', '2023-01-27 18:30:00');
INSERT INTO unsuccessful_deliveries VALUES(1, 2, 'Recipient not home', '2023-01-28 18:30:00');
INSERT INTO unsuccessful_deliveries VALUES(1, 3, 'Recipient not home', '2023-01-31 12:30:00');

INSERT INTO legs VALUES(2, 1, 4, '2023-01-26 17:30:00', '2023-01-26 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES(2, 1, 'Recipient not home', '2023-01-26 19:30:00');
COMMIT;

-- Test 2, invalid, multiple insertions in single statement
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1);
INSERT INTO legs VALUES(1, 4, 4, '2023-01-30 17:30:00', '2023-01-30 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES
    (1, 1, 'Recipient not home', '2023-01-27 18:30:00'),
    (1, 2, 'Recipient not home', '2023-01-28 18:30:00'),
    (1, 3, 'Recipient not home', '2023-01-31 12:30:00'),
    (1, 4, 'Recipient not home', '2023-01-31 19:30:00')
;

-- Test 3, invalid, transaction based (Raise exception when inserting 4 at once)
BEGIN TRANSACTION;
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(1, 2, 4, '2023-01-28 17:30:00', '2023-01-28 18:30:00', 1);
INSERT INTO legs VALUES(1, 3, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1);
INSERT INTO legs VALUES(1, 4, 4, '2023-01-30 17:30:00', '2023-01-30 18:30:00', 1);
INSERT INTO unsuccessful_deliveries VALUES(1, 1, 'Recipient not home', '2023-01-27 18:30:00');
INSERT INTO unsuccessful_deliveries VALUES(1, 2, 'Recipient not home', '2023-01-28 18:30:00');
INSERT INTO unsuccessful_deliveries VALUES(1, 3, 'Recipient not home', '2023-01-31 12:30:00');
INSERT INTO unsuccessful_deliveries VALUES(1, 4, 'Recipient not home', '2023-01-31 19:30:00');
COMMIT;

------------------------------------------------------------------------------------------
-- TESTS: Cancelled_requests related Q6 (Cancel time > submission time of delivery request)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
COMMIT;

-- Test 1, valid
INSERT INTO cancelled_requests VALUES(1, '2023-01-27 14:30:00');

-- Test 2, invalid, cancel time BEFORE submission time of delivery request
INSERT INTO cancelled_requests VALUES(1, '2023-01-26 14:30:00');

-- Test 3, invalid, cancel time == submission time of delivery request
INSERT INTO cancelled_requests VALUES(1, '2023-01-26 16:30:00');

------------------------------------------------------------------------------------------
-- TESTS: Return_legs related Q7 (Consecutive return leg ID, starting from 1)
-- For return_legs, the leg_id is not referencing an existing leg
-- General Setup
BEGIN TRANSACTION;
INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO cancelled_or_unsuccessful_requests VALUES(1), (2);
COMMIT;

-- Test 0,  valid, not consecutive (Check start timestamp values after insertion)
BEGIN TRANSACTION;
INSERT INTO return_legs VALUES(2, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(2, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(2, 3, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
COMMIT;

-- Test 1, valid
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 3, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');

-- Test 2, valid, not consecutive (Check start timestamp values after insertion)
BEGIN TRANSACTION;
INSERT INTO return_legs VALUES(2, 3, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');
INSERT INTO return_legs VALUES(2, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(2, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
COMMIT;

-- Test 3, invalid, not consecutive (Check values after insertion)
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 3, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 4, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');

-- Test 4, invalid, starting from 0 (Check values after insertion)
INSERT INTO return_legs VALUES(1, 0, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');

-- Test 5, invalid, duplicate ID (Check values after insertion)
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');

-- Test 6, valid, non consecutive wrong order, transaction (Check values after insertion)
BEGIN TRANSACTION;
INSERT INTO return_legs VALUES(1, 3, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');
COMMIT;

------------------------------------------------------------------------------------------
-- TESTS: Return_legs related Q8 (FIRST return leg CANNOT be inserted IF no existing request OR
-- LAST EXISTING LEG end_time > start_time of return_leg OR start_time < cancel_time )
-- WE ASSUME THAT ALL PREVIOUS TRIGGERS ARE IN EFFECT
-- General Setup
BEGIN TRANSACTION;
INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO cancelled_or_unsuccessful_requests VALUES(1), (2);
COMMIT;

-- Test 1, valid insertion (No existing cancellation requests)
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1); -- Existing leg for delivery request
INSERT INTO legs VALUES(1, 2, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1); -- Last Existing leg for delivery request
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00'); -- Start time > last end time

-- Test 2, valid insertion, existing cancellation requests
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1); -- Existing leg for delivery request
INSERT INTO legs VALUES(1, 2, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1); -- Last Existing leg for delivery request
INSERT INTO cancelled_requests VALUES(1, '2023-01-29 18:45:00'); -- Cancel time 15 minutes after last leg end time
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 20:30:00', 3, '2023-01-30 17:30:00'); -- Start time > last end time + Start time > cancel time

-- Test 3, invalid insertion, no existing leg
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');

-- Test 4, invalid, invalid return leg start time
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1); -- Existing leg for delivery request
INSERT INTO legs VALUES(1, 2, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1); -- Last Existing leg for delivery request
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 16:30:00', 3, '2023-01-30 17:30:00'); -- Start time < last leg end time

-- Test 5, invalid, return leg start time < cancel_time of request
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1); -- Existing leg for delivery request
INSERT INTO legs VALUES(1, 2, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1); -- Last Existing leg for delivery request
INSERT INTO cancelled_requests VALUES(1, '2023-01-29 18:45:00'); -- Cancel time 15 minutes after last leg end time
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 18:40:00', 3, '2023-01-30 17:30:00'); -- Error: Start time < cancel time

-- Test 6, invalid, invalid return leg start == previous leg end
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1); -- Existing leg for delivery request
INSERT INTO legs VALUES(1, 2, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1); -- Last Existing leg for delivery request
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 18:30:00', 3, '2023-01-30 17:30:00');

-- Test 7, invalid, invalid return leg start == cancel time
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1); -- Existing leg for delivery request
INSERT INTO legs VALUES(1, 2, 4, '2023-01-29 17:30:00', '2023-01-29 18:30:00', 1); -- Last Existing leg for delivery request
INSERT INTO cancelled_requests VALUES(1, '2023-01-29 18:45:00'); -- Cancel time 15 minutes after last leg end time
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 18:45:00', 3, '2023-01-30 17:30:00');

-- Test 8, invalid, previous leg end time == NULL
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1); -- Existing leg for delivery request
INSERT INTO legs VALUES(1, 2, 4, '2023-01-29 17:30:00', NULL, 1); -- Last Existing leg for delivery request
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-29 20:30:00', 3, '2023-01-30 17:30:00');

------------------------------------------------------------------------------------------
-- TESTS: Return_legs related Q9 (For each delivery request, AT MOST 3 unsucessful_return_deliveries)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO cancelled_or_unsuccessful_requests VALUES(1), (2);
COMMIT;

-- Test 1, valid insertion up to 3
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO legs VALUES(2, 1, 4, '2023-03-21 16:30:00', '2023-03-22 16:30:00', 1);
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 3, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');
INSERT INTO return_legs VALUES(2, 1, 3, '2023-03-23 16:30:00', 3, '2023-03-23 17:30:00');
INSERT INTO return_legs VALUES(2, 2, 3, '2023-03-24 16:30:00', 3, '2023-03-24 17:30:00');

INSERT INTO unsuccessful_return_deliveries VALUES(1, 1, 'Failed return', '2023-01-28 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 2, 'Failed return', '2023-01-29 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 3, 'Failed return', '2023-01-30 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(2, 1, 'Failed return', '2023-03-23 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(2, 2, 'Failed return', '2023-03-24 17:35:00');

-- Test 2, invalid insertion, exceed limit
INSERT INTO legs VALUES(2, 1, 4, '2023-03-21 16:30:00', '2023-03-22 16:30:00', 1);
INSERT INTO return_legs VALUES(2, 1, 3, '2023-03-23 16:30:00', 3, '2023-03-23 17:30:00');
INSERT INTO return_legs VALUES(2, 2, 3, '2023-03-24 16:30:00', 3, '2023-03-24 17:30:00');
INSERT INTO return_legs VALUES(2, 3, 3, '2023-03-25 16:30:00', 3, '2023-03-25 17:30:00');
INSERT INTO return_legs VALUES(2, 4, 3, '2023-03-26 16:30:00', 3, '2023-03-26 17:30:00');

INSERT INTO unsuccessful_return_deliveries VALUES(2, 1, 'Failed return', '2023-03-23 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(2, 2, 'Failed return', '2023-03-24 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(2, 3, 'Failed return', '2023-03-25 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(2, 4, 'Failed return', '2023-03-26 17:35:00');

------------------------------------------------------------------------------------------
-- TESTS: Unsuccessful_return_deliveries related Q10 (Timestamp > start_time of corresponding return_leg)
-- General Setup
BEGIN TRANSACTION;
INSERT INTO facilities VALUES(1, 'address1', '123456');
INSERT INTO facilities VALUES(2, 'address2', '235467');
INSERT INTO facilities VALUES(3, 'address3', '345678');
INSERT INTO facilities VALUES(4, 'address4', '456789');
INSERT INTO customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO customers VALUES(2, 'Bob', 'male', '93478234');
INSERT INTO employees VALUES(1, 'John', 'male',  '1992-02-02', 'Manager', 5000.0);
INSERT INTO employees VALUES(2, 'Jane', 'female',  '1996-04-03', 'Worker', 3500.0);
INSERT INTO employees VALUES(3, 'Leonard', 'male',  '1994-08-20', 'Worker', 3500.0);
INSERT INTO employees VALUES(4, 'Daniel', 'male',  '1996-10-14', 'Worker', 3500.0);
INSERT INTO delivery_staff VALUES(2), (3), (4);

INSERT INTO delivery_requests VALUES(1, 1, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-01-26 16:30:00', '2023-01-28', 4, 10.0);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'accepted', 'start_addr', '987654', 'recp1', 'recp_addr', '456789', '2023-03-20 16:30:00', '2023-03-23', 3, 25.0);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);

INSERT INTO accepted_requests VALUES(1, '123456789', '2023-01-26 17:30:00', 1);
INSERT INTO accepted_requests VALUES(2, '987654321', '2023-03-20 17:30:00', 1);

INSERT INTO cancelled_or_unsuccessful_requests VALUES(1), (2);
COMMIT;

-- Test 1, valid insertion
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 3, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 1, 'Failed return', '2023-01-28 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 2, 'Failed return', '2023-01-29 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 3, 'Failed return', '2023-01-30 17:35:00');

-- Test 2, invalid insertion, timestamp BEFORE corresponding leg start time
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 3, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 1, 'Failed return', '2023-01-28 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 2, 'Failed return', '2023-01-29 16:25:00'); -- Invalid time
INSERT INTO unsuccessful_return_deliveries VALUES(1, 3, 'Failed return', '2023-01-30 17:35:00');

-- Test 3, invalid insertion, time == corresponding leg
INSERT INTO legs VALUES(1, 1, 4, '2023-01-27 17:30:00', '2023-01-27 18:30:00', 1);
INSERT INTO return_legs VALUES(1, 1, 3, '2023-01-28 16:30:00', 3, '2023-01-28 17:30:00');
INSERT INTO return_legs VALUES(1, 2, 3, '2023-01-29 16:30:00', 3, '2023-01-29 17:30:00');
INSERT INTO return_legs VALUES(1, 3, 3, '2023-01-30 16:30:00', 3, '2023-01-30 17:30:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 1, 'Failed return', '2023-01-28 17:35:00');
INSERT INTO unsuccessful_return_deliveries VALUES(1, 2, 'Failed return', '2023-01-29 16:30:00'); -- Invalid time
INSERT INTO unsuccessful_return_deliveries VALUES(1, 3, 'Failed return', '2023-01-30 17:35:00');