package fr.epita.yakaappli

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path

interface WSInterface {
    @GET("GetParticipants/{event}")
    fun getEvent(@Path("event") event : String) : Call<List<String>>

    @GET("GetUser/{e}")
    fun getUser(@Path("e") e : String) : Call<User>

    @GET("GetEvent/{e}")
    fun getEvents(@Path("e") e : String) : Call<List<String>>

    @GET("GetLogin/{login}/{mdp}")
    fun getLogin(@Path("login") login : String, @Path("mdp") mdp : String) : Call<String>

    @GET("RemoveUser/{id}/{e]")
    fun removeUser(@Path("id") id : String, @Path("e") e : String) : Call<Void>

    @GET("EnterUser/{id}/{e]")
    fun enterUser(@Path("id") id : String, @Path("e") e : String) : Call<Void>
}