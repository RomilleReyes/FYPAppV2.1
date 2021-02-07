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
        
        /*
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapStatusBTN))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        */
    }
    /*
    @objc func buttonAction(sender: UIButton!) {
      print("Button tapped")
    }
    */
    
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
