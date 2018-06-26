package fr.epita.yakaappli

import android.app.PendingIntent.getActivity
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import com.google.zxing.integration.android.IntentIntegrator
import kotlinx.android.synthetic.main.activity_check.*

class CheckActivity : AppCompatActivity(), View.OnClickListener {

    var enter = true
    var event : Event = Event("none", 0)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_check)

        btn_scan.setOnClickListener(this@CheckActivity)
        btn_list.setOnClickListener(this@CheckActivity)
        btn_validate.setOnClickListener(this@CheckActivity)
        btn_switch.setOnClickListener(this@CheckActivity)
        val originIntent = intent
        event  = originIntent.getSerializableExtra("Event") as Event
        event_name.setText(event.name)
    }

    var scanIntegrator = IntentIntegrator(this)

    override fun onClick(clickedView: View?) {
                if (clickedView != null) {
                    when (clickedView.id) {
                        R.id.btn_validate -> {
                            //Toast.makeText(this, "test", Toast.LENGTH_LONG).show()
                        }
                        R.id.btn_scan -> {
                            scanIntegrator.setOrientationLocked(false)
                            scanIntegrator.initiateScan()
                        }
                        R.id.btn_switch -> {
                            enter = !enter
                            if (enter)
                                btn_switch.setText("Entrée")
                            else
                                btn_switch.setText("Sortie")
                        }
                        R.id.btn_list -> {
                            val explicitIntent = Intent(this@CheckActivity, ListActivity::class.java)
                            explicitIntent.putExtra("Event", event.name)
                            startActivity(explicitIntent)
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
                ticket.setText(scanningResult.getContents())
            }
        }
        else{
            Toast.makeText(this, "Not found", Toast.LENGTH_LONG).show()
            super.onActivityResult(requestCode, resultCode, intent)
        }
    }
}
