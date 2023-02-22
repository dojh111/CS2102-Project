DROP TYPE IF EXISTS gender_t, request_status_t CASCADE;

DROP TABLE IF EXISTS Customers, DeliveryRequests, Cancels, AcceptsPayments, InvolvesPackages, Employees, DeliveryProcesses, Facilities, ConsistsLegs, IsUnsuccessful CASCADE;

CREATE TYPE gender_t AS enum ('M', 'F');
CREATE TYPE request_status_t AS enum ('Completed', 'Cancelled', 'Unsuccessful');

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
  eid INT NOT NULL REFERENCES Employees(eid)
);

-- Need to test by inserting DR without payment
CREATE TABLE AcceptsPayments(
  drid INT REFERENCES DeliveryRequests(drid), 
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
  src VARCHAR,
  dest VARCHAR,
  startTime TIMESTAMP,
  endTime TIMESTAMP,
  isReturn BOOLEAN,
  drid INT REFERENCES DeliveryRequests(drid) ON DELETE CASCADE,
  deliveryEid INT NOT NULL REFERENCES Employees(eid),
  monitorEid INT NOT NULL REFERENCES Employees(eid),
  fid INT UNIQUE, 
  PRIMARY KEY (drid, src, dest, startTime, endTime)
);

CREATE TABLE Facilities (
  fid INT PRIMARY KEY,
  address VARCHAR,
  postalCode VARCHAR,
  src VARCHAR,
  dest VARCHAR,
  startTime TIMESTAMP,
  endTime TIMESTAMP,
  drid INT,
  UNIQUE(drid, src, dest, startTime, endTime),
  CONSTRAINT fk_facilities FOREIGN KEY (drid, src, dest, startTime, endTime) REFERENCES DeliveryProcesses(drid, src, dest, startTime, endTime)
);

CREATE TABLE ConsistsLegs (
  lid INT,
  src VARCHAR,
  dest VARCHAR,
  startTime TIMESTAMP,
  endTime TIMESTAMP,
  drid INT,
  CONSTRAINT fk_facilities_consistslegs FOREIGN KEY (drid, src, dest, startTime, endTime) REFERENCES DeliveryProcesses(drid, src, dest, startTime, endTime) ON DELETE CASCADE,
  PRIMARY KEY (lid, drid, src, dest, startTime, endTime)
);

CREATE TABLE IsUnsuccessful (
  timestamp TIMESTAMP,
  reason VARCHAR,
  src VARCHAR,
  dest VARCHAR,
  startTime TIMESTAMP,
  endTime TIMESTAMP,
  drid INT,
  CONSTRAINT fk_facilities_isunsuccessful FOREIGN KEY (drid, src, dest, startTime, endTime) REFERENCES DeliveryProcesses(drid, src, dest, startTime, endTime) ON DELETE CASCADE,
  PRIMARY KEY (timestamp, drid, src, dest, startTime, endTime)
);

-- Note that multiple parties (incl employee) can cancel the request
CREATE TABLE Cancels (
  timestamp TIMESTAMP,
  fid INT REFERENCES Facilities(fid),
  cid INT REFERENCES Customers(cid),
  drid INT REFERENCES DeliveryRequests(drid),
  PRIMARY KEY (drid)
);

ALTER TABLE DeliveryProcesses ADD FOREIGN KEY (fid) REFERENCES Facilities(fid);
