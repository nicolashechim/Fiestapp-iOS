//
//  FacebookService.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 10/6/17.
//  Copyright © 2017 Mint. All rights reserved.
//
import UIKit

class FacebookService{

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
}
