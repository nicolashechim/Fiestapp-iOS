//
//  FiestaModel.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 19/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class FiestaModel {

    //MARK: Properties
    var Nombre: String
    var Detalle: String
    var Fecha: String
    var Hora: String
    var Imagen: String
    var CantidadFotos: Int
    var CantidadInvitados: Int
    var Funcionalidades = [EnumFuncionalidades]()
    
    //MARK: Initialization
    init(nombre: String, detalle: String, fecha: String, hora: String, imagen: String, cantidadFotos: Int, cantidadInvitados: Int, funcionalidades: [EnumFuncionalidades]) {
        self.Nombre = nombre
        self.Detalle = detalle
        self.Fecha = fecha
        self.Hora = hora
        self.Imagen = imagen
        self.CantidadFotos = cantidadFotos
        self.CantidadInvitados = cantidadInvitados
        self.Funcionalidades = funcionalidades
    }
    
    init() {
        self.Nombre = ""
        self.Detalle = ""
        self.Fecha = ""
        self.Hora = ""
        self.Imagen = ""
        self.CantidadFotos = 0
        self.CantidadInvitados = 0
        self.Funcionalidades = [EnumFuncionalidades]()
    }
    
    func FechaHora() -> String {
        return Fecha + " " + Hora + " | ";
    }
}
