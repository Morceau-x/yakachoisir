using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class DalEvent
    {

        public DalEvent()
        {
        }

        public static List<string> GetAllEvents()
        {
            try
            {
                List<object[]> events = Database.Database.database.RequestTable("f_list_future_events", 1);

                List<string> ret = new List<string>();
                foreach (object[] item in events)
                {
                    ret.Add((string)item[0]);
                }
                return ret;
            }
            catch (Exception)
            { }

            return new List<string>();
        }

        public static bool ModifyEvent(string user, string name, string description, DateTime begin, DateTime end)
        {
            bool result = false;
            try
            {
                result = Database.Database.database.RequestBoolean("f_edit_event", user, name, description, begin.ToString("yyyy-MM-dd HH:mm:ss"), end.ToString("yyyy-MM-dd HH:mm:ss"));
            }
            catch { }

            return result;
        }

        public static void CreateEvent(string user, string name, string description, DateTime begin, DateTime end, string assoc)
        {
            try
            {
                Database.Database.database.RequestVoid("f_create_event", user, name, description, begin.ToString("yyyy-MM-dd HH:mm:ss"), end.ToString("yyyy-MM-dd HH:mm:ss"), assoc);
            }
            catch { }
        }

        public static bool CreateEvent(Event e)
        {
            bool result = false;
            try
            {
                result = Database.Database.database.RequestBoolean("f_create_event", e.Owner, e.Name, e.Description, e.Begin.ToString("yyyy-MM-dd HH:mm:ss"), e.End.ToString("yyyy-MM-dd HH:mm:ss"), e.Assoc);
            }
            catch { }

            return result;
        }
    }
}