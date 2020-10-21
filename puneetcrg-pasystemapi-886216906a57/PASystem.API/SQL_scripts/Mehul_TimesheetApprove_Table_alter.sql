ALTER TABLE TimesheetApprove
ADD EditReqNote nvarchar(150);

ALTER TABLE TimesheetApprove
ADD EditAllow bit;

ALTER TABLE TimesheetApprove
ADD EditDate datetime;