package fr.epita.yakaappli

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity(), View.OnClickListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btn_connect.setOnClickListener(this@MainActivity)
    }

    override fun onClick(clickedView: View?) {
        if (clickedView != null) {
            when (clickedView.id) {
                R.id.btn_connect -> {
                    val explicitIntent = Intent(this@MainActivity, EventsActivity::class.java)
                    val message = "Identifiant"
                    explicitIntent.putExtra("ID", message)
                    startActivity(explicitIntent)
                }
                else -> {
                }
            }
        }
    }

}
