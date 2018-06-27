using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace YakaTicket.Models
{
    public class ExternalLoginConfirmationViewModel
    {
        [Required]
        [Display(Name = "Adresse mail")]
        public string Email { get; set; }
    }

    public class ExternalLoginListViewModel
    {
        public string ReturnUrl { get; set; }
    }

    public class SendCodeViewModel
    {
        public string SelectedProvider { get; set; }
        public ICollection<System.Web.Mvc.SelectListItem> Providers { get; set; }
        public string ReturnUrl { get; set; }
        public bool RememberMe { get; set; }
    }

    public class VerifyCodeViewModel
    {
        [Required]
        public string Provider { get; set; }

        [Required]
        [Display(Name = "Code")]
        public string Code { get; set; }
        public string ReturnUrl { get; set; }

        [Display(Name = "Mémoriser ce navigateur?")]
        public bool RememberBrowser { get; set; }

        public bool RememberMe { get; set; }
    }

    public class ForgotViewModel
    {
        [Required]
        [Display(Name = "Adresse mail")]
        public string Email { get; set; }
    }

    public class LoginViewModel
    {
        [Required]
        [Display(Name = "Pseudonyme")]
        public string Pseudo { get; set; }

        [Required]
        //[DataType(DataType.Password)]
        [Display(Name = "Mot de passe")]
        public string Password { get; set; }

        [Display(Name = "Rester connecté?")]
        public bool RememberMe { get; set; }
    }

    public class RegisterViewModel
    {
        [Required]
        [EmailAddress]
        [Display(Name = "Adresse mail")]
        public string Email { get; set; }

        [Required]
        [Display(Name = "Pseudonyme")]
        public string Pseudo { get; set; }

        [Required]
        [Display(Name = "Nom")]
        public string Nom { get; set; }

        [Required]
        [Display(Name = "Prenom")]
        public string Prenom { get; set; }

        [Required]
        //[StringLength(100, ErrorMessage = "Le {0} doit contenir au moins {2} caractères.", MinimumLength = 6)]
        //[DataType(DataType.Password)]
        [Display(Name = "Mot de passe")]
        public string Password { get; set; }

        //[DataType(DataType.Password)]
        [Display(Name = "Confirmation mot de passe")]
        [Compare("Password", ErrorMessage = "Le mot de passe et la confirmations sont différents.")]
        public string ConfirmPassword { get; set; }
    }

    public class ResetPasswordViewModel
    {
        [Required]
        [EmailAddress]
        [Display(Name = "Adresse mail")]
        public string Email { get; set; }

        [Required]
        //[StringLength(100, ErrorMessage = "Le {0} doit contenir au moins {2} caractères.", MinimumLength = 6)]
        //[DataType(DataType.Password)]
        [Display(Name = "Mot de passe")]
        public string Password { get; set; }

        //[DataType(DataType.Password)]
        [Display(Name = "Confirmation mot de passe")]
        [Compare("Password", ErrorMessage = "Le mot de passe et la confirmations sont différents.")]
        public string ConfirmPassword { get; set; }

        public string Code { get; set; }
    }

    public class ForgotPasswordViewModel
    {
        [Required]
        [EmailAddress]
        [Display(Name = "Adresse mail")]
        public string Email { get; set; }
    }
}
