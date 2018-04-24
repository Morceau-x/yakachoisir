using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace YakaTicket.Controllers
{
    public class EventsController : Controller
    {
        public ActionResult ModifyEvent(int? id)
        {
            if (id.HasValue)
            {
                Models.DalEvent dalevent = new Models.DalEvent();
                Models.Event e = dalevent.GetAllEvents().FirstOrDefault(r => r.Id == id.Value);
                if (e == null)
                    return View("NoEvent");
                return View(e);
            }
            else
                return View("NoEvent");
        }

        [HttpPost]
        public ActionResult ModifyEvent(int? id, string name, string datebegin, string hour, int duration)
        {
            if (id.HasValue)
            {
                Models.DalEvent dalevent = new Models.DalEvent();
                dalevent.ModifyEvent(id.Value, name, datebegin, hour, duration);
                return RedirectToAction("Home/Index");
            }
            else
                return View("NoEvent");
        }
    }
}