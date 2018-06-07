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
                UpdateWithMessage("Let's see your events for the week !", CallBackUpdateType.Full);
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
                DataTextField = "Text";

                //Events = from e in dc.Events where !((e.End <= VisibleStart) || (e.Start >= VisibleEnd)) select e;
            }
        }
    }
}