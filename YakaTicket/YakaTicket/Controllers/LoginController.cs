using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace YakaTicket.Controllers
{
    public class LoginController : ApiController
    {
        [Route("api/GetLogin/{login}/{mdp}")]
        public IHttpActionResult Get(string login, string mdp)
        {
            // Authentication
            Boolean response = Database.Database.database.RequestBoolean("f_regular_connect", login, mdp);
            if (response)
                return Ok(login);
            else
                return NotFound();
        }
    }
}
