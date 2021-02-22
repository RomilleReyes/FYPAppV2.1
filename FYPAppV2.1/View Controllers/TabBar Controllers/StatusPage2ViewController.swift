//
//  StatusPage2ViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 09/02/2021.
//

import UIKit
import DropDown
import Firebase
import FirebaseAuth

class StatusPage2ViewController: UIViewController {

    var db:Firestore!
    
    var groupArray = [Grouper]()
    var taskArray = [Task]()
    var updatedgroupid: String = ""
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Accept",
            "Decline"
        ]
        return menu
    }()
    
    
    
    @IBOutlet weak var groupCodeLABEL: KGCopyableLabel!
    //@IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var StatusBTN: UIBarButtonItem!
    let rightBarDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        /*
        print("this is using the updategroupfunc\(updatedgroupid)")
        //get groupid
        
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document(currentuid2)
        docRef.getDocument { [self] (document,error) in
            
            if let document = document {
                let property = document.get("groupbelong")
                let updatedgroupid = property as! String
                updategroupid(groupid: updatedgroupid)
                print("this is updatedgroupid in the func \(updatedgroupid)")
            }
            else {
                print("Document does not exist")
            }
            
        }
        //end of groupid
        print("this is AFTER using the updategroupfunc\(updatedgroupid)")
        */
        
        loadData()
        //checkforupdates()
        //checkForUpdatesV2()
        
        rightBarDropDown.anchorView = StatusBTN
              rightBarDropDown.dataSource = [
                "Available",
                "Engaged",
                "Busy"
              ]
              rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        
        //set group code as variable here so it can be called later
        
        /*
        //add group label to left side of navigation bar
        if let navigationBar = self.navigationController?.navigationBar {
            let leftFrame = CGRect(x: 20, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
 
            let leftLabel = UILabel(frame: leftFrame)
            leftLabel.text = "Group code"
            
            navigationBar.addSubview(leftLabel)
        }
        */
        
        //get groupid
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document(currentuid2)
        docRef.getDocument { [self] (document,error) in
            if let document = document {
                let property = document.get("groupbelong")
                let updatedgroupid = property as! String
                updategroupid(groupid: updatedgroupid)
                print("this is updatedgroupid in the func \(updatedgroupid)")
                
                groupCodeLABEL.text = "GroupID: \(updatedgroupid)"
                //groupCodeLABEL.intrinsicContentSize.width
                groupCodeLABEL.font = groupCodeLABEL.font.withSize(12)
                //groupCodeLABEL.frame = CGRect(x:  groupCodeLABEL.frame.origin.x, y: groupCodeLABEL.frame.origin.y, width: 100, height: groupCodeLABEL.frame.size.height)
                
                /*
                //let property2 = document.get("")
                
                //add group label to left side of navigation bar
                if let navigationBar = self.navigationController?.navigationBar {
                    let leftFrame = CGRect(x: 20, y: 0, width: navigationBar.frame.width/1.40, height: navigationBar.frame.height)
         
                    let leftLabel = UILabel(frame: leftFrame)
                    leftLabel.text = updatedgroupid
                    leftLabel.font = leftLabel.font.withSize(11)
                    navigationBar.addSubview(leftLabel)
                }
                */
               
            }
            else {
                print("Document does not exist")
            }
        }
        //end of groupid
     
        
        /*
        //get groupid
        
        //let db = Firestore.firestore()
        let currentuid3 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef2 = db.collection("usergroups").document(currentuid3)
        docRef.getDocument { [self] (document,error) in
            
            if let document = document {
                let property = document.get("groupname")
                let groupername = property as! String
                
                //add group label to left side of navigation bar
                if let navigationBar = self.navigationController?.navigationBar {
                    let leftFrame = CGRect(x: 20, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
         
                    let leftLabel = UILabel(frame: leftFrame)
                    leftLabel.text = groupername
                    leftLabel.font = leftLabel.font.withSize(14)
                    navigationBar.addSubview(leftLabel)
                
                
            }
            else {
                print("Document does not exist")
            }
            
        }
        //end of groupid
         
         }
        */
        
    }
    
    
    func loadData(){
        
        
        print("this is using the updategroupfunc\(updatedgroupid)")
        //get groupid
        
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document(currentuid2)
        docRef.getDocument { [self] (document,error) in
            
            if let document = document {
                let property = document.get("groupbelong")
                let updatedgroupid = property as! String
                updategroupid(groupid: updatedgroupid)
                print("this is updatedgroupid in the func \(updatedgroupid)")
                
                
                
                db.collection("users2").whereField("groupbelong", isEqualTo: updatedgroupid).getDocuments() {
                    querySnapshot, error in
                    if let error = error  {
                        print("\(error.localizedDescription)")
                    }
                    else {
                        print("suppsoed to print data in statusind")
                        self.groupArray = querySnapshot!.documents.flatMap({Grouper(dictionary2: $0.data())})
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    }
                }
                
                
            }
            else {
                print("Document does not exist")
            }
            
        }
        //end of groupid
        print("this is AFTER using the updategroupfunc\(updatedgroupid)")
        
        
        
        /*
        db.collection("users2").whereField("groupbelong", isEqualTo: returnupdatedgroupid()).getDocuments() {
            querySnapshot, error in
            if let error = error  {
                print("\(error.localizedDescription)")
            }
            else {
                print("suppsoed to print data in statusind")
                self.groupArray = querySnapshot!.documents.flatMap({Grouper(dictionary2: $0.data())})
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
        
        */
        
        
    }
    
    //will work for when a new user joins the group
    func checkforupdates() {
        
        print("this is using the updategroupfunc\(updatedgroupid)")
        //get groupid
        
        let db = Firestore.firestore()
        let currentuid2 = (Auth.auth().currentUser?.uid)!
        //var updatedgroupid = "not changed yet"
        let docRef = db.collection("users2").document(currentuid2)
        docRef.getDocument { [self] (document,error) in
            
            if let document = document {
                let property = document.get("groupbelong")
                let updatedgroupid = property as! String
                updategroupid(groupid: updatedgroupid)
                print("this is updatedgroupid in the func \(updatedgroupid)")
                
                /*
                db.collection("users2").whereField("groupbelong", isEqualTo: updatedgroupid).addSnapshotListener{
                    querySnapshot, error in
                    
                    guard let snapshot = querySnapshot else {return}
                    
                    snapshot.documentChanges.forEach{
                        diff in
                        
                        if diff.type == .added {
                            self.groupArray.append(Grouper(dictionary2: diff.document.data())!)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                */
                //division for checking status update
                db.collection("users2").whereField("timeStamp", isGreaterThan: Date()).addSnapshotListener{
                    querySnapshot, error in
                    
                    guard let snapshot = querySnapshot else {return}
                    
                    snapshot.documentChanges.forEach{
                        diff in
                        
                        if diff.type == .modified{
                            /*
                            self.groupArray.append(Grouper(dictionary2: diff.document.data())!)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                            */
                            loadData()
                        }
                    }
                }
                //ends here
                
                
            }
            else {
                print("Document does not exist")
            }
            
        }
        //end of groupid
        print("this is AFTER using the updategroupfunc\(updatedgroupid)")
        
        /*
        db.collection("users2").whereField("groupbelong", isEqualTo: returnupdatedgroupid()).addSnapshotListener{
            querySnapshot, error in
            
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach{
                diff in
                
                if diff.type == .added {
                    self.groupArray.append(Grouper(dictionary2: diff.document.data())!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        */
        
        
        
    }
    
    func checkForUpdatesV2() {
        //db.collection("C5CFB030-C2CE-4025-9E30-C762509582FF").whereField("timeStamp", isGreaterThan: Date()).addSnapshotListener {
        db.collection("users2").addSnapshotListener {
            querySnapshot, error in
            
            guard let snapshot  = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                diff in
                
                //need to also check for .deleted tasks
                if diff.type == .modified {
                    //self.groupArray.append(Grouper(dictionary2: diff.document.data())!)
                    DispatchQueue.main.async {
                        print("Supposed to refresh data since added document now")
                        self.tableView.reloadData()
                        
                        //self.tableView.reloadData(at: [indexPath], with: .fade)
                        //to update cell
                    }
                }
            }
        }
    }
    
    
    func updategroupid(groupid: String) {
        updatedgroupid = groupid
    }
    
    func returnupdatedgroupid() -> String {
        return updatedgroupid
    }
    
    
    @IBAction func StatusBTNTapped(_ sender: Any) {
        
        //self.loadView()
        rightBarDropDown.selectionAction = { (index: Int, item: String) in
            
                // do action here
                print("Selected item: \(item) at index: \(index)")
            
            //let changestatus = item
            self.StatusBTN.title = item
            
            //change title colour
            
            if index == 0 {
                self.StatusBTN.tintColor = UIColor.systemGreen
                
                //update database on user availability
                let db = Firestore.firestore()
                let currentuid2 = (Auth.auth().currentUser?.uid)!
                db.collection("users2").document(currentuid2).updateData([
                "userstatus":"Available",
                ])
            }
            else if index == 1{
                self.StatusBTN.tintColor = UIColor.systemYellow
                
                let db = Firestore.firestore()
                let currentuid2 = (Auth.auth().currentUser?.uid)!
                db.collection("users2").document(currentuid2).updateData([
                "userstatus":"Engaged",
                ])
            }
            else {
                self.StatusBTN.tintColor = UIColor.systemRed
                
                let db = Firestore.firestore()
                let currentuid2 = (Auth.auth().currentUser?.uid)!
                db.collection("users2").document(currentuid2).updateData([
                "userstatus":"Busy",
                ])
            }
            
            self.viewDidLoad()
            
        }
       
              rightBarDropDown.width = 140
              rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
              rightBarDropDown.show()
    }
    
    /*
    @objc func didTapStatusBTN(){
        menu.show()
    }
    */
    
    /*
      func numberOfSections(in tableView:UITableView) -> Int {
        print("going through tableViewFunc1")
        return 1
    }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("going through tableViewFunc2")
        return groupArray.count
        //number of rows you want
    }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //let groupdata = groupArray[indexPath.row]
        let groupdata = groupArray[indexPath.row]
        
        print("going through tableViewFunc3")
        //get users name
        cell.textLabel?.text = "\(groupdata.firstname)"
        
        //for second label
        //cell.detailTextLabel?.text = "\(groupdata.userstatus)"
        
        //cell.textLabel?.text = "\(task.content)"
        return cell
    }
 
    */
}
extension StatusPage2ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
        //number of rows you want
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = groupArray[indexPath.row]
        cell.textLabel?.text = "\(task.firstname) is \(task.userstatus)"
        //cell.detailTextLabel?.text = "\(task.userstatus)"
        //change colour of cell according to status?
        
        if task.userstatus == "Available" {
            //cell.backgroundColor = .systemGreen
            cell.contentView.backgroundColor = .systemGreen
        }
        else if task.userstatus == "Engaged" {
            //cell.backgroundColor = .systemYellow
            cell.contentView.backgroundColor = .systemYellow
        }
        else if task.userstatus == "Away" {
            cell.contentView.backgroundColor = .systemGray
        }
        else {
            //cell.backgroundColor = .systemRed
            cell.contentView.backgroundColor = .systemRed
        }
        return cell
    }
}
//take this out? since we dont need the click
extension StatusPage2ViewController: UITableViewDelegate{
    /*
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
    */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70 
    }
    }

    
    
