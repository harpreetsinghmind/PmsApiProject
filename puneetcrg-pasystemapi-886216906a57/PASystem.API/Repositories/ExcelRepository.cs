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
using System.Data.SqlClient;

namespace PASystem.API.Repositories
{
    public class ExcelRepository
    {
        //private UserDBContext _ctx;


        //public static UserManager<ApplicationUser> _userManager;
        Microsoft.Owin.Security.DataProtection.DpapiDataProtectionProvider provider = new Microsoft.Owin.Security.DataProtection.DpapiDataProtectionProvider("PASystem.API");

        public ExcelRepository()
        {

            //var userStore = new UserStore<IdentityUser>();
            //var manager = new UserManager<IdentityUser>(userStore);
            var _ctx = HttpContext.Current.Request.GetOwinContext();
            //_userManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(_ctx));
            //_userManager.UserTokenProvider = TokenProvider.Provider;
            //_userManager.UserTokenProvider = new Microsoft.AspNet.Identity.Owin.DataProtectorTokenProvider<ApplicationUser>(provider.Create("ResetPassword"));

        }


        public Int64 saveholidays(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[saveHoliday]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }
        public Int64 saveAdvancePayment(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[saveAdvancePayment]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }
        public Int64 saveApproved(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[saveApproved]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }

        public Int64 savebusinesslist(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[savebusinesslist]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }

        public Int64 savecategory(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[savecategory]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }

        public Int64 savecustomer(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[savecustomer]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }

        public Int64 saveprojectphase(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[saveprojectphase]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }

        public Int64 savesales(long cmpcode)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[savesales]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                return Convert.ToInt32(sp.ExecuteScalar());

            }
            catch (Exception ex)
            {
                return 0;
            }

            //return result;
        }
    }
}
