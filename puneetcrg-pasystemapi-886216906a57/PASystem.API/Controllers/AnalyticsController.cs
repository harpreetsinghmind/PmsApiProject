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

namespace PASystem.API.Controllers
{
    //[Authorize]
    public class AnalyticsController : ApiController
    {
        private AuthRepository _arepo = null;
        private IAuthenticationManager Authentication => Request.GetOwinContext().Authentication;

        //string SrsApiUrl = ConfigurationManager.AppSettings["SrsApiUrl"];
        public AnalyticsController()
        {
            _arepo = new AuthRepository();
        }

        [HttpGet]
        [System.Web.Http.Route("api/analytics/Getexpansedetail/{Userid}/{customerid}/{reportid}/{fromdate}/{todate}")]
        public HttpResponseMessage Getexpansedetail(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.Getexpansedetail(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }


        [HttpGet]
        [System.Web.Http.Route("api/analytics/Getunsubmittedexpanse/{Userid}/{customerid}/{reportid}/{fromdate}/{todate}")]
        public HttpResponseMessage Getunsubmittedexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.Getunsubmittedexpanse(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        [System.Web.Http.Route("api/analytics/Getcategoryexpanse/{Userid}/{customerid}/{reportid}/{fromdate}/{todate}")]
        public HttpResponseMessage Getcategoryexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.Getcategoryexpanse(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        [System.Web.Http.Route("api/analytics/getuserwiseexpanse/{Userid}/{customerid}/{reportid}/{fromdate}/{todate}")]
        public HttpResponseMessage getuserwiseexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getuserwiseexpanse(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        [System.Web.Http.Route("api/analytics/getmilegeexpanse/{Userid}/{customerid}/{reportid}/{fromdate}/{todate}")]
        public HttpResponseMessage getmilegeexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getmilegeexpanse(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }


        [HttpGet]
        [System.Web.Http.Route("api/analytics/getpolicyviolation/{Userid}/{customerid}/{reportid}/{fromdate}/{todate}")]

        public HttpResponseMessage getpolicyviolation(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getpolicyviolation(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        [System.Web.Http.Route("api/analytics/getpolicyviolation/{Userid}/{customerid}/{reportid}/{fromdate}/{todate}")]
        public HttpResponseMessage getcustomerexpanse(long UserId, long customerid, int reportid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getcustomerexpanse(UserId, customerid, reportid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        public HttpResponseMessage getprojectexpanse()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getprojectexpanse();
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getexrptresourceallocation/{Userid}/{customerid}/{projectid}/{fromdate}/{todate}")]
        public HttpResponseMessage getexrptresourceallocation(long UserId, long customerid, int projectid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getexrptresourceallocation(UserId, customerid, projectid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getprojectleaveplannerreport/{Userid}/{projectid}/{customerid}/{fromdate}/{todate}")]
        public HttpResponseMessage getprojectleaveplannerreport(long UserId, long projectId, long customerid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getprojectleaveplannerreport( UserId,  projectId,  customerid,  fromdate,  todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getoverduetask/{Userid}/{projectid}/{fromdate}/{todate}")]
        public HttpResponseMessage getoverduetask(long UserId, long customerid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getoverduetask(UserId, customerid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getplannedvsactual/{Userid}/{projectid}/{fromdate}/{todate}/{status}")]
        public HttpResponseMessage getplannedvsactual(long UserId, long customerid, DateTime fromdate, DateTime todate,int status)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getplannedvsactual(UserId, customerid, fromdate, todate,status);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getexrptresourceallocation/{Userid}/{projectid}/{employeeid}/{fromdate}/{todate}")]
        public HttpResponseMessage getexrptresourceworkdetail(long UserId, long projectid, int employeeid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getexrptresourceworkdetail(UserId, projectid, employeeid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getprojectprofitablity/{Userid}/{projectid}/{fromdate}/{todate}")]
        public HttpResponseMessage getprojectprofitablity(long Userid, long projectid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getprojectprofitablity(Userid, projectid, fromdate, todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getmomreport/{Userid}/{projectid}/{fromdate}/{todate}")]
        public HttpResponseMessage getmomreport(long Userid, long projectid, DateTime fromdate, DateTime todate)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getmomreport( Userid,  projectid,  fromdate,  todate);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        public HttpResponseMessage getchangerequest()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getchangerequest();
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        public HttpResponseMessage getresourceeffciency()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getresourceeffciency();
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        public HttpResponseMessage getresourceutilization()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getresourceutilization();
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        public HttpResponseMessage getrollback()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getrollback();
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, data = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }

        [HttpGet]
        [System.Web.Http.Route("api/analytics/getprojectdashboard/{projectid}")]
        public HttpResponseMessage getprojectdashboard(long projectid)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getprojectdashboard(projectid);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, message = "Records Loaded Successfully", responseData = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        [System.Web.Http.Route("api/analytics/getexpense/{userid}")]
        public HttpResponseMessage getexpense(long userid)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getexpense(userid);
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, message = "Records Loaded Successfully", responseData = result });
                }
                else return Request.CreateErrorResponse(HttpStatusCode.NotFound, string.Join(", ", ModelState.Values.SelectMany(v => v.Errors)));
            }
            catch (Exception)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Some error occured in current request.");
            }
        }
        [HttpGet]
        public HttpResponseMessage getwbsandcbs()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getwbsandcbs();
                    return Request.CreateResponse(HttpStatusCode.OK, new { success = true, message = "Records Loaded Successfully", data = result });
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