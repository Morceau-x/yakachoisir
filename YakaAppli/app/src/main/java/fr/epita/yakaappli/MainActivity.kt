package fr.epita.yakaappli

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import kotlinx.android.synthetic.main.activity_main.*
import com.google.zxing.integration.android.IntentIntegrator
import android.content.Intent
import android.widget.Toast
import com.google.zxing.integration.android.IntentResult





class MainActivity : AppCompatActivity(), View.OnClickListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btn_scan.setOnClickListener(this@MainActivity)
    }

    var scanIntegrator = IntentIntegrator(this)

    override fun onClick(clickedView: View?) {
        if (clickedView != null) {
            when (clickedView.id) {
                R.id.btn_scan -> {
                    scanIntegrator.setOrientationLocked(false)
                    scanIntegrator.initiateScan()
                }
                else -> {
                }
            }
        }
    }

    public override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent) {
        //retrieve scan result
        val scanningResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, intent)
        if (scanningResult != null) {
            //we have a result
            if(scanningResult.getContents() == null) {
                Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show()
            } else {
                Toast.makeText(this, "Scanned: " + scanningResult.getContents(), Toast.LENGTH_LONG).show()
            }
        }
        else{
            Toast.makeText(this, "Not found", Toast.LENGTH_LONG).show()
            super.onActivityResult(requestCode, resultCode, intent)
        }
    }
}
