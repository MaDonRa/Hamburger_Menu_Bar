//
//  MenuBarTableViewCell.swift
//  silde menu
//
//  Created by Sakkaphong on 1/17/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

class MenuBarTableViewCell: UITableViewCell {

    @IBOutlet weak var TextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
