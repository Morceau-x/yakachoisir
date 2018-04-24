using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace YakaTicket.Models
{
    public class BddContext : DbContext
    {
        public DbSet<Event> Events { get; set; }
    }
}