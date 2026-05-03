-- QUERIES (JOINS + AGGREGATIONS)
USE bloodbank;

-- JOIN QUERIES

-- Query 1: Donor names with their blood groups
SELECT p.name AS DonorName, d.bloodGroup
FROM Person p
JOIN Donor d ON p.personID = d.personID;

-- Query 2: Blood requests with hospital names and patient names
SELECT br.requestID, p.name AS PatientName, h.name AS HospitalName,
       br.bloodGroup, br.status, br.requestDate
FROM BloodRequest br
JOIN Patient pa  ON br.patientID  = pa.patientID
JOIN Person  p   ON pa.personID   = p.personID
JOIN Hospital h  ON br.hospitalID = h.hospitalID;

-- Query 3: Blood units with their storage location and blood bank
SELECT bu.bloodUnitID, bu.bloodGroup, bu.expiryDate,
       sl.locationName, bb.name AS BloodBankName
FROM BloodUnit bu
JOIN StorageLocation sl ON bu.storageID   = sl.storageID
JOIN BloodBank       bb ON sl.bloodBankID = bb.bloodBankID;

-- Query 4: Staff managing blood requests (with their role and blood bank)
SELECT br.requestID, p.name AS StaffName, s.role,
       bb.name AS BloodBankName, br.status
FROM BloodRequest br
JOIN Staff     s  ON br.staffID    = s.staffID
JOIN Person    p  ON s.personID    = p.personID
JOIN BloodBank bb ON s.bloodBankID = bb.bloodBankID;

-- Query 5: Full donation trail
SELECT p.name AS DonorName, d.bloodGroup AS DonorBloodGroup,
       dn.donationDate, dn.quantity,
       bu.bloodUnitID, bu.expiryDate,
       sl.locationName AS StoredAt
FROM Person p
JOIN Donor           d  ON p.personID    = d.personID
JOIN Donation        dn ON d.donorID     = dn.donorID
JOIN BloodUnit       bu ON dn.donationID = bu.donationID
JOIN StorageLocation sl ON bu.storageID  = sl.storageID;

-- AGGREGATION QUERIES

-- Query 6: Total blood units by blood group
SELECT bloodGroup, COUNT(*) AS TotalUnits
FROM BloodUnit
GROUP BY bloodGroup
ORDER BY TotalUnits DESC;

-- Query 7: Total donations per donor
SELECT p.name AS DonorName, COUNT(dn.donationID) AS TotalDonations,
       SUM(dn.quantity) AS TotalUnitsDonated
FROM Person p
JOIN Donor    d  ON p.personID = d.personID
JOIN Donation dn ON d.donorID  = dn.donorID
GROUP BY p.personID, p.name
ORDER BY TotalDonations DESC;

-- Query 8: Total requests per hospital
SELECT h.name AS HospitalName, COUNT(br.requestID) AS TotalRequests,
       SUM(br.unitsRequired) AS TotalUnitsRequested
FROM Hospital h
JOIN BloodRequest br ON h.hospitalID = br.hospitalID
GROUP BY h.hospitalID, h.name
ORDER BY TotalRequests DESC;

-- Query 9: Count of expired blood units
SELECT COUNT(*) AS ExpiredUnits
FROM BloodUnit
WHERE expiryDate < CURDATE();

-- Query 10: Requests by status summary
SELECT status, COUNT(*) AS `Count`
FROM BloodRequest
GROUP BY status;

-- Query 11: Monthly donation summary
SELECT YEAR(donationDate)  AS `Year`,
       MONTH(donationDate) AS `Month`,
       COUNT(*)            AS TotalDonations,
       SUM(quantity)       AS TotalUnits
FROM Donation
GROUP BY YEAR(donationDate), MONTH(donationDate)
ORDER BY `Year`, `Month`;