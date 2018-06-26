package fr.epita.yakaappli

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.util.Log
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
    val baseURL = "http://localhost"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list)

        val originIntent = intent
        event = originIntent.getStringExtra("Event")

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
                Log.d("MainActivity", "WebService characters call failed")
            }

            override fun onResponse(call: Call<List<String>>?, response: Response<List<String>>?) {
                if (response == null || response.code() != 200)
                    return
                val responseData = response.body() ?: return

                participants.addAll(responseData)
                Log.d("ListActivity", "WebService characters success : ")
            }
        }

        service.getEvent(event).enqueue(participantCallback)
    }
}
