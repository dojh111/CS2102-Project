BEGIN TRANSACTION;
INSERT INTO Customers VALUES(1, 'Alice', 'female', '97123456');
INSERT INTO employees VALUES (1, 'John', 'male',  NOW(), 'Manager', 5000);
INSERT INTO delivery_requests VALUES (1, 1, 1, 'submitted', 'test', 'test', 'test', 'test', 'test', NOW(), NOW(), 1, 1.0);
INSERT INTO packages VALUES (1, 1, 1.0, 1.0, 1.0, 1.0, 'test', 1.0, 1.0, 1.0, 1.0, 1.0);
INSERT INTO delivery_staff VALUES (1);
INSERT INTO accepted_requests VALUES (1, 'test', NOW(), 1);
COMMIT;

--BEGIN TRANSACTION;
--    INSERT INTO delivery_requests VALUES (1, 1, 1, 'submitted', 'test', 'test', 'test', 'test', 'test', NOW(), NOW(), 1, 1.0);
--    INSERT INTO packages VALUES (1, 1, 1.0, 1.0, 1.0, 1.0, 'test', 1.0, 1.0, 1.0, 1.0, 1.0);
--COMMIT;

--BEGIN TRANSACTION;
--    INSERT INTO delivery_requests VALUES (1, 1, 1, 'submitted', 'test', 'test', 'test', 'test', 'test', NOW(), NOW(), 1, 1.0);
--    INSERT INTO delivery_requests VALUES (2, 1, 1, 'submitted', 'test', 'test', 'test', 'test', 'test', NOW(), NOW(), 1, 1.0);
--    INSERT INTO packages VALUES(1, 3, 5.0, 5.0, 5.0, 5.0, 'Teddy bears', 20.0, 5.0, 5.0, 5.0, 5.0);
--    INSERT INTO packages VALUES(1, 2, 5.0, 5.0, 5.0, 5.0, 'Crayons', 20.0, 5.0, 5.0, 5.0, 5.0);
--    INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 5.0, 'Chairs', 20.0, 5.0, 5.0, 5.0, 5.0);
--
--    INSERT INTO packages VALUES(2, 2, 5.0, 5.0, 5.0, 5.0, 'Teddy bears', 20.0, 5.0, 5.0, 5.0, 5.0);
--    INSERT INTO packages VALUES(2, 3, 5.0, 5.0, 5.0, 5.0, 'Crayons', 20.0, 5.0, 5.0, 5.0, 5.0);
--    INSERT INTO packages VALUES(2, 4, 5.0, 5.0, 5.0, 5.0, 'Chairs', 20.0, 5.0, 5.0, 5.0, 5.0);
--COMMIT;

--BEGIN TRANSACTION;
--INSERT INTO packages VALUES(1, 6, 5.0, 5.0, 5.0, 5.0, 'Table', 20.0, 5.0, 5.0, 5.0, 5.0);
----INSERT INTO packages VALUES(1, 2, 5.0, 5.0, 5.0, 5.0, 'Teddy bears', 20.0, 5.0, 5.0, 5.0, 5.0);
--INSERT INTO packages VALUES(1, 3, 5.0, 5.0, 5.0, 5.0, 'Crayons', 20.0, 5.0, 5.0, 5.0, 5.0);
--INSERT INTO packages VALUES(1, 4, 5.0, 5.0, 5.0, 5.0, 'White Board', 20.0, 5.0, 5.0, 5.0, 5.0);
--INSERT INTO packages VALUES(1, 5, 5.0, 5.0, 5.0, 5.0, 'Chairs', 20.0, 5.0, 5.0, 5.0, 5.0);
--COMMIT;

-- Test data for q3
-- create a delivery staff first

-- Good case
INSERT INTO unsuccessful_pickups VALUES(1, 4, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 1, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 3, 1, NOW(), 'nopackages');

-- Not starting from 1: error
INSERT INTO unsuccessful_pickups VALUES(1, 4, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 5, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 2, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 3, 1, NOW(), 'nopackages');

-- Missing value: error
INSERT INTO unsuccessful_pickups VALUES(1, 4, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 1, 1, NOW(), 'nopackages');
INSERT INTO unsuccessful_pickups VALUES(1, 3, 1, NOW(), 'nopackages');