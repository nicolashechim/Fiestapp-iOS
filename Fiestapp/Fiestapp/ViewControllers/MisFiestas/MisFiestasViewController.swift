//
//  MisFiestasViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 13/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit
import FirebaseAuth

class MisFiestasViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var viewHeader: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.shared.applyGradientView(view: viewHeader)
        
        //Back-left gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
