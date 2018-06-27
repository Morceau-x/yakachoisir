using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class Token
    {
        [Required(ErrorMessage = "Vous devez spécifier un nom pour cet événement")]
        public string Event { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier un login pour cet événement")]
        public string Login { get; set; }
    }
}