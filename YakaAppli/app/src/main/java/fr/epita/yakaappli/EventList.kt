package fr.epita.yakaappli

import java.io.Serializable

class EventList : Serializable {
    public var event_list : ArrayList<Event>

    constructor(elist : ArrayList<Event>) {
        event_list = elist
    }

    public fun add_event(e : Event) {
        event_list.add(e)
    }
}