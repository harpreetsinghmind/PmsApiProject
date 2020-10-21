using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Owin.Security.DataProtection;
using Microsoft.Owin.Security;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using PASystem.API.Entity;
namespace PASystem.API.Providers
{
  public static class TokenProvider
  {
    //[UsedImplicitly]
    private static DataProtectorTokenProvider<ApplicationUser> _tokenProvider;
    //dataProtectionProvider = options.DataProtectionProvider;
    public static DataProtectorTokenProvider<ApplicationUser> Provider
    {
      get
      {
        if (_tokenProvider != null)
          return _tokenProvider;
        var dataProtectionProvider = new DpapiDataProtectionProvider();
        _tokenProvider = new DataProtectorTokenProvider<ApplicationUser>(dataProtectionProvider.Create());
        return _tokenProvider;
      }
    }
  }
}
