using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Claims;
using System.Web.Http;
using System.Security.Principal;

namespace PASystem.API.Common
{
    public static class ClaimsHelper
    {
        //long UserId = ClaimsHelper.GetUserId(User);
        public static string GetUserId(IPrincipal User)
        {
            var identity = User.Identity as ClaimsIdentity;

            var claims = from c in identity.Claims
                         select new
                         {
                             subject = c.Subject.Name,
                             type = c.Type,
                             value = c.Value
                         };

            var userIdClaim = claims.Where(x => x.type == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid").FirstOrDefault();
            if (userIdClaim != null)
                return userIdClaim.value;
            return "";
        }
    }
}