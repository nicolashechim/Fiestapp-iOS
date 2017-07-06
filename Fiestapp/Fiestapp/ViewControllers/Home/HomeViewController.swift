//
//  HomeViewController.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 2/7/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController, UITabBarControllerDelegate {
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Cerrar sesión" {
            let alertController = UIAlertController(title: "Cerrar sesión", message: "¿Seguro que querés cerrar sesión? Necesitás estar logueado para utilizar Fiestapp!", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
                (result : UIAlertAction) -> Void in
            })
            
            alertController.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.destructive)
            {
                (result : UIAlertAction) -> Void in
                FirebaseService.shared.cerrarSesion()
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
