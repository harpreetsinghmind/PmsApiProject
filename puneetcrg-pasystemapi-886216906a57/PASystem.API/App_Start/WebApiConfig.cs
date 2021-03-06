﻿using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Formatting;
using System.Web.Http;
using System.Web.Cors;

namespace PASystem.API
{
    public static class WebApiConfig
    {
        //public static void Register(HttpConfiguration config)
        //{

        //    // Web API routes
        //    config.MapHttpAttributeRoutes();

        //    config.Routes.MapHttpRoute(
        //        name: "DefaultApi",
        //        routeTemplate: "api/{controller}/{action}/{id}",
        //        defaults: new { id = RouteParameter.Optional }
        //    );

        //    var jsonFormatter = config.Formatters.OfType<JsonMediaTypeFormatter>().First();
        //    jsonFormatter.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
        //}

        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
            // Configure Web API to use only bearer token authentication.

            // Web API routes
            //config.MapHttpAttributeRoutes();

            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{id}",
            //    defaults: new { id = RouteParameter.Optional }
            //);

            //config.EnableCors();
            config.Routes.MapHttpRoute(
              name: "DefaultApi",
              routeTemplate: "api/{controller}/{action}/{id}",
              defaults: new { id = RouteParameter.Optional }
          );




        }


    }
}
