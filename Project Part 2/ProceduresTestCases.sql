-- Q1 Test Case
CALL submit_request(
  1,
  1,
  'fasdf',
  'fasdf',
  'fasdf',
  'fasdf',
  'fasdf',
  '2011-01-01 00:00:00'::TIMESTAMP,
  2,
  ARRAY [1, 2],
  ARRAY [1, 2],
  ARRAY [1, 2],
  ARRAY [1, 2],
  ARRAY ['test1', 'test2'],
  ARRAY [1.0, 2.0]
);

-- Q2 Test case
CALL resubmit_request(
  2,
  4,
  '2023-01-01 00:00:00'::TIMESTAMP,
  ARRAY [8888888, 88888888],
  ARRAY [8888888, 88888888],
  ARRAY [8888888, 88888888],
  ARRAY [8888888, 88888888]
);

-- Q3 Test case
CALL insert_leg(1, 2, '2023-01-01 00:00:00'::TIMESTAMP, 1);