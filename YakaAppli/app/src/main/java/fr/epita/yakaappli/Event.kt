package fr.epita.yakaappli

import java.util.jar.Attributes

class Event{
    public var name = "NoEvent"
    public var id = 0

    constructor(name : String, id : Int) {
        this.name = name
        this.id = id
    }
}