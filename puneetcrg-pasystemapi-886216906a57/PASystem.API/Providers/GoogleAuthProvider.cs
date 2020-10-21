using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Owin;
using Microsoft.Owin.Security.Facebook;
using Microsoft.Owin.Security.Google;
using Microsoft.Owin.Security.OAuth;
using Owin;
using System.Threading.Tasks;
using System.Security.Claims;

namespace PASystem.API.Providers
{
  public class GoogleAuthProvider : IGoogleOAuth2AuthenticationProvider
  {
    public void ApplyRedirect(GoogleOAuth2ApplyRedirectContext context)
    {
      //context.Properties.IsPersistent = true;
      //string destination = context.RedirectUri.Split('&')[2].Split('=')[1];
      //string redirectUrl = "http%3A%2F%2Flocalhost:63000%2Fapi%2FAccounts%2FSocialLoginCallback";
      //context.RedirectUri.Replace(destination, redirectUrl);
      // context.Response.Headers["Access-Control-Allow-Origin"] = "*";
      context.Response.Redirect("http://localhost:4200");    //context.RedirectUri
    }

    public Task Authenticated(GoogleOAuth2AuthenticatedContext context)
    {
      context.Identity.AddClaim(new Claim("ExternalAccessToken", context.AccessToken));
      return Task.FromResult<object>(null);
    }

    public Task ReturnEndpoint(GoogleOAuth2ReturnEndpointContext context)
    {
      return Task.FromResult<object>(null);
    }
  }
}