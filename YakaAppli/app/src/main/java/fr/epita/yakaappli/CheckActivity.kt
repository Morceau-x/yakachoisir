package fr.epita.yakaappli

import android.app.PendingIntent.getActivity
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import com.google.gson.GsonBuilder
import com.google.zxing.integration.android.IntentIntegrator
import kotlinx.android.synthetic.main.activity_check.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class CheckActivity : AppCompatActivity(), View.OnClickListener {

    var enter = true
    var id = ""
    var event = ""
    var login = ""
    val baseURL = "https://localhost:44345/api/"
    var user : User = User("", "", "", "")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_check)

        btn_scan.setOnClickListener(this@CheckActivity)
        btn_list.setOnClickListener(this@CheckActivity)
        btn_validate.setOnClickListener(this@CheckActivity)
        btn_switch.setOnClickListener(this@CheckActivity)
        val originIntent = intent
        event  = originIntent.getStringExtra("Event")
        event_name.setText(event)
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
                            explicitIntent.putExtra("Event", event)
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
                id = scanningResult.contents
                val splited = id.split("(^_^)".toRegex())
                login = splited[0]
                getUser()
                login_name.text = login
                name_name.text = user.firstname + " " + user.lastname
            }
        }
        else{
            Toast.makeText(this, "Not found", Toast.LENGTH_LONG).show()
            super.onActivityResult(requestCode, resultCode, intent)
        }
    }

    fun getUser() {
        val jsonConverter = GsonConverterFactory.create(GsonBuilder().create())
        val retrofit = Retrofit.Builder().baseUrl(baseURL).addConverterFactory(jsonConverter).build()
        val service = retrofit.create(WSInterface::class.java)

        val userCallback = object : Callback<User> {
            override fun onFailure(call: Call<User>?, t: Throwable?) {
                Toast.makeText(this@CheckActivity, "User not found", Toast.LENGTH_LONG).show()
                Log.d("MainActivity", "WebService user call failed")
            }

            override fun onResponse(call: Call<User>?, response: Response<User>?) {
                if (response == null || response.code() != 200) {
                    Toast.makeText(this@CheckActivity, "User not found", Toast.LENGTH_LONG).show()
                    return
                }
                user = response.body() ?: return
            }
        }
        service.getUser(login).enqueue(userCallback)
    }
}
