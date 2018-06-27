package fr.epita.yakaappli

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import kotlin.collections.ArrayList
import kotlinx.android.synthetic.main.activity_events.*
import android.widget.Toast
import android.R.interpolator.linear
import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Color
import android.provider.FontsContract
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.graphics.Typeface






class EventsActivity : AppCompatActivity() {

    var events : ArrayList<String> = ArrayList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_events)

        val originIntent = intent
        val le = originIntent.getSerializableExtra("List") as ArrayList<String>
        events = le


        for (e in events) {
            val linearLayout : LinearLayout = findViewById(R.id.rootContainer)

            var btnShow = Button(this)
            btnShow.setText(e)
            btnShow.setTextColor(resources.getColor(R.color.colorBlank))
            btnShow.setBackgroundResource(R.drawable.button_event)
            var params = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT)
            params.setMargins(16,16,16,16)
            btnShow.setLayoutParams(params)
            btnShow.setOnClickListener(object : View.OnClickListener {
                override fun onClick(v : View) {
                    val explicitIntent = Intent(this@EventsActivity, CheckActivity::class.java)
                    explicitIntent.putExtra("Event", e)
                    startActivity(explicitIntent)
                }
            })
            if (linearLayout != null) {
                linearLayout.addView(btnShow)
            }
        }
    }

}
