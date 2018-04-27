using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class Event
    {
        //Mandatory
        public int Id { get; set; }
        public String Name { get; set; }
        public String Description { get; set; }
        public DateTime Begin { get; set; }
        public DateTime End { get; set; }
        public String Location { get; set; }
        public DateTime Close { get; set; }
        public int ExternPlaces { get; set; }
        public int InternPlaces { get; set; }
        public float ExternPrice { get; set; }
        public float InternPrice { get; set; }
        public bool UniquePrice { get; set; } = false;
        public bool LeftPlaces { get; set; } = false;

        //Optionnal
        public String PromotionPic { get; set; } = null;

    }
}