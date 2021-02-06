//
//  GroupViewController.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 26/01/2021.
//

import UIKit

class GroupViewController: UIViewController {

    @IBOutlet weak var JoinGroupBTN: UIButton!
    //@IBOutlet weak var CreateGroupBTN: UIButton!
    
    //@IBOutlet weak var CreateGroupBTN2: UIButton!
    
    @IBOutlet weak var CreateGroupBTN3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
        
    }
    func setUpElements(){
        Utilities.styleFilledButton(JoinGroupBTN)
        Utilities.styleFilledButton(CreateGroupBTN3)
    }
    
    @IBAction func joinGroupBTNTapped(_ sender: Any) {
    }
    
    
    @IBAction func createGroupBTN2Tapped(_ sender: Any) {
    }
    @IBAction func createGroupBTN3Tapped(_ sender: Any) {
    }
}

// create animated view for join / create group
