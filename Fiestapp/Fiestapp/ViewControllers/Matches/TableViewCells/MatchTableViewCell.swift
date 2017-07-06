//
//  MatchTableViewCell.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 2/7/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var cardMask: UIView!
    @IBOutlet var contentViewCell: UIView!
    @IBOutlet weak var iconCircle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
