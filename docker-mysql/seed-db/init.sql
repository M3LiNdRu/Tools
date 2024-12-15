CREATE USER 'user'@'%' IDENTIFIED BY 'letmein'; 
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;

-- FILL THIS SCRIPT WITH NECESSARY TABLES AND DATA

CREATE TABLE IF NOT EXISTS Users (
    Email VARCHAR(255) NOT NULL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    AccountId INT NOT NULL
);

DELIMITER $$

CREATE PROCEDURE IngestFakeData()
BEGIN
    DECLARE users_count INT;

    SELECT COUNT(*) INTO users_count FROM Users;

    IF users_count = 0 THEN
        INSERT INTO Users (email, name, password, accountId) VALUES ('user1@example.com', 'User One', 'password123', 1), ('user2@example.com', 'User Two', 'password456', 2);
    END IF;
END$$

DELIMITER ;

CALL IngestFakeData();