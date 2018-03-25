//
//  MenuBarTableViewCell.swift
//  silde menu
//
//  Created by Sakkaphong on 1/17/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit

class MenuBarTableViewCell: UITableViewCell {

    @IBOutlet weak var IconImageView: UIImageView!
    @IBOutlet weak var TextLabel: UILabel!
    
    @IBOutlet weak var BackgroundBadgeView: UIView!
    @IBOutlet weak var BadgeLabel: UILabel!
    
    private let Font = ResizeFont()
    
    override func awakeFromNib() {
        Font.LabelFontSizeArray([TextLabel,
                                 BadgeLabel])
        
        self.TextLabel.isHidden = true
        self.IconImageView.isHidden = true
        self.BackgroundBadgeView.isHidden = true
        self.BadgeLabel.isHidden = true
        
        self.BackgroundBadgeView.layer.masksToBounds = true
        self.BackgroundBadgeView.layer.cornerRadius = (((ScreenSize.SCREEN_HEIGHT/667) * 50)/2.5) / 2.0
    }
    
    override func prepareForReuse() {
        self.IconImageView.image = nil
    }
}
