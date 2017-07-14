//
//  NuevaFiestaViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 13/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class NuevaFiestaViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewContent: UIView!
    @IBOutlet var viewCardMask: UIView!
    @IBOutlet var inputCodigo: UITextField!
    @IBAction func buttonSubmit(_ sender: UIButton) {
        ProgressOverlayView.shared.showProgressView(view)
        FiestaService.shared.agregarFiesta(codigo: inputCodigo.text!) { success in
            ProgressOverlayView.shared.hideProgressView()
            if success {
                let alertController = UIAlertController(title: "¡Fiesta añadida!", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                {
                    (result : UIAlertAction) -> Void in
                    if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") {
                        UIApplication.shared.keyWindow?.rootViewController = homeViewController
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: "Código inválido. ¡Probá con otro!", preferredStyle: UIAlertControllerStyle.actionSheet)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                {
                    (result : UIAlertAction) -> Void in
                })
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.shared.applyGradientView(view: viewHeader)
        Common.shared.initCardMaskCell(viewContent: self.viewContent, viewMask: self.viewCardMask)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
