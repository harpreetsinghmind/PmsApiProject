CREATE PROC [dbo].[usp_TimesheetDetailsCopyforDate] -- exec [usp_TimesheetDetailsCopyforDate] '08/20/2019 00:00:00','09/03/2019 00:00:00',10081,'admin',1202164
    @SourceDate DATETIME,  
    @DestinationDate DATETIME,  
    @EmployeeId BIGINT,  
    @CreatedBy NVARCHAR(MAX) = NULL,  
	@timesheetId BIGINT 
AS   
 SET NOCOUNT ON   
 SET XACT_ABORT ON    
   
 BEGIN TRAN  

                           DECLARE @totalhours DECIMAL, @day INT     

						   SET @day = (CASE WHEN DATEPART(dw,@DestinationDate) = 1 THEN 7 ELSE (DATEPART(dw,@DestinationDate)-1) END) 

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
																	,@timesheetId  
																FROM  
																 [dbo].[TimesheetDetail] WITH (UPDLOCK)  
																WHERE CONVERT(VARCHAR(20),[Day],111) = CONVERT(VARCHAR(20),@SourceDate,111) AND  
																 TimesheetId IN (SELECT TimesheetId FROM [Timesheet]   
																				  WHERE EmployeeId = @EmployeeId AND  
																	   (CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																	   CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																	   CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																	   CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																	   CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																	   CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
																	   CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@SourceDate,111))  
																	 )  
  
                  
      
								SET @totalhours = ISNULL((SELECT SUM(Hours) FROM [TimesheetDetail] where TimesheetId = @timesheetId AND  WeekDay = @day),0)  
      
      
								UPDATE [Timesheet] SET  Day1 = (CASE WHEN @day = 1 THEN @totalhours ELSE Day1 END),  
									  Day2 = (CASE WHEN @day = 2 THEN @totalhours ELSE Day2 END),  
									  Day3 = (CASE WHEN @day = 3 THEN @totalhours ELSE Day3 END),  
									  Day4 = (CASE WHEN @day = 4 THEN @totalhours ELSE Day4 END),  
									  Day5 = (CASE WHEN @day = 5 THEN @totalhours ELSE Day5 END),  
									  Day6 = (CASE WHEN @day = 6 THEN @totalhours ELSE Day6 END),  
									  Day7 = (CASE WHEN @day = 7 THEN @totalhours ELSE Day7 END)  
								WHERE Id = @timesheetId  
              
                 
								  SELECT   
									 Count(Id) As AffectedRecords  
								  FROM  
								   [dbo].[TimesheetDetail] WITH (UPDLOCK)  
								  WHERE CONVERT(VARCHAR(20),[Day],111) = CONVERT(VARCHAR(20),@SourceDate,111) AND  
								TimesheetId IN (SELECT TimesheetId FROM [Timesheet]   
									 WHERE EmployeeId = @EmployeeId AND  
									 (CONVERT(VARCHAR(20),[DDay1],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
									 CONVERT(VARCHAR(20),[DDay2],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
									 CONVERT(VARCHAR(20),[DDay3],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
									 CONVERT(VARCHAR(20),[DDay4],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
									 CONVERT(VARCHAR(20),[DDay5],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
									 CONVERT(VARCHAR(20),[DDay6],111) = CONVERT(VARCHAR(20),@SourceDate,111) OR   
									 CONVERT(VARCHAR(20),[DDay7],111) = CONVERT(VARCHAR(20),@SourceDate,111))  
									)  

				  
                  
 COMMIT 


  


  