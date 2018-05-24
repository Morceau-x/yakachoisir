using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace YakaTicket.Tools
{
    public class PDFCreator
    {
        public static void createPDF()
        {
            Document doc = new Document(iTextSharp.text.PageSize.A4, 10, 10, 42, 42);
            PdfWriter pdf = PdfWriter.GetInstance(doc, new FileStream("Test.pdf", FileMode.Create));
            doc.Open();

            Paragraph par = new Paragraph("Hello World!");
            doc.Add(par);
            doc.Close();
        }
    }
}