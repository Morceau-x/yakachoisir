using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class Event
    {
        public int Id { get; set; }
        public String Name { get; set; }
        public String DateBegin { get; set; }
        public String Hour { get; set; }
        public int Duration { get; set; }
    }
}