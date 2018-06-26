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
        public List<Event> Get(string id)
        {
            List<Event> events = new List<Event>();

            return events;
        }
    }
}
