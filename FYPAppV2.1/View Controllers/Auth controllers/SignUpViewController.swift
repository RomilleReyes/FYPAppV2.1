//
//  SignUpViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 18/01/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        //hides the error label when nothing is showing
        errorLabel.alpha = 0
        
        //style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }

    //check fields if the data is correct and if it is then the method will return nil
    //if wrong then error message produced
    //returns optional string
    func validateFields() -> String? {
        
        //check all fields are filled
        
        //take away white spaces and new lines
        //and check if empty
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""    ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            return "Please fill in all fields"
        }
        
        //check is password is secure enough
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if  Utilities.isPasswordValid(cleanedPassword) == false {
            // passsword not good enough
            return "The password needs to have at least 8 characters, one special character and a number"
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate fields
        let error = validateFields()
        if error != nil {
            //something wrong with fields
            showError(error!)
        }
        else {
            
            //clean version of data
            //no white space and lines
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //let groupBelong = "nogroup"
                
        
        // create user
            Auth.auth().createUser(withEmail: email, password: password) { ( result, err) in
                
                //check for errors
                
                if err != nil {
                    // error creating user
                    self.showError("Error creating the user")
                }
                else {
                    
                    let db = Firestore.firestore()

                    db.collection("users2").document(result!.user.uid).setData([
                        "firstname":firstName,
                        "lastname":lastName,
                        "email":email,
                        "uid":result!.user.uid,
                        "groupbelong":"nogroup",
                    ])
                    { err in
                        if let err = err {
                            print("error")
                        }
                        else {
                            print("error2")
                        }
                    }
                    
                    self.moveToGroupPage()
                    
                   
                }
            }
            
        }
        
    }
    
    
    
    func transitionToHome(){
        self.showError("movingtoHomenow")
        let homeViewController =
        storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func moveToGroupPage(){
        let groupViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.groupViewController) as? GroupViewController
        self.view.window?.rootViewController = groupViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
}
