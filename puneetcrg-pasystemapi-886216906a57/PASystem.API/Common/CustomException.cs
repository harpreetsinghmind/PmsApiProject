using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PASystem.API.Common
{
    public class CustomException : Exception
    {
        public CustomException()
        {

        }

        public CustomException(string message)
            : base(message)
        {

        }
    }
}