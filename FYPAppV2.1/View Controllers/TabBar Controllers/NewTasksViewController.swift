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
    
    var selectedCellIndexPath: NSIndexPath?
    let selectedCellHeight: CGFloat = 88.0
    
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
        //print("entered load data function but not loading data")
        
        //db.collection("E86F83C7-FEB8-4549-9808-29078056ED53").getDocuments() {
        db.collection("D080F830-F22E-4E40-BDF4-7CC4B794A820").whereField("taskstatus2", isEqualTo: "Unassigned").getDocuments() {
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
        db.collection("D080F830-F22E-4E40-BDF4-7CC4B794A820").whereField("taskstatus2", isEqualTo: "Unassigned").addSnapshotListener {
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
                
                // add if diff.type ==.deleted??
            }
        }
    }
    
    func updateTaskStatus(UserStatus: String) {
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        
        // change this to collection group code.document
        db.collection("users2").document(currentuid2).updateData([
        "userstatus":UserStatus,
        ])
    }
    
    
    
    @IBAction func composeTaskBTNTapped(_ sender: Any) {
        
        let composeAlert = UIAlertController(title: "New Task", message: "Enter description for the task", preferredStyle: .alert)
        
        
        let nameEntered = composeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your name"
        }
        
        
        let DescriptionEntered = composeAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Description"
        }
        
        composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        composeAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            
            
            
            // ADDING TASK TO DATABASE
            if let name = composeAlert.textFields?.first?.text, let content = composeAlert.textFields?.last?.text {
                
                if name.isEmpty || content.isEmpty {
                    
                  print("field empty")
                }
                else {
                
                let taskstatus2 = "Unassigned"
                let documentID = "checking"
                let acceptedBy = "NoOne"
                    let newTask = Task(name: name, content: content, taskstatus2: taskstatus2, documentID: documentID, acceptedBy:acceptedBy)
                //add documentid here
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
                        //change group id
                        let ref = self.db.collection(updatedgroupid)
                        let ref2 = ref.addDocument(data: newTask.dictionary){
                            error in
                            
                            if let error = error {
                                print("error adding document")
                                
                                
                            }
                            else {
                                //print("Document added with ID: \(ref2.documentID)")
                                // add
                            }
                           
                            
                        }
                        print("Document added with ID: \(ref2.documentID)")

                        ///update document and add as doc id
                        
                        ref.document("\(ref2.documentID)").updateData([
                            "taskstatus2": "Unassigned",
                            "documentID": "\(ref2.documentID)",
                            "acceptedBy": "\(currentuid2)"
                            
                        ])
                        { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                        //trial end
                    }
                    else {
                        print("Document does not exist")
                        return
                    }
                    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        
        //let cell = tableView.cellForRow(at: indexPath)
        //menu.anchorView = cell
        /*
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
        */
        
       //let selectedSortingRow = cell
       // tableView.deselectRow(at: indexPath, animated: true)
        /*
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
                selectedCellIndexPath = nil
            } else {
                selectedCellIndexPath = indexPath
            }
        
            tableView.beginUpdates()
            tableView.endUpdates()

            if selectedCellIndexPath != nil {
                // This ensures, that the cell is fully visible once expanded
                tableView.scrollToRow(at: indexPath as IndexPath, at: .none, animated: true)
            }
        
        print("you tapped me")
        */
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedCellIndexPath == indexPath {
                return selectedCellHeight
            }
        return 30
    }
    */
    
    
    
    
    //swipe left developers log blog
    func tableView(_ tableView: UITableView,
                    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
         let closeAction = UIContextualAction(style: .normal, title:  "Accept", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                 print("OK, marked as accepted")
            //this is swipe right
            //update database that user has accepted
                 success(true)
             })
             closeAction.image = UIImage(named: "tick")
             closeAction.backgroundColor = .systemGreen

            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        //taskArray.remove(at: indexPath.row)
        //tableView.deleteRows(at: [indexPath], with: .fade)
        //vr1
        let task = taskArray[indexPath.row]
        let taskdescription = task.content
        let chosendocument = task.documentID
        
        
        let ref = self.db.collection(updatedgroupid).document("\(chosendocument)").updateData([
            "taskstatus2":"Accepted"
        
        ])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        taskArray.remove(at: indexPath.row)
        //tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.deleteRows(at: [indexPath], with: .top)
        //update taskstatus to Accepted
        
        //
        /*
        for document in snapshot!.documents {

          if document == document {
           print(document.documentID)
             }
               }
        */
        //find documentid by using wherefield == (same as content and name)
        //db.collection("BD2EF9C0-5BE1-4CF2-AD95-C904E1A87D09").whereField("content", isEqualTo: "\(taskdescription)")
        //update field taskstatus: "Accepted"
        //update and add uid to the task
        
        //delete task from this page
        
        /*
         taskArray.remove(at: indexPath.row)
         tableView.deleteRows(at: [indexPath], with: .fade)
        */
        
        //ver2
        //add to completed task
        // move to completed task
        //add also userid
        //add also groupid
        
        
             return UISwipeActionsConfiguration(actions: [closeAction])
     
     }
    /*
      //this is to swipe left
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
        
        // user accepted task
        //add completed to database
        
        //updateTaskStatus(UserStatus: "Accepted")
     
         return UISwipeActionsConfiguration(actions: [modifyAction])
     }
 */
    
    //swipe left to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
     
                taskArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            

            // change text to delete instead of decline
            }
    
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
