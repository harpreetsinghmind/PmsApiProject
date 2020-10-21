using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Web;

namespace PASystem.API.Common
{
    public class EmailHelper
    {
        public bool SendEmail(Tuple<string,string> to, string subject, string body, string fileName, byte[] attachment = null)
        {
            using (MailMessage mm = new MailMessage())
            {
                mm.From = new MailAddress("pms@crgroup.co.in", "CRG PMS Admin");
                mm.Subject = subject;
                //item1 email item2 name
                mm.To.Add(new MailAddress(to.Item1,to.Item2));

                mm.Body = body;

                if (attachment != null)
                {
                    mm.Attachments.Add(new Attachment(new MemoryStream(attachment), fileName));
                }
                mm.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                smtp.Host = System.Configuration.ConfigurationManager.AppSettings["Smtp.Host"];
                smtp.EnableSsl = Convert.ToBoolean(System.Configuration.ConfigurationManager.AppSettings["Smtp.EnableSsl"]);
                System.Net.NetworkCredential credentials = new System.Net.NetworkCredential();
                credentials.UserName = System.Configuration.ConfigurationManager.AppSettings["Smtp.Username"];
                credentials.Password = System.Configuration.ConfigurationManager.AppSettings["Smtp.Password"];
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = credentials;
                smtp.Port = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["Smtp.Port"]);
                smtp.Send(mm);
                return true;
            }
        }
    }
}