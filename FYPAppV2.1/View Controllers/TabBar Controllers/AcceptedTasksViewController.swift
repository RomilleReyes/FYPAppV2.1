//
//  AcceptedTasksViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 23/02/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AcceptedTasksViewController: UIViewController {

    var db = Firestore.firestore()
    var taskArray = [Task]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //use custom cell
        let nib = UINib(nibName: "AcceptedCustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AcceptedCustomTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        db = Firestore.firestore()
        
        loadData()
        checkUpdates()
       
    }
    
    func loadData(){
        
        db.collection("13303EE4-17C5-4003-8DB8-A2CB1578E531").whereField("taskstatus2", isEqualTo: "Accepted").getDocuments() {
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
    
    func checkUpdates(){
        db.collection("13303EE4-17C5-4003-8DB8-A2CB1578E531").whereField("taskstatus2", isEqualTo: "Accepted").addSnapshotListener {
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
    



}

extension AcceptedTasksViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
    
    
}

extension AcceptedTasksViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptedCustomTableViewCell",
                                                 for: indexPath) as! AcceptedCustomTableViewCell
        //swapping out data
        //insted of creating multiple cells
        //dequing is processs of using previous cell as template for next cell
        let task = taskArray[indexPath.row]
        
        cell.taskLabel.text = "\(task.content)"
        
        //check users name using task.name
        
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document("\(task.acceptedBy)")
        docRef.getDocument { [self] (document,error) in
            if let document = document {
                let property = document.get("firstname")
                let taskTookOnBy = property as! String
                //updategroupid(groupid: updatedgroupid)
                //print("this is the name of the task taker \(taskTookOnBy)")
               
                cell.taskTookBy.text = "⇢ \(taskTookOnBy)"
            }
            else {
                print("Document does not exist")
            }
        }
        
        //cell.taskTookBy.text = "Taken on by: \(task.name)"
        
        //cell.textLabel?.text = "\(task.content)"
        //add detail of who accepted it?
        //cell.detailTextLabel?.text = "\(task.name)"
        
        //change colour of cells associated with the user
        //let currentuid2 = (Auth.auth().currentUser?.uid)!
        if task.acceptedBy == currentuid2 {
            cell.contentView.backgroundColor = .systemGreen
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;//Choose your custom row height
    }
    
}
