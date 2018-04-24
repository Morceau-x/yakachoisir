using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class DalEvent
    {
        private BddContext bdd;

        public DalEvent()
        {
            bdd = new BddContext();
        }

        public List<Event> GetAllEvents()
        {
            return bdd.Events.ToList();
        }

        public void Dispose()
        {
            bdd.Dispose();
        }

        public void ModifyEvent(int id, String name, String dateBegin, String hour, int duration)
        {
            Event e = GetAllEvents().FirstOrDefault(r => r.Id == id);
            if (e != null)
            {
                e.Name = name;
                e.Duration = duration;
                e.DateBegin = dateBegin;
                e.Hour = hour;
                bdd.SaveChanges();
            }
        }
    }
}