using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Database
{
    public class DataEvent
    {
        // Info
        public int Id;
        public String name;
        public String summary;
        public bool premium; // Not mandatory
        public DateTime begin_date;
        public DateTime end_date;
        public String assoc;

        //Options
        public bool moderator_approved;
        public bool president_approved;
        public bool deleted;
        public DateTime creation_date;
        public DateTime deletion_date;

        public DataEvent(int Id, String name, String summary, bool premium, DateTime begin_date, DateTime end_date,
                         String assoc, bool moderator_approved, bool president_approved, bool deleted, DateTime creation_date,
                         DateTime deletion_date)
        {
            this.Id = Id;
            this.summary = summary;
            this.premium = premium;
            this.begin_date = begin_date;
            this.end_date = end_date;
            this.assoc = assoc;
            this.moderator_approved = moderator_approved;
            this.president_approved = president_approved;
            this.deleted = deleted;
            this.creation_date = creation_date;
            this.deletion_date = deletion_date;
        }
    }
}