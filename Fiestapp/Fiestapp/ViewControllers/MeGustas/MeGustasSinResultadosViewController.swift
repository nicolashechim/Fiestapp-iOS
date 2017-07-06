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
    @IBAction func buttonMisMatches(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueMatches", sender: self)
    }
    @IBAction func goBack(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
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
        self.labelTitulo.text = titulo
        self.labelMensaje.text = mensaje
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
