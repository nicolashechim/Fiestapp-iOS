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
    @IBOutlet var buttonLogout: UIButton!
    @IBAction func logout(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Cerrar sesión", message: "¿Seguro que quieres cerrar sesión? Necesitas estar logueado para utilizar Fiestapp!", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
        })
        
        alertController.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.destructive)
        {
            (result : UIAlertAction) -> Void in
            try! FIRAuth.auth()!.signOut()
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Back-left gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.applyGradientView(view: viewHeader)
        
        //Back-left gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
}
