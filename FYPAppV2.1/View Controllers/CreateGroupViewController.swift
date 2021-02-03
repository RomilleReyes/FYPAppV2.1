//
//  CreateGroupViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 28/01/2021.
//

import UIKit
import FirebaseFirestore
import Foundation
import FirebaseAuth

class CreateGroupViewController: UIViewController {

    
    @IBOutlet weak var GroupNameTextField: UITextField!
    
    @IBOutlet weak var SubmitGroupBTN: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func EnterGroupNameBTNTapped(_ sender: Any) {
        
        //let user = Auth.auth().currentUser
        //let uid = user.uid
        /*
        if let user = user {
            let uid = result!.user.uid
        }
        */
        
        
        //validate fields
        let error = validateFields()
        if error != nil {
            //something wrong with fields
            showError(error!)
        }
        else {
            //create group
            // add user as member
            
            let db = Firestore.firestore()
            
            let groupname = GroupNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //creates newgroup document under usergroups
            //can reference to newgroup to get document id

            
            let newgroup = db.collection("usergroups")
   
            
            //create new document with a generated ID
            let newUID = UUID().uuidString
            
            //get current users uid
            let currentuid = Auth.auth().currentUser?.uid

            
            newgroup.document(newUID).setData([
                "groupID":newUID,
                "member":currentuid,
                "groupname":groupname,
            
            ])
            
            //make sure newgroup is created
            
            //remove /usergroups/
            
            
            //var editedgroup = newgroup
        
            
            
            //add groupid to user database as well
            let currentuid2 = (Auth.auth().currentUser?.uid)!
            db.collection("users2").document(currentuid!).updateData([
                "groupbelong": newUID
            ]) { err in
                if let err = err {
                    print("Error udpating document: \(err)")
                }
                else {
                    print("Document succesfully updated")
                }
            }
            
            self.moveToHomeScreen()
            
            //move to home screen
            
        }
        
    }
    
    func setUpElements(){
        
        ErrorLabel.alpha = 0
        
        Utilities.styleFilledButton(SubmitGroupBTN)
    }
    
    //check fields if the data is correct and if it is then the method will return nil
    //if wrong then error message produced
    //returns optional string
    func validateFields() -> String? {
        if GroupNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            return "Please fill in all fields"
        }
        return nil
    }
    func showError(_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
        
    func moveToHomeScreen(){
        let homeViewController =
            self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
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
