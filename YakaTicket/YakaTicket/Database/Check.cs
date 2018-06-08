using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using YakaTicket.Models;

namespace YakaTicket.Database
{
    public class Check
    {
        public static bool CanCreateEvent(string user)
        {
            bool result = false;
            try
            {
                result = Database.database.RequestBoolean("f_has_assoc", user);
            }
            catch { }
            return result;
        }

        public static bool CanEditEvent(string user, string name)
        {
            bool result = false;
            try
            {
                result = Database.database.RequestBoolean("f_can_edit_event", user, name);
            }
            catch { }
            return result;
        }
    }
}