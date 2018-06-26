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
        [Route("api/GetUserController/{e}")]
        public List<User> Get(string e)
        {
            List<User> participants = new List<User>();
            List<string> users = new List<string>(); 
            List<object[]> u = Database.Database.database.RequestTable("f_list_participants", 1, e);
            foreach (object[] ev in u)
            {
                users.Add((string)ev[0]);
            }
            foreach (string s in users)
            {
                object[] user = Database.Database.database.RequestLine("f_get_user", 6, s);
                object[] mail = Database.Database.database.RequestLine("f_email", 1, s);
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
                participants.Add(tmp);
            }
            return participants;
        }

        public User Get(string id, string e)
        {
            User u = new User();
            //Recup user
            return u;
        }
    }
}
