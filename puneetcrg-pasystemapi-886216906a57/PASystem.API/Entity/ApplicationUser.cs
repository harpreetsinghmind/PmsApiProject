using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;

namespace PASystem.API.Entity
{
    public class ApplicationUser : IdentityUser
    {
        

        public virtual long UserID { get; set; }
        public virtual bool PasswordChanged { get; set; }

        //Rest of code is removed for brevity
        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager, string authenticationType)
        {
            var userIdentity = await manager.CreateIdentityAsync(this, authenticationType);
            // Add custom user claims here
            return userIdentity;
        }
    }

    public class ApplicationRole : IdentityRole
    {


        public virtual string Description { get; set; }
        public virtual bool InActive { get; set; }
        public virtual string CreatedBy { get; set; }
        public virtual DateTime? CreatedDate { get; set; }
        public virtual string UpdatedBy { get; set; }
        public virtual DateTime? UpdatedDate { get; set; }

        //Rest of code is removed for brevity
        //public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager, string authenticationType)
        //{
        //    var userIdentity = await manager.CreateIdentityAsync(this, authenticationType);
        //    // Add custom user claims here
        //    return userIdentity;
        //}
    }
}