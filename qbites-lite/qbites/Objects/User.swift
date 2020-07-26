//
//  User.swift
//  qbites
//
//  Created by Mohammad Bashir sidani on 11/11/19.
//  Copyright © 2019 Mohammad Bashir sidani. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {

    var id = -1
    var email = ""
    var notificationsAllowed = false
    var firebaseToken = ""
    
    override init(){
        super.init()
    }
    
    init(id: Int, email: String, notificationsAllowed: Bool, firebaseToken: String) {
        
        self.id = id
        self.email = email
        self.notificationsAllowed = notificationsAllowed
        self.firebaseToken = firebaseToken

    }

    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let notificationsAllowed = aDecoder.decodeBool(forKey: "notificationsAllowed")
        let firebaseToken = aDecoder.decodeObject(forKey: "firebaseToken") as! String
        
        self.init(id: id, email: email, notificationsAllowed: notificationsAllowed, firebaseToken: firebaseToken)
    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(notificationsAllowed, forKey: "notificationsAllowed")
        aCoder.encode(firebaseToken, forKey: "firebaseToken")
        
    }

}
