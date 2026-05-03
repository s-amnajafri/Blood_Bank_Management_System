-- VIEWS
USE bloodbank;

-- View 1: Available blood stock (not expired, not discarded)
CREATE VIEW AvailableBloodStock AS
SELECT bu.bloodUnitID, bu.bloodGroup, bu.expiryDate,
       sl.locationName, bb.name AS BloodBankName
FROM BloodUnit bu
JOIN StorageLocation sl ON bu.storageID   = sl.storageID
JOIN BloodBank       bb ON sl.bloodBankID = bb.bloodBankID
WHERE bu.expiryDate >= CURDATE()
  AND bu.bloodUnitID NOT IN (SELECT bloodUnitID FROM DiscardUnit);

-- View 2: Pending blood requests
CREATE VIEW PendingRequests AS
SELECT br.requestID, p.name AS PatientName, h.name AS HospitalName,
       br.bloodGroup, br.unitsRequired, br.requestDate
FROM BloodRequest br
JOIN Patient  pa ON br.patientID  = pa.patientID
JOIN Person   p  ON pa.personID   = p.personID
JOIN Hospital h  ON br.hospitalID = h.hospitalID
WHERE br.status = 'Pending';

-- View 3: Donor summary
CREATE VIEW DonorSummary AS
SELECT p.name AS DonorName, d.bloodGroup,
       COUNT(dn.donationID) AS TotalDonations,
       SUM(dn.quantity)     AS TotalUnitsDonated
FROM Person   p
JOIN Donor    d  ON p.personID = d.personID
LEFT JOIN Donation dn ON d.donorID = dn.donorID
GROUP BY p.personID, p.name, d.bloodGroup;

-- View 4: Expired blood units
CREATE VIEW ExpiredBloodUnits AS
SELECT bu.bloodUnitID, bu.bloodGroup, bu.expiryDate,
       sl.locationName, bb.name AS BloodBankName
FROM BloodUnit bu
JOIN StorageLocation sl ON bu.storageID   = sl.storageID
JOIN BloodBank       bb ON sl.bloodBankID = bb.bloodBankID
WHERE bu.expiryDate < CURDATE();