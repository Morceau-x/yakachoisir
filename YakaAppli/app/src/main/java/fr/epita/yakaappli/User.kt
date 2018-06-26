package fr.epita.yakaappli

import java.io.Serializable

class User : Serializable {
    public var login = "None"
    public var mail = "None"

    constructor(login : String, mail : String) {
        this.login = login
        this.mail = mail
    }
}