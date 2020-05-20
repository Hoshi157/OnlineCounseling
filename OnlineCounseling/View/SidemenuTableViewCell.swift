//
//  SidemenuTableViewCell.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/21.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class SidemenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        	
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
