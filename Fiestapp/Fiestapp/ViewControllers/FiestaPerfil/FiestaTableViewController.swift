//
//  FiestaTableViewController.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 30/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit
import FBSDKCoreKit

class FiestaTableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var imageProfileContainer: UIImageView!
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDetails: UILabel!
    @IBOutlet var labelDias: UILabel!
    @IBOutlet var labelFotos: UILabel!
    @IBOutlet var labelInvitados: UILabel!
    @IBOutlet var labelCantidadDias: UILabel!
    @IBOutlet var labelCantidadFotos: UILabel!
    @IBOutlet var labelCantidadInvitados: UILabel!
    @IBOutlet var back: UIButton!
    @IBAction func goBack(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    var receivedData = FiestaModel()
    let cellHeight: CGFloat = 170
    let cellIdentifier = "InformacionCell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.applyGradientView(view: viewHeader)
        initTableViewHeader()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//receivedData.Funcionalidades.count + 1 -> InformacionCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        if(indexPath.row == EnumFiestasCell.Informacion.hashValue)
        {
            guard let cellInfo = tableView.dequeueReusableCell(withIdentifier: EnumFiestasCell.Informacion.rawValue, for: indexPath) as? InformacionTableViewCell else {
                fatalError("The dequeued cell is not an instance of" + EnumFiestasCell.Informacion.rawValue +  ".")
            }
            initInformacionCell(cell: cellInfo)
            cell = cellInfo
        }
            // La fiesta tiene la funcionalidad "¡Me gustás!" ?
        else if receivedData.Funcionalidades.contains(EnumFuncionalidades.MeGustas) {
            guard let cellMeGustas = tableView.dequeueReusableCell(withIdentifier: EnumFiestasCell.MeGustas.rawValue, for: indexPath) as? MeGustasTableViewCell else {
                fatalError("The dequeued cell is not an instance of" + EnumFiestasCell.MeGustas.rawValue +  ".")
            }
            initMeGustasCell(cell: cellMeGustas)
            cell = cellMeGustas
        }
        return cell
    }
    
    func initInformacionCell(cell: InformacionTableViewCell) {
        cell.labelDia.text = receivedData.FechaHora
        cell.labelHora.text = receivedData.FechaHora
        cell.labelNombreLugar.text = receivedData.Ubicacion.Nombre
        
        Common.initMapView(mapa: cell.mapaUbicacion,
                           latitud: Double(receivedData.Ubicacion.Latitud)!,
                           longitud: Double(receivedData.Ubicacion.Longitud)!,
                           zoom: 400)
        
        Common.initCardMaskCell(viewCell: cell.viewContentCell, viewMask: cell.viewCardMask)
    }
    
    func initMeGustasCell(cell: MeGustasTableViewCell) {
        cell.imageViewUsuario1.layer.cornerRadius = cell.imageViewUsuario1.frame.height/2
        cell.imageViewUsuario1.layer.masksToBounds = false
        cell.imageViewUsuario1.clipsToBounds = true
        
        cell.imageViewUsuario2.layer.cornerRadius = cell.imageViewUsuario1.frame.height/2
        cell.imageViewUsuario2.layer.masksToBounds = false
        cell.imageViewUsuario2.clipsToBounds = true
        
        cell.imageViewUsuario3.layer.cornerRadius = cell.imageViewUsuario1.frame.height/2
        cell.imageViewUsuario3.layer.masksToBounds = false
        cell.imageViewUsuario3.clipsToBounds = true
        
        let threeRandomUsers = receivedData.Usuarios.choose(3)
        var urlFotoPerfil = FacebookService.shared.getUrlFotoPerfilInSize(idUsuario: threeRandomUsers[0].Id, height: 200, width: 200)
        cell.imageViewUsuario1.downloadedFrom(url: urlFotoPerfil)
        
        urlFotoPerfil = FacebookService.shared.getUrlFotoPerfilInSize(idUsuario: threeRandomUsers[1].Id, height: 200, width: 200)
        cell.imageViewUsuario2.downloadedFrom(url: urlFotoPerfil)
        
        urlFotoPerfil = FacebookService.shared.getUrlFotoPerfilInSize(idUsuario: threeRandomUsers[2].Id, height: 200, width: 200)
        cell.imageViewUsuario3.downloadedFrom(url: urlFotoPerfil)
        
        Common.initCardMaskCell(viewCell: cell.viewContentCell, viewMask: cell.viewCardMask)
        
    }
    
    func initTableViewHeader() {
        labelTitle.text = receivedData.Nombre
        labelDetails.text = receivedData.Detalle
        
        if let fiestaImageUrl = URL(string: receivedData.Imagen) {
            Common.downloadImage(url: fiestaImageUrl, imageView: imageProfile)
        }
        
        imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        imageProfile.layer.masksToBounds = false
        imageProfile.clipsToBounds = true
        
        imageProfileContainer.layer.cornerRadius = imageProfileContainer.frame.height/2
        imageProfileContainer.layer.masksToBounds = false
        imageProfileContainer.clipsToBounds = true
        
        labelCantidadDias.text = String(receivedData.CantidadDias)
        labelCantidadFotos.text = String(receivedData.CantidadFotos)
        labelCantidadInvitados.text = String(receivedData.CantidadInvitados)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    // MARK: - Navigation
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == EnumFiestasCell.Informacion.hashValue) {
            Common.goToMap(latitud: Double(receivedData.Ubicacion.Latitud)!, longitud: Double(receivedData.Ubicacion.Longitud)!, nombreDestino: receivedData.Ubicacion.Nombre)
        }
        else if(indexPath.row == EnumFiestasCell.MeGustas.hashValue - 1) {
            self.performSegue(withIdentifier: "segueMeGustas", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMeGustas" {
            let backgroundAnimationViewController = segue.destination as! BackgroundAnimationViewController
            completarDatosInvitadosFacebook()
            backgroundAnimationViewController.setInvitados(usuarios: self.receivedData.Usuarios)
        }
    }
   
    func completarDatosInvitadosFacebook() {
        for usuario in receivedData.Usuarios {
            let urlFotoPerfil =
                FacebookService.shared.getUrlFotoPerfilInSize(idUsuario: usuario.Id,
                                                              height: 1080,
                                                              width: 1080)
            usuario.FotoPerfil.downloadedFrom(url: urlFotoPerfil)
           
            FBSDKGraphRequest(graphPath: usuario.Id, parameters: ["fields": "name, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    let fbDetails = result as! NSDictionary
                    
                    usuario.Nombre = fbDetails.value(forKey: "name") as! String
                    if String(describing: fbDetails.value(forKey: "gender")) != "nil" {
                        usuario.Genero = EnumGenero(rawValue: fbDetails.value(forKey: "gender") as! String)
                    }
                    
                    print(fbDetails)
                }
            })
        }
    }
}
