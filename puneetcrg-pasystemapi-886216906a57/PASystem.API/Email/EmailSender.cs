using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Mail;

namespace PASystem.API.Email
{
    public class EmailSender
    {
        private readonly Dictionary<string, string> TemplateEmbeddedResourceNameMappings = new Dictionary<string, string>
                        {
                            {
                            "ForgotPassword", @"forgotpassword.html"
                            },
                            {
                            "Employee_TimesheetAdded", @"etimeshhetadded.html"
                            },
                            {
                            "Employee_TimesheetRejected", @"etimesheetreject.html"
                            },
                            {
                            "Employee_TimesheetApproved", @"etimesheetapproved.html"
                            },
                            {
                            "Employee_TimesheetEditRequest", @"etimesheeteditrequest.html"
                            },
                            {
                            "Employee_TimesheetEditApproved", @"etimesheeteditapproved.html"
                            },
                            {
                            "Manager_TimesheetAdded", @"mtimeshhetadded.html"
                            },
                            {
                            "Manager_TimesheetRejected", @"mtimesheetreject.html"
                            },
                            {
                            "Manager_TimesheetApproved", @"mtimesheetapproved.html"
                            },
                            {
                            "Manager_TimesheetEditRequest", @"mtimesheeteditrequest.html"
                            },
                            {
                            "Manager_TimesheetEditApproved", @"mtimesheeteditapproved.html"
                            }
                        };

        public void Send(EmailNotificationModel model)
        {
            var path = System.Web.Hosting.HostingEnvironment.MapPath($"~/Email/Templates/{TemplateEmbeddedResourceNameMappings[model.TemplateName]}");
            var template = File.ReadAllText(path);
            foreach (var item in model.Data)
            {
                if (model.TemplateName != "ForgotPassword")
                {
                    template = template.Replace("[" + item.Key + "]", item.Value);
                }
                else
                {
                    template = template.Replace(item.Key, item.Value);
                }
            }
            var mail = new MailMessage();
            if (string.Equals(ConfigurationManager.AppSettings["smtp.OnlyToTestUsers"], "true", StringComparison.InvariantCultureIgnoreCase))
            {
                var users = ConfigurationManager.AppSettings["smtp.TestUsers"].Split(',');
                foreach (var user in users)
                {
                    mail.To.Add(user);
                }
            }
            else
            {
                var notificationEmailAddresses = model.ToAddress.Split(',');
                foreach (var email in notificationEmailAddresses)
                {
                    mail.To.Add(email);
                }
            }
            mail.From = new MailAddress(ConfigurationManager.AppSettings["smtp.FromAddress"], ConfigurationManager.AppSettings["smtp.DisplayName"]);
            mail.Subject = model.Subject;
            mail.Body = template;
            mail.IsBodyHtml = true;
            var networkCredential = new NetworkCredential(ConfigurationManager.AppSettings["smtp.Username"], ConfigurationManager.AppSettings["smtp.Password"])
            {
                Domain = ConfigurationManager.AppSettings["smtp.Domain"]
            };
            bool.TryParse(ConfigurationManager.AppSettings["smtp.EnableSsl"], out var enableSsl);
            int.TryParse(ConfigurationManager.AppSettings["smtp.Port"], out var port);
            try
            {
                var smtp = new SmtpClient
                {
                    Host = ConfigurationManager.AppSettings["smtp.Host"],
                    Port = port,
                    UseDefaultCredentials = false,
                    Credentials = networkCredential,
                    EnableSsl = enableSsl
                };
                smtp.Send(mail);
            }
            catch (Exception ex)
            {

            }
        }
    }
}