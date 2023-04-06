DELETE FROM customers;
DELETE FROM employees;
DELETE FROM delivery_staff;
DELETE FROM delivery_requests; 
DELETE FROM packages;
DELETE FROM accepted_requests;
DELETE FROM cancelled_or_unsuccessful_requests;
DELETE FROM cancelled_requests;
DELETE FROM unsuccessful_pickups;
DELETE FROM facilities;
DELETE FROM legs;
DELETE FROM unsuccessful_deliveries;
DELETE FROM return_legs;
DELETE FROM unsuccessful_return_deliveries;


INSERT INTO customers VALUES(1, 'Alice', 'female', '91111234');
INSERT INTO customers VALUES(2, 'Bob', 'male', '91115678');
INSERT INTO customers VALUES(3, 'Carl', 'male', '91235678');

INSERT INTO employees VALUES(1, 'Mark', 'male', '2001-09-28', 'Salesperson', 3000.0);
INSERT INTO employees VALUES(2, 'Cain', 'male', '2005-09-28', 'Delivery Staff', 2000.0);
INSERT INTO employees VALUES(3, 'Belle', 'female', '1999-09-28', 'Manager', 5000.0);
INSERT INTO employees VALUES(4, 'Dave', 'male', '1997-09-29', 'Delivery Staff', 2000.0);
INSERT INTO employees VALUES(5, 'Patricia', 'female', '1998-09-29', 'Delivery Staff', 2000.0);
INSERT INTO employees VALUES(6, 'Abel', 'male', '1990-09-29', 'Delivery Staff', 2000.0);

INSERT INTO delivery_staff VALUES(2);
INSERT INTO delivery_staff VALUES(4);
INSERT INTO delivery_staff VALUES(5);
INSERT INTO delivery_staff VALUES(6);

INSERT INTO delivery_requests VALUES(1, 1, 3, 'completed', 'Tai Seng Str 53', 'S621133', 'Kenneth', 'Toh Payoh Mall', 'S892011', '2022-01-08 04:05:06', '2022-03-08', 20, 47.0);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'unsuccessful', '1 Lorang Ah Soo', 'S521133', 'Amanda', 'Jurong Industrial Park', 'S982011', '2022-04-12 04:05:06', '2022-05-18', 10, 27.0);
INSERT INTO delivery_requests VALUES(3, 1, 1, 'accepted', 'Hougang Blk 654', 'S821654', 'Carol', 'Bendemeer St 54', 'S821543', '2022-03-09 04:35:50', '2022-04-09', 30, 12.0);

INSERT INTO accepted_requests VALUES(3, '12345678', '2022-03-09 05:35:50', 1);

INSERT INTO unsuccessful_pickups VALUES(3, 1, 5, '2022-04-09 05:35:50', 'failure 1');

INSERT INTO facilities VALUES(1, 'Bedok HeartBeat', 'S895511');
INSERT INTO facilities VALUES(2, 'Serangoon', 'S901122');
INSERT INTO facilities VALUES(3, 'Orchard', 'S752233');
INSERT INTO facilities VALUES(4, 'Bishan', 'S852233');
INSERT INTO facilities VALUES(5, 'Tampines', 'S944233');
INSERT INTO facilities VALUES(6, 'Jurong', 'S556611');
INSERT INTO facilities VALUES(7, 'Woodlands', 'S223344');

INSERT INTO legs VALUES(1, 1, 2, '2022-03-08 04:05:06', '2022-03-08 04:35:50', 2); --STARTS AT CUSTOMER, ENDS AT FACILITY 2--
INSERT INTO legs VALUES(1, 2, 2, '2022-03-08 05:05:06', '2022-03-08 05:35:06', 3); --(2,3)--
INSERT INTO legs VALUES(1, 3, 2, '2022-03-08 06:05:06', '2022-03-08 06:35:50', 4); --(3,4)--
INSERT INTO legs VALUES(1, 4, 2, '2022-03-08 07:05:06', '2022-03-08 07:35:50', 5); --(4,5)--

INSERT INTO legs VALUES(2, 1, 4, '2022-05-18 10:05:06', '2022-05-18 10:35:06', 2); --(CUST,2)
INSERT INTO legs VALUES(2, 1, 4, '2022-05-18 11:05:06', '2022-05-18 11:35:06', 3); --(2,3)--

INSERT INTO return_legs VALUES(2, 1, 2, '2022-06-22 10:05:06', 3, '2022-06-22 10:35:06'); --(3,2)--
INSERT INTO return_legs VALUES(2, 1, 2, '2022-06-22 11:05:06', 2, '2022-06-22 11:35:06'); --(2,RECIPIENT)

INSERT INTO legs VALUES(3, 1, 5, '2022-03-08 04:05:06', '2022-03-08 04:35:50', 2); --(CUST,2)--
INSERT INTO legs VALUES(3, 2, 5, '2022-03-08 05:05:06', '2022-03-08 05:35:06', 3); --(2,3)--
INSERT INTO legs VALUES(3, 3, 5, '2022-03-08 06:05:06', '2022-03-08 06:35:50', 4); --(3,4)--

-- Q1 - no return legs - ie. completed (1. success OR 2. unsucessful but recipient collects within 2 weeks after 3 unsuccess)
-- Returns 4 legs --
SELECT view_trajectory(1);
 -- Q1 - return - package returned to customer (1. recipient fails to collect after unsucessful delivery within 2 weeks - update d_r table: unsuccesful OR 2. customer cancels delivery request before reach recipient -  update d_r table: cancelled)
-- Returns 2 legs + 2 return legs --
SELECT view_trajectory(2);
-- Q1 - Query fails
SELECT view_trajectory(0);

-- Q2 - unsuccessful pickup happens once
-- OUTPUT: 2-4
SELECT get_top_delivery_persons(1);
-- OUTPUT: 2-4, 4-2, 5-1
SELECT get_top_delivery_persons(3);
-- OUTPUT: 2-4, 4-2, 5-1, 6-0
SELECT get_top_delivery_persons(4);
-- OUTPUT: none
SELECT get_top_delivery_persons(0);
-- OUTPUT: 2-4, 4-2, 5-1, 6-0 OR Query Fails
SELECT view_trajectory(5);

--  Q3 - 
-- OUTPUT: (2,3) - 3
SELECT get_top_connections(1);
-- OUTPUT: (2,3) - 3, (3,4) - 2, (3,2) - 1
SELECT get_top_connections(3);
-- OUTPUT: (2,3) - 3, (3,4) - 2, (3,2) - 1, (4,5) - 1
SELECT get_top_connections(4);
-- OUTPUT: none
SELECT get_top_delivery_persons(0);
-- OUTPUT: (2,3) - 3, (3,4) - 2, (3,2) - 1, (4,5) - 1 OR Query Fails
SELECT view_trajectory(5);
