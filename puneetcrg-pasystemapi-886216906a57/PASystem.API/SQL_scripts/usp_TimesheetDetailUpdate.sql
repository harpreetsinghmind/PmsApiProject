ALTER PROC [dbo].[usp_TimesheetDetailUpdate]   
	@TimesheetId BIGINT,  
    @Id BIGINT,  
    @Detail NVARCHAR(MAX),  
    @Status INT = NULL,  
    @Day DATETIME,  
    @WeekDay INT,  
	@Hours DECIMAL(10,2),  
	@OHours DECIMAL(10,2),  
	@BillingNote NVARCHAR(255),  
    @CreatedBy NVARCHAR(255) = NULL  
  
      
AS   
 SET NOCOUNT ON   
 SET XACT_ABORT ON    
   
 BEGIN TRAN  
   
 IF EXISTS(SELECT * FROM  Timesheet WHERE Id = @TimesheetId)  
    BEGIN  
  IF EXISTS(SELECT * FROM  TimesheetDetail WHERE Id = @Id)  
  BEGIN  
   UPDATE [dbo].[TimesheetDetail]  
   SET [TimesheetId] = @TimesheetId  
      ,[Day] = @Day  
      ,[WeekDay] = @WeekDay  
      ,[Detail] = @Detail  
      ,[Hours] = @Hours  
      ,[OHours] = @OHours  
      ,[BillingNote] = @BillingNote  
      ,[UpdatedBy] = @CreatedBy  
      ,[UpdatedDate] = GETDATE()  
    WHERE Id = @Id  
     
     
    UPDATE Timesheet   
        SET Day1 = CASE   
           WHEN @WeekDay = 1 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =1)  
           ELSE Day1  
          END,  
         Day2 = CASE   
           WHEN @WeekDay = 2 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =2)  
           ELSE Day2  
          END,  
         Day3 = CASE   
           WHEN @WeekDay = 3 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =3)  
           ELSE Day3  
          END,  
         Day4 = CASE   
           WHEN @WeekDay = 4 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =4)  
           ELSE Day4  
          END,  
         Day5 = CASE   
           WHEN @WeekDay = 5 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =5)  
           ELSE Day5  
          END,  
         Day6 = CASE   
           WHEN @WeekDay = 6 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =6)  
           ELSE Day6  
          END,  
         Day7 = CASE   
           WHEN @WeekDay = 7 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =7)  
           ELSE Day7  
          END  
        WHERE Id = @TimesheetId  
     
    UPDATE Timesheet   
        SET ODay1 = CASE   
           WHEN @WeekDay = 1 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =1)  
           ELSE ODay1  
          END,  
         ODay2 = CASE   
           WHEN @WeekDay = 2 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =2)  
           ELSE ODay2  
          END,  
         ODay3 = CASE   
           WHEN @WeekDay = 3 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =3)  
           ELSE ODay3  
          END,  
         ODay4 = CASE   
           WHEN @WeekDay = 4 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =4)  
           ELSE ODay4  
          END,  
         ODay5 = CASE   
           WHEN @WeekDay = 5 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =5)  
           ELSE ODay5  
          END,  
         ODay6 = CASE   
           WHEN @WeekDay = 6 THEN (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =6)  
           ELSE ODay6  
          END,  
         ODay7 = CASE   
           WHEN @WeekDay = 7 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay =7)  
           ELSE ODay7  
          END  
        WHERE Id = @TimesheetId  
     
   -- Begin Return Select <- do not remove  
   SELECT @Id   
  END  
  ELSE  
  BEGIN  
   INSERT INTO [dbo].[TimesheetDetail]  
       ([TimesheetId]  
       ,[Day]  
       ,[WeekDay]  
       ,[Detail]  
       ,[Hours]  
       ,[OHours]  
       ,[BillingNote]  
       ,[CreatedBy]  
       ,[CreatedDate])  
    VALUES  
     (@TimesheetId  
       ,@Day  
       ,@WeekDay  
       ,@Detail  
       ,@Hours  
       ,@OHours  
       ,@BillingNote  
       ,@CreatedBy  
       ,GETDATE())  
          SELECT SCOPE_IDENTITY()   
     
     
     
    UPDATE Timesheet   
        SET Day1 = CASE   
           WHEN @WeekDay = 1 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=1)  
           ELSE Day1  
          END,  
         Day2 = CASE   
           WHEN @WeekDay = 2 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=2)  
           ELSE Day2  
          END,  
         Day3 = CASE   
           WHEN @WeekDay = 3 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=3)  
           ELSE Day3  
          END,  
         Day4 = CASE   
           WHEN @WeekDay = 4 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=4)  
           ELSE Day4  
          END,  
         Day5 = CASE   
           WHEN @WeekDay = 5 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=5)  
           ELSE Day5  
          END,  
         Day6 = CASE   
           WHEN @WeekDay = 6 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=6)  
           ELSE Day6  
          END,  
         Day7 = CASE   
           WHEN @WeekDay = 7 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=7)  
           ELSE Day7  
          END  
        WHERE Id = @TimesheetId  
     
    UPDATE Timesheet   
        SET ODay1 = CASE   
           WHEN @WeekDay = 1 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=1)  
           ELSE ODay1  
          END,  
         ODay2 = CASE   
           WHEN @WeekDay = 2 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=2)  
           ELSE ODay2  
          END,  
         ODay3 = CASE   
           WHEN @WeekDay = 3 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=3)  
           ELSE ODay3  
          END,  
         ODay4 = CASE   
           WHEN @WeekDay = 4 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=4)  
           ELSE ODay4  
          END,  
         ODay5 = CASE   
           WHEN @WeekDay = 5 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=5)  
           ELSE ODay5  
          END,  
         ODay6 = CASE   
           WHEN @WeekDay = 6 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=6)  
           ELSE ODay6  
          END,  
         ODay7 = CASE   
           WHEN @WeekDay = 7 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay=7)  
           ELSE ODay7  
          END  
        WHERE Id = @TimesheetId  
     
  END  
 END  
 ELSE  
 BEGIN  
  SELECT -1  
 END  
 -- End Return Select <- do not remove  
                 
 COMMIT  