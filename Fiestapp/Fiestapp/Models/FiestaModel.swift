//
//  FiestaModel.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 19/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit
import Firebase

class FiestaModel : NSObject {
    
    //MARK: Properties
    var CantidadDias: Int = 0
    var CantidadInvitados: String = ""
    var Detalle: String = ""
    var FechaHora: String = ""
    var Funcionalidades = [EnumFuncionalidades]()
    var Imagen: String  = ""
    var key: String = ""
    var Nombre: String = ""
    var Ubicacion = UbicacionModel()
    var Usuarios = [UsuarioModel]()
    
    //MARK: Initialization
    override init() {
        self.CantidadDias = 0
        self.CantidadInvitados = ""
        self.Detalle = ""
        self.FechaHora = ""
        self.Funcionalidades = [EnumFuncionalidades]()
        self.Imagen = ""
        self.key = ""
        self.Nombre = ""
        self.Ubicacion = UbicacionModel()
        self.Usuarios = [UsuarioModel]()
    }
    
    // Mapping entre el nodo Fiesta de Firebase y mi clase FiestaModel
    init(snapshot: FIRDataSnapshot) {
        super.init()
        
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
            else
            {
                let childOfChild = child.children
                switch(child.key)
                {
                case "Funcionalidades":
                    while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                        switch (childOfChildSnapshot.key as NSString).integerValue {
                        case EnumFuncionalidades.Asistencia.hashValue:
                            self.Funcionalidades.append(EnumFuncionalidades.Asistencia)
                            break;
                        case EnumFuncionalidades.Galeria.hashValue:
                            self.Funcionalidades.append(EnumFuncionalidades.Galeria)
                            break;
                        case EnumFuncionalidades.MeGustas.hashValue:
                            self.Funcionalidades.append(EnumFuncionalidades.MeGustas)
                            break;
                        case EnumFuncionalidades.Menu.hashValue:
                            self.Funcionalidades.append(EnumFuncionalidades.Menu)
                            break;
                        case EnumFuncionalidades.Musica.hashValue:
                            self.Funcionalidades.append(EnumFuncionalidades.Musica)
                            break;
                        case EnumFuncionalidades.Regalos.hashValue:
                            self.Funcionalidades.append(EnumFuncionalidades.Regalos)
                            break;
                        case EnumFuncionalidades.Vestimenta.hashValue:
                            self.Funcionalidades.append(EnumFuncionalidades.Vestimenta)
                            break;
                        default:
                            break;
                        }
                    }
                    break;
                    
                case "Ubicacion":
                    self.Ubicacion = UbicacionModel()
                    while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                        let value = childOfChildSnapshot.value as! String
                        if(childOfChildSnapshot.key == "Latitud") {
                            self.Ubicacion.Latitud = value
                        }
                        else if(childOfChildSnapshot.key == "Longitud") {
                            self.Ubicacion.Longitud = value
                        }
                        else if(childOfChildSnapshot.key == "Nombre"){
                            self.Ubicacion.Nombre = value
                        }
                    }
                    break;
                    
                case "Usuarios":
                    while let childOfChildSnapshot = childOfChild.nextObject() as? FIRDataSnapshot {
                        let idUsuario = childOfChildSnapshot.key
                        let invitado = UsuarioModel()
                        invitado.Id = idUsuario
                        self.Usuarios.append(invitado)
                    }
                    break;
                    
                default:
                    break;
                }
            }
        }
        self.CantidadDias = Common.countDaysTo(fecha: self.FechaHora);
    }
}
