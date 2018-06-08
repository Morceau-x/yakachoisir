using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace YakaTicket.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        public RedirectToRouteResult Index()
        {
            return RedirectToAction("ModeratorDashboard", "Admin");
        }

        public ActionResult ModeratorDashboard()
        {
            var list = new List<Models.Event>();
            try
            {
                List<object[]> table = Database.Database.database.RequestTable("f_list_mod_events", 7);
                foreach (var row in table)
                {
                    var e = new Models.Event()
                    {
                        Name = (string)row[0],
                        Description = (string)row[1],
                        Premium = (bool)row[2],
                        Begin = (DateTime)row[3],
                        End = (DateTime)row[4],
                        Assoc = (string)row[5],
                        Owner = (string)row[6]
                    };

                    list.Add(e);
                }
            }
            catch (Exception)
            { }

            ViewBag.list = list;
            return View();
        }
    }
}