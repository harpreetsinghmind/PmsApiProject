using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;

namespace PASystem.API.Models.CommonModel
{
    public class ResponseViewModel<T>
    {
        //default 200
        public int StatusCode { get; set; } = 200;

        public T Data { get; set; }

        public string Message { get; set; }

    }
}