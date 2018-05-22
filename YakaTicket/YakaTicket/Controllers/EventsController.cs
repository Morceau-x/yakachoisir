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
                Models.Event e = dalevent.GetAllEvents().FirstOrDefault(r => r.Id == id.Value);
  
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
                Models.Event e = dalevent.GetAllEvents().FirstOrDefault(r => r.Id == id.Value);
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
                Models.DalEvent dalevent = new Models.DalEvent();
                dalevent.ModifyEvent(id.Value, name, description, begin, end, location, close, externPlaces, internPlaces, externPrice,
                                     internPrice, uniquePrice, leftPlace, promotionPic);
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