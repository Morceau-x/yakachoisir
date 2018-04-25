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

        public void ModifyEvent(int id, String name, String dateBegin, String hourBegin, String dateEnd, String hourEnd)
        {
            Event e = GetAllEvents().FirstOrDefault(r => r.Id == id);
            if (e != null)
            {
                e.Name = name;
                e.DateBegin = dateBegin;
                e.HourBegin = hourBegin;
                e.DateEnd = dateEnd;
                e.HourEnd = hourEnd;
                bdd.SaveChanges();
            }
        }

        public void CreateEvent(String name, String dateBegin, String hourBegin, String dateEnd, String hourEnd)
        {
            bdd.Events.Add(new Event { Name = name, DateBegin = dateBegin, HourBegin = hourBegin, DateEnd = dateEnd, HourEnd = hourEnd});
            bdd.SaveChanges();
        }
    }
}