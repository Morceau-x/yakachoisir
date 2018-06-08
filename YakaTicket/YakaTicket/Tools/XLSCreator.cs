using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using Excel = Microsoft.Office.Interop.Excel;
using XLS = Microsoft.Office.Interop.Excel._Application;
using Workbook = Microsoft.Office.Interop.Excel._Workbook;
using Worksheet = Microsoft.Office.Interop.Excel._Worksheet;

namespace YakaTicket.Tools
{
    public class XLSCreator
    {

        public static void exportAsXLS(string path, string filename)
        {
            object miss = Type.Missing;
            XLS app = new Excel.Application();
            app.DisplayAlerts = false;
            app.Visible = false;
            Workbook wb = app.Workbooks.Add(miss);
            Worksheet ws = (Worksheet)wb.Sheets[1];
            //ws = wb.Sheets[0];
            //ws = wb.Sheets["Sheet1"];
            ws = wb.ActiveSheet;
            ws.Name = "Detail";

            /*
            for (int i = 0; i < 5; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    ws.Cells[i, j] = "i = " + i.ToString() + "j = " + j.ToString();
                }
            }
            */
            wb.SaveAs(path + filename);
            wb.Close();
            //wb.SaveAs(path + filename, "xls", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Excel.XlSaveAsAccessMode.xlExclusive);
            app.Quit();
        }

        public static string externAsXLS()
        {
            string dateNow = DateTime.Now.ToShortDateString() + "_" + DateTime.Now.ToShortTimeString();
            string path = "";
            string filename = dateNow + "_" + "extern_list";
            object miss = Type.Missing;
            

            XLS app = new Excel.Application();
            app.DisplayAlerts = false;
            app.Visible = false;
            Workbook wb = app.Workbooks.Add(miss);
            Worksheet ws = (Worksheet)wb.Sheets[1];
            //ws = wb.Sheets[0];
            //ws = wb.Sheets["Sheet1"];
            ws = wb.ActiveSheet;
            ws.Name = "Detail";

            /*
            for (int i = 0; i < 5; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    ws.Cells[i, j] = "i = " + i.ToString() + "j = " + j.ToString();
                }
            }
            */
            wb.SaveAs(path + filename);
            wb.Close();
            //wb.SaveAs(path + filename, "xls", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Excel.XlSaveAsAccessMode.xlExclusive);
            app.Quit();
            return filename;
        }




    }
}