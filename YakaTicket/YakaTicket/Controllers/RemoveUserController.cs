using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace YakaTicket.Controllers
{
    public class RemoveUserController : ApiController
    {
        public void Post(string id, string e)
        {
            //Get user
            string login = "test";
            bool response = Database.Database.database.RequestBoolean("f_leave", login, e);
        }
    }
}
