using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Threading.Tasks;
using System.Threading;
using System.Net;
using System.Web.Mvc;
using Microsoft.Owin.Security;
// using Microsoft.Owin.Security;

namespace PASystem.API.Results
{
  // : HttpUnauthorizedResult
  public class ChallengeResult : IHttpActionResult
  {
    public string LoginProvider { get; set; }
    public string RedirectUri { get; set; }
    public HttpRequestMessage Request { get; set; }

    public ChallengeResult(string loginProvider, ApiController controller)    // , string redirectUrl) 
    {
      LoginProvider = loginProvider;
      // RedirectUri = redirectUrl;
      Request = controller.Request;
    }

    public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
    {
      // var properties = new AuthenticationProperties { RedirectUri = RedirectUri};
      Request.GetOwinContext().Authentication.Challenge(LoginProvider);

      HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Unauthorized)
      {
        RequestMessage = Request
      };
      return Task.FromResult(response);
    }

    //public override void ExecuteResult(ControllerContext context)
    //{
    //  var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
    //  context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
    //}

  }
}