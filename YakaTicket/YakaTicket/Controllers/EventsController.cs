using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
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

        [HttpPost]
        public ActionResult ViewEvent(string name)
        {
            Database.Database.database.RequestVoid("f_approve", User.Identity.Name, name);
            return RedirectToAction("ViewEvent", "Events", new { name });
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
                        e.Premium = (bool)row[1];
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
            {
                return RedirectToAction("ModifyEvent", "Events", new {name});
            }
        }

        public ActionResult CreateEvent()
        {
            List<string> ret = new List<string> {""};
            try
            {
                Console.WriteLine(HttpContext.User.Identity.Name);
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
        public ActionResult CreateEvent(Event e)
        {
            if (DalEvent.CreateEvent(e))
            {
                return RedirectToAction("Index", "Home");
            }
            else
                return RedirectToAction("CreateEvent", "Events");
        }


        public ActionResult Payment(string name)
        {
            List<EventPrice> list = new List<EventPrice>();

            try
            {
                List<object[]> tmp = Database.Database.database.RequestTable("f_list_prices", 7, name);
                foreach (var p in tmp)
                {
                    list.Add(new EventPrice
                    {
                        EventName = name,
                        PriceName = (string) p[0],
                        PriceValue = (float) p[1],
                        Number = (int) p[2],
                        MaxNumber = (int) p[3],
                        Assoc = (bool) p[4],
                        Epita = (bool) p[5],
                        Ionis = (bool) p[6]
                    });
                }
            }
            catch (Exception) { }

            ViewBag.list = list;

            return View();
        }

        // GET/Events/AcceptEvent
        [HttpGet]
        public ActionResult AcceptEvent()
        {
            if (!Database.Database.database.RequestBoolean("f_has_assoc", User.Identity.Name) &&
                !Database.Database.database.RequestBoolean("f_is_moderator", User.Identity.Name) &&
                !Database.Database.database.RequestBoolean("f_is_administrator", User.Identity.Name))
            {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.Forbidden);
            }

            List<string> ev = new List<string>();
            List<object[]> list = Database.Database.database.RequestTable("f_list_current_events", 1);
            try
            {
                foreach (var it in list)
                {
                    ev.Add((string)it[0]);
                }
            }
            catch (Exception) { }
            ViewBag.list = ev;
            return View();
        }

        [HttpPost]
        public ActionResult AcceptEvent(Token t)
        {
            string Assoc = "";
            object[] row = Database.Database.database.RequestLine("f_get_event", 6, t.Event);
            try
            {
                Assoc = (string) row[4];
            }
            catch (Exception) { }
            
            if (!Database.Database.database.RequestBoolean("f_is_member", User.Identity.Name, Assoc) &&
                !Database.Database.database.RequestBoolean("f_is_moderator", User.Identity.Name) &&
                !Database.Database.database.RequestBoolean("f_is_administrator", User.Identity.Name))
            {
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.Forbidden);
            }
            
            bool result = Database.Database.database.RequestBoolean("f_enter", t.Login, t.Event);
            if (result)
            {
                HttpContext.Response.Write("Entrée " + t.Event + " : " + t.Login);
            }
            else
            {
                result = Database.Database.database.RequestBoolean("f_leave", t.Login, t.Event);
                if (result)
                {
                    HttpContext.Response.Write("Sortie " + t.Event + " : " + t.Login);
                }
                else
                {
                    HttpContext.Response.Write(t.Login + " n'est pas inscrit.");
                }

            }
            return RedirectToAction("AcceptEvent", "Events");
        }

        public ActionResult DownloadEvent(string name)
        {
            Event ev = new Event {Name = name};
            try
            {
                object[] e = Database.Database.database.RequestLine("f_get_event", 6, name);
                ev.Description = (string) e[0];
                ev.Begin = (DateTime) e[2];
                ev.End = (DateTime) e[3];
                ev.Assoc = (string) e[4];
                ev.Owner = (string) e[5];
            }
            catch (Exception) { }

            string filename = name + ".ics";
            string path = Server.MapPath("~/Download/");
            var ics = new Tools.ICSCreator();
            StreamWriter sw = new StreamWriter(path + filename);
            sw.Write(ics.exportAsICS(ev));
            sw.Close();

            string fullPath = Path.Combine(path, filename);
            FilePathResult file = File(fullPath, "text");
            file.FileDownloadName = filename;
            return file;
        }

        public ActionResult PaymentSuccess()
        {
            string tx = Request.QueryString["tx"];
            string st = Request.QueryString["st"];
            string amt = Request.QueryString["amt"];
            string cc = Request.QueryString["cc"];
            string item = Request.QueryString["item_name"];
            string cm = Request.QueryString["cm"];

            if (!string.IsNullOrEmpty(st) && st.Equals("Completed"))
            {
                ViewBag.item = item;

                bool b = Database.Database.database.RequestBoolean("f_add_participant", HttpContext.User.Identity.Name, cm, item);
                List<object[]> list = Database.Database.database.RequestTable("f_list_participants", 1, cm);
                List<string> participants = new List<string>();
                try
                {
                    foreach (var o in list)
                    {
                        participants.Add((string)o[0]);
                    }
                }
                catch (Exception) { }

                bool t = sendTicket(cm);
                ViewBag.mail = t;

                return View();
            }
            return PaymentFail();
        }

        private bool sendTicket(string ev)
        {
            const string username = "noreply.billetterie@gmail.com";
            const string password = "Qwer!234";

            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
            MailAddress fromaddress = new MailAddress(username);


            SmtpClient smtpclient = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                DeliveryMethod = SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new System.Net.NetworkCredential(username, password),
                EnableSsl = true
            };

            mail.From = fromaddress;

            string email = "";

            try
            {
                email = (string)Database.Database.database.RequestObject("f_email", 1, User.Identity.Name);
            }
            catch (Exception) { }

            if (String.IsNullOrEmpty(email))
                return false;

            mail.To.Add(email);
            mail.Subject = ("Billetterie - Billet pour l'événement " + ev);
            mail.IsBodyHtml = true;
            mail.Body = "Merci pour l'achat du billet " + ev +
                        ". Vous trouverez ci-joint le récapitulatif ainsi que le billet pour entrer à l'événement.\n" +
                        "Vous pouvez retrouver le même document dans votre historique de commande.";


            string path = Server.MapPath("~/Download/");
            string filename = Tools.PDFCreator.MakeTicket(User.Identity.Name, ev, path, Server.MapPath("~/Content/logo_bg1.png"));
            var attachment = new System.Net.Mail.Attachment(Path.Combine(path, filename));
            mail.Attachments.Add(attachment);

            try
            {
                smtpclient.Send(mail);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public ActionResult PaymentFail()
        {
            return View();
        }
    }
}