package fr.epita.yakaappli

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path

interface WSInterface {
    @GET("GetEvent/{event}")
    fun getEvent(@Path("event") event : String) : Call<List<String>>
}