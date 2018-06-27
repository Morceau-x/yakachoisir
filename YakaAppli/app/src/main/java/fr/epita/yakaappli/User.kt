package fr.epita.yakaappli

import java.io.Serializable

class User : Serializable {
    public var login = "None"
    public var firstname = ""
    public var lastname = ""
    public var mail = "None"

    constructor(login : String, firstname : String , lastname : String, mail : String) {
        this.login = login
        this.firstname = firstname
        this.lastname = lastname
        this.mail = mail
    }
}