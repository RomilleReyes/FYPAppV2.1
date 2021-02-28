//
//  AcceptedCustomTableViewCell.swift
//  FYPAppV2.1
//
//  Created by Romille Reyes on 28/02/2021.
//

import UIKit

class AcceptedCustomTableViewCell: UITableViewCell {
    
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var taskTookBy: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
