//
//  NewTasksViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 06/02/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import DropDown
//import FirebaseFirestore

class NewTasksViewController: UIViewController {
    
    //@IBOutlet var tableView: UITableView!
    //var db:Firestore
    var db = Firestore.firestore()
    
    var taskArray = [Task]()
    
    var updatedgroupid = ""
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Accept",
            "Decline"
        ]
        return menu
    }()
    
    @IBOutlet weak var composeTaskBTN: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preloadData()

        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        //self.tabBarController?.tabBar.isHidden = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        checkForUpdates()
        
        
        /*
        //trial to get groupid
        let currentuid3 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef2 = db.collection("usergroups").document(currentuid3)
        docRef2.getDocument { [self] (document,error) in
            
            if let document = document {
                let property = document.get("groupname")
                let groupername = property as! String
                
                
                
            }
            else {
                print("Document does not exist")
            }
            
        }
        //end of trial
        */
        
    }
    
    func loadData(){
        
        //let testingglobaluid = Globaluid.globuid
        print("entered load data function but not loading data")
        
        db.collection("C5CFB030-C2CE-4025-9E30-C762509582FF").getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                print("Supposed to print data now")
                self.taskArray = querySnapshot!.documents.flatMap({Task(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func preloadData(){
        //get groupid
        
        //let db = Firestore.firestore()
        let currentuid3 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef2 = db.collection("users2").document(currentuid3)
        docRef2.getDocument { [self] (document, error) in
            
            if let document = document {
                let property = document.get("groupbelong")
                let grouperid = property as! String
                
                updatedgroupid = grouperid
                updategroupid(groupid: updatedgroupid)
            }
            else {
                print("Document does not exist")
            }
            
        }
    }
    
    //autocheck for updates
    func checkForUpdates() {
        //db.collection("C5CFB030-C2CE-4025-9E30-C762509582FF").whereField("timeStamp", isGreaterThan: Date()).addSnapshotListener {
        db.collection("C5CFB030-C2CE-4025-9E30-C762509582FF").addSnapshotListener {
            querySnapshot, error in
            
            guard let snapshot  = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                diff in
                
                //need to also check for .deleted tasks
                if diff.type == .added {
                    self.taskArray.append(Task(dictionary: diff.document.data())!)
                    DispatchQueue.main.async {
                        print("Supposed to refresh data since added document now")
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func updateTaskStatus(UserStatus: String) {
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        db.collection("users2").document(currentuid2).updateData([
        "userstatus":UserStatus,
        ])
    }
    
    
    
    @IBAction func composeTaskBTNTapped(_ sender: Any) {
        
        let composeAlert = UIAlertController(title: "New Task", message: "Enter description for the task", preferredStyle: .alert)
        
        
        composeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your name"
        }
        
        
        composeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Description"
        }
        
        composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        composeAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            
            
            
            // ADDING TASK TO DATABASE
            if let name = composeAlert.textFields?.first?.text, let content = composeAlert.textFields?.last?.text {
                
                let newTask = Task(name: name, content: content)
                
                var ref:DocumentReference? = nil
                
                
                //getuid
                let currentuid2 = (Auth.auth().currentUser?.uid)!
                var updatedgroupid = "not changed yet"
                let docRef = self.db.collection("users2").document(currentuid2)
                docRef.getDocument { (document,error) in
                    
                    //get specific field
                    //get groupid
                    if let document = document {
                        let property = document.get("groupbelong")
                        updatedgroupid = property as! String
                        print("This is group id here \(updatedgroupid)")
                        
                        //append uid
                        Globaluid.globuid = updatedgroupid
                        
                        
                        
                        //trial
                        
                        ref = self.db.collection(updatedgroupid).addDocument(data: newTask.dictionary){
                            error in
                            
                            if let error = error {
                                print("error adding document")
                                
                            }
                            else {
                                print("Document added with ID: \(ref!.documentID)")
                            }
                        }

                        //trial end
                    }
                    else {
                        print("Document does not exist")
                        return
                    }
                }
                
                //add task to own group collection
                //ref = self.db.collection("grouptasks").document(updatedgroupid).setData()
                
                            }
            
            
            
            
        }))
        
        self.present(composeAlert, animated: true, completion: nil)
        
        
    }
    /*
    func countDocuments(){
        let db = Firestore.firestore()
        db.collection('...').get().then(snap => {
           size = snap.size // will return the collection size
        });
    }
    */
    

    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    */
    struct Globaluid{
        static var globuid = String()
    }
    
    func updategroupid(groupid: String) {
        updatedgroupid = groupid
    }
    
    func returnupdatedgroupid() -> String {
        return updatedgroupid
    }
}






extension NewTasksViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        menu.anchorView = cell
        menu.selectionAction = { [self] index, title in
            print("index \(index) and \(title)")
            
            if index == 0 {
                //accepted
                //change status to avaiable
                //updateStatus(UserStatus: title) CHANGETO updateTaskStatus
                
                //move to completed task page
            }
            else if index == 1 {
                //declined
                //change status to declined?
                //updateStatus(UserStatus: title) CHANGETO updateTaskStatus
                
                //move to completed task page
            }
            }
        print("you tapped me")
    }
    
    //when cell is tapped
    //present anchorview 
    //menu.anchorView = button
    
    //swipe left and right gesture from developers log blog
    func tableView(_ tableView: UITableView,
                    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
         let closeAction = UIContextualAction(style: .normal, title:  "Decline", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                 print("OK, marked as Closed")
            //this is swipe right
            //update database that user has declined
            //do this by adding user to the field?
            //or uid:accepted // uid:declined
                 success(true)
             })
             closeAction.image = UIImage(named: "tick")
             closeAction.backgroundColor = .systemRed
     
             return UISwipeActionsConfiguration(actions: [closeAction])
     
     }
     
     func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
         let modifyAction = UIContextualAction(style: .normal, title:  "Accept", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
             print("Update action ...")
            //this is swipe left
            //update database that user has accepted
             success(true)
         })
         modifyAction.image = UIImage(named: "hammer")
         modifyAction.backgroundColor = .systemGreen
     
         return UISwipeActionsConfiguration(actions: [modifyAction])
     }
    
    
}

extension NewTasksViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
        //number of rows you want
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let task = taskArray[indexPath.row]
        
        
        cell.textLabel?.text = "\(task.content)"
        return cell
    }
}
