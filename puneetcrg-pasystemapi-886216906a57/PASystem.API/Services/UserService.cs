using PASystem.API.Configuration;
using PASystem.API.DataAccessLayer;
using PASystem.API.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace PASystem.API.Services
{
  public class UserService
  {
    public Users ValidateUser(string email, string password)
    {
      // Here you can write the code to validate
      // User from database and return accordingly
      // To test we use dummy list here
      var userList = GetUserList();
      var user = userList.FirstOrDefault(x => x.UserName == email && x.PasswordHash == password);
      if (user == null)
      {
        return user;
      }
      else if (user.ReleavingDate != null && user.ReleavingDate < DateTime.Now)
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_UpdateUserStatus]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, user.UserId);
        sp.ExecuteDataSet();
        return null;
      }
      else
      {
        return user;
      }
    }

    public PMSUser ValidateGoogleUser(string username)
    {
      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_GetOAuthDetails]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@UserName", SqlDbType.VarChar, 256, ParameterDirection.Input, username);
        var ds = sp.ExecuteDataSet();
        if (ds.Tables.Count > 0)
        {
          PMSUser user = new PMSUser()
          {
            UserId = ds.Tables[0].Rows[0]["UserId"].ToString(),
            UserName = ds.Tables[0].Rows[0]["UserName"].ToString(),
            Email = ds.Tables[0].Rows[0]["Email"].ToString(),
            UserFullName = ds.Tables[0].Rows[0]["UserFullName"].ToString()
          };
          return user;
        }
        else
        {
          return null;
        }
      }
      catch (Exception ex)
      {
        return null;
      }
    }

    public List<Users> GetUserList()
    {
      // Create the list of user and return   

      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_UsersSelectAll]", ConfigManager.GetNewSqlConnection);
        var ds = sp.ExecuteDataSet();
        var myData = ds.Tables[0].AsEnumerable().Select(r => new Users
        {
          UserName = r.Field<string>("UserName"),
          UserFullName = r.Field<string>("EmployeeFullName"),
          Email = r.Field<string>("Email"),
          PasswordHash = r.Field<string>("PasswordHash"),
          UserId = r.Field<long>("UserId"),
          ReleavingDate = r.Field<DateTime?>("ReleavingDate"),
          UserType = r.Field<string>("UserType")
        });
        var list = myData.ToList();
        return list;
      }
      catch (Exception ex)
      {
        return null;
      }



      return null;

    }
  }
}