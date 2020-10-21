ALTER TABLE ProjectPhase ALTER COLUMN StartDate DATETIME NULL;

ALTER TABLE ProjectSubPhase ALTER COLUMN StartDate DATETIME NULL;

ALTER TABLE ProjectPhase
ADD EstimatedStartDate datetime;

ALTER TABLE ProjectSubPhase
ADD EstimatedStartDate datetime;