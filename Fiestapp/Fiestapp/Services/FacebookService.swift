//
//  FacebookService.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 10/6/17.
//  Copyright © 2017 Mint. All rights reserved.
//
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookService {
    
    static let shared = FacebookService()
    
    func getFotoPerfil(idUsuario : String) -> UIImageView {
        let imgFoto = UIImageView()
        let url = URL(string: "https://graph.facebook.com/"+idUsuario+"/picture?type=large&width=100")
        imgFoto.downloadedFrom(url: url!)
        
        return imgFoto
    }
    
    func getUrlFotoPerfilInSize(idUsuario: String, height: Int, width: Int) -> URL {
        return URL(string: "https://graph.facebook.com/" + idUsuario +
            "/picture?height=" + String(height) +
            "&width=" + String(width))!
        
    }
    
    func completarDatosInvitadosFacebook(invitados: [UsuarioModel], completionHandler:@escaping (Bool) -> ()) {
        var cantRequests = 0
        for usuario in invitados {
            let urlFotoPerfil =
                getUrlFotoPerfilInSize(idUsuario: usuario.Id,
                                       height: 1080,
                                       width: 1080)
            usuario.FotoPerfil.downloadedFrom(url: urlFotoPerfil)
            
            FBSDKGraphRequest(graphPath: usuario.Id, parameters: ["fields": "name, gender"])
                .start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil) {
                        let fbDetails = result as! NSDictionary
                        
                        usuario.Nombre = fbDetails.value(forKey: "name") as! String
                        if String(describing: fbDetails.value(forKey: "gender")) != "nil" {
                            usuario.Genero = EnumGenero(rawValue: fbDetails.value(forKey: "gender") as! String)
                        }
                    }
                    cantRequests += 1
                    if cantRequests == invitados.count {
                        ProgressOverlayView.shared.hideProgressView()
                        completionHandler(true)
                    }
                })
        }
    }
    
    func abrirPerfil(idUsuario: String) {
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/" + idUsuario)!)
    }
}
