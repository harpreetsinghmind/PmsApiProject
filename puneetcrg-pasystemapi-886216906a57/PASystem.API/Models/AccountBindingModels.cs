using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace PASystem.API.Models
{
  public class CreateUserBindingModel
  {
    [Required]
    [EmailAddress]
    [Display(Name = "Email")]
    public string Email { get; set; }

    [Required]
    [Display(Name = "Username")]
    public string UserName { get; set; }

    [Required]
    [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
    [DataType(DataType.Password)]
    [Display(Name = "Password")]
    public string Password { get; set; }

    [Required]
    [DataType(DataType.Password)]
    [Display(Name = "Confirm password")]
    [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
    public string ConfirmPassword { get; set; }

    //[Display(Name = "Role")]
    //public string Role { get; set; }




  }

  public class ReturnUserModel
  {
    public string UserId { get; set; }
    public string Message { get; set; }
  }

  public class ChangePasswordBindingModel
  {
    [Required]
    [Display(Name = "User Name")]
    public string UserName { get; set; }

    [Required]
    [DataType(DataType.Password)]
    [Display(Name = "Current password")]
    public string OldPassword { get; set; }

    [Required]
    [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
    [DataType(DataType.Password)]
    [Display(Name = "New password")]
    public string NewPassword { get; set; }

    [Required]
    [DataType(DataType.Password)]
    [Display(Name = "Confirm new password")]
    [Compare("NewPassword", ErrorMessage = "The new password and confirmation password do not match.")]
    public string ConfirmPassword { get; set; }

  }

  public class ForgotPasswordViewModel
  {
    public string UserName { get; set; }
    public string CallbackUrl { get; set; }
  }

  public class ResetPasswordViewModel
  {

    //public string UserName { get; set; }

    public string UserId { get; set; }

    [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
    [DataType(DataType.Password)]
    [Display(Name = "Password")]
    public string Password { get; set; }

    [DataType(DataType.Password)]
    [Display(Name = "Confirm password")]
    [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
    public string ConfirmPassword { get; set; }
    public string Code { get; set; }
  }

  public class GoogleProviderModel
  {
    public string Provider { get; set; }
  }

  public class GoogleCallbackParamsModel
  {
    public string State { get; set; }
    public string Code { get; set; }
    public string Scope { get; set; }
    public string AuthUser { get; set; }
    public string Session_State { get; set; }
    public string Prompt { get; set; }
  }

  //public class ConfirmEmailViewModel
  //{
  //    public string Userid { get; set; }
  //    public string Code { get; set; }
  //}

  //public class PrimaryInfoModel
  //{

  //    public string UserId { get; set; }
  //    public string PTitle { get; set; }
  //    public string FirstName { get; set; }
  //    public string LastName { get; set; }
  //    public string EmailID { get; set; }
  //    public string MobileNo { get; set; }
  //    public string Address1 { get; set; }
  //    public string Address2 { get; set; }
  //    public string PostCode { get; set; }
  //    public long? CityID { get; set; }
  //    public long? CountryID { get; set; }
  //    public bool InActive { get; set; }
  //    public string CreatedBy { get; set; }
  //    public DateTime? CreatedDate { get; set; }
  //    public string UpdatedBy { get; set; }
  //    public DateTime? UpdatedDate { get; set; }
  //    public string UserPhoto { get; set; }
  //    public string profilePicBase64 { get; set; }


  //    public virtual DateTime? DOB { get; set; }

  //}

  //public class ResendConfirmEmailViewModel
  //{
  //    public string Userid { get; set; }
  //    public string CallbackUrl { get; set; }
  //}

  //public class RoleViewModel
  //{
  //    public virtual string Name { get; set; }
  //    public virtual string Description { get; set; }
  //}
}