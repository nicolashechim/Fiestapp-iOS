//
//  MatchesViewController.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 2/7/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var viewHeader: UIView!
    @IBAction func goBack(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    var idFiesta = String()
    
    func setIdFiesta(idFiesta: String) {
        self.idFiesta = idFiesta
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.shared.applyGradientView(view: self.viewHeader)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
