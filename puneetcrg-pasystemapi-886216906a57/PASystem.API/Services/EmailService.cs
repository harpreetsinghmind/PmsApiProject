using Microsoft.AspNet.Identity;
using SendGrid;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Net.Mail;
namespace PASystem.API.Services
{
    public class EmailService : IIdentityMessageService
    {
        public async Task SendAsync(IdentityMessage message)
        {
            await configSendGridasync(message);
        }

        // Use NuGet to install SendGrid (Basic C# client lib) 
        private async Task configSendGridasync(IdentityMessage message)
        {
            var myMessage = new SendGridMessage();

            myMessage.AddTo(message.Destination);
            myMessage.From = new System.Net.Mail.MailAddress("Registration@Echelonnet.com", "Echelon");
            myMessage.Subject = message.Subject;
            myMessage.Text = message.Body;
            myMessage.Html = message.Body;

            var credentials = new NetworkCredential(ConfigurationManager.AppSettings["emailService:Account"],
                                                    ConfigurationManager.AppSettings["emailService:Password"]);

            // Create a Web transport for sending email.
            var transportWeb = new Web(credentials);

            // Send the email.
            if (transportWeb != null)
            {
                await transportWeb.DeliverAsync(myMessage);
            }
            else
            {
                //Trace.TraceError("Failed to create Web transport.");
                await Task.FromResult(0);
            }
        }

        public void SendEmail(string to_email, string subject, string body)
        {
            try
            {

                MailMessage Message = new MailMessage();
                Message.Subject = subject;
                Message.Body = body;
                Message.IsBodyHtml = true;
                Message.From = new System.Net.Mail.MailAddress("Registration@Echelonnet.com");
                Message.To.Add(new MailAddress(to_email));

                //Message.Bcc.Add("sanjay.singh@PlanetEDUTech.com");


                SmtpClient Smtp = new SmtpClient();
                //Smtp.UseDefaultCredentials = true;
                Smtp.Port = 25;
                Smtp.Send(Message);
            }
            catch
            { }
        }
    }
}