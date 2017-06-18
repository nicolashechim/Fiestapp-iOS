//
//  MeGustasTableViewCell.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 31/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class MeGustasTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet var viewContentCell: UIView!
    @IBOutlet var viewCardMask: UIView!
    @IBOutlet var imageViewUsuario1: UIImageView!
    @IBOutlet var imageViewUsuario2: UIImageView!
    @IBOutlet var imageViewUsuario3: UIImageView!
    @IBOutlet var labelSinInvitados: UILabel!
    @IBOutlet var buttonQuienTeGusta: UIButton!
    @IBAction func buttonQuienTeGustaOnPress(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
