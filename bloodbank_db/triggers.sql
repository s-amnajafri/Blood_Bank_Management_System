-- TRIGGERS
USE bloodbank;

DELIMITER $$

-- Trigger 1: Auto-create a BloodUnit after a Donation is inserted
CREATE TRIGGER trg_auto_create_blood_unit
AFTER INSERT ON Donation
FOR EACH ROW
BEGIN
    DECLARE v_storageID INT;

    SELECT sl.storageID INTO v_storageID
    FROM StorageLocation sl
    JOIN Staff s ON sl.bloodBankID = s.bloodBankID
    WHERE s.staffID = NEW.staffID
    LIMIT 1;

    INSERT INTO BloodUnit (donationID, bloodGroup, expiryDate, storageID)
    SELECT NEW.donationID,
           d.bloodGroup,
           DATE_ADD(NEW.donationDate, INTERVAL 42 DAY),
           v_storageID
    FROM Donor d
    WHERE d.donorID = NEW.donorID;
END$$

-- Trigger 2: Prevent overfilling a storage location
CREATE TRIGGER trg_check_storage_capacity
BEFORE INSERT ON BloodUnit
FOR EACH ROW
BEGIN
    DECLARE current_count INT;
    DECLARE max_capacity  INT;

    SELECT capacity INTO max_capacity
    FROM StorageLocation
    WHERE storageID = NEW.storageID;

    SELECT COUNT(*) INTO current_count
    FROM BloodUnit
    WHERE storageID = NEW.storageID
      AND expiryDate >= CURDATE()
      AND bloodUnitID NOT IN (SELECT bloodUnitID FROM DiscardUnit);

    IF current_count >= max_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Storage location is full. Cannot add more blood units.';
    END IF;
END$$

-- Trigger 3: Auto-log expired blood units into DiscardUnit
CREATE TRIGGER trg_auto_discard_expired
BEFORE UPDATE ON BloodUnit
FOR EACH ROW
BEGIN
    IF NEW.expiryDate < CURDATE() AND OLD.expiryDate >= CURDATE() THEN
        INSERT INTO DiscardUnit (bloodUnitID, discardDate, reason)
        VALUES (NEW.bloodUnitID, CURDATE(), 'Expired');
    END IF;
END$$

DELIMITER ;