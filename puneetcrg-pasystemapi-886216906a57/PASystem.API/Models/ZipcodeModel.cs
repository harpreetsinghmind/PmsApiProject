using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PASystem.API.Models
{
    public class ExportZipcodeModel
    {
        public virtual string Zipcode { get; set; }
        public virtual string CountryName { get; set; }
        public virtual string StateName { get; set; }
        public virtual string CityName { get; set; }
        public virtual bool InActive { get; set; }
        public virtual string Notes { get; set; }
        public virtual bool IsDeleted { get; set; }
        public virtual string ImportStatus { get; set; }
    }
    public class ImportZipcodeModel:ExportZipcodeModel
    {
        public virtual bool AllowEdit { get; set; }
        public virtual bool AllowAdd { get; set; }
        public virtual Dictionary<string, object> Attributes { get; set; }

    }
}