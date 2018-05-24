package fr.epita.yakaappli

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.ActionBar
import android.view.View
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity(), View.OnClickListener {

    var le = EventList(ArrayList())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        test()

        btn_connect.setOnClickListener(this@MainActivity)
    }

    override fun onClick(clickedView: View?) {
        if (clickedView != null) {
            when (clickedView.id) {
                R.id.btn_connect -> {
                    val explicitIntent = Intent(this@MainActivity, EventsActivity::class.java)
                    explicitIntent.putExtra("List", le)
                    startActivity(explicitIntent)
                }
                else -> {
                }
            }
        }
    }

    fun test() {
        le.add_event(Event("Test1",2))
        le.add_event(Event("Test42",1))
        le.add_event(Event("Test51",3))
        le.add_event(Event("Test20",2))
        le.add_event(Event("Test21",1))
        le.add_event(Event("Test22",3))
        le.add_event(Event("Test23",2))
        le.add_event(Event("Test24",1))
        le.add_event(Event("Test25",3))
    }

}
