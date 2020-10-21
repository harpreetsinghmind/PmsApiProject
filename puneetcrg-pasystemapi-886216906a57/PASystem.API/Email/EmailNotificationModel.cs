using System.Collections.Generic;

namespace PASystem.API.Email
{
    public class EmailNotificationModel
    {
        public string TemplateName { get; set; }

        public Dictionary<string, string> Data { get; set; }

        public string ToAddress { get; set; }

        public string CcAddress { get; set; }

        public string Subject { get; set; }
    }
}