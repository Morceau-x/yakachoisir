using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace YakaTicket.Controllers
{
    public class GetParticipantsController : ApiController
    {
        [Route("api/GetParticipants/{e}")]
        public List<string> Get(string e)
        {
            List<string> participants = new List<string>();
            List<object[]> u = Database.Database.database.RequestTable("f_list_participants", 1, e);
            foreach (object[] ev in u)
            {
                participants.Add((string)ev[0]);
            }
            return participants;
        }
    }
}
