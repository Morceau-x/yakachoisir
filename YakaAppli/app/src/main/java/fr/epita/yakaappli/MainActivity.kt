package fr.epita.yakaappli

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.ActionBar
import android.util.Log
import android.view.View
import android.widget.Toast
import com.google.gson.GsonBuilder
import kotlinx.android.synthetic.main.activity_main.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class MainActivity : AppCompatActivity(), View.OnClickListener {

    var login = ""
    var mdp = ""
    var res = ""
    var le = ArrayList<String>()
    //var baseURL = "https://10.0.2.2:44345/api/"
    var baseURL = "https://localhost:44345/api/"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        //test()
        btn_connect.setOnClickListener(this@MainActivity)
    }

    override fun onClick(clickedView: View?) {
        if (clickedView != null) {
            when (clickedView.id) {
                R.id.btn_connect -> {
                    if (url.text.toString() != "")
                        baseURL = url.text.toString()
                    login = text_login.text.toString()
                    mdp = text_password.text.toString()
                    getEvents()
                    if (res == "")
                        return
                    val explicitIntent = Intent(this@MainActivity, EventsActivity::class.java)
                    explicitIntent.putExtra("List", le)
                    explicitIntent.putExtra("Login", res)
                    explicitIntent.putExtra("Url", baseURL)
                    startActivity(explicitIntent)
                }
                else -> {
                }
            }
        }
    }

    fun getEvents() {
        val jsonConverter = GsonConverterFactory.create(GsonBuilder().create())
        val retrofit = Retrofit.Builder().baseUrl(baseURL).addConverterFactory(jsonConverter).build()
        val service = retrofit.create(WSInterface::class.java)

        val loginCallback = object : Callback<String> {
            override fun onFailure(call: Call<String>?, t: Throwable?) {
                Toast.makeText(this@MainActivity, "Identifiants invalides", Toast.LENGTH_LONG).show()
                Log.d("MainActivity", "WebService login call failed")
            }

            override fun onResponse(call: Call<String>?, response: Response<String>?) {
                if (response == null || response.code() != 200) {
                    Toast.makeText(this@MainActivity, "Identifiants invalides", Toast.LENGTH_LONG).show()
                    return
                }
                res = response.body() ?: return
            }
        }

        val eventCallback = object : Callback<List<String>> {
            override fun onFailure(call: Call<List<String>>?, t: Throwable?) {
                Toast.makeText(this@MainActivity, "Identifiants invalides", Toast.LENGTH_LONG).show()
                Log.d("MainActivity", "WebService login call failed")
            }

            override fun onResponse(call: Call<List<String>>?, response: Response<List<String>>?) {
                if (response == null || response.code() != 200) {
                    Toast.makeText(this@MainActivity, "Identifiants invalides", Toast.LENGTH_LONG).show()
                    return
                }
                val responseData = response.body() ?: return
                le.addAll(responseData)
            }
        }
        service.getLogin(login, mdp).enqueue(loginCallback)
        if (res == "")
            return
        service.getEvents(login).enqueue(eventCallback)
    }

    fun test() {
        le.add("soirée Nova")
        le.add("BBQ")
        le.add("Fin de partiel")
    }

}
