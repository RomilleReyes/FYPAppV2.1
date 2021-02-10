//
//  StatusPageViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 06/02/2021.
//

import UIKit
import DropDown
import FirebaseFirestore
import FirebaseAuth

class StatusPageViewController: UIViewController {
    
    @IBOutlet weak var User1Label: UILabel!
    @IBOutlet weak var User1Status: UITextField!
    
    
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Available",
            
            "Busy"
        ]
        return menu
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //for change status button
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        
        //change position of button
        let buttonMargins : CGFloat = 20
        button.frame.origin.x = (self.view.frame.width) - (button.frame.size.width) - (self.view.safeAreaInsets.right == 0 ? buttonMargins : self.view.safeAreaInsets.right ) + 20
        button.frame.origin.y = self.view.safeAreaInsets.top + buttonMargins + 20
        
        
        //check status here and change title and colour accordingly?
          //button.backgroundColor = .green
          button.setTitle("Status", for: .normal)
          button.addTarget(self, action: #selector(didTapStatusBTN), for: .touchUpInside)

          self.view.addSubview(button)
        
        menu.anchorView = button
        
        menu.selectionAction = { [self] index, title in
            print("index \(index) and \(title)")
            
            if index == 0 {
                //available
                //change status to avaiable
                updateStatus(UserStatus: title)
                
                //change button
                
                button.setTitleColor(.green, for: .normal)
                button.setTitle(title, for: .normal)
            }
            else if index == 1 {
                //busy
                //change status to busy
                updateStatus(UserStatus: title)
                
                //change button
                
                button.setTitleColor(.red, for: .normal)
                button.setTitle(title, for: .normal)
            }
            }
        
        
        
        
        
        
            let db = Firestore.firestore()
            let collectionRef = db.collection("groupmembers")
            let currentuid2 = (Auth.auth().currentUser?.uid)!
            
            //get groupid by using uid and checking for group?

            //testing this code outside function
            var updatedgroupid = "not changed yet"
            let docRef = db.collection("users2").document(currentuid2)
            docRef.getDocument { (document,error) in
                
                //get specific field
                //groupbelong
                if let document = document {
                    let property = document.get("groupbelong")
                    updatedgroupid = property as! String
                    print("This is group id here \(updatedgroupid)")
                    
                }
                else {
                    print("Document does not exist")
                    //return
                }
            
            //testing this code
            
            
            print("this is group id after calling function \(updatedgroupid)")
            
            let documentRef = collectionRef.document(updatedgroupid)
            var FIELDCOUNT = 0
            
            documentRef.getDocument(completion: { Snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                //counts number of members
                FIELDCOUNT = (Snapshot?.data()?.count)!
                print("this is the field count \(FIELDCOUNT)")
            
                let numOfMembers = FIELDCOUNT
                print("this is number of members \(numOfMembers)")
                
               
                
        }
            )
                
                
                // get user groupcode
                //check number of users
                
                //use groupmembers
                //for loop
                //run same times as number of members
                //let numOfMembers = 3
                //countMembers()
                //for index in 1...numOfMembers{
                //change label and text for each index
                    
                    
                //}
                
                
            }
                /*
                //get name of member1
                print("This is the groupid before getting name: \(updatedgroupid)")
                let docRef2 = db.collection("groupmembers").document(updatedgroupid)
                docRef.getDocument { (document,error) in
                    
                    //get specific field
                    //groupbelong
                    if let document = document {
                        let property = document.get("member1")
                        var usersname = property as! String
                        print("This is group id here \(usersname)")
                        
                        //change textlabel
                            self.User1Label.text = usersname
                    }
                    else {
                        print("Document does not exist")
                        return
                    }
                
               
                
            }
                 */
            
        
        
        
        
        
        
        
    }
    
    
    func countMembers(){
        let db = Firestore.firestore()
        let collectionRef = db.collection("groupmembers")
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        
        //get groupid by using uid and checking for group?

        //testing this code outside function
        var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document(currentuid2)
        docRef.getDocument { (document,error) in
            
            //get specific field
            //groupbelong
            if let document = document {
                let property = document.get("groupbelong")
                updatedgroupid = property as! String
                print("This is group id here \(updatedgroupid)")
                
            }
            else {
                print("Document does not exist")
                return
            }
        
        //testing this code
        
        
        print("this is group id after calling function \(updatedgroupid)")
        
        let documentRef = collectionRef.document(updatedgroupid)
        var FIELDCOUNT = 0
        
        documentRef.getDocument(completion: { Snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            //counts number of members
            FIELDCOUNT = (Snapshot?.data()?.count)!
            print("this is the field count \(FIELDCOUNT)")
        
            let numOfMembers = FIELDCOUNT
            print("this is number of members \(numOfMembers)")
            
            //return Int(numOfMembers)
    }
        )
        }
        
        return
    }
    
    func getgroupid() -> String{
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document(currentuid2)
        docRef.getDocument { (document,error) in
            
            if let document = document {
                let property = document.get("groupbelong")
                updatedgroupid = property as! String
                print("This is group id here \(updatedgroupid)")
                
            }
            else {
                print("Document does not exist")
            }
            
    }
        return  updatedgroupid
    }
        
   
    
    func updateStatus(UserStatus: String) {
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        db.collection("users2").document(currentuid2).updateData([
        "userstatus":UserStatus,
        ])
    }
    
    
    
    @objc func didTapStatusBTN(){
        menu.show()
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
/*
class dropDownBtn: UIButton{
    override init(frame:CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
 */
