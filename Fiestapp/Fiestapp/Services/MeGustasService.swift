//
//  MeGustasService.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 1/7/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Firebase

class MeGustasService {
    
    static let shared = MeGustasService()
    static let MIS_MATCHES = "Mis matches"
    static let QUIEN_TE_GUSTA = "¿Quién te gusta?"
    static let SIN_INVITADOS = "Aún no hay invitados para evaluar, ¡Volvé más tarde!"
    static let SIN_MATCHES = "Aún no tenés coincidencias con ningún invitado"
    static let TODOS_EVALUADOS = "¡Evaluaste a todos los invitados de la fiesta!\nMirá tus matches"
    
    
    func guardarLikeOrNope(idFiesta: String, idInvitado: String, like: Bool, completionHandler:@escaping (Bool) -> ()) {
        let reaccion = like ? EnumReaccionesMeGustas.LikesDados.rawValue : EnumReaccionesMeGustas.NopesDados.rawValue
        
        FirebaseService.shared.ref.child("meGustas")
            .child("/" + idFiesta + "/" + FirebaseService.shared.userIdFacebook! + "/" + reaccion + "/" + idInvitado)
            .setValue(true)
        
        completionHandler(true)
    }
    
    func guardarMatch(idFiesta: String, idInvitado: String, completionHandler:@escaping (Bool) -> ()) {
        // Se guarda match en usuario logueado
        FirebaseService.shared.ref.child("meGustas")
            .child("/" + idFiesta + "/" + FirebaseService.shared.userIdFacebook! + "/" + EnumReaccionesMeGustas.Matches.rawValue + "/" + idInvitado)
            .setValue(true)
        
        // Se guarda match en el usuario invitado
        FirebaseService.shared.ref.child("meGustas")
            .child("/" + idFiesta + "/" + idInvitado + "/" + EnumReaccionesMeGustas.Matches.rawValue + "/" + FirebaseService.shared.userIdFacebook!)
            .setValue(true)
        
        completionHandler(true)
    }
    
    func obtenerReaccionesUsuario(idFiesta: String, idInvitado: String, reaccion: EnumReaccionesMeGustas, completionHandler:@escaping ([String]) -> ()) {
        var result = [String]()
        
        FirebaseService.shared.ref.child("meGustas")
            .child(idFiesta)
            .child(idInvitado)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                        let childOfChild = child.children
                        if child.key == reaccion.rawValue {
                            while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                                let idUsuario = childOfChildSnapshot.key
                                result.append(idUsuario)
                            }
                        }
                    }
                }
                completionHandler(result)
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func hayMatch(idFiesta: String, idInvitado: String, completionHandler:@escaping (Bool) -> ()) {
        FirebaseService.shared.ref.child("meGustas")
            .child(idFiesta)
            .child(idInvitado)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                        let childOfChild = child.children
                        if child.key == EnumReaccionesMeGustas.LikesDados.rawValue {
                            while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                                let idUsuario = childOfChildSnapshot.key
                                if idUsuario == FirebaseService.shared.userIdFacebook {
                                    self.guardarMatch(idFiesta: idFiesta, idInvitado: idInvitado) { matchGuardado in
                                        if matchGuardado {
                                            completionHandler(true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                completionHandler(false)
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func obtenerMatches(idFiesta: String, completionHandler:@escaping([String]) ->()) {
        var result = [String]()
        
        FirebaseService.shared.ref.child("meGustas")
            .child(idFiesta)
            .child(FirebaseService.shared.userIdFacebook!)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                        let childOfChild = child.children
                        if child.key == EnumReaccionesMeGustas.Matches.rawValue {
                            while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                                let idUsuario = childOfChildSnapshot.key
                                result.append(idUsuario)
                            }
                        }
                    }
                }
                completionHandler(result)
            }) { (error) in
                print(error.localizedDescription)
        }
    }
}
