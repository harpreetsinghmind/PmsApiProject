using System;
using System.Collections.Generic;
using System.Configuration;
using System.IdentityModel.Claims;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using PASystem.API.Email;
using PASystem.API.Models;
using PASystem.API.Repositories;
using PASystem.API.Results;
using AllowAnonymousAttribute = System.Web.Http.AllowAnonymousAttribute;
using AuthorizeAttribute = System.Web.Mvc.AuthorizeAttribute;
using HttpGetAttribute = System.Web.Http.HttpGetAttribute;
using HttpPostAttribute = System.Web.Http.HttpPostAttribute;
using System.Data;
using System.IO;
using System.Data.OleDb;
using System.Data.SqlClient;
using PASystem.API.Configuration;

namespace PASystem.API.Controllers
{
    public class ExcelController : ApiController
    {
        private ExcelRepository _arepo = null;
        // private IAuthenticationManager Authentication => Request.GetOwinContext().Authentication;
        public ExcelController()
        {
            _arepo = new ExcelRepository();
        }
        [HttpGet]
        [System.Web.Http.Route("api/excel/holidaylist/{filename}/{cmpcode}")]
        public HttpResponseMessage saveHolidayList(string filename, long cmpcode)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempholidays",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.saveholidays(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/excel/advancepayment/{filename}/{cmpcode}")]
        public HttpResponseMessage saveAdvancePayment(string filename, long cmpcode)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempadvancepayment",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.saveAdvancePayment(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
        }

        [HttpGet]
        [System.Web.Http.Route("api/excel/approved/{filename}/{cmpcode}")]
        public HttpResponseMessage saveApproved(string filename, long cmpcode)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempapproval",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.saveApproved(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
        }

        [HttpGet]
        [System.Web.Http.Route("api/excel/businesslist/{filename}/{cmpcode}")]
        public HttpResponseMessage savebusinesslist(string filename, long cmpcode)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempbusinesslist",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.savebusinesslist(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
        }

        [HttpGet]
        [System.Web.Http.Route("api/excel/category/{filename}/{cmpcode}")]
        public HttpResponseMessage savecategory(string filename, long cmpcode)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempcategory",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.savecategory(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
        }

        [HttpGet]
        [System.Web.Http.Route("api/excel/customer/{filename}/{cmpcode}")]
        public HttpResponseMessage savecustomer(string filename, long cmpcode)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempcustomer",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.savecustomer(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
        }

        [HttpGet]
        [System.Web.Http.Route("api/excel/projectphase/{filename}/{cmpcode}")]
        public HttpResponseMessage saveprojectphase(string filename, long cmpcode)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempprojectphase",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.saveprojectphase(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
        }

        [HttpGet]
        [System.Web.Http.Route("api/excel/sales/{filename}/{cmpcode}")]
        public HttpResponseMessage savesales(string filename, long cmpcode)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string filePath = System.Web.HttpContext.Current.Server.MapPath("~/Upload/" + filename);
                    bool fileexists = System.IO.File.Exists(filePath);
                    if (!fileexists)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "File Not Found" });
                    }
                    int i = exportexcel(filename, filePath, "tempsales",cmpcode);
                    if (i == 1)
                    {
                        var result = _arepo.savesales(cmpcode);
                        if (result == 0)
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Record not updated successfully" });
                        else
                            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });

                    }
                    else
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, new { success = false, data = "Please try after sometime" });

                    }

                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
            return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
        }
        public Int32 exportexcel(string filename, string filePath,string tablename,long cmpcode)
        {
            string conStr = "";
            string extension;
            extension = Path.GetExtension(filename);
            switch (extension)
            {
                case ".xls": //Excel 97-03
                    conStr = ConfigurationManager.ConnectionStrings["Excel03ConString"].ConnectionString;
                    break;
                case ".xlsx": //Excel 07
                    conStr = ConfigurationManager.ConnectionStrings["Excel07ConString"].ConnectionString;
                    break;

            }
            try
            {
                conStr = String.Format(conStr, filePath, "Yes");
                System.Data.OleDb.OleDbConnection connExcel = new System.Data.OleDb.OleDbConnection(conStr);
                System.Data.OleDb.OleDbCommand cmdExcel = new System.Data.OleDb.OleDbCommand();
                System.Data.OleDb.OleDbDataAdapter oda = new System.Data.OleDb.OleDbDataAdapter();
                DataTable dt = new DataTable();
                cmdExcel.Connection = connExcel;
                //Get the name of First Sheet
                connExcel.Open();
                DataTable dtExcelSchema;
                dtExcelSchema = connExcel.GetOleDbSchemaTable(System.Data.OleDb.OleDbSchemaGuid.Tables, null);
                string SheetName = dtExcelSchema.Rows[0]["TABLE_NAME"].ToString();
                connExcel.Close();
                string myexceldataquery = "SELECT * From [" + SheetName + "]";
                string ssqlconnectionstring = ConfigManager.GetNewSqlConnection.ConnectionString;
                OleDbCommand oledbcmd = new OleDbCommand(myexceldataquery, connExcel);
                connExcel.Open();
                cmdExcel.CommandText = "SELECT * From [" + SheetName + "]";
                oda.SelectCommand = cmdExcel;

                oda.Fill(dt);
                dt.Columns.Add("CmpCode", typeof(System.Int64));

                foreach (DataRow row in dt.Rows)
                {
                    row["CmpCode"] = cmpcode;
                }
                // OleDbDataReader dr = oledbcmd.ExecuteReader();
                SqlBulkCopy bulkcopy = new SqlBulkCopy(ssqlconnectionstring);
                bulkcopy.DestinationTableName = tablename;
                bulkcopy.WriteToServer(dt);
                //while (dt)
                //{
                //    bulkcopy.WriteToServer(dr);
                //}
               // dr.Close();
                connExcel.Close();
                return 1;
            }
            catch (Exception e)
            {
                return 2;
            }
        }
    }
}