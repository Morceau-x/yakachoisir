using System;
using System.IO;
using System.Web.Mvc;

namespace YakaTicket.Controllers
{
    public class EpitaController : Controller
    {
        // GET: Epita
        public ActionResult Index()
        {
            Request.InputStream.Position = 0;
            var input = new StreamReader(Request.InputStream).ReadToEnd();
            ViewBag.text = input;
            return View();
        }
    }
}