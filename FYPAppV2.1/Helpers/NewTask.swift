//
//  NewTask.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 08/02/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol DocumentSerialisable {
    init?(dictionary:[String:Any])
}

struct Task {
    var name:String
    var content:String
    //var timeStamp:Date
    var taskstatus2:String
    var documentID:String
    
    var dictionary:[String:Any] {
        return [
            "name":name,
            "content":content,
            //"timeStamp":timeStamp
            "taskstatus2":taskstatus2,
            "documentID":documentID,
        ]
    }
}

extension Task:DocumentSerialisable {
    init?(dictionary: [String : Any]){
        guard let name = dictionary["name"] as? String,
              let taskstatus2 = dictionary["taskstatus2"] as? String,
              let documentID = dictionary["documentID"] as? String,
              let content = dictionary["content"] as? String else {return nil}
              //let timeStamp = dictionary["timeStamp"] as? Date else {return nil}
        self.init(name: name, content: content, taskstatus2:taskstatus2, documentID:documentID)
    }
}

/*
struct globaluid {
    static var:String
}
*/
