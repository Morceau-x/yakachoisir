using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using YakaTicket.Models;
using Microsoft.AspNet.Identity;
using YakaTicket.Database;

namespace YakaTicket.Controllers
{
    public class AssocController : Controller
    {
        // GET: Assoc
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult DashBoard()
        {
            string name = Request.QueryString["name"];
            if (!string.IsNullOrEmpty(name))
            {
                AssocModel e = new AssocModel { Name = name };
                try
                {
                    object[] row = Database.Database.database.RequestLine("f_get_assoc", 3, name);
                    if (row != null)
                    {
                        e.Summary = (string)row[0];
                        e.School = (string)row[1];
                        e.President = (string)row[2];
                    }
                    else
                        return View("NoAssoc");
                }
                catch (Exception)
                { }
                ViewBag.assoc = e;
                return View();
            }
            return RedirectToAction("DashBoardList", "Assoc");
        }

        public ActionResult DashBoardList()
        {
            List<string> ret = new List<string>();
            try
            {
                string login = User.Identity.GetUserName();
                List<object[]> assocs = Database.Database.database.RequestTable("f_assocs", 1, login);
                if (assocs == null)
                    return View("NoAssoc");
                foreach (object[] item in assocs)
                {
                    ret.Add((string)item[0]);
                }
            }
            catch (Exception)
            { }

            ViewBag.list = ret;
            return View();
        }

        public ActionResult NoAssoc()
        {
            return View();
        }

        public ActionResult AddMember()
        {
            string name = Request.QueryString["name"];
            ViewBag.user = "";
            string user = User.Identity.GetUserName();
            if (!string.IsNullOrEmpty(name))
            {
                AssocModel e = new AssocModel { Name = name };
                try
                {
                    object[] row = Database.Database.database.RequestLine("f_get_assoc", 3, name);
                    if (row != null)
                    {
                        e.Summary = (string)row[0];
                        e.School = (string)row[1];
                        e.President = (string)row[2];
                    }
                    else
                        return View("NoAssoc");
                }
                catch (Exception)
                { }
                ViewBag.assoc = e;
                return View();
            }
            return View("DashBoardList");
        }

        [HttpPost]
        public ActionResult AddMember(AssocAdd e)
        {
            string name = Request.QueryString["name"];
            string user = User.Identity.GetUserName();
            if (!string.IsNullOrEmpty(e.login) && !string.IsNullOrEmpty(name))
            {
                bool response = Database.Database.database.RequestBoolean("f_set_member", user, e.login, name);
                if (response)
                    return RedirectToAction("DashBoard", "Assoc", new { name });
                else
                    ViewBag.user = "L'utilisateur n'existe pas";
            }
            return View("NoAssoc");
        }

        public class AssocAdd
        {
            public string login;
        }
    }
}