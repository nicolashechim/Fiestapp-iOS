//
//  MeGustasSinResultadosViewController
//  Fiestapp
//
//  Created by Nicolás Hechim on 1/7/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class MeGustasSinResultadosViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var labelTitulo: UILabel!
    @IBOutlet var labelMensaje: UILabel!
    @IBOutlet var buttonMisMatches: UIButton!
    @IBAction func buttonMisMatches(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueMatches", sender: self)
    }
    @IBAction func goBack(_ sender: UIButton) {
        if let navController = self.navigationController {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if (appDelegate.vc != nil) {
                navController.popToViewController(appDelegate.vc!, animated:true)
            }
            else {
                navController.popToRootViewController(animated: true)
            }
        }
    }
    
    var mensaje = String()
    var titulo = String()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setMensaje(mensaje: String) {
        self.mensaje = mensaje
    }
    
    func setTitulo(titulo: String) {
        self.titulo = titulo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.shared.applyGradientView(view: viewHeader)
        print(titulo)
        print(MeGustasService.SIN_MATCHES)
        if mensaje == MeGustasService.SIN_MATCHES {
            self.buttonMisMatches.isHidden = true
        }
        self.labelTitulo.text = titulo
        self.labelMensaje.text = mensaje
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if mensaje == MeGustasService.SIN_MATCHES {
            self.buttonMisMatches.isHidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
