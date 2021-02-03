//
//  LogInViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 18/01/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //hides the error label when nothing is showing
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(logInButton)
    }

    
    
    
    
    @IBAction func logInTapped(_ sender: Any) {
        
        
        //TODO
        //validate text fields
        
        //create cleaned version
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        
        //sign in user
        Auth.auth().signIn(withEmail: email, password: password) {
            (result,error) in
            
            if error != nil{
                //cant sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                
            }
            else {
                
                // if usee does not have a group then let them create / join group
                //else join home view
                
                //need unique ID of user signing in and then check on that
                //self.ref.child("users/")
                
                //let grpID = db.collection("users2")
                
                let db = Firestore.firestore()
                var grpid = ""
            
                let user = Auth.auth().currentUser
                
                /*
                self.db.collection("users2").whereField("uid", isEqualTo: "\(uid)").getDocuments { (snapshot,err) in
                    
                    if let err = err {
                            print("Error getting documents: ")
                        }
                    else {
                            for document in snapshot!.documents {
                                if document == document {
                                    print("SUCCESS")
                                }
                            }
                        }
 
                    */
                
                
                if let user = user {
                    let uid = result!.user.uid
                    //let grpBel = user.groupbelong
                    
                    let docRef = db.collection("users2").document(user.uid)
                    docRef.getDocument {   (document,error) in
                        if let document = document, document.exists {
                            grpid = document.get("groupbelong") as! String
                            print("groupid updated")
                            print(grpid)
                            
                            if grpid == "nogroup" {
                                //if user has not created / joined group then
                                //user brought to the group page
                                self.moveToGroupPage()
                            }
                            else {
                                //if user has a group then moves to homescreen straight
                                self.moveToHomeScreen()

                            }
                        }
                        else {
                            //print error
                            print("did not update grpid")
                        }
                    }
                    
                    
                    /*
                    
                    if uid != "" {
        
                        print(uid)
                        // change TESTDOC
                        
                        //
                        
                        let docRef = db.collection("users2").document(user.uid)
                        docRef.getDocument {   (document,error) in
                            if let document = document, document.exists {
                                grpid = document.get("groupbelong") as! String
                                print("groupid updated")
                                print(grpid)
                                
                                if grpid == "nogroup" {
                                    //if user has not created / joined group then
                                    //user brought to the group page
                                    self.moveToGroupPage()
                                }
                                else {
                                    //if user has a group then moves to homescreen straight
                                    self.moveToHomeScreen()

                                }
                            }
                            else {
                                //print error
                                print("did not update grpid")
                            }
                        }
                        
                        
                        
                        //print(grpid + "here now")
                        print(result!.user.uid)
                        print("ERROR")
                        
                    }
                ///
                    
                    */
                    
                    
                }
                
                
            }
        }
    
        
    }
    
    
    func moveToHomeScreen(){
        let homeViewController =
            self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    func moveToGroupPage(){
        let groupViewController =
            self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.groupViewController) as? GroupViewController
        
        self.view.window?.rootViewController = groupViewController
        self.view.window?.makeKeyAndVisible()
    }
    

    

}

