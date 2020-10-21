/****** Object:  StoredProcedure [dbo].[usp_ProjectPhaseLevels]    Script Date: 22-12-2019 10:56:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectPhaseLevels]
    @ProjectId bigint
AS
BEGIN
	--DECLARE @CopyProject TABLE(
	--	PSeqID INT, SPSeqID INT, TSeqID INT, STSeqID INT, Id INT, ParentId INT, PhLevel INT, Name varchar(max)
	--);

	WITH PHASES AS
	(
		SELECT row_num AS PSeqID, 0 AS SPSeqID, 0 AS TSeqID, 0 AS STSeqID, Id, 0 AS ParentId, 1 AS PhLevel, Name FROM 
		(SELECT ROW_NUMBER() OVER (ORDER BY PP.Id)row_num, PP.Id, PP.Name
			FROM ProjectPhase PP WHERE PP.ProjectId = @ProjectId) Ph
	),
	SUBPHASES AS
	(
		SELECT PSeqID, row_num AS SPSeqID, 0 AS TSeqID, 0 AS STSeqID, Id, PhaseId, 2 AS PhLevel, Name FROM 
		(SELECT ROW_NUMBER() OVER (ORDER BY PSP.Id)row_num, PSP.Id, PSP.PhaseId, P.PSeqID, PSP.Name
			FROM ProjectSubPhase PSP JOIN PHASES P ON PSP.PhaseId = P.Id) PhS 
	),
	TASKS AS 
	(
		SELECT PSeqID, SPSeqID, row_num AS TSeqID, 0 AS STSeqID, Id, SubPhaseId, 3 AS PhLevel, Name FROM 
		(SELECT ROW_NUMBER() OVER (ORDER BY PT.Id)row_num, PT.Id, PT.SubPhaseId, P.PSeqID, SP.SPSeqID, PT.Name
			FROM ProjectTask PT
				JOIN SUBPHASES SP ON PT.SubPhaseId = SP.Id 
				JOIN PHASES P ON SP.PhaseId = P.Id) PhS 
	),
	SUBTASKS AS 
	(
		SELECT PSeqID, SPSeqID, TSeqID, row_num AS STSeqID, Id, TaskId, 4 AS PhLevel, Name FROM 
		(SELECT ROW_NUMBER() OVER (ORDER BY ST.Id)row_num, ST.Id, ST.TaskId, P.PSeqID, SP.SPSeqID, PT.TSeqID, ST.Name
			FROM ProjectSubTask ST 
				JOIN TASKS PT ON ST.TaskId = PT.Id
				JOIN SUBPHASES SP ON PT.SubPhaseId = SP.Id 
				JOIN PHASES P ON SP.PhaseId = P.Id) PhS 
	)
	--INSERT INTO @CopyProject
	SELECT * FROM PHASES
	UNION ALL
	SELECT * FROM SUBPHASES
	UNION ALL
	SELECT * FROM TASKS
	UNION ALL
	SELECT * FROM SUBTASKS
	ORDER BY PSeqID, SPSeqID,TSeqID,STSeqID

	--SELECT Id, PhLevel FROM @CopyProject
	--SELECT * FROM @CopyProject
END

GO


