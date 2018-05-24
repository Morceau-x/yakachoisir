using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace YakaTicket.Tools
{
    public class ICSCreator
    {
        public DateTime DateStart { get; set; } = DateTime.Now;
        public DateTime DateEnd { get; set; } = DateTime.Now.AddMinutes(105);
        public string Organizer { get; set; } = "";
        public string OrganizerEmail { get; set; } = "";
        public string Summary { get; set; } = "summary text";
        public string Location { get; set; } = "Event location";
        public string Description { get; set; } = "Event description";
        public string FileName { get; set; } = "calendar";
        public int Priority { get; set; } = 0;


        public string exportAsICS()
        {
            //create a new stringbuilder instance
            StringBuilder sb = new StringBuilder();

            //start the calendar item
            sb.AppendLine("BEGIN:VCALENDAR");
            sb.AppendLine("VERSION:2.0");
            sb.AppendLine("PRODID:BilleterieEPITA");
            
            //add the event
            sb.AppendLine("BEGIN:VEVENT");
            
            //DTSTART: Date de début de l'événement
            sb.AppendLine("DTSTART;TZID=Europe/Paris:" + DateStart.ToString("yyyyMMddTHHmm00"));
            //sb.AppendLine("DTSTART:" + DateStart.ToString("yyyyMMddTHHmm00"));
            //DTEND: Date de fin de l'événement
            sb.AppendLine("DTEND;TZID=Europe/Paris:" + DateEnd.ToString("yyyyMMddTHHmm00"));
            //sb.AppendLine("DTEND:" + DateEnd.ToString("yyyyMMddTHHmm00"));

            sb.AppendLine("ORGANIZER:CN=" + Organizer + ":MAILTO:" + OrganizerEmail);

            //SUMMARY: Titre de l'événement
            sb.AppendLine("SUMMARY:" + Summary + "");
            //LOCATION: Lieu de l'événement
            sb.AppendLine("LOCATION:" + Location + "");
            //DESCRIPTION: Description de l'événement
            sb.AppendLine("DESCRIPTION:" + Description + "");

            //CATEGORIES: Catégorie de l'événement (ex: Conférence, Fête...)
            //STATUS: Statut de l'événement (TENTATIVE, CONFIRMED, CANCELLED)
            //TRANSP: Définit si la ressource affectée à l'événement est rendu indisponible (OPAQUE, TRANSPARENT)
            //SEQUENCE: Nombre de mises à jour, la première mise à jour est à 1


            sb.AppendLine("PRIORITY:" + Priority.ToString());

            sb.AppendLine("END:VEVENT");

            //end calendar item
            sb.AppendLine("END:VCALENDAR");

            //create a string from the stringbuilder
            string CalendarItem = sb.ToString();
            return CalendarItem;
            //send the calendar item to the browser
            /*
            Response.ClearHeaders();
            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "text/calendar";
            Response.AddHeader("content-length", CalendarItem.Length.ToString());
            Response.AddHeader("content-disposition", "attachment; filename=\"" + FileName + ".ics\"");
            Response.Write(CalendarItem);
            Response.Flush();
            HttpContext.Current.ApplicationInstance.CompleteRequest();
            */
        }
    }
}