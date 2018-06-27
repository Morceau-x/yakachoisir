using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace YakaTicket.Controllers
{
    public class EnterUserController : ApiController
    {
        public IHttpActionResult Get(string id, string e)
        {
            bool response = Database.Database.database.RequestBoolean("f_enter", id, e);
            if (response)
                return Ok();
            else
                return NotFound();
        }
    }
}
