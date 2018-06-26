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
        public string Get(string login, string mdp)
        {
            // Authentication
            return login;
        }
    }
}
