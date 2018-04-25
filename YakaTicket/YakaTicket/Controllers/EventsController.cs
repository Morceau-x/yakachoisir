using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace YakaTicket.Controllers
{
    public class EventsController : Controller
    {

        Models.DalEvent dalevent = new Models.DalEvent();

        public ActionResult Index()
        {
            if (dalevent == null || dalevent.GetAllEvents() == null)
                return View("CreateEvent");
            return View();
        }

        public ActionResult ModifyEvent(int? id)
        {
            if (id.HasValue)
            {
                Models.Event e = dalevent.GetAllEvents().FirstOrDefault(r => r.Id == id.Value);
                if (e == null)
                    return View("NoEvent");
                return View(e);
            }
            else
                return View("NoEvent");
        }

        [HttpPost]
        public ActionResult ModifyEvent(int? id, string name, string datebegin, string hourbegin, string dateend, string hourend)
        {
            if (id.HasValue)
            {
                Models.DalEvent dalevent = new Models.DalEvent();
                dalevent.ModifyEvent(id.Value, name, datebegin, hourbegin, dateend, hourend);
                return RedirectToAction("Home/Index");
            }
            else
                return View("NoEvent");
        }

        public ActionResult CreateEvent()
        {
            return View();
        }


        [HttpPost]
        public ActionResult CreateEvent(Models.Event e)
        {

            if (ModelState.IsValid) 
            {
                dalevent.CreateEvent(e.Name, e.DateBegin, e.HourBegin, e.DateEnd, e.HourBegin);
                return RedirectToAction("Home/Index");
            }
            else
            {
                return View(e);
            }

        }
    }
}