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
        public HttpResponseMessage Getexpansedetail(string filename,long cmpcode)
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



                    //Read Data from First Sheet

                    connExcel.Open();
                    cmdExcel.CommandText = "SELECT * From [" + SheetName + "]";
                    oda.SelectCommand = cmdExcel;
                    oda.Fill(dt);
                    connExcel.Close();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        var result = _arepo.saveholidays(Convert.ToString(dt.Rows[i]["Holiday"]),Convert.ToDateTime(dt.Rows[i]["Date"]),Convert.ToString(dt.Rows[i]["Day"]), cmpcode, Convert.ToString(dt.Rows[i]["Location"]));
                    }
                    // var result = _arepo.saveholidays(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = "Data upload successfully" });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
    }
}