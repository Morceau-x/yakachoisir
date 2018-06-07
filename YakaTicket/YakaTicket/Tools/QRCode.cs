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
            return getImage("test");
        }

        public static Bitmap getImage(string code)
        {
            BarcodeWriter barcode = new BarcodeWriter {Format = BarcodeFormat.QR_CODE};
            return barcode.Write(code);
        }
    }
}