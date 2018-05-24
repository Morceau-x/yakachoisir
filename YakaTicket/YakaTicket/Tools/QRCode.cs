using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ZXing;

namespace YakaTicket.Tools
{
    public class QRCode
    {
        BarcodeWriter _barcode = null;

        QRCode()
        {
            _barcode = new BarcodeWriter();
        }

        public void Write()
        {
            _barcode.Format = BarcodeFormat.QR_CODE;
            _barcode.Write("test").Save("test.bmp");
        }
    }
}