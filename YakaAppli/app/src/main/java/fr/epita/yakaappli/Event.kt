package fr.epita.yakaappli

import java.io.Serializable
import java.util.jar.Attributes

class Event : Serializable {
    public var name = "NoEvent"

    constructor(name : String) {
        this.name = name
    }
}