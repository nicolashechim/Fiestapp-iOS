//
//  MisFiestasService.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 27/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Firebase

class MisFiestasService {
    
    class func obtenerFiestas(viewController: MisFiestasTableViewController) {
        var fiestas = [FiestaModel]()
        
        // Se obtienen los ids de las fiestas que tienen al usuario logueado como invitado
        FIRDatabase.database().reference().child("usuarios")
            .child(FirebaseService.shared.userIdFacebook!)
            .child("Fiestas")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                        
                        // Por cada id de fiesta se obtienen los datos de cada una
                        FIRDatabase.database().reference().child("fiestas")
                            .queryOrdered(byChild: "key")
                            .queryEqual(toValue: child.key)
                            .observeSingleEvent(of: .value, with: { (snapshot) in
                                if snapshot.exists() {
                                    for child in snapshot.children.allObjects {
                                        fiestas.append(FiestaModel(snapshot: child as! FIRDataSnapshot))
                                    }
                                    
                                    // Se actualiza el viewController con cada fiesta obtenida
                                    viewController.mostrarFiestas(fiestas: fiestas)
                                }
                            }) { (error) in
                                print(error.localizedDescription)
                                viewController.mostrarError()
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
        }
    }
}
