//
//  FiestaService.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 10/6/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Firebase

class FiestaService {
    
    class func FiltrarInvitadosMeGustas(idFiesta: String, completionHandler:@escaping ([String]) -> ()) {
        var idsAFiltrar = [String]()
        
        // Se obtienen ids de los invitados de una fiesta a los que el usuario logueado les ha dado like o nope
        FIRDatabase.database().reference().child("meGustas")
            .child(idFiesta)
            .child(FirebaseService.shared.userIdFacebook!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                        let childOfChild = child.children
                        if child.key == "LikesDados" || child.key == "NopesDados" {
                            while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                                let idUsuario = childOfChildSnapshot.key
                                idsAFiltrar.append(idUsuario)
                                print(idsAFiltrar)
                            }
                        }
                    }
                }
                completionHandler(idsAFiltrar)
            }) { (error) in
                print(error.localizedDescription)
        }
    }
}
