//
//  HomeViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 18/01/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {

    
    @IBOutlet weak var FreeBTN: UIButton!
    @IBOutlet weak var BusyBTN: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func FreeBTNTapped(_ sender: Any) {
        //chnage user status to free
        
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        db.collection("users2").document(currentuid2).updateData([
        "userstatus":"Available",
        ])
    }
    
    @IBAction func BusyBTNTapped(_ sender: Any) {
        //change user status to busy
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        db.collection("users2").document(currentuid2).updateData([
        "userstatus":"Busy",
        ])
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
