using PASystem.API.Entity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace PASystem.API.Infrastructure
{
    public class ApplicationDbContext:IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext():base("PASystem")

      {
        }


            public static ApplicationDbContext Create()
            {
                return new ApplicationDbContext();

            }
      
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
    
            //modelBuilder.HasDefaultSchema("public");
            base.OnModelCreating(modelBuilder);
            //modelBuilder.Entity<IdentityUser>().ToTable("Users");
        }

    }



    }
