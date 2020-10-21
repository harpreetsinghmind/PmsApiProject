using PASystem.API.Entity;
using PASystem.API.Infrastructure;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity.Owin;
using PASystem.API.Repositories;
namespace PASystem.API.Providers
{
    public class CustomOAuthProvider : OAuthAuthorizationServerProvider
    {

        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            context.Validated();
            return Task.FromResult<object>(null);
        }

        //public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        //{

        //    var allowedOrigin = "*";

        //  context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { allowedOrigin });

        //    var userManager = context.OwinContext.GetUserManager<ApplicationUserManager>();

        //    ApplicationUser user = await userManager.FindAsync(context.UserName, context.Password);

        //    if (user == null)
        //    {
        //        context.SetError("invalid_grant", "The user name or password is incorrect.");
        //        return;
        //    }

        //    if (!user.EmailConfirmed)
        //    {
        //        context.SetError("invalid_grant", "User did not confirm email.");
        //        return;
        //    }

        //    ClaimsIdentity oAuthIdentity = await user.GenerateUserIdentityAsync(userManager, "JWT");

        //    var ticket = new AuthenticationTicket(oAuthIdentity, null);

        //    context.Validated(ticket);

        //}


        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {


            string uid = ""; string usertype = ""; string username = ""; string userroles = ""; string name = ""; string passwordchanged = "";
            IList<string> roles=null;

           ApplicationUser user =null;
            var allowedOrigin = context.OwinContext.Get<string>("as:clientAllowedOrigin");

            if (allowedOrigin == null) allowedOrigin = "*";

            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { allowedOrigin });

            using (AuthRepository _repo = new AuthRepository())
            {
                if (IsValidEmail(context.UserName) == true)
                {
                    ApplicationUser us = await _repo.FindUserByEmail(context.UserName);
                    if (us == null)
                    {
                        context.SetError("true", "The email or password is incorrect.");
                        return;
                    }
                    user = await _repo.FindUser(us.UserName, context.Password);

                    if (user == null)
                    {
                        context.SetError("true", "The user name or password is incorrect.");
                        return;
                    }
                    uid = user.Id;
                    roles = await _repo.GetUserRoles(user.Id);
                    //role = roles.FirstOrDefault();
                    username = user.UserName;
                    var upi=_repo.GetUserPrimaryInfo(user.Id);
                    name = upi.PTitle + " " + upi.FirstName + " " + upi.LastName;
                    passwordchanged = user.PasswordChanged.ToString();

                }
                else
                {
                    user = await _repo.FindUser(context.UserName, context.Password);

                    if (user == null)
                    {
                        context.SetError("true", "The user name or password is incorrect.");
                        return;
                    }
                    //if (user.EmailConfirmed == false)
                    //{
                    //    context.SetError("true", "Account not activated");
                    //    return;
                    //}

                    uid = user.Id;
                    roles = await _repo.GetUserRoles(user.Id);
                    //role = roles.FirstOrDefault();
                    username = user.UserName;
                    var upi = _repo.GetUserPrimaryInfo(user.Id);
                    name = upi.PTitle + " " + upi.FirstName + " " + upi.LastName;
                    passwordchanged = user.PasswordChanged.ToString();
                    
                }
            }

            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim(ClaimTypes.Name, context.UserName));
            identity.AddClaim(new Claim(ClaimTypes.GivenName, name));
            
            identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.Id));



            if (roles != null && roles.Any())
            {
                foreach (var role in roles)
                {
                    identity.AddClaim(new Claim(ClaimTypes.Role, role));
                    userroles += role + ",";
                }

                userroles = userroles.Substring(0, userroles.Length - 1);
            }


            identity.AddClaim(new Claim("sub", context.UserName));

          
            var props = new AuthenticationProperties(new Dictionary<string, string>
                {
                    //{ 
                    //    "as:client_id", (context.ClientId == null) ? string.Empty : context.ClientId
                    //},
                    { 
                        "userName", username
                    },
                    {
                        "userId",uid
                    },
                    {
                        "role",userroles
                    },
                    {
                        "name",name
                    },
                    {
                        "passwordchanged",passwordchanged
                    },
                    {
                        "error","false"
                    }
                });
            
            var ticket = new AuthenticationTicket(identity, props);
            context.Validated(ticket);

        }

        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }

        public bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}