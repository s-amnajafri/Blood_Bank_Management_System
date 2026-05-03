-- STORED PROCEDURES
USE bloodbank;

DELIMITER $$

-- Procedure 1: Monthly donation report
CREATE PROCEDURE GenerateMonthlyDonationReport(IN p_year INT, IN p_month INT)
BEGIN
    SELECT p.name AS DonorName, d.bloodGroup,
           dn.donationDate, dn.quantity,
           s.role AS HandledBy
    FROM Donation dn
    JOIN Donor    d  ON dn.donorID  = d.donorID
    JOIN Person   p  ON d.personID  = p.personID
    JOIN Staff    s  ON dn.staffID  = s.staffID
    WHERE YEAR(dn.donationDate)  = p_year
      AND MONTH(dn.donationDate) = p_month
    ORDER BY dn.donationDate;
END$$

-- Procedure 2: Check blood availability for a given blood group
CREATE PROCEDURE CheckBloodAvailability(IN p_bloodGroup VARCHAR(5))
BEGIN
    SELECT bu.bloodUnitID, bu.bloodGroup, bu.expiryDate,
           sl.locationName, bb.name AS BloodBankName
    FROM BloodUnit bu
    JOIN StorageLocation sl ON bu.storageID   = sl.storageID
    JOIN BloodBank       bb ON sl.bloodBankID = bb.bloodBankID
    WHERE bu.bloodGroup  = p_bloodGroup
      AND bu.expiryDate >= CURDATE()
      AND bu.bloodUnitID NOT IN (SELECT bloodUnitID FROM DiscardUnit);
END$$

-- Procedure 3: Approve a blood request
CREATE PROCEDURE ApproveBloodRequest(IN p_requestID INT)
BEGIN
    UPDATE BloodRequest
    SET status = 'Approved'
    WHERE requestID = p_requestID;

    SELECT CONCAT('Request ', p_requestID, ' has been approved.') AS Message;
END$$

-- Procedure 4: Get discard report
CREATE PROCEDURE GetDiscardReport()
BEGIN
    SELECT du.discardID, bu.bloodGroup, bu.expiryDate,
           du.discardDate, du.reason,
           sl.locationName
    FROM DiscardUnit     du
    JOIN BloodUnit       bu ON du.bloodUnitID = bu.bloodUnitID
    JOIN StorageLocation sl ON bu.storageID   = sl.storageID
    ORDER BY du.discardDate DESC;
END$$

DELIMITER ;