CREATE DATABASE All_SCD;
use All_SCD;
CREATE TABLE target_table (
    business_key INT PRIMARY KEY,
    attribute1 VARCHAR(100),
    attribute2 VARCHAR(100),
    previous_attribute1 VARCHAR(100),
    start_date DATE,
    end_date DATE,
    current_flag TINYINT DEFAULT 1,
    version INT DEFAULT 1
);
CREATE TABLE source_table (
    business_key INT PRIMARY KEY,
    attribute1 VARCHAR(100),
    attribute2 VARCHAR(100)
);
CREATE TABLE target_table_history (
    business_key INT,
    attribute1 VARCHAR(100),
    attribute2 VARCHAR(100),
    archived_on DATE
);

CREATE OR ALTER PROCEDURE scd_type_0
AS
BEGIN
    INSERT INTO target_table (business_key, attribute1, attribute2)
    SELECT s.business_key, s.attribute1, s.attribute2
    FROM source_table s
    LEFT JOIN target_table t ON s.business_key = t.business_key
    WHERE t.business_key IS NULL;
END;
GO

CREATE OR ALTER PROCEDURE scd_type_1
AS
BEGIN
    UPDATE t
    SET 
        t.attribute1 = s.attribute1,
        t.attribute2 = s.attribute2
    FROM target_table t
    JOIN source_table s ON s.business_key = t.business_key
    WHERE s.attribute1 <> t.attribute1 OR s.attribute2 <> t.attribute2;

    -- Insert new
    INSERT INTO target_table (business_key, attribute1, attribute2)
    SELECT s.business_key, s.attribute1, s.attribute2
    FROM source_table s
    LEFT JOIN target_table t ON s.business_key = t.business_key
    WHERE t.business_key IS NULL;
END;
GO

CREATE OR ALTER PROCEDURE scd_type_2
AS
BEGIN
    DECLARE @today DATE = CAST(GETDATE() AS DATE);
    UPDATE t
    SET 
        t.end_date = @today,
        t.current_flag = 0
    FROM target_table t
    JOIN source_table s ON s.business_key = t.business_key
    WHERE t.current_flag = 1
      AND (s.attribute1 <> t.attribute1 OR s.attribute2 <> t.attribute2);
    INSERT INTO target_table (business_key, attribute1, attribute2, start_date, end_date, current_flag, version)
    SELECT 
        s.business_key, s.attribute1, s.attribute2,
        @today, NULL, 1, 1
    FROM source_table s
    LEFT JOIN target_table t ON s.business_key = t.business_key AND t.current_flag = 1
    WHERE t.business_key IS NULL OR s.attribute1 <> t.attribute1 OR s.attribute2 <> t.attribute2;
END;
GO

CREATE OR ALTER PROCEDURE scd_type_3
AS
BEGIN
    UPDATE t
    SET 
        t.previous_attribute1 = t.attribute1,
        t.attribute1 = s.attribute1
    FROM target_table t
    JOIN source_table s ON s.business_key = t.business_key
    WHERE s.attribute1 <> t.attribute1;

    INSERT INTO target_table (business_key, attribute1, attribute2, previous_attribute1)
    SELECT s.business_key, s.attribute1, s.attribute2, NULL
    FROM source_table s
    LEFT JOIN target_table t ON s.business_key = t.business_key
    WHERE t.business_key IS NULL;
END;
GO

CREATE OR ALTER PROCEDURE scd_type_4
AS
BEGIN
    DECLARE @today DATE = CAST(GETDATE() AS DATE);
    INSERT INTO target_table_history (business_key, attribute1, attribute2, archived_on)
    SELECT t.business_key, t.attribute1, t.attribute2, @today
    FROM target_table t
    JOIN source_table s ON s.business_key = t.business_key
    WHERE s.attribute1 <> t.attribute1 OR s.attribute2 <> t.attribute2;
    UPDATE t
    SET 
        t.attribute1 = s.attribute1,
        t.attribute2 = s.attribute2
    FROM target_table t
    JOIN source_table s ON s.business_key = t.business_key
    WHERE s.attribute1 <> t.attribute1 OR s.attribute2 <> t.attribute2;
    INSERT INTO target_table (business_key, attribute1, attribute2)
    SELECT s.business_key, s.attribute1, s.attribute2
    FROM source_table s
    LEFT JOIN target_table t ON s.business_key = t.business_key
    WHERE t.business_key IS NULL;
END;
GO

CREATE OR ALTER PROCEDURE scd_type_6
AS
BEGIN
    DECLARE @today DATE = CAST(GETDATE() AS DATE);
    UPDATE t
    SET 
        t.end_date = @today,
        t.current_flag = 0
    FROM target_table t
    JOIN source_table s ON s.business_key = t.business_key
    WHERE t.current_flag = 1
      AND (s.attribute1 <> t.attribute1 OR s.attribute2 <> t.attribute2);
    INSERT INTO target_table (business_key, attribute1, attribute2, previous_attribute1, start_date, end_date, current_flag, version)
    SELECT 
        s.business_key, s.attribute1, s.attribute2, t.attribute1,
        @today, NULL, 1, 1
    FROM source_table s
    JOIN target_table t ON s.business_key = t.business_key AND t.current_flag = 1
    WHERE s.attribute1 <> t.attribute1 OR s.attribute2 <> t.attribute2;
    INSERT INTO target_table (business_key, attribute1, attribute2, previous_attribute1, start_date, end_date, current_flag, version)
    SELECT s.business_key, s.attribute1, s.attribute2, NULL, @today, NULL, 1, 1
    FROM source_table s
    LEFT JOIN target_table t ON s.business_key = t.business_key
    WHERE t.business_key IS NULL;
END;
GO
