using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using ZXing;

namespace YakaTicket.Tools
{
    public class QRCode
    {
        public static Bitmap getImage()
        {
            BarcodeWriter barcode = null;
            barcode = new BarcodeWriter();
            barcode.Format = BarcodeFormat.QR_CODE;
            return barcode.Write("test");
        }
    }
}