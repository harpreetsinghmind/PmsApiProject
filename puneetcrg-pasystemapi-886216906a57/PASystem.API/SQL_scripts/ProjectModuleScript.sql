Delete from TimesheetDetail;
Delete from Timesheet;
Delete from ProjectSubPhase;
Delete from PhaseContract;
Delete from ProjectPhase;
Delete from Projects;
Delete from ProjectSources;
Delete from ProjectTypes;

INSERT INTO ProjectSources (
    Name,
    InActive,
    CreatedBy,
    CreatedDate,
	UpdatedBy,
	UpdatedDate
)
VALUES
    (
        'IT Engineering',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
    (
        'PMDG',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
    (
        'Survey',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Outside Referral',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Others',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    );

INSERT INTO ProjectTypes(
    Name,
    InActive,
    CreatedBy,
    CreatedDate,
	UpdatedBy,
	UpdatedDate
)
VALUES
    (
        'C-Store',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Petroleum',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Government',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Grocery',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Hospitality',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Shoping centers',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Offices',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Quick service Restaurants',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    ),
	(
        'Retail',
        0,
        NULL,
        NULL,
		NULL,
		NULL
    );

ALTER TABLE Projects
ADD PlannedStartDate datetime;

ALTER TABLE Projects
ADD WorkingDays nvarchar(255);
