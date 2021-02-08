//
//  global.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 07/02/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class global {
    /*
  var groupid:String
  init(groupid:String) {
    self.groupid = groupid
  }
 */
    
    
    class func accessgroupid() -> String {
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document(currentuid2)
        docRef.getDocument { (document,error) in
            
            if let document = document {
                let property = document.get("groupbelong")
                updatedgroupid = property as! String
                //print("Passed by but not able to get groupbelong")
                print("This is group id here \(updatedgroupid)")
                //return updatedgroupid
            }
            else {
                print("Document does not exist")
            }
            
            
            //return updatedgroupid
        }
        
        return updatedgroupid
    }
}

//var mainInstance = Main(groupid:"My Global Class")

func accessgroupid() -> String {
    let db = Firestore.firestore()
    let currentuid2 = (Auth.auth().currentUser?.uid)!
    var updatedgroupid = "not changed yet"
    let docRef = db.collection("users2").document(currentuid2)
    docRef.getDocument { (document,error) in
        
        if let document = document {
            let property = document.get("groupbelong")
            updatedgroupid = property as! String
        }
        else {
            print("Document does not exist")
        }
        
        
        
    }
    
    return updatedgroupid
}


 
