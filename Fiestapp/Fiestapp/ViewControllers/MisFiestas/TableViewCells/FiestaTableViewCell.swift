//
//  FiestaTableViewCell.swift
//  
//
//  Created by Nicolás Hechim on 13/5/17.
//
//

import UIKit

class FiestaTableViewCell: UITableViewCell {

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var title: UILabel!
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
