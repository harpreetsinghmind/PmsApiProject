using PASystem.API.Providers;
using Microsoft.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Jwt;
using Microsoft.Owin.Security.OAuth;
using Newtonsoft.Json.Serialization;
using Owin;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http.Formatting;
using System.Web;
using System.Web.Http;
using Microsoft.Owin.Security.Facebook;
using Microsoft.Owin.Security.Google;


[assembly: OwinStartup(typeof(PASystem.API.Startup))]
namespace PASystem.API
{
  public class Startup
  {
    public static OAuthBearerAuthenticationOptions OAuthBearerOptions { get; private set; }
    public static GoogleOAuth2AuthenticationOptions googleAuthOptions { get; private set; }
    public static FacebookAuthenticationOptions facebookAuthOptions { get; private set; }

    public void Configuration(IAppBuilder app)
    {
      HttpConfiguration httpConfig = new HttpConfiguration();
      app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
      ConfigureOAuthTokenGeneration(app);
      ConfigureOAuthTokenConsumption(app);

      ConfigureWebApi(httpConfig);
      WebApiConfig.Register(httpConfig);
      app.UseCors(Microsoft.Owin.Cors.CorsOptions.AllowAll);
      app.UseWebApi(httpConfig);

    }

    private void ConfigureOAuthTokenGeneration(IAppBuilder app)
    {
      // Configure the db context and user manager to use a single instance per request
      app.UseExternalSignInCookie(Microsoft.AspNet.Identity.DefaultAuthenticationTypes.ExternalCookie);
      OAuthBearerOptions = new OAuthBearerAuthenticationOptions();
      OAuthAuthorizationServerOptions OAuthServerOptions = new OAuthAuthorizationServerOptions()
      {
        //For Dev enviroment only (on production should be AllowInsecureHttp = false)
        AllowInsecureHttp = true,
        TokenEndpointPath = new PathString("/oauth/token"),
        AccessTokenExpireTimeSpan = TimeSpan.FromDays(1),
        Provider = new OAuthProvider(),
        AccessTokenFormat = new CustomJwtFormat("PASystem")
      };

      // OAuth 2.0 Bearer Access Token Generation
      app.UseOAuthAuthorizationServer(OAuthServerOptions);
      app.UseOAuthBearerAuthentication(OAuthBearerOptions);

      //Configure Google External Login
      googleAuthOptions = new GoogleOAuth2AuthenticationOptions()
      {
        //ClientId = "609930121640-75u1865ec3egpdrlult4hl8baab17aho.apps.googleusercontent.com",
        //ClientSecret = "glBOOHGv9QiHCvzdRUmF2oiN",
        ClientId = "85058222632-7gbrgmkilnpusuu5fepfg1inoh302ot1.apps.googleusercontent.com",
        ClientSecret = "fXOiqi_DQtucAnlpzbyQbTs1",
        Provider = new GoogleAuthProvider(),
      };
      googleAuthOptions.Scope.Add("email");
      googleAuthOptions.Scope.Add("profile");
      googleAuthOptions.Scope.Add("openid");
      app.UseGoogleAuthentication(googleAuthOptions);
      
      ////Configure Facebook External Login
      //facebookAuthOptions = new FacebookAuthenticationOptions()
      //{
      //    AppId = "xxxxxx",
      //    AppSecret = "xxxxxx",
      //    Provider = new FacebookAuthProvider()
      //};
      //app.UseFacebookAuthentication(facebookAuthOptions);
    }



    private void ConfigureWebApi(HttpConfiguration config)
    {
      config.MapHttpAttributeRoutes();
      config.EnableCors();

      var jsonFormatter = config.Formatters.OfType<JsonMediaTypeFormatter>().First();
      jsonFormatter.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
    }

    private void ConfigureOAuthTokenConsumption(IAppBuilder app)
    {
      var issuer = "PASystem";
      string audienceId = ConfigurationManager.AppSettings["as:AudienceId"];
      byte[] audienceSecret = Microsoft.Owin.Security.DataHandler.Encoder.TextEncodings.Base64Url.Decode(ConfigurationManager.AppSettings["as:AudienceSecret"]);

      // Api controllers with an [Authorize] attribute will be validated with JWT
      app.UseJwtBearerAuthentication(
          new JwtBearerAuthenticationOptions
          {
            AuthenticationMode = AuthenticationMode.Active,
            AllowedAudiences = new[] { audienceId },
            IssuerSecurityTokenProviders = new IIssuerSecurityTokenProvider[]
            {
                new SymmetricKeyIssuerSecurityTokenProvider(issuer, audienceSecret)
            }
          });
    }



  }
}