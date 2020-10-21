namespace PASystem.API.Migrations
{
    using PASystem.API.Entity;
    using PASystem.API.Infrastructure;
    using Microsoft.AspNet.Identity;
    using Microsoft.AspNet.Identity.EntityFramework;
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;

    internal sealed class Configuration : DbMigrationsConfiguration<PASystem.API.Infrastructure.ApplicationDbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = true;
            
            
        }

        protected override void Seed(PASystem.API.Infrastructure.ApplicationDbContext context)
        {
            //  This method will be called after migrating to the latest version.

            var manager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(new ApplicationDbContext()));
            var roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(new ApplicationDbContext()));
            var user = new ApplicationUser()
            {
                UserName = "ranakdinesh",
                Email = "ranakdinesh@gmail.com",
                EmailConfirmed = true,
               
  
            };

            manager.Create(user, "ceg!@66%");
            
            if (roleManager.Roles.Count() == 0)
            {
                roleManager.Create(new IdentityRole { Name = "SuperAdmin" });
                roleManager.Create(new IdentityRole { Name = "Admin" });
                roleManager.Create(new IdentityRole { Name = "Management Team" });
                roleManager.Create(new IdentityRole { Name = "Parent" });
                roleManager.Create(new IdentityRole { Name = "Teaching Staff" });
                roleManager.Create(new IdentityRole { Name = "Non Teaching Staff" });
                roleManager.Create(new IdentityRole { Name = "Student" });
                roleManager.Create(new IdentityRole { Name = "Content Curator" });
                roleManager.Create(new IdentityRole { Name = "content Approvar" });


            }

            var adminUser = manager.FindByName("ranakdinesh");

            manager.AddToRoles(adminUser.Id, new string[] { "SuperAdmin", "Admin" });
        }
    }
}
