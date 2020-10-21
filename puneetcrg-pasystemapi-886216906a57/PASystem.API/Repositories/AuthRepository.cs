using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using PASystem.API.Entity;
using PASystem.API.Models;
using System.Data.Entity;
using PASystem.API.Services;
using PASystem.API.Providers;
using PASystem.API;
using Microsoft.Owin.Security.OAuth;
using PASystem.API.DataAccessLayer;
using System.Data;
using PASystem.API.Configuration;
using Microsoft.Owin.Security;
using System.Data.SqlClient;

namespace PASystem.API.Repositories
{
  public class AuthRepository
  {
    //private UserDBContext _ctx;


    //public static UserManager<ApplicationUser> _userManager;
    Microsoft.Owin.Security.DataProtection.DpapiDataProtectionProvider provider = new Microsoft.Owin.Security.DataProtection.DpapiDataProtectionProvider("PASystem.API");

    public AuthRepository()
    {

      //var userStore = new UserStore<IdentityUser>();
      //var manager = new UserManager<IdentityUser>(userStore);
      var _ctx = HttpContext.Current.Request.GetOwinContext();
      //_userManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(_ctx));
      //_userManager.UserTokenProvider = TokenProvider.Provider;
      //_userManager.UserTokenProvider = new Microsoft.AspNet.Identity.Owin.DataProtectorTokenProvider<ApplicationUser>(provider.Create("ResetPassword"));

    }


    public Int64 RegisterUser(CreateUserBindingModel cModel)
    {
      //var result = new IdentityResult();
      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_UsersInsert]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@Email", SqlDbType.NVarChar, 256, ParameterDirection.Input, cModel.Email);
        sp.AddParameterWithValue("@UserName", SqlDbType.NVarChar, 50, ParameterDirection.Input, cModel.UserName);
        sp.AddParameterWithValue("@PasswordHash", SqlDbType.NVarChar, 0, ParameterDirection.Input, cModel.Password);
        sp.AddParameterWithValue("@SecurityStamp", SqlDbType.NVarChar, 0, ParameterDirection.Input, "");
        sp.AddParameterWithValue("@EmailConfirmed", SqlDbType.Bit, 0, ParameterDirection.Input, true);
        sp.AddParameterWithValue("@InActive", SqlDbType.Bit, 0, ParameterDirection.Input, false);
        sp.AddParameterWithValue("@CreatedDate", SqlDbType.DateTime, 0, ParameterDirection.Input, DateTime.Now);
        sp.AddParameterWithValue("@CreatedBy", SqlDbType.NVarChar, 255, ParameterDirection.Input, "");
        //sp.AddParameterWithValue("@Notes", SqlDbType.NVarChar, 0, ParameterDirection.Input, cModel.Notes);
        return Convert.ToInt32(sp.ExecuteScalar());

      }
      catch (Exception ex)
      {
        return 0;
      }

      //return result;
    }


   
    public DataSet GetAllUsersByRole(Int64 Id)
    {

      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_UsersGetAllByRole]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@RoleId", SqlDbType.BigInt, 0, ParameterDirection.Input, Id);
        return sp.ExecuteDataSet();
      }
      catch (Exception ex)
      {
        return null;
      }

    }

  
    public DataSet VerifyToken(string token)
    {
      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_VerifyToken]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@Token", SqlDbType.NVarChar, 0, ParameterDirection.Input, token);
        return sp.ExecuteDataSet();

      }
      catch (Exception ex)
      {
        return null;
      }
    }

  

    public Int64 UnAssignUserRole(Int64 Id)
    {
      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_UserRolesDelete]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@UserRoleId", SqlDbType.BigInt, 0, ParameterDirection.Input, Id);
        sp.ExecuteNonQuery();
        return 1;

      }
      catch (Exception ex)
      {
        SqlException myException = (SqlException)ex.InnerException;

        if (myException.Number == 547)
          return 547;
        else
          return 0;
      }
    }

    public DataSet GetUserRolesCount(Int64 Id)
    {
      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_UserRolesCount]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@RoleId", SqlDbType.BigInt, 0, ParameterDirection.Input, Id);
        return sp.ExecuteDataSet();
      }
      catch
      {
        return null;
      }
    }

    public string GenerateForgotPassword(string email)
    {
      string token = string.Empty;
      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_GenerateForgotPasswordToken]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@Email", SqlDbType.NVarChar, 256, ParameterDirection.Input, email);
        token = Convert.ToString(sp.ExecuteScalar());
      }
      catch (Exception)
      {
      }
      return token;
    }
    
    public DataSet GetAllRolesByUserId(Int64 Id)
    {

      try
      {
        SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[usp_GetAllRolesByUserId]", ConfigManager.GetNewSqlConnection);
        sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, Id);
        return sp.ExecuteDataSet();
      }
      catch (Exception ex)
      {
        return null;
      }

    }
  

        //public Int64 Register(CreateUserBindingModel cModel)
        //{
        //    var userStore = new UserStore<IdentityUser>();
        //    var manager = new UserManager<IdentityUser>(userStore);
        //    var user = new IdentityUser() { UserName = cModel.UserName};

        //    IdentityResult result = manager.Create(user, cModel.Password);

        //    if (result.Succeeded)
        //    {
        //        var authenticationManager = HttpContext.Current.GetOwinContext().Authentication;
        //        var userIdentity = manager.CreateIdentity(user, DefaultAuthenticationTypes.ApplicationCookie);
        //        authenticationManager.SignIn(new AuthenticationProperties() { }, userIdentity);
        //        //Response.Redirect("~/Login.aspx");
        //    }
        //    else
        //    {
        //        StatusMessage.Text = result.Errors.FirstOrDefault();
        //    }

        //}


        //-----------------------Analytics

        public DataSet Getexpansedetail()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exGetexpansedetail]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet Getunsubmittedexpanse()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exGetunsubmittedexpanse]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet Getcategoryexpanse()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exGetcategoryexpanse]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }


        public DataSet getuserwiseexpanse()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetuserwiseexpanse]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet getmilegeexpanse()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetmilegeexpanse]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet getpolicyviolation()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetpolicyviolation]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }



        public DataSet getcustomerexpanse()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetcustomerexpanse]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }


        public DataSet getprojectexpanse()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetprojectexpanse]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }





    }
}
