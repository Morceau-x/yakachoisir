using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using YakaTicket.Models;

namespace YakaTicket.Controllers
{
    public class EventsController : Controller
    {

        public RedirectToRouteResult Index()
        {
            string name = Request.QueryString["name"];
            if (name != null && name != "")
                return RedirectToAction("ViewEvent", "Events", new { name });
            else
                return RedirectToAction("ListEvent", "Events");
        }

        public ActionResult ViewEvent()
        {
            string name = Request.QueryString["name"];
            if (name != null && name != "")
            {
                Event e = new Event();
                e.Name = name;
                try
                {
                    object[] row = Database.Database.database.RequestLine("f_get_event", 6, name);
                    if (row != null)
                    {
                        e.Description = (string)row[0];
                        e.Begin = (DateTime)row[2];
                        e.End = (DateTime)row[3];
                        e.Assoc = (string)row[4];
                        e.Owner = (string)row[5];
                    }
                }
                catch (Exception ex)
                { }
                return View(e);
            }
            return RedirectToAction("ListEvent", "Events");
        }

        public ActionResult ListEvent()
        {
            ViewBag.list = new List<Event>();
            string name = Request.QueryString["name"];
            List<string> events = DalEvent.GetAllEvents();
            List<Event> eventList = new List<Event>();
            foreach (string s in events)
            {
                Event e = new Event();
                e.Name = s;
                try
                {
                    object[] row = Database.Database.database.RequestLine("f_get_event", 6, s);
                    if (row != null)
                    {
                        e.Description = (string)row[0];
                        e.Begin = (DateTime)row[2];
                        e.End = (DateTime)row[3];
                        e.Assoc = (string)row[4];
                        e.Owner = (string)row[5];
                    }
                }
                catch (Exception ex)
                { }
                eventList.Add(e);
            }
            if (name != null && name != "")
            {
                foreach (Event s in eventList)
                {
                    if (s.Name.ToLower().Contains(name.ToLower()))
                        ViewBag.list.Add(s);
                    else if (s.Assoc.ToLower().Contains(name.ToLower()))
                        ViewBag.list.Add(s);
                }
            }
            else
            {
                ViewBag.list = eventList;
            }
            return View();
        }

        public ActionResult ModifyEvent()
        {
            string name = Request.QueryString["name"];
            if (name != null && name != "")
            {
                Event e = new Event();
                e.Name = name;
                try
                {
                    object[] row = Database.Database.database.RequestLine("f_get_event", 6, name);
                    if (row != null)
                    {
                        e.Description = (string)row[0];
                        e.Begin = (DateTime)row[2];
                        e.End = (DateTime)row[3];
                        e.Assoc = (string)row[4];
                        e.Owner = (string)row[5];
                    }
                }
                catch (Exception ex)
                { }
                return View(e);
            }
            return RedirectToAction("ListEvent", "Events");
        }

        [HttpPost]
        public ActionResult ModifyEvent(string user, string name, string description, DateTime begin, DateTime end)
        {
            DalEvent.ModifyEvent(user, name, description, begin, end);
            return RedirectToAction("Index", "Home");
        }

        public ActionResult CreateEvent()
        {
            List<string> ret = new List<string>();
            ret.Add("");
            try
            {
                List<object[]> events = Database.Database.database.RequestTable("f_list_assocs", 1);

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
        public ActionResult CreateEvent(Event e)
        {
            if (ModelState.IsValid) 
            {
                DalEvent.CreateEvent(e);
                return RedirectToAction("Index", "Home");
            }
            else
            {
                return View(e);
            }

        }
    }
}