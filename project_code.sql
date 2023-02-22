CREATE TABLE Customers (
    cid INT PRIMARY KEY,
    gender TEXT CHECK(gender = "M" OR gender = "F"),
    name TEXT, -- NOT NULL?
    phoneNumber TEXT, -- UNIQUE?
);

CREATE TABLE DeliveryRequests (
    drid INT PRIMARY KEY,
    deliveryRequestStatus CHECK(status = "Completed" OR status = "Cancelled" OR status = "Unsuccessful" OR IS NULL)
    pickupPostal TEXT NOT NULL,
    pickupAddress TEXT NOT NULL,
    recipientName TEXT NOT NULL,
    recipeintAddress TEXT NOT NULL,
    recipientPostal TEXT NOT NULL,
);

CREATE TABLE Packages(
    pid INT PRIMARY KEY,
    description TEXT NOT NULL, -- packageDescription, packageWeight, packageValue?
    weight NUMERIC NOT NULL,
    value NUMERIC NOT NULL,
    actualHeight NUMERIC,
    actualWidth NUMERIC,
    actualDepth NUMERIC,
    height NUMERIC NOT NULL,
    width NUMERIC NOT NULL,
    depth NUMERIC NOT NULL
);

CREATE TABLE Makes (
    drid INT PRIMARY KEY,
    cid INT,
    FOREIGN KEY drid REFERENCES DeliveryRequests(drid)
    FOREIGN KEY cid REFERENCES Customers(cid)
);

CREATE TABLE Cancels (
    cancellationTimeStamp TIMESTAMP PRIMARY KEY,
    drid INT REFERENCES DeliveryRequests(drid),
    cid INT REFERENCES Customers(cid),
    UNIQUE(drid),
    PRIMARY KEY(cancellationTimeStamp, drid, cid)
);