ALTER PROC [dbo].[usp_TimesheetCopyforDate] -- exec [usp_TimesheetCopyforDate] '08/20/2019 00:00:00','09/06/2019 00:00:00',10081,'admin',0,1
    @SourceDate DATETIME,  
    @DestinationDate DATETIME,  
    @EmployeeId BIGINT,  
    @CreatedBy NVARCHAR(MAX) = NULL,  
	@timesheetId BIGINT,
	@IsCopyEverything BIT = 1  
AS   
 SET NOCOUNT ON   
 SET XACT_ABORT ON    
   
 BEGIN TRAN  

                  DECLARE @totalhours DECIMAL, @day INT     
				  DECLARE @DDay1 DATETIME, @DDay2 DATETIME, @DDay3 DATETIME, @DDay4 DATETIME, @DDay5 DATETIME, @DDay6 DATETIME, @DDay7 DATETIME
				  DECLARE @OldtimesheetId BIGINT, @ProjectId BIGINT, @PhaseId BIGINT, @SubPhaseId BIGINT
				  DECLARE @Dayhours DECIMAL(10,2),@ODayhours DECIMAL(10,2), @sourceday INT
				  DECLARE @NewTimesheetId BIGINT

                  SET @day = (CASE WHEN DATEPART(dw,@DestinationDate) = 1 THEN 7 ELSE (DATEPART(dw,@DestinationDate)-1) END) 
				  
				  IF(@day = 1)
					BEGIN
					    SET @DDay1 = @DestinationDate
						SET @DDay2 = DATEADD(dd,1,@DestinationDate)
						SET @DDay3 = DATEADD(dd,2,@DestinationDate)
						SET @DDay4 = DATEADD(dd,3,@DestinationDate)
						SET @DDay5 = DATEADD(dd,4,@DestinationDate)
						SET @DDay6 = DATEADD(dd,5,@DestinationDate)
						SET @DDay7 = DATEADD(dd,6,@DestinationDate)
					END
					ELSE IF(@day = 2)
					BEGIN
					    SET @DDay1 = DATEADD(dd,-1,@DestinationDate)
						SET @DDay2 = @DestinationDate
						SET @DDay3 = DATEADD(dd,1,@DestinationDate)
						SET @DDay4 = DATEADD(dd,2,@DestinationDate)
						SET @DDay5 = DATEADD(dd,3,@DestinationDate)
						SET @DDay6 = DATEADD(dd,4,@DestinationDate)
						SET @DDay7 = DATEADD(dd,5,@DestinationDate)
					END
					ELSE IF(@day = 3)
					BEGIN
					    SET @DDay1 = DATEADD(dd,-2,@DestinationDate)
						SET @DDay2 = DATEADD(dd,-1,@DestinationDate)
						SET @DDay3 = @DestinationDate
						SET @DDay4 = DATEADD(dd,1,@DestinationDate)
						SET @DDay5 = DATEADD(dd,2,@DestinationDate)
						SET @DDay6 = DATEADD(dd,3,@DestinationDate)
						SET @DDay7 = DATEADD(dd,4,@DestinationDate)
					END
					ELSE IF(@day = 4)
					BEGIN
					    SET @DDay1 = DATEADD(dd,-3,@DestinationDate)
						SET @DDay2 = DATEADD(dd,-2,@DestinationDate)
						SET @DDay3 = DATEADD(dd,-1,@DestinationDate)
						SET @DDay4 = @DestinationDate
						SET @DDay5 = DATEADD(dd,1,@DestinationDate)
						SET @DDay6 = DATEADD(dd,2,@DestinationDate)
						SET @DDay7 = DATEADD(dd,3,@DestinationDate)
					END
					ELSE IF(@day = 5)
					BEGIN
					    SET @DDay1 = DATEADD(dd,-4,@DestinationDate)
						SET @DDay2 = DATEADD(dd,-3,@DestinationDate)
						SET @DDay3 = DATEADD(dd,-2,@DestinationDate)
						SET @DDay4 = DATEADD(dd,-1,@DestinationDate)
						SET @DDay5 = @DestinationDate
						SET @DDay6 = DATEADD(dd,1,@DestinationDate)
						SET @DDay7 = DATEADD(dd,2,@DestinationDate)
					END
					ELSE IF(@day = 6)
					BEGIN
					    SET @DDay1 = DATEADD(dd,-5,@DestinationDate)
						SET @DDay2 = DATEADD(dd,-4,@DestinationDate)
						SET @DDay3 = DATEADD(dd,-3,@DestinationDate)
						SET @DDay4 = DATEADD(dd,-2,@DestinationDate)
						SET @DDay5 = DATEADD(dd,-1,@DestinationDate)
						SET @DDay6 = @DestinationDate
						SET @DDay7 = DATEADD(dd,1,@DestinationDate)
					END
					ELSE IF(@day = 7)
					BEGIN
					    SET @DDay1 = DATEADD(dd,-6,@DestinationDate)
						SET @DDay2 = DATEADD(dd,-5,@DestinationDate)
						SET @DDay3 = DATEADD(dd,-4,@DestinationDate)
						SET @DDay4 = DATEADD(dd,-3,@DestinationDate)
						SET @DDay5 = DATEADD(dd,-2,@DestinationDate)
						SET @DDay6 = DATEADD(dd,-1,@DestinationDate)
						SET @DDay7 = @DestinationDate
					END

				  IF(@IsCopyEverything = 1)
				  BEGIN
				  
				            DECLARE copytimesheetforday_Cursor CURSOR FOR     
							SELECT Id, ProjectId, PhaseId, SubPhaseId
							FROM 
								[dbo].[Timesheet] WITH (UPDLOCK)
							WHERE EmployeeId = @EmployeeId AND 
								(CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@SourceDate,111))
  
  
							OPEN copytimesheetforday_Cursor    
  
							FETCH NEXT FROM copytimesheetforday_Cursor     
									INTO @OldtimesheetId,@ProjectId,@PhaseId,@SubPhaseId    
  
									WHILE @@FETCH_STATUS = 0    
									BEGIN    
									         
											IF EXISTS(SELECT Id FROM [dbo].[Timesheet] WITH (UPDLOCK) 
													          WHERE EmployeeId = @EmployeeId AND  ProjectId = @ProjectId AND PhaseId = @PhaseId AND SubPhaseId = @SubPhaseId
																		AND (CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@DestinationDate,111)))
													BEGIN
													        --SELECT 'If'

														    SET @sourceday = (CASE WHEN DATEPART(dw,@SourceDate) = 1 THEN 7 ELSE (DATEPART(dw,@SourceDate)-1) END) 

															(SELECT  @Dayhours =(CASE WHEN @sourceday = 1 THEN Day1
																			 WHEN @sourceday = 2 THEN Day2
																			 WHEN @sourceday = 3 THEN Day3
																			 WHEN @sourceday = 4 THEN Day4
																			 WHEN @sourceday = 5 THEN Day5
																			 WHEN @sourceday = 6 THEN Day6
																			 WHEN @sourceday = 7 THEN Day7
																			 ELSE 0 END),
															 @ODayhours =(CASE WHEN @sourceday = 1 THEN ODay1
																				WHEN @sourceday = 2 THEN ODay2
																				WHEN @sourceday = 3 THEN ODay3
																				WHEN @sourceday = 4 THEN ODay4
																				WHEN @sourceday = 5 THEN ODay5
																				WHEN @sourceday = 6 THEN ODay6
																				WHEN @sourceday = 7 THEN ODay7
																				ELSE 0 END)
															FROM Timesheet WHERE Id = @OldtimesheetId)
																	  
													--SELECT @day 
													--SELECt @Dayhours as dayhours
													--SELECt @ODayhours as odayhours
													--SELECT @sourceday
													--SELECt @OldtimesheetId as id
													DECLARE @DestinationTimesheetID INT
													SET @DestinationTimesheetId = ( SELECT TOP 1 Id FROM Timesheet WHERE
																						EmployeeId = @EmployeeId AND  ProjectId = @ProjectId AND PhaseId = @PhaseId AND SubPhaseId = @SubPhaseId
																								AND (CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																									CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																									CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																									CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																									CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																									CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																									CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@DestinationDate,111))
																                   
																				   )

																				   --SELECT @DestinationTimesheetID

														  UPDATE [dbo].[Timesheet]
														     SET 
															    [Day1] = (CASE WHEN @day = 1 THEN @Dayhours ELSE [Day1] END)
															   ,[Day2] = (CASE WHEN @day = 2 THEN @Dayhours ELSE [Day2] END)
															   ,[Day3] = (CASE WHEN @day = 3 THEN @Dayhours ELSE [Day3] END)
															   ,[Day4] = (CASE WHEN @day = 4 THEN @Dayhours ELSE [Day4] END)
															   ,[Day5] = (CASE WHEN @day = 5 THEN @Dayhours ELSE [Day5] END)
															   ,[Day6] = (CASE WHEN @day = 6 THEN @Dayhours ELSE [Day6] END)
															   ,[Day7] = (CASE WHEN @day = 7 THEN @Dayhours ELSE [Day7] END)
															   ,[ODay1] = (CASE WHEN @day = 1 THEN @ODayhours ELSE [ODay1] END)
															   ,[ODay2] = (CASE WHEN @day = 2 THEN @ODayhours ELSE [ODay2] END)
															   ,[ODay3] = (CASE WHEN @day = 3 THEN @ODayhours ELSE [ODay3] END)
															   ,[ODay4] = (CASE WHEN @day = 4 THEN @ODayhours ELSE [ODay4] END)
															   ,[ODay5] = (CASE WHEN @day = 5 THEN @ODayhours ELSE [ODay5] END)
															   ,[ODay6] = (CASE WHEN @day = 6 THEN @ODayhours ELSE [ODay6] END)
															   ,[ODay7] = (CASE WHEN @day = 7 THEN @ODayhours ELSE [ODay7] END)
															   ,[UpdatedBy] = @CreatedBy
															   ,[UpdatedDate] = GETDATE()
													FROM 
														[dbo].[Timesheet] WITH (UPDLOCK)
													WHERE
														EmployeeId = @EmployeeId AND  ProjectId = @ProjectId AND PhaseId = @PhaseId AND SubPhaseId = @SubPhaseId
																		AND (CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@DestinationDate,111) OR   
																			CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@DestinationDate,111))


													INSERT INTO [dbo].[TimesheetDetail]  
																  (  
																	Day  
																   ,Detail  
																   ,WeekDay  
																   ,Status  
																   ,Hours  
																   ,OHours  
																   ,BillingNote  
																   ,CreatedBy  
																   ,CreatedDate  
																   ,TimesheetId  
																  )  
																SELECT   
																     @DestinationDate  
																	,Detail  
																	,@day  
																	,Status  
																	,Hours  
																	,OHours  
																	,BillingNote  
																	,@CreatedBy  
																	,GETDATE()  
																	,@DestinationTimesheetId  
																FROM  [dbo].[TimesheetDetail] WITH (UPDLOCK)  
															    WHERE CONVERT(VARCHAR(20),[Day],111) = CONVERT(VARCHAR(20),@SourceDate,111) 
																AND TimesheetId = @OldtimesheetId 
                  
													END
											ELSE
													BEGIN
													
													       --SELECT 'ELSE'

															SET @sourceday = (CASE WHEN DATEPART(dw,@SourceDate) = 1 THEN 7 ELSE (DATEPART(dw,@SourceDate)-1) END) 

															(SELECT  @Dayhours =(CASE WHEN @sourceday = 1 THEN Day1
																			 WHEN @sourceday = 2 THEN Day2
																			 WHEN @sourceday = 3 THEN Day3
																			 WHEN @sourceday = 4 THEN Day4
																			 WHEN @sourceday = 5 THEN Day5
																			 WHEN @sourceday = 6 THEN Day6
																			 WHEN @sourceday = 7 THEN Day7
																			 ELSE 0 END),
															 @ODayhours =(CASE WHEN @sourceday = 1 THEN ODay1
																				WHEN @sourceday = 2 THEN ODay2
																				WHEN @sourceday = 3 THEN ODay3
																				WHEN @sourceday = 4 THEN ODay4
																				WHEN @sourceday = 5 THEN ODay5
																				WHEN @sourceday = 6 THEN ODay6
																				WHEN @sourceday = 7 THEN ODay7
																				ELSE 0 END)
															FROM Timesheet 
															WHERE Id = @OldtimesheetId)


													--			SELECT @day 
													--SELECt @Dayhours as dayhours
													--SELECt @ODayhours as odayhours
													--SELECT @sourceday
													--SELECt @OldtimesheetId as id


													               INSERT INTO [dbo].[Timesheet]
																							   (
																							    [EmployeeId]
																							   ,[ProjectId]
																							   ,[PhaseId]
																							   ,[SubPhaseId]
																							   ,[Day1]
																							   ,[Day2]
																							   ,[Day3]
																							   ,[Day4]
																							   ,[Day5]
																							   ,[Day6]
																							   ,[Day7]
																							   ,[ODay1]
																							   ,[ODay2]
																							   ,[ODay3]
																							   ,[ODay4]
																							   ,[ODay5]
																							   ,[ODay6]
																							   ,[ODay7]
																							   ,[DDay1]
																							   ,[DDay2]
																							   ,[DDay3]
																							   ,[DDay4]
																							   ,[DDay5]
																							   ,[DDay6]
																							   ,[DDay7]
																							   ,[Billing]
																							   ,[CreatedBy]
																							   ,[CreatedDate]
																							 )
																					SELECT
																						 @EmployeeId
																						,[ProjectId]
																						,[PhaseId]
																						,[SubPhaseId]
																						,(CASE WHEN @day = 1 THEN @Dayhours ELSE 0 END)
																						,(CASE WHEN @day = 2 THEN @Dayhours ELSE 0 END)
																						,(CASE WHEN @day = 3 THEN @Dayhours ELSE 0 END)
																						,(CASE WHEN @day = 4 THEN @Dayhours ELSE 0 END)
																						,(CASE WHEN @day = 5 THEN @Dayhours ELSE 0 END)
																						,(CASE WHEN @day = 6 THEN @Dayhours ELSE 0 END)
																						,(CASE WHEN @day = 7 THEN @Dayhours ELSE 0 END)
																						,(CASE WHEN @day = 1 THEN @ODayhours ELSE 0 END)
																						,(CASE WHEN @day = 2 THEN @ODayhours ELSE 0 END)
																						,(CASE WHEN @day = 3 THEN @ODayhours ELSE 0 END)
																						,(CASE WHEN @day = 4 THEN @ODayhours ELSE 0 END)
																						,(CASE WHEN @day = 5 THEN @ODayhours ELSE 0 END)
																						,(CASE WHEN @day = 6 THEN @ODayhours ELSE 0 END)
																						,(CASE WHEN @day = 7 THEN @ODayhours ELSE 0 END)
																						,(CASE WHEN DDay1 IS NOT NULL THEN @DDay1 ELSE DDay1 END)
																						,(CASE WHEN DDay2 IS NOT NULL THEN @DDay2 ELSE DDay2 END)
																						,(CASE WHEN DDay3 IS NOT NULL THEN @DDay3 ELSE DDay3 END)
																						,(CASE WHEN DDay4 IS NOT NULL THEN @DDay4 ELSE DDay4 END)
																						,(CASE WHEN DDay5 IS NOT NULL THEN @DDay5 ELSE DDay5 END)
																						,(CASE WHEN DDay6 IS NOT NULL THEN @DDay6 ELSE DDay6 END)
																						,(CASE WHEN DDay7 IS NOT NULL THEN @DDay7 ELSE DDay7 END)
																						,[Billing]
																						,@CreatedBy
																						,GETDATE()
																					FROM 
																						[dbo].[Timesheet] WITH (UPDLOCK)
																					WHERE
																						Id = @OldtimesheetId

													SET @NewTimesheetId  = SCOPE_IDENTITY()
											

													INSERT INTO [dbo].[TimesheetDetail]  
																  (  
																	Day  
																   ,Detail  
																   ,WeekDay  
																   ,Status  
																   ,Hours  
																   ,OHours  
																   ,BillingNote  
																   ,CreatedBy  
																   ,CreatedDate  
																   ,TimesheetId  
																  )  
																SELECT   
																     @DestinationDate  
																	,Detail  
																	,@day  
																	,Status  
																	,Hours  
																	,OHours  
																	,BillingNote  
																	,@CreatedBy  
																	,GETDATE()  
																	,@NewTimesheetId  
																FROM  [dbo].[TimesheetDetail] WITH (UPDLOCK)  
															   WHERE CONVERT(VARCHAR(20),[Day],111) = CONVERT(VARCHAR(20),@SourceDate,111) AND  TimesheetId = @OldtimesheetId
																

													END


											       
                  
      
      
										FETCH NEXT FROM copytimesheetforday_Cursor     
										INTO @OldtimesheetId,@ProjectId,@PhaseId,@SubPhaseId     
   
									END     

									CLOSE copytimesheetforday_Cursor;    
									DEALLOCATE copytimesheetforday_Cursor;
								

								SELECT Count(Id) As AffectedRecords  
							FROM 
								[dbo].[Timesheet] WITH (UPDLOCK)
							WHERE EmployeeId = @EmployeeId AND 
								(CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@SourceDate,111))
				   

				  END
                ELSE
				  BEGIN
				  
											INSERT INTO [dbo].[Timesheet]
																		   (
																		    [EmployeeId]
																		   ,[ProjectId]
																		   ,[PhaseId]
																		   ,[SubPhaseId]
																		   ,[Day1]
																		   ,[Day2]
																		   ,[Day3]
																		   ,[Day4]
																		   ,[Day5]
																		   ,[Day6]
																		   ,[Day7]
																		   ,[ODay1]
																		   ,[ODay2]
																		   ,[ODay3]
																		   ,[ODay4]
																		   ,[ODay5]
																		   ,[ODay6]
																		   ,[ODay7]
																		   ,[DDay1]
																		   ,[DDay2]
																		   ,[DDay3]
																		   ,[DDay4]
																		   ,[DDay5]
																		   ,[DDay6]
																		   ,[DDay7]
																		   ,[Billing]
																		   ,[CreatedBy]
																		   ,[CreatedDate]
																		  )
																SELECT
																		@EmployeeId
																		,[ProjectId]
																		,[PhaseId]
																		,[SubPhaseId]
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,0
																		,(CASE WHEN DDay1 IS NOT NULL THEN @DDay1 ELSE DDay1 END)
																		,(CASE WHEN DDay2 IS NOT NULL THEN @DDay2 ELSE DDay2 END)
																		,(CASE WHEN DDay3 IS NOT NULL THEN @DDay3 ELSE DDay3 END)
																		,(CASE WHEN DDay4 IS NOT NULL THEN @DDay4 ELSE DDay4 END)
																		,(CASE WHEN DDay5 IS NOT NULL THEN @DDay5 ELSE DDay5 END)
																		,(CASE WHEN DDay6 IS NOT NULL THEN @DDay6 ELSE DDay6 END)
																		,(CASE WHEN DDay7 IS NOT NULL THEN @DDay7 ELSE DDay7 END)
																		,[Billing]
																		,@CreatedBy
																		,GETDATE()
																FROM [dbo].[Timesheet] WITH (UPDLOCK)
																WHERE EmployeeId = @EmployeeId AND 
																(CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@SourceDate,111))
								
												SELECT Count(Id) As AffectedRecords  
							FROM 
								[dbo].[Timesheet] WITH (UPDLOCK)
							WHERE EmployeeId = @EmployeeId AND 
								(CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
								CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@SourceDate,111))
				  END
                  
 COMMIT 