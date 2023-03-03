DROP SCHEMA public CASCADE;
CREATE SCHEMA public; 

CREATE TYPE gender_t AS enum ('M', 'F');
CREATE TYPE request_status_t AS enum ('Completed', 'Cancelled', 'Unsuccessful', 'Acceptable', 'Unacceptable', 'Accepted');

CREATE TABLE Customers(
  cid INT PRIMARY KEY,
  name VARCHAR NOT NULL,
  gender gender_t NOT NULL,
  phoneNumber VARCHAR NOT NULL
);

CREATE TABLE Employees (
  eid INT PRIMARY KEY,
  name VARCHAR NOT NULL,
  gender gender_t NOT NULL,
  dob DATE NOT NULL,
  title VARCHAR NOT NULL,
  salary NUMERIC NOT NULL
);

CREATE TABLE MonitoringPersonnel (
  eid INT PRIMARY KEY REFERENCES Employees(eid)
);

CREATE TABLE ProcessingPersonnel (
  eid INT PRIMARY KEY REFERENCES Employees(eid)
);

CREATE TABLE DeliveryPersonnel (
  eid INT PRIMARY KEY REFERENCES Employees(eid)
);

CREATE TABLE DeliveryRequests(
  drid INT PRIMARY KEY,
  status request_status_t,
  pickupAddress VARCHAR NOT NULL,
  pickupPostal INT NOT NULL,
  recipientName VARCHAR NOT NULL,
  recipientAddress VARCHAR NOT NULL,
  recipientPostal INT NOT NULL,
  pickupDate DATE,
  price NUMERIC,
  estimatedDays INT,
  cid INT NOT NULL REFERENCES Customers(cid),
  processEid INT NOT NULL REFERENCES ProcessingPersonnel (eid)
);

CREATE TABLE AcceptsPayments(
  drid INT UNIQUE REFERENCES DeliveryRequests(drid), 
  creditCardNumber INT,
  paymentTimestamp TIMESTAMP, 
  PRIMARY KEY (drid, creditCardNumber, paymentTimestamp)
);

CREATE TABLE InvolvesPackages(
  pid INT,
  description TEXT NOT NULL,
  weight NUMERIC NOT NULL,
  value NUMERIC NOT NULL,
  actualHeight NUMERIC,
  actualWidth NUMERIC, 
  actualDepth NUMERIC,
  userHeight NUMERIC NOT NULL,
  userWidth NUMERIC NOT NULL,
  userDepth NUMERIC NOT NULL,
  drid INT REFERENCES DeliveryRequests(drid) ON DELETE CASCADE,
  PRIMARY KEY (drid, pid)
);

CREATE TABLE DeliveryProcesses (
  src INT,
  dest INT,
  startTime TIMESTAMP,
  endTime TIMESTAMP,
  isReturn BOOLEAN,
  drid INT REFERENCES DeliveryRequests(drid) ON DELETE CASCADE,
  deliveryEid INT NOT NULL REFERENCES DeliveryPersonnel(eid),
  monitorEid INT NOT NULL REFERENCES MonitoringPersonnel(eid),
  UNIQUE (drid, src, dest, startTime),
  PRIMARY KEY (drid, src, dest, startTime, endTime)
);

CREATE TABLE Facilities (
  fid INT PRIMARY KEY,
  address VARCHAR,
  postalCode VARCHAR
);

CREATE TABLE Legs (
  src INT,
  dest INT,
  startTime TIMESTAMP,
  endTime TIMESTAMP,
  drid INT,
  CONSTRAINT fk_facilities_legs FOREIGN KEY (drid, src, dest, startTime, endTime) REFERENCES DeliveryProcesses(drid, src, dest, startTime, endTime) ON DELETE CASCADE,
  PRIMARY KEY (drid, src, dest, startTime, endTime)
);

CREATE TABLE Unsuccessful (
  timestamp TIMESTAMP,
  reason VARCHAR,
  src INT,
  dest INT,
  startTime TIMESTAMP,
  endTime TIMESTAMP,
  drid INT,
  CONSTRAINT fk_facilities_unsuccessful FOREIGN KEY (drid, src, dest, startTime, endTime) REFERENCES DeliveryProcesses(drid, src, dest, startTime, endTime) ON DELETE CASCADE,
  PRIMARY KEY (drid, src, dest, startTime, endTime)
);

CREATE TABLE Cancels (
  timestamp TIMESTAMP,
  fid INT REFERENCES Facilities(fid),
  cid INT REFERENCES Customers(cid),
  drid INT REFERENCES DeliveryRequests(drid),
  isRefund BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (drid)
);

ALTER TABLE DeliveryProcesses ADD FOREIGN KEY (src) REFERENCES Facilities (fid);
ALTER TABLE DeliveryProcesses ADD FOREIGN KEY (dest) REFERENCES Facilities (fid);