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
        
        Common.applyGradientView(view: viewHeader)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
