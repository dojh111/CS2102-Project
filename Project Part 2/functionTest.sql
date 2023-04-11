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


BEGIN TRANSACTION;
INSERT INTO delivery_requests VALUES(1, 1, 3, 'completed', 'custAddr1', 'custPostal1', 'Kenneth', 'recpAdrr1', 'S892011', '2021-01-08 04:05:06', '2022-03-08', 20, 47.0);
INSERT INTO delivery_requests VALUES(2, 2, 1, 'unsuccessful', 'custAddr2', 'custPostal2', 'Amanda', 'recpAdrr2', 'S982011', '2021-04-12 04:05:06', '2022-05-18', 10, 27.0);
INSERT INTO delivery_requests VALUES(3, 1, 1, 'accepted', 'custAddr3', 'custPostal3', 'Carol', 'recpAdrr3', 'S821543', '2021-03-09 04:35:50', '2022-04-09', 30, 12.0);

INSERT INTO packages VALUES(1, 4, 5.0, 5.0, 5.0, 2.5, 'artwork', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 2, 5.0, 5.0, 5.0, 2.5, 'artwork1', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 3, 5.0, 5.0, 5.0, 2.5, 'artwork2', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(1, 1, 5.0, 5.0, 5.0, 2.5, 'artwork3', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 1, 5.0, 5.0, 5.0, 2.5, 'lemons', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 2, 5.0, 5.0, 5.0, 2.5, 'lemons2', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(2, 3, 5.0, 5.0, 5.0, 2.5, 'lemons3', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(3, 1, 5.0, 5.0, 5.0, 2.5, 'pear', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(3, 2, 5.0, 5.0, 5.0, 2.5, 'pear2', 30.0, 5.0, 5.0, 5.0, 2.5);
INSERT INTO packages VALUES(3, 3, 5.0, 5.0, 5.0, 2.5, 'pear3', 30.0, 5.0, 5.0, 5.0, 2.5);
COMMIT;

INSERT INTO accepted_requests VALUES(1, '12345678', '2022-03-09 05:35:50', 1);
INSERT INTO accepted_requests VALUES(2, '12345678', '2022-03-09 05:35:50', 1);
INSERT INTO accepted_requests VALUES(3, '12345678', '2022-03-09 05:35:50', 1);

INSERT INTO cancelled_or_unsuccessful_requests VALUES(1), (2), (3);

INSERT INTO unsuccessful_pickups VALUES(3, 1, 5, '2022-02-09 05:35:50', 'failure 1');

INSERT INTO facilities VALUES(1, 'facility1', 'S895511');
INSERT INTO facilities VALUES(2, 'facility2', 'S901122');
INSERT INTO facilities VALUES(3, 'facility3', 'S752233');
INSERT INTO facilities VALUES(4, 'facility4', 'S852233');
INSERT INTO facilities VALUES(5, 'facility5', 'S944233');
INSERT INTO facilities VALUES(6, 'facility6', 'S556611');
INSERT INTO facilities VALUES(7, 'facility7', 'S223344');

INSERT INTO legs VALUES(1, 1, 2, '2022-03-08 04:05:06', '2022-03-08 04:35:50', 2); --STARTS AT CUSTOMER, ENDS AT FACILITY 2--
INSERT INTO legs VALUES(1, 2, 2, '2022-03-08 05:05:06', '2022-03-08 05:35:06', 3); --(2,3)--
INSERT INTO legs VALUES(1, 3, 2, '2022-03-08 06:05:06', '2022-03-08 06:35:50', 4); --(3,4)--
INSERT INTO legs VALUES(1, 4, 2, '2022-03-08 07:05:06', '2022-03-08 07:35:50', 5); --(4,5)--
INSERT INTO legs VALUES(1, 5, 2, '2022-03-08 08:05:06', '2022-03-08 08:35:50', NULL); --(5, Receipent)--

INSERT INTO legs VALUES(2, 1, 4, '2022-05-18 10:05:06', '2022-05-18 10:35:06', 2); --(CUST,2)
INSERT INTO legs VALUES(2, 2, 4, '2022-05-18 11:05:06', '2022-05-18 11:35:06', 3); --(2,3)--

INSERT INTO return_legs VALUES(2, 1, 2, '2022-06-22 10:05:06', 3, '2022-06-22 10:35:06'); --(3,2)--
INSERT INTO return_legs VALUES(2, 2, 2, '2022-06-22 11:05:06', 2, '2022-06-22 11:35:06'); --(2,RECIPIENT)

INSERT INTO legs VALUES(3, 1, 5, '2022-03-08 04:05:06', '2022-03-08 04:35:50', 2); --(CUST,2)--
INSERT INTO legs VALUES(3, 2, 5, '2022-03-08 05:05:06', '2022-03-08 05:35:06', 3); --(2,3)--
INSERT INTO legs VALUES(3, 3, 5, '2022-03-08 06:05:06', '2022-03-08 06:35:50', 4); --(3,4)--