//
//  MisFiestasViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 13/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class MisFiestasViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var viewHeader: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Back-left gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Back-left gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        viewHeader.applyGradient(colours: [UIColor(red: 44/255, green: 193/255, blue: 255/255, alpha: 1),
                                           UIColor(red: 44/255, green: 93/255, blue: 255/255, alpha: 1)],
                                 locations: [0.0, 1.0])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
