using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class User
    {
        public bool Ionis { get; set; }
        public bool Epita { get; set; }
        public string Firstname { get; set; }
        public string Lastname { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public string Id { get; set; }
        public string Mail { get; set; }
    }
}