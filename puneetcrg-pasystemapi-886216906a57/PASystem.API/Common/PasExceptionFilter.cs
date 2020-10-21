using PASystem.API.Models.CommonModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Script.Serialization;

namespace PASystem.API.Common
{
    public class PasExceptionFilter : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            var exceptionType = actionExecutedContext.Exception.GetType();
            HttpStatusCode status;
            string message;
            if (exceptionType == typeof(UnauthorizedAccessException))
            {
                message = "Access to the Web API is not authorized.";
                status = HttpStatusCode.Unauthorized;
            }
            else if(exceptionType == typeof(CustomException))
            {
                message = actionExecutedContext.Exception.Message;
                status = HttpStatusCode.PreconditionFailed;
            }
            else
            {
                message = "Something went wrong";
                status = HttpStatusCode.InternalServerError;
            }
            var responseJson = new ResponseViewModel<bool> { Data = false, Message = message, StatusCode = Convert.ToInt32(status) };
            actionExecutedContext.Response = new HttpResponseMessage()
            {
                Content = new StringContent(new JavaScriptSerializer().Serialize(responseJson), System.Text.Encoding.UTF8, "application/json"),
                StatusCode = status
            };
            base.OnException(actionExecutedContext);
        }
    }
}