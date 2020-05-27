//
//  CustomTextTableViewCell.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/17.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class CustomTextTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var underLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
