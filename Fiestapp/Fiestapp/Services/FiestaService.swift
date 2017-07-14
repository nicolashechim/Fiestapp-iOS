//
//  FiestaService.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 10/6/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Firebase

class FiestaService {
    
    static let shared = FiestaService()
    
    func obtenerFiestas(completionHandler:@escaping ([FiestaModel]) -> ()) {
        var fiestas = [FiestaModel]()
        
        // Se obtienen los ids de las fiestas que tienen al usuario logueado como invitado
        FirebaseService.shared.ref.child("usuarios")
            .child(FirebaseService.shared.userIdFacebook!)
            .child("Fiestas")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                        
                        // Por cada id de fiesta se obtienen los datos de cada una
                        FirebaseService.shared.ref.child("fiestas")
                            .queryOrdered(byChild: "key")
                            .queryEqual(toValue: child.key)
                            .observeSingleEvent(of: .value, with: { (snapshot) in
                                if snapshot.exists() {
                                    for child in snapshot.children.allObjects {
                                        fiestas.append(FiestaModel(snapshot: child as! FIRDataSnapshot))
                                    }
                                }
                                
                                // Por cada fiesta que obtengo, refresco el ViewController
                                completionHandler(fiestas)
                            }) { (error) in
                                print(error.localizedDescription)
                        }
                    }
                }
                else {
                    completionHandler(fiestas)
                }
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func filtrarInvitadosMeGustas(idFiesta: String, completionHandler:@escaping ([String]) -> ()) {
        var idsAFiltrar = [String]()
        
        // Se obtienen ids de los invitados de una fiesta a los que el usuario logueado les ha dado like o nope
        FirebaseService.shared.ref.child("meGustas")
            .child(idFiesta)
            .child(FirebaseService.shared.userIdFacebook!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                        let childOfChild = child.children
                        if child.key == EnumReaccionesMeGustas.LikesDados.rawValue || child.key == EnumReaccionesMeGustas.NopesDados.rawValue {
                            while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                                let idUsuario = childOfChildSnapshot.key
                                idsAFiltrar.append(idUsuario)
                            }
                        }
                    }
                }
                completionHandler(idsAFiltrar)
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func agregarFiesta(codigo: String, completionHandler:@escaping (Bool) -> ()) {
        // Se busca si existe fiesta con el id ingresado
        FirebaseService.shared.ref.child("fiestas")
            .queryOrdered(byChild: "Codigo")
            .queryEqual(toValue: codigo)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    // Se encontró una fiesta con el código ingresado
                    var fiestas = [FiestaModel]()
                    // Se mapea a FiestaModel
                    for child in snapshot.children.allObjects {
                        fiestas.append(FiestaModel(snapshot: child as! FIRDataSnapshot))
                    }
                    // El usuario logueado ya es invitado de la fiesta?
                    if ((fiestas.first?.Usuarios.index(where: { $0.Id == FirebaseService.shared.userIdFacebook })) != nil) {
                        completionHandler(false)
                    }
                    else {
                        // Se agrega la fiesta al listado de fiestas del usuario logueado
                        FirebaseService.shared.ref.child("usuarios")
                            .child("/" + FirebaseService.shared.userIdFacebook! + "/Fiestas/" + (fiestas.first?.key)!)
                            .setValue(true)
                        
                        // Se agrega el usuario al listado de usuarios de la fiesta
                        FirebaseService.shared.ref.child("fiestas")
                            .child("/" + (fiestas.first?.key)! + "/Usuarios/" + FirebaseService.shared.userIdFacebook!)
                            .setValue(true)
                        
                        completionHandler(true)
                    }
                }
                else {
                    completionHandler(false)
                }
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
}
