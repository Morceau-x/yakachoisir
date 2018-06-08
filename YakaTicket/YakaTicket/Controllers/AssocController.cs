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
            string error = Request.QueryString["error"];
            if (!string.IsNullOrEmpty(name))
                ViewBag.user = error;
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
            string error = "L'utilisateur n'existe pas ou est déja présent";
            if (!string.IsNullOrEmpty(e.login) && !string.IsNullOrEmpty(name))
            {
                bool response = Database.Database.database.RequestBoolean("f_set_member", user, e.login, name);
                if (response)
                    return RedirectToAction("DashBoard", "Assoc", new { name });
                else
                    return RedirectToAction("AddMember", "Assoc", new { name, error });
            }
            return View("NoAssoc");
        }

        public ActionResult DeleteMember()
        {
            string name = Request.QueryString["name"];
            ViewBag.user = "";
            string error = Request.QueryString["error"];
            if (!string.IsNullOrEmpty(error))
                ViewBag.user = error;
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
        public ActionResult DeleteMember(AssocAdd e)
        {
            string name = Request.QueryString["name"];
            string user = User.Identity.GetUserName();
            string error = "L'utilisateur n'existe pas ou ne fait pas partie de l'association";
            if (!string.IsNullOrEmpty(e.login) && !string.IsNullOrEmpty(name))
            {
                bool response = Database.Database.database.RequestBoolean("f_remove_member", user, e.login, name);
                if (response)
                    return RedirectToAction("DashBoard", "Assoc", new { name });
                else
                    return RedirectToAction("DeleteMember", "Assoc", new { name, error });
            }
            return View("NoAssoc");
        }

        public class AssocAdd
        {
            public string login { get; set; }
        }

        public ActionResult ViewMembers()
        {
            string name = Request.QueryString["name"];
            string user = User.Identity.GetUserName();
            if (!string.IsNullOrEmpty(name))
            {
                try
                {
                    List<object[]> assocs = Database.Database.database.RequestTable("f_list_assocs", 1);
                    if (assocs != null)
                    {
                        List<string> ret = new List<string>();
                        foreach (object[] item in assocs)
                        {
                            ret.Add((string)item[0]);
                        }
                        if (!ret.Contains(name))
                            return View("NoAssoc");
                    }
                    else
                        return View("NoAssoc");
                    List<object[]> members = Database.Database.database.RequestTable("f_get_members", 1, name);
                    if (members != null)
                    {
                        List<string> ret = new List<string>();
                        foreach (object[] item in members)
                        {
                            ret.Add((string)item[0]);
                        }
                        ViewBag.list = ret;
                    }
                    List<object[]> desk = Database.Database.database.RequestTable("f_get_desk", 1, name);
                    if (desk != null)
                    {
                        List<string> ret = new List<string>();
                        foreach (object[] item in desk)
                        {
                            ret.Add((string)item[0]);
                        }
                        ViewBag.desk = ret;
                    }
                    List<object[]> pres = Database.Database.database.RequestTable("f_get_president", 1, name);
                    if (pres != null)
                    {
                        List<string> ret = new List<string>();
                        foreach (object[] item in pres)
                        {
                            ret.Add((string)item[0]);
                        }
                        ViewBag.pres = ret;
                    }
                }
                catch (Exception)
                { }
                return View();
            }
            return View("NoAssoc");
        }

        public ActionResult CreateAssoc()
        {
            List<string> ret = new List<string> { "" };
            try
            {
                // TODO recup list of schools
                List<object[]> events = Database.Database.database.RequestTable("f_assocs", 1, HttpContext.User.Identity.Name);

                foreach (object[] item in events)
                {
                    ret.Add((string)item[0]);
                }

            }
            catch { }

            ViewBag.list = ret;
            return View();
        }

        [HttpPost]
        public ActionResult CreateEvent(AssocModel e)
        {
            bool result = false;
            try
            {
                result = Database.Database.database.RequestBoolean("f_create_event", e.Name, e.Summary, e.School);
            }
            catch { }

            if (result)
                return RedirectToAction("Index", "Home");
            else
                return RedirectToAction("CreateAssoc", "Assoc");
        }
    }
}