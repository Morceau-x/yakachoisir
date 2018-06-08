using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using DayPilot.Web.Mvc;
using DayPilot.Web.Mvc.Enums;
using DayPilot.Web.Mvc.Events.Calendar;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using YakaTicket.Models;

namespace YakaTicket.Controllers
{
    public class CalendarController : Controller
    {

        public ActionResult Backend()
        {
            return new Dpc().CallBack(this);
        }

        class Dpc : DayPilotCalendar
        {
            

            protected override void OnInit(InitArgs e)
            {
                
                Update();
            }

            protected override void OnBeforeEventRender(BeforeEventRenderArgs e)
            {
                if(e.Id == "0")
                {
                    e.BackgroundColor = "Khaki";
                    e.BorderColor = "silver";

                }
            }

            protected override void OnFinish()
            {
                if (UpdateType == CallBackUpdateType.None)
                {
                    return;
                }

                DataIdField = "Id";
                DataStartField = "Start";
                DataEndField = "End";
                DataTextField = "Desc";
                
                List<TemplEvent> levents = new List<TemplEvent>();
                long i = 0;
                List<object[]> table = Database.Database.database.RequestTable("f_list_week_events", 7);
                if (table == null)
                    table = new List<object[]>();
                foreach (var e in table)
                {
                    levents.Add(new TemplEvent {
                        Id = ((bool) e.GetValue(2) ? 1 : 0),
                        Start = (DateTime) e.GetValue(3),
                        End = (DateTime) e.GetValue(4),
                        Desc = (string) e.GetValue(1)+ " / " + (string) e.GetValue(5)
                    });
                    i++;
                }
                Events =  levents;
                
            }
        }

        class TemplEvent
        {
            public long Id { get; set; }
            public DateTime Start { get; set; }
            public DateTime End { get; set; }
            public string Desc { get; set; }
        }
    }
}