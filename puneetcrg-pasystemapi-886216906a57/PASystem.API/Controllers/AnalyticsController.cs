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
    [Authorize]
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
        public HttpResponseMessage Getexpansedetail()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.Getexpansedetail();
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
        public HttpResponseMessage Getunsubmittedexpanse()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.Getunsubmittedexpanse();
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
        public HttpResponseMessage Getcategoryexpanse()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.Getcategoryexpanse();
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
        public HttpResponseMessage getuserwiseexpanse()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getuserwiseexpanse();
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
        public HttpResponseMessage getmilegeexpanse()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getmilegeexpanse();
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
        public HttpResponseMessage getpolicyviolation()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getpolicyviolation();
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
        public HttpResponseMessage getcustomerexpanse()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getcustomerexpanse();
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
        public HttpResponseMessage getexrptresourceallocation()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getexrptresourceallocation();
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
        public HttpResponseMessage getprojectleaveplannerreport()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getprojectleaveplannerreport();
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
        public HttpResponseMessage getoverduetask()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getoverduetask();
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
        public HttpResponseMessage getplannedvsactual()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getplannedvsactual();
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
        public HttpResponseMessage getexrptresourceworkdetail()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getexrptresourceworkdetail();
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
        public HttpResponseMessage getprojectprofitablity()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getprojectprofitablity();
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
        public HttpResponseMessage getmomreport()
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = _arepo.getmomreport();
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

        





    }
}