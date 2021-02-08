//
//  JoinGroupViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 28/01/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class JoinGroupViewController: UIViewController {
    
    
    @IBOutlet weak var GroupCodeTextField2: UITextField!
    @IBOutlet weak var GroupCodeTextField: UITextField!
    
    @IBOutlet weak var JoinGroupBTN: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
        
    }
    
    func setUpElements(){
        //hides error label if there is no error
        ErrorLabel.alpha = 0
        
        Utilities.styleFilledButton(JoinGroupBTN)
    }
    
    //count number of fields in database
    //used to find out number of suers
    func countFields() -> Int  {
        let db = Firestore.firestore()
        let collectionRef = db.collection("usergroups")
        let groupid = GroupCodeTextField2.text;
        let documentRef = collectionRef.document(groupid!)
        var FIELDCOUNT = 0
        documentRef.getDocument(completion: { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            FIELDCOUNT = (documentSnapshot?.data()?.count)!
            print("this is the field count \(FIELDCOUNT)")
            
            
        })
        return FIELDCOUNT
    }

    @IBAction func JoinGroupBTNTapped(_ sender: Any) {
        
        //validate fields
        let error = validateFields()
        if error != nil {
            //something wrong with fields
            showError(error!)
        }
        else {

            
            //trial to take out function
            let db = Firestore.firestore()
            let collectionRef = db.collection("usergroups")
            let groupid = GroupCodeTextField2.text;
            let documentRef = collectionRef.document(groupid!)
            var FIELDCOUNT = 0
            documentRef.getDocument(completion: { documentSnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                //counts number of members
                //-2 to get rid of ID and name fields
                FIELDCOUNT = (documentSnapshot?.data()?.count)! - 2
                print("this is the field count \(FIELDCOUNT)")
            
                
                let numOfMembers = FIELDCOUNT
                print("this is number of members \(numOfMembers)")
                
                //update usergroups add user as member
                let currentuid2 = (Auth.auth().currentUser?.uid)!
                db.collection("usergroups").document(groupid!).updateData([
                    "member\(FIELDCOUNT)":currentuid2
                ])
                    
                //update user profile
                    db.collection("users2").document(currentuid2).updateData([
                    "groupbelong":groupid,
                    ])
                
                //update groupmembers
                let memNumb = FIELDCOUNT + 1
                db.collection("groupmembers").document(groupid!).updateData([
                "member\(memNumb)":currentuid2,
                ])
                
                // to access groupid
               //call globalclass and set groupid
                
            }
            
            )
            
            
            
            
            //move to home screen
            self.moveToHomeScreen()
            // only moves if all fields are filled
            
        }
        
        
        
        }
    
    func moveToHomeScreen(){
        let homeViewController =
            self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        if GroupCodeTextField2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            return "Please fill in all fields"
        }
        return nil
    }
    func showError(_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
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
