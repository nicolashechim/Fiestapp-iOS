//
//  InformacionTableViewCell.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 29/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit
import MapKit

class InformacionTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet var viewContentCell: UIView!
    @IBOutlet var viewCardMask: UIView!
    @IBOutlet var mapaUbicacion: MKMapView!
    @IBOutlet var labelDia: UILabel!
    @IBOutlet var labelHora: UILabel!
    @IBOutlet var labelNombreLugar: UILabel!
    @IBOutlet var buttonInfo: UIButton!
    @IBAction func buttonInfoOnPress(_ sender: UIButton) {
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
