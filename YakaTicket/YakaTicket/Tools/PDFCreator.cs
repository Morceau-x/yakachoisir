using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Threading;
using PDF = iTextSharp.text;
using iTextSharp.text.pdf;
using YakaTicket.Models;

namespace YakaTicket.Tools
{
    public class PDFCreator
    {
        public static string exportAsPDF(string path, Event ev, User user, string logo)
        {
            string filename = "billet_" + ev.Name + "_" + user.Firstname + "_" + user.Lastname;

            PDF.Document doc = new PDF.Document(PDF.PageSize.A4, 20, 20, 42, 42);
            
            FileStream file = new FileStream(path + filename + ".pdf", FileMode.OpenOrCreate);
            PdfWriter pdf = PdfWriter.GetInstance(doc, file);

            doc.Open();

            /* Réservation */
            PDF.Paragraph par = new PDF.Paragraph("Réservation");
            PDF.Paragraph ph = new PDF.Paragraph("Merci de votre réservation pour l'événement " + ev.Name);
            PDF.Paragraph ph2 = new PDF.Paragraph(user.Firstname + " " + user.Lastname);

            /* Logo */
            PDF.Image logoBilleterie = PDF.Image.GetInstance(logo);
            logoBilleterie.ScalePercent(20.0f);


            /* QRcode */
            PDF.Image qrcode = PDF.Image.GetInstance(QRCode.getImage(ev.Name + "(^_^)" + user.Id), PDF.BaseColor.WHITE);


            /* Receipt */
            PdfPTable table2 = new PdfPTable(4);
            PdfPCell cell21 = new PdfPCell();
            PdfPCell cell22 = new PdfPCell();
            PdfPCell cell23 = new PdfPCell();
            PdfPCell cell24 = new PdfPCell();

            cell21.AddElement(new PDF.Paragraph("Billet"));
            cell22.AddElement(new PDF.Paragraph("Date de début"));
            cell23.AddElement(new PDF.Paragraph("Date de fin"));
            cell24.AddElement(new PDF.Paragraph("Prix"));

            table2.AddCell(cell21);
            table2.AddCell(cell22);
            table2.AddCell(cell23);
            table2.AddCell(cell24);
            

            PdfPCell cell31 = new PdfPCell();
            PdfPCell cell32 = new PdfPCell();
            PdfPCell cell33 = new PdfPCell();
            PdfPCell cell34 = new PdfPCell();

            Thread.CurrentThread.CurrentCulture = new CultureInfo("fr-FR");

            float price_value = -1;
            string price_name = "";

            try
            {
                object[] tmp = Database.Database.database.RequestLine("f_get_participant", 2, user.Id, ev.Name);
                price_name = (string)tmp[0];
                price_value = (float)tmp[1];
            }
            catch (Exception) { }

            cell31.AddElement(new PDF.Paragraph(price_name));
            cell32.AddElement(new PDF.Paragraph(ev.Begin.ToShortDateString() + " " + ev.Begin.ToShortTimeString()));
            cell33.AddElement(new PDF.Paragraph(ev.End.ToShortDateString() + " " + ev.End.ToShortTimeString()));
            cell34.AddElement(new PDF.Paragraph(price_value.ToString("C")));

            
            table2.AddCell(cell31);
            table2.AddCell(cell32);
            table2.AddCell(cell33);
            table2.AddCell(cell34);

            /* Add */
            doc.Add(logoBilleterie);
            doc.Add(par);
            doc.Add(ph);
            doc.Add(ph2);
            doc.Add(qrcode);
            doc.Add(table2);
            

            doc.Close();

            return filename + ".pdf";
        }

        public static string test(string path, string filename)
        {

            PDF.Document doc = new PDF.Document(PDF.PageSize.A4, 20, 20, 42, 42);
            FileStream file = new FileStream(path + filename, FileMode.OpenOrCreate);
            PdfWriter pdf = PdfWriter.GetInstance(doc, file);
            doc.Open();



            /* LOGO BILLET */
            PDF.Image logoBilleterie = PDF.Image.GetInstance("~/Content/logo_bg1.png");
            logoBilleterie.ScalePercent(20.0f);

            

            PdfPTable table1 = new PdfPTable(2);
            table1.DefaultCell.Border = 0;
            table1.WidthPercentage = 80;


            PdfPCell cell11 = new PdfPCell();
            cell11.Colspan = 1;
            cell11.AddElement(new PDF.Paragraph("ABC Traders Receipt"));
            cell11.AddElement(new PDF.Paragraph("Thankyou for shoping at ABC traders,your order details are below"));


            cell11.VerticalAlignment = PDF.Element.ALIGN_LEFT;

            PdfPCell cell12 = new PdfPCell();


            cell12.VerticalAlignment = PDF.Element.ALIGN_CENTER;


            table1.AddCell(cell11);

            table1.AddCell(cell12);


            PdfPTable table2 = new PdfPTable(3);

            //One row added

            PdfPCell cell21 = new PdfPCell();

            cell21.AddElement(new PDF.Paragraph("Photo Type"));

            PdfPCell cell22 = new PdfPCell();

            cell22.AddElement(new PDF.Paragraph("No. of Copies"));

            PdfPCell cell23 = new PdfPCell();

            cell23.AddElement(new PDF.Paragraph("Amount"));


            table2.AddCell(cell21);

            table2.AddCell(cell22);

            table2.AddCell(cell23);


            //New Row Added

            PdfPCell cell31 = new PdfPCell();

            cell31.AddElement(new PDF.Paragraph("Safe"));

            cell31.FixedHeight = 300.0f;

            PdfPCell cell32 = new PdfPCell();

            cell32.AddElement(new PDF.Paragraph("2"));

            cell32.FixedHeight = 300.0f;

            PdfPCell cell33 = new PdfPCell();

            cell33.AddElement(new PDF.Paragraph("20.00 * " + "2" + " = " + (20 * Convert.ToInt32("2")) + ".00"));

            cell33.FixedHeight = 300.0f;



            table2.AddCell(cell31);

            table2.AddCell(cell32);

            table2.AddCell(cell33);


            PdfPCell cell2A = new PdfPCell(table2);

            cell2A.Colspan = 2;

            table1.AddCell(cell2A);

            PdfPCell cell41 = new PdfPCell();

            cell41.AddElement(new PDF.Paragraph("Name : " + "ABC"));

            cell41.AddElement(new PDF.Paragraph("Advance : " + "advance"));

            cell41.VerticalAlignment = PDF.Element.ALIGN_LEFT;

            PdfPCell cell42 = new PdfPCell();

            cell42.AddElement(new PDF.Paragraph("Customer ID : " + "011"));

            cell42.AddElement(new PDF.Paragraph("Balance : " + "3993"));

            cell42.VerticalAlignment = PDF.Element.ALIGN_RIGHT;


            table1.AddCell(cell41);

            table1.AddCell(cell42);


            doc.Add(table1);
            doc.Close();
            return filename;
        }
    }
}