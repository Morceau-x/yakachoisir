using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Excel = Microsoft.Office.Interop.Excel;
using XLS = Microsoft.Office.Interop.Excel._Application;
using Workbook = Microsoft.Office.Interop.Excel._Workbook;
using Worksheet = Microsoft.Office.Interop.Excel._Worksheet;

namespace YakaTicket.Tools
{
    public class XLSCreator
    {

        public static void exportAsXLS()
        {
            XLS app = new Excel.Application();
            Workbook wb = app.Workbooks.Add(Type.Missing);
            Worksheet ws = null;
            ws = wb.Sheets[0];
            ws = wb.Sheets["Sheet1"];
            ws = wb.ActiveSheet;
            ws.Name = "Detail";

            for (int i = 0; i < 5; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    ws.Cells[i, j] = "i = " + i.ToString() + "j = " + j.ToString();
                }
            }

            wb.SaveAs("Test", "xls", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Excel.XlSaveAsAccessMode.xlExclusive);
            app.Quit();
        }


    }
}