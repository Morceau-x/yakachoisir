using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.IO;
using PDF = iTextSharp.text;
using iTextSharp.text.pdf;

namespace YakaTicket.Tools
{
    public class PDFCreator
    {
        public static void exportAsPDF(string path, string filename, string logo)
        {
            PDF.Document doc = new PDF.Document(PDF.PageSize.A4, 20, 20, 42, 42);
            FileStream file = new FileStream(path + filename, FileMode.OpenOrCreate);
            PdfWriter pdf = PdfWriter.GetInstance(doc, file);
            doc.Open();

            PDF.Paragraph par = new PDF.Paragraph("Réservation");
            PDF.Image logoBilleterie = PDF.Image.GetInstance(logo);
            logoBilleterie.ScalePercent(20.0f);
            PDF.Image qrcode = PDF.Image.GetInstance(QRCode.getImage(), PDF.BaseColor.WHITE);
            doc.Add(logoBilleterie);
            doc.Add(par);
            doc.Add(qrcode);

            doc.Close();
        }
    }
}