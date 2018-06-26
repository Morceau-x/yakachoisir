using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using YakaTicket.Models;

namespace YakaTicket.Controllers
{
    public class GetUserController : ApiController
    {
        [Route("api/GetUser/{e}")]
        public User Get(string e)
        {
            object[] user = Database.Database.database.RequestLine("f_get_user", 6, e);
            object[] mail = Database.Database.database.RequestLine("f_email", 1, e);
            User tmp = new User
            {
                    Ionis = (bool)user[0],
                    Epita = (bool)user[1],
                    Firstname = (string)user[2],
                    Lastname = (string)user[3],
                    Address = (string)user[4],
                    PhoneNumber = (string)user[5],
                    Id = User.Identity.Name,
                    Mail = (string)mail[0]
            };
            return tmp;
        }

        public User Get(string id, string e)
        {
            User u = new User();
            //Recup user
            return u;
        }
    }
}
