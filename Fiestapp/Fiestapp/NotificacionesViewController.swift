//
//  NotificacionesViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 13/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//


import UIKit

class NotificacionesViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var viewHeader: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeader.applyGradient(colours: [UIColor(red: 0/255, green: 177/255, blue: 255/255, alpha: 1),
                                           UIColor(red: 232/255, green: 0/255, blue: 166/255, alpha: 1)],
                                 locations: [0.0, 1.0])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
