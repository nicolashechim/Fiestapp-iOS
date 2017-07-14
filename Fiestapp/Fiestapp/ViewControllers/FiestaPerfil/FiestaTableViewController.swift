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
    @IBOutlet var labelTipoFiesta: UILabel!
    @IBOutlet var labelInvitados: UILabel!
    @IBOutlet var labelCantidadDias: UILabel!
    @IBOutlet var labelTipo: UILabel!
    @IBOutlet var labelCantidadInvitados: UILabel!
    @IBAction func goBack(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    var receivedData = FiestaModel()
    var invitadosMeGustas = [UsuarioModel]()
    let cellHeight: CGFloat = 170
    let cellIdentifier = "InformacionCell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.shared.applyGradientView(view: viewHeader)
        initTableViewHeader()
        invitadosMeGustas = receivedData.Usuarios
        
        //Se excluye el usuario logueado de la lista de invitados para "Me gustás"
        if let index = invitadosMeGustas.index(where: { $0.Id == FirebaseService.shared.userIdFacebook }) {
            invitadosMeGustas.remove(at: index)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.vc = self;
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
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    // MARK: - Navigation
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == EnumFiestasCell.Informacion.hashValue) {
        }
        else if(indexPath.row == EnumFiestasCell.MeGustas.hashValue - 1
            && receivedData.Usuarios.count == 0 ) {
            self.performSegue(withIdentifier: "segueMeGustasSinInvitados", sender: self)
        }
        else if(indexPath.row == EnumFiestasCell.MeGustas.hashValue - 1
            && receivedData.Usuarios.count > 0 ) {
            self.performSegue(withIdentifier: "segueMeGustas", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMeGustas" {
            let backgroundAnimationViewController = segue.destination as! BackgroundAnimationViewController
            backgroundAnimationViewController.setInvitados(usuarios: self.invitadosMeGustas)
            backgroundAnimationViewController.setIdFiesta(idFiesta: self.receivedData.key)
        }
    }
    
    func initTableViewHeader() {
        labelTitle.text = receivedData.Nombre
        labelDetails.text = receivedData.Detalle
        
        if let fiestaImageUrl = URL(string: receivedData.Imagen) {
            Common.shared.downloadImage(url: fiestaImageUrl, imageView: imageProfile)
        }
        
        imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        imageProfile.layer.masksToBounds = false
        imageProfile.clipsToBounds = true
        
        imageProfileContainer.layer.cornerRadius = imageProfileContainer.frame.height/2
        imageProfileContainer.layer.masksToBounds = false
        imageProfileContainer.clipsToBounds = true
        
        labelCantidadDias.text = String(receivedData.CantidadDias)
        labelTipo.text = receivedData.Tipo
        labelCantidadInvitados.text = String(receivedData.CantidadInvitados)
    }
    
    func initInformacionCell(cell: InformacionTableViewCell) {
        cell.labelDia.text = Common.shared.getDiaMes(fecha: receivedData.FechaHora)
        cell.labelHora.text = Common.shared.getHora(fecha: receivedData.FechaHora)
        cell.labelNombreLugar.text = receivedData.Ubicacion.Nombre
        
        Common.shared.initMapView(mapa: cell.mapaUbicacion,
                           latitud: Double(receivedData.Ubicacion.Latitud)!,
                           longitud: Double(receivedData.Ubicacion.Longitud)!,
                           zoom: 400)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapMap(_:)))
        cell.mapaUbicacion.addGestureRecognizer(tapGesture)
        
        Common.shared.initCardMaskCell(viewContent: cell.viewContentCell, viewMask: cell.viewCardMask)
    }
    
    func tapMap(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Abrir en mapas", message: "¿Quieres ver la ruta hacia " + self.receivedData.Ubicacion.Nombre + "?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
        })
        
        alertController.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            Common.shared.goToMap(latitud: Double(self.receivedData.Ubicacion.Latitud)!, longitud: Double(self.receivedData.Ubicacion.Longitud)!, nombreDestino: self.receivedData.Ubicacion.Nombre)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initMeGustasCell(cell: MeGustasTableViewCell) {
        if invitadosMeGustas.count == 0 {
            cell.labelSinInvitados.isHidden = false
            cell.imageViewUsuario3.image = UIImage(named: "ic_meGustasCell.png")
        }
        else {
            cell.imageViewUsuario1.layer.cornerRadius = cell.imageViewUsuario1.frame.height/2
            cell.imageViewUsuario1.layer.masksToBounds = false
            cell.imageViewUsuario1.clipsToBounds = true
            
            cell.imageViewUsuario2.layer.cornerRadius = cell.imageViewUsuario1.frame.height/2
            cell.imageViewUsuario2.layer.masksToBounds = false
            cell.imageViewUsuario2.clipsToBounds = true
            
            cell.imageViewUsuario3.layer.cornerRadius = cell.imageViewUsuario1.frame.height/2
            cell.imageViewUsuario3.layer.masksToBounds = false
            cell.imageViewUsuario3.clipsToBounds = true
            
            let randomUsers = invitadosMeGustas.choose(invitadosMeGustas.count == 1 ? 1
                : invitadosMeGustas.count == 2 ? 2
                : 3)
            
            for i in 0..<randomUsers.count {
                let urlFotoPerfil = FacebookService.shared.getUrlFotoPerfilInSize(idUsuario: randomUsers[i].Id, height: 200, width: 200)
                if i == 0 {
                    cell.imageViewUsuario1.downloadedFrom(url: urlFotoPerfil)
                }
                else if i == 1 {
                    cell.imageViewUsuario2.downloadedFrom(url: urlFotoPerfil)
                }
                else if i == 2 {
                    cell.imageViewUsuario3.downloadedFrom(url: urlFotoPerfil)
                }
            }
        }
        Common.shared.initCardMaskCell(viewContent: cell.viewContentCell, viewMask: cell.viewCardMask)
    }
}
