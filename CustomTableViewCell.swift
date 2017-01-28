//
//  CustomTableViewCell.swift
//  planWMI
//
//  Created by user115090 on 1/16/17.
//  Copyright © 2017 wojek. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var classroom1: UILabel!
    @IBOutlet var classroom: UILabel!
    @IBOutlet var lesson: UILabel!
    @IBOutlet var hour: UILabel!
    override func awakeFromNib() {
    
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
