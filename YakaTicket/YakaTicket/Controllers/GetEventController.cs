using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using YakaTicket.Models;

namespace YakaTicket.Controllers
{
    public class GetEventController : ApiController
    {
        public List<string> Get(string id)
        {
            List<string> events = new List<string>();
            List<object[]> u = Database.Database.database.RequestTable("f_list_current_moderable_events", 1, id);
            foreach (object[] ev in u)
            {
                events.Add((string)ev[0]);
            }
            return events;
        }
    }
}
