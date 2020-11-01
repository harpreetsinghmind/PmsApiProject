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

        public DataSet Getexpansedetail(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exGetexpansedetail]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Reportid", SqlDbType.Int, 0, ParameterDirection.Input, reportid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet Getunsubmittedexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exGetunsubmittedexpanse]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Reportid", SqlDbType.Int, 0, ParameterDirection.Input, reportid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet Getcategoryexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exGetcategoryexpanse]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Reportid", SqlDbType.Int, 0, ParameterDirection.Input, reportid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }


        public DataSet getuserwiseexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetuserwiseexpanse]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Reportid", SqlDbType.Int, 0, ParameterDirection.Input, reportid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet getmilegeexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetmilegeexpanse]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Reportid", SqlDbType.Int, 0, ParameterDirection.Input, reportid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet getpolicyviolation(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetpolicyviolation]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Reportid", SqlDbType.Int, 0, ParameterDirection.Input, reportid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }



        public DataSet getcustomerexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exgetcustomerexpanse]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Reportid", SqlDbType.Int, 0, ParameterDirection.Input, reportid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
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
        public DataSet getexrptresourceallocation(long UserId, long ProjectId, long customerid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exrptresourceallocation]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@ProjectId", SqlDbType.BigInt, 0, ParameterDirection.Input, ProjectId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getprojectleaveplannerreport(long UserId, long ProjectId, long customerid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[projectleaveplannerreport]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@ProjectId", SqlDbType.BigInt, 0, ParameterDirection.Input, ProjectId);
                sp.AddParameterWithValue("@Customerid", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getoverduetask(long UserId, long ProjectId, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[overduetask]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@ProjectId", SqlDbType.BigInt, 0, ParameterDirection.Input, ProjectId);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getplannedvsactual(long UserId, long customerid, DateTime fromdate, DateTime todate, int status)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[plannedvsactual]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@CustomerId", SqlDbType.BigInt, 0, ParameterDirection.Input, customerid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                sp.AddParameterWithValue("@Status", SqlDbType.DateTime, 0, ParameterDirection.Input, status);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getexrptresourceworkdetail(long UserId, long ProjectId, long employeeid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[exrptresourceworkdetail]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, UserId);
                sp.AddParameterWithValue("@ProjectId", SqlDbType.BigInt, 0, ParameterDirection.Input, ProjectId);
                sp.AddParameterWithValue("@Employeeid", SqlDbType.BigInt, 0, ParameterDirection.Input, employeeid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getprojectprofitablity(long Userid, long projectid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[projectprofitablity]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, Userid);
                sp.AddParameterWithValue("@ProjectId", SqlDbType.BigInt, 0, ParameterDirection.Input, projectid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getmomreport(long Userid, long projectid, DateTime fromdate, DateTime todate)
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[momreport]", ConfigManager.GetNewSqlConnection);
                sp.AddParameterWithValue("@UserId", SqlDbType.BigInt, 0, ParameterDirection.Input, Userid);
                sp.AddParameterWithValue("@ProjectId", SqlDbType.BigInt, 0, ParameterDirection.Input, projectid);
                sp.AddParameterWithValue("@Fromdate", SqlDbType.DateTime, 0, ParameterDirection.Input, fromdate);
                sp.AddParameterWithValue("@Todate", SqlDbType.DateTime, 0, ParameterDirection.Input, todate);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getchangerequest()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[changerequest]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getresourceeffciency()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[resourceeffciency]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getresourceutilization()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[resourceutilization]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getrollback()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[getrollback]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet getwbsandcbs()
        {

            try
            {
                SqlStoredProcedure sp = new SqlStoredProcedure("[dbo].[getwbsandcbs]", ConfigManager.GetNewSqlConnection);
                return sp.ExecuteDataSet();
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public object getprojectdashboard(long projectid)
        {
            responseData objData = new responseData();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigManager.GetNewSqlConnection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        DataSet ds = new DataSet();
                        DataTable dt = new DataTable();
                        DataTable dt1 = new DataTable();
                        DataTable dt2 = new DataTable();
                        DataTable dt3 = new DataTable();
                        List<teamall> Team = new List<teamall>();
                        List<teamall> Team2 = new List<teamall>();
                        teamall t = new teamall();
                        billableall billable = new billableall();
                        costbreakdownall costbreakdown = new costbreakdownall();
                        healthcardall healthcard = new healthcardall();
                        cmd.CommandText = "getProjectDashboard";
                        cmd.Connection = conn;
                        cmd.Parameters.AddWithValue("@projectid", projectid);
                        cmd.CommandType = CommandType.StoredProcedure;
                        conn.Open();

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.Fill(ds);
                        healthcard.min = "1";
                        healthcard.max = "100";
                        healthcard.value = "25";
                        if (ds.Tables.Count > 0)
                        {
                            dt = ds.Tables[0];
                            dt1 = ds.Tables[1];
                            dt2 = ds.Tables[2];
                            dt3 = ds.Tables[3];
                        }
                        int teamcount = dt1.Rows.Count > 5 ? 5 : dt1.Rows.Count;
                        for (int i = 0; i < teamcount; i++)
                        {

                            t.name = Convert.ToString(dt1.Rows[i]["name"]);
                            t.occupied = Convert.ToString(dt1.Rows[i]["occupied"]);
                            Team.Add(t);
                        }
                        for (int i = teamcount + 1; i < dt1.Rows.Count; i++)
                        {

                            t.name = Convert.ToString(dt1.Rows[i]["name"]);
                            t.occupied = Convert.ToString(dt1.Rows[i]["occupied"]);
                            Team2.Add(t);
                        }
                        if (dt2.Rows.Count > 0)
                        {
                            billable.billedhours = Convert.ToString(dt2.Rows[0]["Billablehours"]);
                            billable.nonbilledhours = Convert.ToString(dt2.Rows[0]["nonbillablehours"]);
                        }
                        if (dt3.Rows.Count > 0)
                        {
                            costbreakdown.budget = Convert.ToString(dt3.Rows[0]["Budgetcot"]);
                            costbreakdown.actual = Convert.ToString(dt3.Rows[0]["Actualcost"]);
                        }
                        if (dt.Rows.Count > 0)
                        {
                            objData.Projectid = Convert.ToString(dt.Rows[0]["Projectid"]);
                            objData.ProjectName = Convert.ToString(dt.Rows[0]["ProjectName"]);
                            objData.Plannedstartdate = dt.Rows[0]["Plannedstartdate"] == null ? "" : Convert.ToString(dt.Rows[0]["Plannedstartdate"]);
                            objData.Plannedenddate = Convert.ToString(dt.Rows[0]["Plannedenddate"]);
                            objData.Actualstartdate = dt.Rows[0]["Actualstartdate"] == null ? "" : Convert.ToString(dt.Rows[0]["Actualstartdate"]);
                            objData.Actualenddate = dt.Rows[0]["Actualenddate"] == null ? "" : Convert.ToString(dt.Rows[0]["Actualenddate"]);
                            objData.projectage = dt.Rows[0]["projectage"] == null ? "0" : Convert.ToString(dt.Rows[0]["projectage"]);
                            objData.completionper = dt.Rows[0]["completionper"] == null ? "" : Convert.ToString(dt.Rows[0]["completionper"]);
                            objData.variance = dt.Rows[0]["variance"] == null ? "" : Convert.ToString(dt.Rows[0]["variance"]);
                            objData.projectmanagername = dt.Rows[0]["projectmanagername"] == null ? "" : Convert.ToString(dt.Rows[0]["projectmanagername"]);
                            objData.Projectmanagermobuleno = dt.Rows[0]["Projectmanagermobuleno"] == null ? "" : Convert.ToString(dt.Rows[0]["Projectmanagermobuleno"]);
                            objData.projectmanageremailid = dt.Rows[0]["Projectmanagermobuleno"] == null ? "" : Convert.ToString(dt.Rows[0]["projectmanageremailid"]);
                            objData.Plannedphase = dt.Rows[0]["Plannedphase"] == null ? "" : Convert.ToString(dt.Rows[0]["Plannedphase"]);
                            objData.Plannedsubphase = dt.Rows[0]["Plannedsubphase"] == null ? "" : Convert.ToString(dt.Rows[0]["Plannedsubphase"]);
                            objData.PLannedtask = dt.Rows[0]["PLannedtask"] == null ? "" : Convert.ToString(dt.Rows[0]["PLannedtask"]);

                            objData.Plannedsubtask = dt.Rows[0]["Plannedsubtask"] == null ? "" : Convert.ToString(dt.Rows[0]["Plannedsubtask"]);
                            objData.Notstartedphase = dt.Rows[0]["Notstartedphase"] == null ? "" : Convert.ToString(dt.Rows[0]["Notstartedphase"]);
                            objData.Nonstartedsubphase = dt.Rows[0]["Nonstartedsubphase"] == null ? "" : Convert.ToString(dt.Rows[0]["Nonstartedsubphase"]);
                            objData.Nonstartedtask = dt.Rows[0]["Nonstartedtask"] == null ? "" : Convert.ToString(dt.Rows[0]["Nonstartedtask"]);
                            objData.Nonstartedsubtask = dt.Rows[0]["Nonstartedsubtask"] == null ? "" : Convert.ToString(dt.Rows[0]["Nonstartedsubtask"]);
                            objData.inprogressphase = dt.Rows[0]["inprogressphase"] == null ? "" : Convert.ToString(dt.Rows[0]["inprogressphase"]);
                            objData.inprogresssubphase = dt.Rows[0]["inprogresssubphase"] == null ? "" : Convert.ToString(dt.Rows[0]["inprogresssubphase"]);
                            objData.inprogresstask = dt.Rows[0]["inprogresssubphase"] == null ? "" : Convert.ToString(dt.Rows[0]["inprogresstask"]);
                            objData.inprogresssubtask = dt.Rows[0]["inprogresssubtask"] == null ? "" : Convert.ToString(dt.Rows[0]["inprogresssubtask"]);
                            objData.completedphase = dt.Rows[0]["completedphase"] == null ? "" : Convert.ToString(dt.Rows[0]["completedphase"]);
                            objData.completedsubphase = dt.Rows[0]["completedsubphase"] == null ? "" : Convert.ToString(dt.Rows[0]["completedsubphase"]);
                            objData.completedtask = dt.Rows[0]["completedtask"] == null ? "" : Convert.ToString(dt.Rows[0]["completedtask"]);
                            objData.copletedsubtask = dt.Rows[0]["copletedsubtask"] == null ? "" : Convert.ToString(dt.Rows[0]["copletedsubtask"]);
                            objData.Totalchangerequest = dt.Rows[0]["Totalchangerequest"] == null ? "" : Convert.ToString(dt.Rows[0]["Totalchangerequest"]);
                            objData.waitingapproval = dt.Rows[0]["waitingapproval"] == null ? "" : Convert.ToString(dt.Rows[0]["waitingapproval"]);
                            objData.completedchangerequest = dt.Rows[0]["completedchangerequest"] == null ? "" : Convert.ToString(dt.Rows[0]["completedchangerequest"]);
                            objData.Avgtattillapproval = dt.Rows[0]["Avgtattillapproval"] == null ? "" : Convert.ToString(dt.Rows[0]["Avgtattillapproval"]);
                            objData.avgtattillcompleted = dt.Rows[0]["avgtattillcompleted"] == null ? "" : Convert.ToString(dt.Rows[0]["avgtattillcompleted"]);
                            objData.totalmom = dt.Rows[0]["inprogressmom"] == null ? "" : Convert.ToString(dt.Rows[0]["inprogressmom"]);
                            objData.inprogressmom = dt.Rows[0]["inprogressmom"] == null ? "" : Convert.ToString(dt.Rows[0]["inprogressmom"]);
                            objData.completedmomm = dt.Rows[0]["completedmomm"] == null ? "" : Convert.ToString(dt.Rows[0]["completedmomm"]);
                            objData.cancelledmom = dt.Rows[0]["cancelledmom"] == null ? "" : Convert.ToString(dt.Rows[0]["cancelledmom"]);
                            objData.Highprioritytask = dt.Rows[0]["Highprioritytask"] == null ? "" : Convert.ToString(dt.Rows[0]["Highprioritytask"]);
                            objData.mediumpriority = dt.Rows[0]["mediumpriority"] == null ? "" : Convert.ToString(dt.Rows[0]["mediumpriority"]);
                            objData.lowpriority = dt.Rows[0]["lowpriority"] == null ? "" : Convert.ToString(dt.Rows[0]["lowpriority"]);
                            objData.Roadblock = dt.Rows[0]["Roadblock"] == null ? "" : Convert.ToString(dt.Rows[0]["Roadblock"]);
                            objData.roadbockbyclientnotinitiated = dt.Rows[0]["roadbockbyclientnotinitiated"] == null ? "" : Convert.ToString(dt.Rows[0]["roadbockbyclientnotinitiated"]);
                            objData.roadbockbyclientinprogress = dt.Rows[0]["roadbockbyclientinprogress"] == null ? "" : Convert.ToString(dt.Rows[0]["roadbockbyclientinprogress"]);
                            objData.roadbockbyclientnotclosed = dt.Rows[0]["roadbockbyclientnotclosed"] == null ? "" : Convert.ToString(dt.Rows[0]["roadbockbyclientnotclosed"]);
                            objData.avgtimebyclient = dt.Rows[0]["roadbockbyclientnotclosed"] == null ? "" : Convert.ToString(dt.Rows[0]["avgtimebyclient"]);
                            objData.roadbockbyservicenotinitiated = dt.Rows[0]["roadbockbyservicenotinitiated"] == null ? "" : Convert.ToString(dt.Rows[0]["roadbockbyservicenotinitiated"]);
                            objData.roadbockbyserviceinprogress1 = dt.Rows[0]["roadbockbyserviceinprogress1"] == null ? "" : Convert.ToString(dt.Rows[0]["roadbockbyserviceinprogress1"]);
                            objData.roadbockbyservicenotclosed1 = dt.Rows[0]["roadbockbyservicenotclosed1"] == null ? "" : Convert.ToString(dt.Rows[0]["roadbockbyservicenotclosed1"]);
                            objData.avgtimebyservice = dt.Rows[0]["avgtimebyservice"] == null ? "" : Convert.ToString(dt.Rows[0]["avgtimebyservice"]);
                            objData.Team = Team;
                            objData.Team2 = Team2;
                            objData.billable = billable;
                            objData.healthcard = healthcard;
                            objData.costbreakdown = costbreakdown;
                        }
                        return objData;
                    }
                }
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public object getexpense(long userid)
        {
            expense objData = new expense();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigManager.GetNewSqlConnection.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        DataSet ds = new DataSet();
                        DataTable dt = new DataTable();
                        DataTable dt1 = new DataTable();
                        DataTable dt2 = new DataTable();
                        DataTable dt3 = new DataTable();
                        List<exoansechart> exoansechart = new List<exoansechart>();
                        List<Report> Report = new List<Report>();
                        exoansechart t;
                        Report r ;
                        cmd.CommandText = "getexpense";
                        cmd.Connection = conn;
                        cmd.Parameters.AddWithValue("@userid", userid);
                        cmd.CommandType = CommandType.StoredProcedure;
                        conn.Open();

                        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                        adapter.Fill(ds);
                        if (ds.Tables.Count > 0)
                        {
                            dt = ds.Tables[0];
                            dt1 = ds.Tables[1];
                            dt2 = ds.Tables[2];
                            dt3 = ds.Tables[3];
                        }
                        string piechart = "[";
                        for (int i = 0; i < dt1.Rows.Count; i++)
                        {
                            piechart = piechart + "{";
                            if (i < dt1.Rows.Count-1)
                                piechart = piechart + ("\""+ dt1.Rows[i]["CategoryName"].ToString() + "\":") + dt1.Rows[i]["Total"].ToString() + "},";
                            else
                                piechart = piechart + ("\"" + dt1.Rows[i]["CategoryName"].ToString() + "\":") + dt1.Rows[i]["Total"].ToString() + "}";
                        }
                        piechart = piechart + "]";
                        for (int i = 0; i < dt2.Rows.Count; i++)
                        {
                            t = new exoansechart();
                            t.month = Convert.ToString(dt2.Rows[i]["month"]);
                            t.submitted = Convert.ToString(dt2.Rows[i]["submitted"]);
                            t.approved = Convert.ToInt64(dt2.Rows[i]["approved"]);
                            exoansechart.Add(t);
                        }
                        for (int i = 0; i < dt3.Rows.Count; i++)
                        {
                            r = new Report();
                            r.monthyear = Convert.ToString(dt3.Rows[i]["month"]);
                            r.reportname = Convert.ToString(dt3.Rows[i]["reportTitle"]);
                            r.Amount = Convert.ToString(dt3.Rows[i]["Amount"]);
                            r.status = Convert.ToString(dt3.Rows[i]["status"]);
                            Report.Add(r);
                        }
                        if (dt.Rows.Count > 0)
                        {
                            objData.TotalExNo = Convert.ToString(dt.Rows[0]["TotalExNo"]);
                            objData.TotalExAmount = Convert.ToString(dt.Rows[0]["TotalExAmount"]);
                            objData.ReimNo = dt.Rows[0]["ReimNo"] == null ? "0" : Convert.ToString(dt.Rows[0]["ReimNo"]);
                            objData.Reimamount = Convert.ToString(dt.Rows[0]["Reimamount"]);
                            objData.NoofCustomer = dt.Rows[0]["NoofCustomer"] == null ? "0" : Convert.ToString(dt.Rows[0]["NoofCustomer"]);
                            objData.NoofProject = dt.Rows[0]["NoofProject"] == null ? "0" : Convert.ToString(dt.Rows[0]["NoofProject"]);
                            objData.Internalex = dt.Rows[0]["Internalex"] == null ? "0" : Convert.ToString(dt.Rows[0]["Internalex"]);
                            objData.Externalex = dt.Rows[0]["Externalex"] == null ? "" : Convert.ToString(dt.Rows[0]["Externalex"]);
                            objData.Approvependingno = dt.Rows[0]["Approvependingno"] == null ? "0" : Convert.ToString(dt.Rows[0]["Approvependingno"]);
                            objData.Approvependingamount = dt.Rows[0]["Approvependingamount"] == null ? "0" : Convert.ToString(dt.Rows[0]["Approvependingamount"]);
                            objData.unsumbitno = dt.Rows[0]["unsumbitno"] == null ? "0" : Convert.ToString(dt.Rows[0]["unsumbitno"]);
                            objData.unsubmitamount = dt.Rows[0]["unsubmitamount"] == null ? "0" : Convert.ToString(dt.Rows[0]["unsubmitamount"]);
                            objData.rejectedno = dt.Rows[0]["rejectedno"] == null ? "" : Convert.ToString(dt.Rows[0]["rejectedno"]);
                            objData.rejectamount = dt.Rows[0]["rejectamount"] == null ? "0" : Convert.ToString(dt.Rows[0]["rejectamount"]);
                            objData.piechart = piechart;
                            objData.exoansechart = exoansechart;
                            objData.Report = Report;
                        }
                        return objData;
                    }
                }
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public class responseData
        {
            public string Projectid { get; set; }
            public string ProjectName { get; set; }
            public string Plannedstartdate { get; set; }
            public string Plannedenddate { get; set; }
            public string Actualstartdate { get; set; }
            public string Actualenddate { get; set; }
            public string projectage { get; set; }
            public string completionper { get; set; }
            public string variance { get; set; }
            public string projectmanagername { get; set; }
            public string Projectmanagermobuleno { get; set; }
            public string projectmanageremailid { get; set; }
            public string Plannedphase { get; set; }
            public string Plannedsubphase { get; set; }
            public string PLannedtask { get; set; }

            public string Plannedsubtask { get; set; }
            public string Notstartedphase { get; set; }
            public string Nonstartedsubphase { get; set; }
            public string Nonstartedtask { get; set; }
            public string Nonstartedsubtask { get; set; }
            public string inprogressphase { get; set; }
            public string inprogresssubphase { get; set; }
            public string inprogresstask { get; set; }
            public string inprogresssubtask { get; set; }
            public string completedphase { get; set; }
            public string completedsubphase { get; set; }
            public string completedtask { get; set; }
            public string copletedsubtask { get; set; }
            public string Totalchangerequest { get; set; }
            public string waitingapproval { get; set; }
            public string completedchangerequest { get; set; }
            public string Avgtattillapproval { get; set; }
            public string avgtattillcompleted { get; set; }
            public string totalmom { get; set; }
            public string inprogressmom { get; set; }
            public string completedmomm { get; set; }
            public string cancelledmom { get; set; }
            public string Highprioritytask { get; set; }
            public string mediumpriority { get; set; }
            public string lowpriority { get; set; }
            public string Roadblock { get; set; }
            public string roadbockbyclientnotinitiated { get; set; }
            public string roadbockbyclientinprogress { get; set; }
            public string roadbockbyclientnotclosed { get; set; }
            public string avgtimebyclient { get; set; }
            public string roadbockbyservicenotinitiated { get; set; }
            public string roadbockbyserviceinprogress1 { get; set; }
            public string roadbockbyservicenotclosed1 { get; set; }
            public string avgtimebyservice { get; set; }
            public List<teamall> Team { get; set; }
            public List<teamall> Team2 { get; set; }
            public billableall billable { get; set; }
            public healthcardall healthcard { get; set; }
            public costbreakdownall costbreakdown { get; set; }

        }
        public class teamall
        {
            public string name { get; set; }
            public string occupied { get; set; }
        }
        public class billableall
        {
            public string billedhours { get; set; }
            public string nonbilledhours { get; set; }
        }
        public class healthcardall
        {
            public string min { get; set; }
            public string max { get; set; }
            public string value { get; set; }
        }
        public class costbreakdownall
        {
            public string budget { get; set; }
            public string actual { get; set; }
        }

        public class expense
        {
            public string TotalExNo { get; set; }
            public string TotalExAmount { get; set; }
            public string ReimNo { get; set; }
            public string Reimamount { get; set; }
            public string NoofCustomer { get; set; }
            public string NoofProject { get; set; }
            public string Internalex { get; set; }
            public string Externalex { get; set; }
            public string Approvependingno { get; set; }
            public string Approvependingamount { get; set; }
            public string unsumbitno { get; set; }
            public string unsubmitamount { get; set; }
            public string rejectedno { get; set; }
            public string rejectamount { get; set; }
            public object piechart { get; set; }
            public List<exoansechart> exoansechart { get; set; }
            public List<Report> Report { get; set; }

        }
        public class exoansechart
        {
            public string month { get; set; }
            public string submitted { get; set; }
            public Int64 approved { get; set; }
        }
        public class Report
        {
            public string monthyear { get; set; }
            public string reportname { get; set; }
            public string Amount { get; set; }
            public string status { get; set; }
        }
    }
}
