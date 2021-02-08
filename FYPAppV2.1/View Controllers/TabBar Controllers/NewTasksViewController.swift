//
//  NewTasksViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 06/02/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NewTasksViewController: UIViewController {
    
    //@IBOutlet var tableView: UITableView!
    
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.tabBarController?.tabBar.isHidden = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewTasksViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
    }
    
}

extension NewTasksViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        //number of rows you want
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = "Hello world"
        return cell
    }
}
