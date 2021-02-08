//
//  NewTasksViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 06/02/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
//import FirebaseFirestore

class NewTasksViewController: UIViewController {
    
    //@IBOutlet var tableView: UITableView!
    var db:Firestore!
    //let db = Firestore.firestore()
    
    var taskArray = [Task]()
    
    @IBOutlet weak var composeTaskBTN: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        //self.tabBarController?.tabBar.isHidden = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        checkForUpdates()
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
    
    //autocheck for updates
    func checkForUpdates() {
        //db.collection("C5CFB030-C2CE-4025-9E30-C762509582FF").whereField("timeStamp", isGreaterThan: Date()).addSnapshotListener {
        db.collection("C5CFB030-C2CE-4025-9E30-C762509582FF").addSnapshotListener {
            querySnapshot, error in
            
            guard let snapshot  = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                diff in
                
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
}






extension NewTasksViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
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
