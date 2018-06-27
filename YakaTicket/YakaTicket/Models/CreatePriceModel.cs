using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class CreatePriceModel
    {
        public string Login { get; set; }
        public string Event { get; set; }
        public string Name { get; set; }
        public float Price { get; set; }
        public int MaxNumber { get; set; }
        public bool AssocOnly { get; set; }
        public bool EpitaOnly { get; set; }
        public bool IonisOnly { get; set; }
    }
}