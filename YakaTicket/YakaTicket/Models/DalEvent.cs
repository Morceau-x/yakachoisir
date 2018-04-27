using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace YakaTicket.Models
{
    public class DalEvent
    {
        private BddContext bdd;

        public DalEvent()
        {
            bdd = new BddContext();
        }

        public List<Event> GetAllEvents()
        {
            return bdd.Events.ToList();
        }

        public void Dispose()
        {
            bdd.Dispose();
        }

        public void ModifyEvent(int id, String name, String description, DateTime begin, DateTime end, String location, DateTime close,
                                int externPlaces, int internPlaces, float externPrice, float internPrice, bool uniquePrice,
                                bool leftPlaces, String promotionPic)
        {
            Event e = GetAllEvents().FirstOrDefault(r => r.Id == id);
            if (e != null)
            {
                e.Name = name;
                e.Description = description;
                e.Begin = begin;
                e.End = end;
                e.Location = location;
                e.Close = close;
                e.ExternPlaces = externPlaces;
                e.InternPlaces = internPlaces;
                e.ExternPrice = externPrice;
                e.InternPrice = internPrice;
                e.UniquePrice = uniquePrice;
                e.LeftPlaces = leftPlaces;
                e.PromotionPic = promotionPic;
                bdd.SaveChanges();
            }
        }

        public void CreateEvent(String name, String description, DateTime begin, DateTime end, String location, DateTime close,
                                int externPlaces, int internPlaces, float externPrice, float internPrice, bool uniquePrice,
                                bool leftPlaces, String promotionPic)
        {
            bdd.Events.Add(new Event { Name = name, Description = description, Begin = begin, End = end, Location = location,
                                       Close = close, ExternPlaces = externPlaces, InternPlaces = internPlaces, ExternPrice = externPrice,
                                       InternPrice = internPrice, UniquePrice = uniquePrice, LeftPlaces = leftPlaces,
                                       PromotionPic = promotionPic });
            bdd.SaveChanges();
        }
    }
}