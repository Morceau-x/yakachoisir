using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class Event
    {
        //Mandatory
        [Required(ErrorMessage = "Vous devez spécifier un nom pour cet événement")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier une association pour cet événement")]
        public string Assoc { get; set; }
        public bool Premium { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier un créateur pour cet événement")]
        public string Owner { get; set; }
        [Required(ErrorMessage = "Vous devez ajouter une description")]
        public string Description { get; set; }
        [DisplayFormat(DataFormatString = "{0:d}")]
        [Required(ErrorMessage = "Vous devez spécifier une date de début")]
        public DateTime Begin { get; set; }
        [DisplayFormat(DataFormatString = "{0:d}")]
        [Required(ErrorMessage = "Vous devez spécifier une date de fin")]
        public DateTime End { get; set; }

        public Event ()
        {

        }

        public Event(string assoc, string owner, string name, string description, DateTime begin, DateTime end)
        {
            Assoc = assoc;
            Name = name;
            Description = description;
            Begin = begin;
            End = end;
            Owner = owner;
        }
    }
}