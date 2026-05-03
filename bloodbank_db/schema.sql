CREATE TABLE Person (
    personID INT NOT NULL AUTO_INCREMENT,  
    name VARCHAR(100) NOT NULL,                 
    gender VARCHAR(10) NOT NULL,                
    age INT NOT NULL,                 
    contact VARCHAR(20) NOT NULL,                 

    PRIMARY KEY (personID),

    UNIQUE (contact),                                     
    CHECK (age >= 0 AND age <= 120),                      
    CHECK (gender IN ('Male', 'Female', 'Other'))         
);

CREATE TABLE Donor (
    donorID INT NOT NULL AUTO_INCREMENT, 
    personID INT NOT NULL,                 
    bloodGroup VARCHAR(5) NOT NULL,                 

    PRIMARY KEY (donorID),

    FOREIGN KEY (personID) REFERENCES Person(personID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CHECK (bloodGroup IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'))
);


CREATE TABLE Patient (
    patientID INT NOT NULL AUTO_INCREMENT,  
    personID INT NOT NULL,                 
    bloodGroup VARCHAR(5) NOT NULL,                 

    PRIMARY KEY (patientID),

    FOREIGN KEY (personID) REFERENCES Person(personID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CHECK (bloodGroup IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'))
);

CREATE TABLE BloodBank (
    bloodBankID INT NOT NULL AUTO_INCREMENT,  
    name VARCHAR(100) NOT NULL,                 
    location VARCHAR(200) NOT NULL,                
    contact VARCHAR(20) NOT NULL,                

    PRIMARY KEY (bloodBankID),

    UNIQUE (contact)
);

CREATE TABLE Staff (
    staffID INT NOT NULL AUTO_INCREMENT,  
    personID INT NOT NULL,                 
    role VARCHAR(50) NOT NULL,                
    bloodBankID INT NOT NULL,                 

    PRIMARY KEY (staffID),

    FOREIGN KEY (personID)    REFERENCES Person(personID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (bloodBankID) REFERENCES BloodBank(bloodBankID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE ClinicalAnalyst (
    analystID INT NOT NULL AUTO_INCREMENT,  
    staffID INT NOT NULL,                 
    staffTraining VARCHAR(100) NOT NULL,                 
    labSpecialization VARCHAR(100) NOT NULL,                 

    PRIMARY KEY (analystID),

    FOREIGN KEY (staffID) REFERENCES Staff(staffID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Donation (
    donationID INT NOT NULL AUTO_INCREMENT, 
    donorID INT NOT NULL,                 
    staffID INT NOT NULL,                 
    donationDate DATE NOT NULL,                 
    quantity INT NOT NULL,                

    
    PRIMARY KEY (donationID),

    FOREIGN KEY (donorID)  REFERENCES Donor(donorID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (staffID)  REFERENCES Staff(staffID)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CHECK (quantity > 0)                              
);

CREATE TABLE StorageLocation (
    storageID INT NOT NULL AUTO_INCREMENT,  
    locationName VARCHAR(100) NOT NULL,                 
    capacity INT NOT NULL,                
    bloodBankID INT NOT NULL,                

    PRIMARY KEY (storageID),

    FOREIGN KEY (bloodBankID) REFERENCES BloodBank(bloodBankID)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CHECK (capacity > 0)                                   
);

CREATE TABLE BloodUnit (
    bloodUnitID INT NOT NULL AUTO_INCREMENT,  
    donationID INT NOT NULL,                 
    bloodGroup VARCHAR(5) NOT NULL,             
    expiryDate DATE NOT NULL,                 
    storageID INT NOT NULL,                 
    
    PRIMARY KEY (bloodUnitID),

    FOREIGN KEY (donationID) REFERENCES Donation(donationID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (storageID)  REFERENCES StorageLocation(storageID)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CHECK (bloodGroup IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'))
);

CREATE TABLE Hospital (
    hospitalID INT NOT NULL AUTO_INCREMENT, 
    name VARCHAR(100) NOT NULL,                 
    location VARCHAR(200) NOT NULL,                 
    contact VARCHAR(20) NOT NULL,                 

    PRIMARY KEY (hospitalID),

    UNIQUE (contact)                                     
);

CREATE TABLE BloodRequest (
    requestID INT NOT NULL AUTO_INCREMENT,  
    patientID INT NOT NULL,                 
    hospitalID INT NOT NULL,                
    staffID INT NOT NULL,                 
    requestDate DATE NOT NULL,                 
    bloodGroup VARCHAR(5) NOT NULL,                 
    status VARCHAR(20) NOT NULL DEFAULT 'Pending', 
    unitsRequired INT NOT NULL,                 

    PRIMARY KEY (requestID),

    FOREIGN KEY (patientID)  REFERENCES Patient(patientID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (hospitalID) REFERENCES Hospital(hospitalID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (staffID)    REFERENCES Staff(staffID)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CHECK (bloodGroup IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
    CHECK (status IN ('Pending', 'Approved', 'Rejected')),  
    CHECK (unitsRequired > 0)                              
);

CREATE TABLE DiscardUnit (
    discardID INT NOT NULL AUTO_INCREMENT,  
    bloodUnitID INT NOT NULL,                 
    discardDate DATE NOT NULL,                 
    reason VARCHAR(200) NOT NULL,                 

    PRIMARY KEY (discardID),

    FOREIGN KEY (bloodUnitID) REFERENCES BloodUnit(bloodUnitID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


-- NORMALIZATION VERIFICATION

-- 1NF: Every column stores one value only, not a list.
-- e.g. bloodGroup = 'A+' only, not 'A+, B-, O+'

-- 2NF: Each table stores only its own data, nothing extra.
-- e.g. Donor table only has donor info (bloodGroup), name and age are kept in Person table.

-- 3NF: No column depends on another non-key column.
-- e.g. Staff does not store blood bank name or location, that data belongs in BloodBank table only.
-- ClinicalAnalyst details are not stored in Staff table.