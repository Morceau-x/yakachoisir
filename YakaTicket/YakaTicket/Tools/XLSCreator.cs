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

        public static string externAsXLS(string path)
        {
            string dateNow = DateTime.Now.ToShortDateString();
            string filename = dateNow + "_" + "extern_list";
            object miss = Type.Missing;
            List<List<String>> externs = new List<List<string>>();

            try
            {
                List<object[]> list = Database.Database.database.RequestTable("f_get_extern_user", 6);
                foreach (var o in list)
                {
                    externs.Add(new List<string> {(string)o[0], (string)o[1], (string)o[2], (string)o[3], (string)o[4], (string)o[5]});
                }
            }
            catch (Exception) { }

            XLS app = new Excel.Application();
            app.DisplayAlerts = false;
            app.Visible = false;
            Workbook wb = app.Workbooks.Add(miss);
            Worksheet ws = (Worksheet)wb.Sheets[1];
            //ws = wb.Sheets[0];
            //ws = wb.Sheets["Sheet1"];
            ws = wb.ActiveSheet;
            ws.Name = "Liste des externes";

            ws.Cells[1, 1] = "Login";
            ws.Cells[1, 2] = "Adresse mél";
            ws.Cells[1, 3] = "Prénom";
            ws.Cells[1, 4] = "Nom";
            ws.Cells[1, 5] = "Adresse";
            ws.Cells[1, 6] = "Numéro de téléphone";



            for (int y = 2; y <= externs.Count + 1; y++)
            {
                for (int x = 1; x <= externs[y - 2].Count; x++)
                {
                    ws.Cells[y, x] = externs[y - 2][x - 1];
                }
            }

            ws.Columns.AutoFit();
            wb.SaveAs(path + filename);
            wb.Close();
            //wb.SaveAs(path + filename, "xls", Type.Missing, Type.Missing, Type.Missing, Type.Missing, Excel.XlSaveAsAccessMode.xlExclusive);
            app.Quit();
            return filename + ".xlsx";
        }




    }
}