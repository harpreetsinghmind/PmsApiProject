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


        public Int64 saveholidays(string holiday,DateTime holidaydate,string holidayday,long cmpcode,string location)
        {
            //var result = new IdentityResult();
            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[saveHoliday]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@HolidayName", SqlDbType.NVarChar, 256, ParameterDirection.Input, holiday);
                sp.AddParameterWithValue("@HolidayDate", SqlDbType.Date, 50, ParameterDirection.Input, holidaydate);
                sp.AddParameterWithValue("@CmpCode", SqlDbType.BigInt, 0, ParameterDirection.Input, cmpcode);
                sp.AddParameterWithValue("@Locations", SqlDbType.NVarChar, 50, ParameterDirection.Input, location);
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
