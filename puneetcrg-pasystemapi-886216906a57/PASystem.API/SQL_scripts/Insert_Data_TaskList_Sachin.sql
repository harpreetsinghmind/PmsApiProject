USE [PASystem]
GO

INSERT INTO TaskList ([Task],[TaskModule],[TaskEntityId],[TaskById],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[DueDate],[UserId],[Status])
     VALUES
			('Submit timesheets','TimeSheet',1,1,'Admin','2019-07-27 00:00:00.000','Admin','2019-07-27 00:00:00.000','2019-07-31 00:00:00.000',10100,0),
			('Create sales graph','Sales',2,2,'Manager','2019-08-01 00:00:00.000','Admin','2019-08-01 00:00:00.000','2019-08-02 00:00:00.000',10100,0),
			('Regulate attendance time entries','Attendance',3,3,'Admin','2019-07-26 00:00:00.000','Admin','2019-07-26 00:00:00.000','2019-07-30 00:00:00.000',10100,0),
			('Design dashboards','Manager',4,4,'Manager','2019-08-01 00:00:00.000','Admin','2019-08-01 00:00:00.000','2019-08-08 00:00:00.000',10100,0),
			('Submit timesheets','TimeSheet',1,1,'Admin','2019-07-27 00:00:00.000','Admin','2019-07-27 00:00:00.000','2019-07-31 00:00:00.000',10098,0),
			('Create sales graph','Sales',2,2,'Manager','2019-08-01 00:00:00.000','Admin','2019-08-01 00:00:00.000','2019-08-02 00:00:00.000',10098,0),
			('Regulate attendance time entries','Attendance',3,3,'Admin','2019-07-26 00:00:00.000','Admin','2019-07-26 00:00:00.000','2019-07-30 00:00:00.000',10098,0),
			('Design dashboards','Manager',4,4,'Manager','2019-08-01 00:00:00.000','Admin','2019-08-01 00:00:00.000','2019-08-08 00:00:00.000',10098,0);

GO

COMMIT;
GO

/*Then update EmployeeId with existing Employee Ids from 'PASystem' DB*/
