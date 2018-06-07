using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;

namespace YakaTicket.Models
{
    public class EventPrice
    {
        public string PriceName { get; set; }
        public float PriceValue { get; set; }
        public int MaxNumber { get; set; }
        public bool Assoc { get; set; }
        public bool Epita { get; set; }
        public bool Ionis { get; set; }

        public string PriceValueS
        {
            get
            {
                Thread.CurrentThread.CurrentCulture = new CultureInfo("fr-FR");
                return PriceValue.ToString("C");
            }
        }
    }
}