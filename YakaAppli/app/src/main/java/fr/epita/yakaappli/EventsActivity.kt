package fr.epita.yakaappli

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import kotlin.collections.ArrayList
import kotlinx.android.synthetic.main.activity_events.*
import android.widget.Toast
import android.R.interpolator.linear
import android.content.Intent
import android.graphics.Color
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout




class EventsActivity : AppCompatActivity() {

    var events : ArrayList<Event> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_events)

        val originIntent = intent
        originIntent.getStringExtra("ID")

        test()

        for (e in events) {
            val linearLayout : LinearLayout = findViewById(R.id.rootContainer);

            var btnShow = Button(this)
            btnShow.setText(e.name)
            btnShow.setLayoutParams(LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT))
            btnShow.setOnClickListener(object : View.OnClickListener {
                override fun onClick(v : View) {
                    val explicitIntent = Intent(this@EventsActivity, CheckActivity::class.java)
                    val message = e.name
                    explicitIntent.putExtra("ID", message)
                    startActivity(explicitIntent)
                }
            })
            if (linearLayout != null) {
                linearLayout.addView(btnShow)
            }
        }
    }

    fun test() {
        events.add(Event("Test1",2))
        events.add(Event("Test42",1))
        events.add(Event("Test51",3))
        events.add(Event("Test20",2))
        events.add(Event("Test21",1))
        events.add(Event("Test22",3))
        events.add(Event("Test23",2))
        events.add(Event("Test24",1))
        events.add(Event("Test25",3))
    }
}
