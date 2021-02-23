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

        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        db = Firestore.firestore()
        
        loadData()
        checkUpdates()
       
    }
    
    func loadData(){
        
        db.collection("E86F83C7-FEB8-4549-9808-29078056ED53").whereField("taskstatus2", isEqualTo: "Accepted").getDocuments() {
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
        db.collection("E86F83C7-FEB8-4549-9808-29078056ED53").whereField("taskstatus2", isEqualTo: "Accepted").addSnapshotListener {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //swapping out data
        //insted of creating multiple cells
        //dequing is processs of using previous cell as template for next cell
        let task = taskArray[indexPath.row]
        
        cell.textLabel?.text = "\(task.content)"
        //add detail of who accepted it?
        cell.detailTextLabel?.text = "\(task.name)"
        return cell
    }
}
