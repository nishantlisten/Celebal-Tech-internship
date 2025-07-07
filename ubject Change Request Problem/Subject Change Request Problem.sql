
CREATE DATABASE CollegeManagement;
GO


USE CollegeManagement;
GO


CREATE TABLE SubjectAllotments (
    StudentID varchar(50),
    SubjectID varchar(50),
    Is_Valid bit
);
GO


CREATE TABLE SubjectRequest (
    StudentID varchar(50),
    SubjectID varchar(50)
);
GO


INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);
GO


INSERT INTO SubjectRequest (StudentID, SubjectID)
VALUES
('159103036', 'PO1496');
GO


CREATE PROCEDURE UpdateSubjectAllotments
    @StudentID varchar(50),
    @RequestedSubjectID varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

   
    IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentID = @StudentID)
    BEGIN
    
        IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentID = @StudentID AND Is_Valid = 1 AND SubjectID != @RequestedSubjectID)
        BEGIN
  
            UPDATE SubjectAllotments
            SET Is_Valid = 0
            WHERE StudentID = @StudentID AND Is_Valid = 1;

  
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @RequestedSubjectID, 1);
        END
        ELSE IF NOT EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentID = @StudentID AND Is_Valid = 1)
        BEGIN
 
            INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
            VALUES (@StudentID, @RequestedSubjectID, 1);
        END
    END
    ELSE
    BEGIN
     
        INSERT INTO SubjectAllotments (StudentID, SubjectID, Is_Valid)
        VALUES (@StudentID, @RequestedSubjectID, 1);
    END
END;
GO


EXEC UpdateSubjectAllotments @StudentID = '159103036', @RequestedSubjectID = 'PO1496';
GO


SELECT * FROM SubjectAllotments;
GO