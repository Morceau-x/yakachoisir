using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;

namespace YakaTicket.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin
        public RedirectToRouteResult Index()
        {
            if (Database.Database.database.RequestBoolean("f_is_moderator", User.Identity.Name))
                return RedirectToAction("ModeratorDashboard", "Admin");
            else
                return RedirectToAction("PresidentDashboard", "Admin");
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

            var other = new List<Models.Event>();
            try
            {
                List<object[]> table = Database.Database.database.RequestTable("f_list_pres_all_events", 7);
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

                    other.Add(e);
                }
            }
            catch (Exception)
            { }
            ViewBag.other = other;
            return View();
        }

        public ActionResult PresidentDashboard()
        {
            var list = new List<Models.Event>();
            try
            {
                string str = (string)Database.Database.database.RequestLine("f_get_president_assoc", 1, User.Identity.Name)[0];
                List<object[]> table = Database.Database.database.RequestTable("f_list_pres_events", 7, str);
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


            string path = Server.MapPath("~/Download/");


            ViewBag.list = list;
            return View();
        }

        public ActionResult ExternList()
        {
            if (!Request.IsAuthenticated)
            {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.Forbidden);
            }
            if (!(Database.Database.database.RequestBoolean("f_is_moderator", User.Identity.GetUserName()) ||
                Database.Database.database.RequestBoolean("f_is_administrator", User.Identity.GetUserName())))
            {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.Forbidden);
            }
            string path = Server.MapPath("~/Download/");
            string filename = Tools.XLSCreator.externAsXLS(path);
            string fullPath = Path.Combine(path, filename);
            FilePathResult file = File(fullPath, "xlsx");
            file.FileDownloadName = filename;
            return file;
        }
    }
}