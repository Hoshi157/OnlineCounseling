//
//  ImageNameOnlyTableViewCell.swift
//  OnlineCounseling
//
//  Created by 福山帆士 on 2020/05/25.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class ImageNameOnlyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avaterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
