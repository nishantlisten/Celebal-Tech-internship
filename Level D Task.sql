use company;
CREATE TABLE time_dimension (
    SKDate VARCHAR(10),
    KeyDate DATE,
    Date DATE PRIMARY KEY,
    CalendarDay INT,
    CalendarMonth INT,
    CalendarQuarter INT,
    CalendarYear INT,
    DayNameLong VARCHAR(15),
    DayNameShort VARCHAR(5),
    DayNumberOfWeek INT,
    DayNumberOfYear INT,
    DaySuffix VARCHAR(5),
    FiscalWeek INT,
    FiscalPeriod INT,
    FiscalQuarter INT,
    FiscalYear INT,
    FiscalYearPeriod VARCHAR(10)
);
DELIMITER $$
-- This stored procedure generates and imports date-related data into the `time_dimension` table
CREATE PROCEDURE populate_date_dimension(IN input_date DATE)
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;

    SET start_date = DATE_FORMAT(input_date, '%Y-01-01');
    SET end_date = DATE_FORMAT(input_date, '%Y-12-31');

    INSERT INTO date_dimension (full_date, day, month, year, day_name, is_weekend)
    SELECT 
        curr_date,
        DAY(curr_date),
        MONTH(curr_date),
        YEAR(curr_date),
        DAYNAME(curr_date),
        CASE WHEN DAYOFWEEK(curr_date) IN (1, 7) THEN TRUE ELSE FALSE END
    FROM (
        SELECT ADDDATE(start_date, INTERVAL seq DAY) AS curr_date
        FROM (
            SELECT @row := @row + 1 AS seq
            FROM 
                (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
                 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
                (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
                 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
                (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
                 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
                (SELECT @row := -1) init
        ) AS seq_nums
        WHERE ADDDATE(start_date, INTERVAL seq DAY) <= end_date
    ) AS dates;
END$$

DELIMITER ;
CALL populate_time_dimension('2020-07-14');

