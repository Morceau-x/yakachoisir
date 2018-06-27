package fr.epita.yakaappli

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.util.Log
import android.widget.Toast
import com.google.gson.GsonBuilder
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class ListActivity : AppCompatActivity() {

    var data : ArrayList<User> = ArrayList()
    var participants : ArrayList<String> = ArrayList()
    var event : String = "none"
    //var baseURL = "https://10.0.2.2:44345/api/"
    var baseURL = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list)

        val originIntent = intent
        event = originIntent.getStringExtra("Event")
        baseURL = originIntent.getStringExtra("Url")

        getParticipant()

        var viewManager = LinearLayoutManager(this)
        var viewAdapter = LoginRecyclerAdapter(this, data)
        var recyclerView = findViewById<RecyclerView>(R.id.login_recycler_view).apply {
            setHasFixedSize(true)
            layoutManager = viewManager
            adapter = viewAdapter
        }
    }

    fun getParticipant() {
        val jsonConverter = GsonConverterFactory.create(GsonBuilder().create())
        val retrofit = Retrofit.Builder().baseUrl(baseURL).addConverterFactory(jsonConverter).build()
        val service = retrofit.create(WSInterface::class.java)

        val participantCallback = object : Callback<List<String>> {
            override fun onFailure(call: Call<List<String>>?, t: Throwable?) {
                Toast.makeText(this@ListActivity, "Event not found", Toast.LENGTH_LONG).show()
                Log.d("MainActivity", "WebService list call failed")
                Log.d("test", retrofit.baseUrl().toString())
            }

            override fun onResponse(call: Call<List<String>>?, response: Response<List<String>>?) {
                if (response == null || response.code() != 200) {
                    Toast.makeText(this@ListActivity, "Event not found", Toast.LENGTH_LONG).show()
                    return
                }
                val responseData = response.body() ?: return

                participants.addAll(responseData)
            }
        }

        val userCallback = object : Callback<User> {
            override fun onFailure(call: Call<User>?, t: Throwable?) {
                Toast.makeText(this@ListActivity, "User not found", Toast.LENGTH_LONG).show()
                Log.d("MainActivity", "WebService user call failed")
            }

            override fun onResponse(call: Call<User>?, response: Response<User>?) {
                if (response == null || response.code() != 200) {
                    Toast.makeText(this@ListActivity, "User not found", Toast.LENGTH_LONG).show()
                    return
                }
                val responseData = response.body() ?: return

                data.add(responseData)
            }
        }

        service.getEvent(event).enqueue(participantCallback)
        for (login in participants) {
            service.getUser(login).enqueue(userCallback)
        }
    }
}
