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
            if (!string.IsNullOrEmpty(name))
                return RedirectToAction("ViewEvent", "Events", new { name });
            else
                return RedirectToAction("ListEvent", "Events");
        }

        public ActionResult ViewEvent()
        {
            string name = Request.QueryString["name"];
            if (!string.IsNullOrEmpty(name))
            {
                Event e = new Event { Name = name };
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
                catch (Exception)
                { }

                ViewBag.name = name;
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
                Event e = new Event { Name = s };
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
                catch (Exception)
                { }
                eventList.Add(e);
            }
            if (!string.IsNullOrEmpty(name))
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
            if (!string.IsNullOrEmpty(name))
            {
                Event e = new Event { Name = name };
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
                catch (Exception)
                { }
                return View(e);
            }
            return RedirectToAction("ListEvent", "Events");
        }

        [HttpPost]
        public ActionResult ModifyEvent(string user, string name, string description, DateTime begin, DateTime end)
        {
            if (!DalEvent.ModifyEvent(user, name, description, begin, end))
                return RedirectToAction("Index", "Home");
            else
                return RedirectToAction("ModifyEvent", "Events", new { name });
        }

        public ActionResult CreateEvent()
        {
            List<string> ret = new List<string> {""};
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
            if (DalEvent.CreateEvent(e)) 
                return RedirectToAction("Index", "Home");
            else
                return RedirectToAction("CreateEvent", "Events");
        }

        public ActionResult Payment(string name)
        {
            List<EventPrice> list = new List<EventPrice>();

            try
            {
                List<object[]> tmp = Database.Database.database.RequestTable("f_list_prices", 6, name);
                foreach (var p in tmp)
                {
                    list.Add(new EventPrice
                    {
                        PriceName = (string) p[0],
                        PriceValue = (float) p[1],
                        MaxNumber = (int) p[2],
                        Assoc = (bool) p[3],
                        Epita = (bool) p[4],
                        Ionis = (bool) p[5]
                    });
                }
            }
            catch (Exception) { }

            ViewBag.list = list;

            return View();
        }
    }
}