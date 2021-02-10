//
//  GroupStatus.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 09/02/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
protocol DocumentSerialisable2 {
    init?(dictionary2:[String:Any])
}


struct Grouper {
    var email:String
    var firstname:String
    var groupbelong:String
    var lastname:String
    var uid:String
    var userstatus:String
    //var timeStamp:Date
        
    
    var dictionary2:[String:Any] {
        return [
            "email":email,
            "firstname":firstname,
            "groupbelong":groupbelong,
            "lastname":lastname,
            "uid":uid,
            "userstatus":userstatus,
            //"timeStamp": timeStamp
        ]
    }
}

extension Grouper:DocumentSerialisable2 {
    init?(dictionary2: [String : Any]) {
        guard let email = dictionary2["email"] as? String,
              let firstname = dictionary2["firstname"] as? String,
              let groupbelong = dictionary2["groupbelong"] as? String,
              let lastname = dictionary2["lastname"] as? String,
              let uid = dictionary2["uid"] as? String,
              let userstatus = dictionary2["userstatus"] as? String
              //let timeStamp = dictionary2["timeStamp"] as? Date
        else{return nil}
        
        self.init(email: email, firstname: firstname, groupbelong: groupbelong, lastname: lastname, uid: uid, userstatus: userstatus)
    }
}
