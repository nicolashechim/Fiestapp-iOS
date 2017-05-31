//
//  UIViewExtension.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 31/5/17.
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
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
