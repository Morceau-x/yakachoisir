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
        public int Id { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier un titre pour cet événement")]
        public String Name { get; set; }
        [Required(ErrorMessage = "Vous devez ajouter une description")]
        public String Description { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier une date de début")]
        public DateTime Begin { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier une date de fin")]
        public DateTime End { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier un lieu pour cet événement")]
        public String Location { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier une date de cloture des inscriptions")]
        public DateTime Close { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier le nombre de places externes")]
        [Range(0, 150 , ErrorMessage = "Le nombre de places externes doit être compris entre 0 et 150")]
        public int ExternPlaces { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier le nombre de places internes")]
        [Range(0, 450, ErrorMessage = "Le nombre de places internes doit être compris entre 0 et 450")]
        public int InternPlaces { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier le prix pour les externes")]
        public float ExternPrice { get; set; }
        [Required(ErrorMessage = "Vous devez spécifier le prix pour les internes")]
        public float InternPrice { get; set; }
        public bool UniquePrice { get; set; } = false;
        public bool LeftPlaces { get; set; } = false;

        //Optionnal
        public String PromotionPic { get; set; } = null;

    }
}