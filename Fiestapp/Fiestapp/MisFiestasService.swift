//
//  MisFiestasService.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 27/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Firebase

class MisFiestasService {
    
    class func obtenerFiestas(viewController: MisFiestasTableViewController)  {
        FIRDatabase.database().reference().child("fiestas").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                var fiestas = [FiestaModel]()
                for child in snapshot.children.allObjects {
                    fiestas.append(FiestaModel(snapshot: child as! FIRDataSnapshot))
                }
                viewController.mostrarFiestas(fiestas: fiestas)
            }
        }) { (error) in
            print(error.localizedDescription)
            viewController.mostrarError()
        }
    }
}
