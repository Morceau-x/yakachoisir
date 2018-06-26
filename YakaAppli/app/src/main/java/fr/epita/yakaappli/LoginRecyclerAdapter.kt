package fr.epita.yakaappli

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.util.EventLog
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView

class LoginRecyclerAdapter(
        val context: Context,
        var data: ArrayList<User>) :
        RecyclerView.Adapter<LoginRecyclerAdapter.ViewHolder>() {

    class ViewHolder(rowView: View) :RecyclerView.ViewHolder(rowView) {
        val login: TextView = itemView.findViewById(R.id.list_item_login)
        val mail: TextView = itemView.findViewById(R.id.list_item_mail)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val rowView = LayoutInflater
                .from(context)
                .inflate(R.layout.login_list, parent, false)
        return ViewHolder(rowView)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val currentItem = data[position]
        holder.login.text = currentItem.login
        holder.mail.text = currentItem.mail
    }


    override fun getItemCount(): Int {
        return data.size
    }
}