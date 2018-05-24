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

        public ActionResult ViewEvent(int? id)
        {
            if (id.HasValue)
            {
                //Models.Event e = dalevent.GetAllEvents().FirstOrDefault(r => r.Id == id.Value);
                Models.Event e = null
                if(id == 0)
                {
                    e = new Models.Event(0, "test", "event test", DateTime.Now, DateTime.Now, "Villejuif", DateTime.Now, 200, 250, 2.0f, 0.0f,
                        false, true, "no");
                        }
                if (e == null)
                    return View("NoEvent");
                return View(e);
            }
            else
                return View("NoEvent");
        }

        public ActionResult ModifyEvent(int? id)
        {
            if (id.HasValue)
            {
                Database.DataEvent de = (Database.DataEvent)Database.Database.database.RequestObject("f_get_event",
                                                                                  new List<Object> { 0 /* FIXME user_id*/, id });
                /* FIXME replace "test" by real value */
                Models.Event e = new Models.Event(de.Id, de.name, de.summary, de.begin_date, de.end_date, "test", de.end_date /*FIXME*/,
                                                  0, 0, 0, 0, false, false, "test");
                if (e == null)
                    return View("NoEvent");
                return View(e);
            }
            else
                return View("NoEvent");
        }

        public ActionResult ListEvent()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ModifyEvent(int? id, string name, string description, DateTime begin, DateTime end, string location,
                                        DateTime close, int externPlaces, int internPlaces, float externPrice, float internPrice,
                                        bool uniquePrice, bool leftPlace, String promotionPic)
        {
            if (id.HasValue)
            {
                /* FIXME Edit event */
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
                /*dalevent.CreateEvent(e.Name, e.Description, e.Begin, e.End, e.Location, e.Close, e.ExternPlaces, e.InternPlaces,
                                     e.ExternPrice, e.InternPrice, e.UniquePrice, e.LeftPlaces, e.PromotionPic);*/
                Database.Database.database.RequestVoid("f_create_event",
                                                       new List<Object> { 0 /* FIXME user_id*/, e.Name, e.Description, e.Begin,
                                                       e.End, "test"});
                return RedirectToAction("Home/Index");
            }
            else
            {
                return View(e);
            }

        }
    }
}