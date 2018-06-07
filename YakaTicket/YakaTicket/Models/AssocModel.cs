using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace YakaTicket.Models
{
    public class AssocModel
    {

        [Required(ErrorMessage = "Vous devez spécifier un nom pour cet association")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier un résumé pour cet association")]
        public string Summary { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier une école pour cet association")]
        public string School { get; set; }
        public bool Deleted { get; set; }
        public DateTime CreationDate { get; set; }
        public string President { get; set; }

        public AssocModel()
        {

        }

        public AssocModel(string name, string summary, string school, bool deleted, DateTime creationDate, string president)
        {
            Name = name;
            Summary = summary;
            School = school;
            Deleted = deleted;
            CreationDate = creationDate;
            President = president;
        }
    }
}