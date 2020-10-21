using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PASystem.API.Models
{
    public class UDFModel
    {
        public int AttributeId { get; set; }
        public string AttributeLabel { get; set; }
        public string DataType { get; set; }
        public string ControlType { get; set; }
        public string Attribute1 { get; set; }
        public bool IsRequired { get; set; }
        public int MinLength { get; set; }
        public int MaxLength { get; set; }

        public string Value { get; set; }

    }
}