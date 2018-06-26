package fr.epita.yakaappli

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.View
import kotlinx.android.synthetic.main.activity_check.*

class ListActivity : AppCompatActivity() {

    var data : ArrayList<User> = ArrayList()
    var event : String = "none"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list)

        val originIntent = intent
        event = originIntent.getStringExtra("Event")

        var viewManager = LinearLayoutManager(this)
        var viewAdapter = LoginRecyclerAdapter(this, data)
        var recyclerView = findViewById<RecyclerView>(R.id.login_recycler_view).apply {
            setHasFixedSize(true)
            layoutManager = viewManager
            adapter = viewAdapter
        }
    }
}
