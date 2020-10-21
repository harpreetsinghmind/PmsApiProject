using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PASystem.API.Entity;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity;
namespace PASystem.API
{
    public class UserDBContext : IdentityDbContext<ApplicationUser>
    {
        public UserDBContext()
            : base("PASystem")
        {
           

        }

        
       


        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();


            // PostgreSQL uses the public schema by default - not dbo.
            Database.SetInitializer<UserDBContext>(null);
            modelBuilder.HasDefaultSchema("public");
            base.OnModelCreating(modelBuilder);
        }
    }
}