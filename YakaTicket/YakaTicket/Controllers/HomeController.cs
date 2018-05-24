using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace YakaTicket.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Download()
        {
            List<string> l = new List<string>(3);
            l.Add("test.pdf");
            l.Add("test.xlsx");
            l.Add("test.ics");
            return View(l);
        }

        public ActionResult DownloadFile(string filename)
        {
            string path = Server.MapPath("~/Download/");
            if (Path.GetExtension(filename) == ".pdf")
            {
                string logo = Server.MapPath("~/Content/logo_billeterie5.png");
                YakaTicket.Tools.PDFCreator.exportAsPDF(path, filename, logo);
                string fullPath = Path.Combine(path, filename);

                FilePathResult file = File(fullPath, "pdf");
                file.FileDownloadName = filename;
                return file;
            }
            else if (Path.GetExtension(filename) == ".xlsx")
            {
                Tools.XLSCreator.exportAsXLS(path, filename);
                string fullPath = Path.Combine(path, filename);

                FilePathResult file = File(fullPath, "xlsx");
                file.FileDownloadName = filename;
                return file;
            }
            else if (Path.GetExtension(filename) == ".ics")
            {
                var ics = new Tools.ICSCreator();
                StreamWriter sw = new StreamWriter(path + filename);
                sw.Write(ics.exportAsICS());
                sw.Close();

                string fullPath = Path.Combine(path, filename);
                FilePathResult file = File(fullPath, "text");
                file.FileDownloadName = filename;
                return file;
            }
            else
                return new HttpStatusCodeResult(System.Net.HttpStatusCode.Forbidden);
        }
    }
}