using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using PASystem.API.Services;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;

namespace PASystem.API.Providers
{
  public class OAuthProvider : OAuthAuthorizationServerProvider
  {
    #region[GrantResourceOwnerCredentials]
    public override Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
    {

      return Task.Factory.StartNew(() =>
      {
        //if (password == "1ODQxMTc1LCJuYmYiOjE1NzU3NTQ3NzV9.mLQvyQ6NgnqSkB0RuG-mpshlrTl9JebjGL5N74u_Rqs")
        //{
        //  Models.PMSUser UserInfo = userService.ValidateGoogleUser(userName);
        //  if (UserInfo != null)
        //  {
        //    var claims = new List<Claim>()
        //      {
        //                new Claim(ClaimTypes.Sid, UserInfo.UserId),
        //                new Claim(ClaimTypes.Name, UserInfo.UserName),
        //                new Claim(ClaimTypes.Email, UserInfo.Email)
        //      };
        //    ClaimsIdentity oAuthIdentity = new ClaimsIdentity(claims,
        //                      Startup.OAuthBearerOptions.AuthenticationType);

        //    var properties = CreateProperties(UserInfo.UserName, UserInfo.UserId, UserInfo.Email, UserInfo.UserFullName);
        //    var ticket = new AuthenticationTicket(oAuthIdentity, properties);
        //    context.Validated(ticket);
        //  }
        //  else
        //  {
        //    context.SetError("user_not_found", "Email (" + userName + ") verification failed.\r\nPlease contact system administrator.");
        //  }          
        //}
        //else
        //{

        var userName = context.UserName;
        var password = context.Password;
        var userService = new UserService();

        Models.Users user = userService.ValidateUser(userName, password);
        if (user != null)
        {
          var claims = new List<Claim>()
                    {
                        new Claim(ClaimTypes.Sid, Convert.ToString(user.UserId)),
                        new Claim(ClaimTypes.Name, user.UserName),
                        new Claim(ClaimTypes.Email, user.Email),
                        new Claim(ClaimTypes.Role, user.UserType)
                    };
          ClaimsIdentity oAuthIdentity = new ClaimsIdentity(claims,
                      Startup.OAuthBearerOptions.AuthenticationType);

          var properties = CreateProperties(user.UserName, Convert.ToString(user.UserId), user.Email, user.UserFullName, user.UserType);
          var ticket = new AuthenticationTicket(oAuthIdentity, properties);
          context.Validated(ticket);
        }
        else
        {
          context.SetError("invalid_grant", "The user name or password is incorrect");
        }
        //  }
      });
    }
    #endregion

    #region[ValidateClientAuthentication]
    public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
    {
      if (context.ClientId == null)
        context.Validated();

      return Task.FromResult<object>(null);
    }
    #endregion

    #region[TokenEndpoint]
    public override Task TokenEndpoint(OAuthTokenEndpointContext context)
    {
      foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
      {
        context.AdditionalResponseParameters.Add(property.Key, property.Value);
      }

      return Task.FromResult<object>(null);
    }
    #endregion

    #region[CreateProperties]
    public static AuthenticationProperties CreateProperties(string userName, string userId, string userEmail, string userFullname, string userType)
    {
      IDictionary<string, string> data = new Dictionary<string, string>
            {
                {"userName", userName },
                {"userId", userId },
                {"userEmail", userEmail },
                {"userFullName", userFullname },
                {"userType", userType }
            };
      return new AuthenticationProperties(data);
    }
    #endregion
  }
}

