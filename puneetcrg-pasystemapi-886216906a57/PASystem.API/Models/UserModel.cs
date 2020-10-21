using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
namespace PASystem.API.Models
{

  public class Users
  {
    public virtual long UserId { get; set; }
    public virtual string Email { get; set; }
    public virtual bool EmailConfirmed { get; set; }
    public virtual string PasswordHash { get; set; }
    public virtual string SecurityStamp { get; set; }
    public virtual string PhoneNumber { get; set; }
    public virtual bool PhoneNumberConfirmed { get; set; }
    public virtual bool TwoFactorEnabled { get; set; }
    public virtual DateTime? LockoutEndDateUtc { get; set; }
    public virtual bool LockoutEnabled { get; set; }
    public virtual int AccessFailedCount { get; set; }
    public virtual string UserName { get; set; }
    public virtual string UserFullName { get; set; }
    public virtual bool isAuthorized { get; set; }
    public virtual bool InActive { get; set; }
    public virtual string CreatedBy { get; set; }
    public virtual DateTime? CreatedDate { get; set; }
    public virtual string UpdatedBy { get; set; }
    public virtual DateTime? UpdatedDate { get; set; }
    public virtual DateTime? ReleavingDate { get; set; }
    public virtual string UserType { get; set; }
  }

  public class PMSUser
  {
    public virtual string UserName { get; set; }
    public virtual string UserId { get; set; }
    public virtual string Email { get; set; }
    public virtual string UserFullName { get; set; }
  }
}