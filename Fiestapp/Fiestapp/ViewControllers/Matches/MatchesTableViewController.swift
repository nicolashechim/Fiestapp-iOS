//
//  MatchesTableViewController.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 2/7/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {
    
    let cellHeight: CGFloat = 84
    let cellIdentifier = "MatchCell"
    var idFiesta = String()
    var idUsuarioMatch = String()
    var invitados = [UsuarioModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressOverlayView.shared.showProgressView(view)
        MeGustasService.shared.obtenerMatches(idFiesta: "-KkrLG86TLQ4HcURJynY") { idUsuariosMatch in
            if idUsuariosMatch.count == 0 {
                ProgressOverlayView.shared.hideProgressView()
                self.performSegue(withIdentifier: "segueSinMatches", sender: self)
            }
            self.invitados = Common.shared.initUsuariosConListaIds(ids: idUsuariosMatch)
            FacebookService.shared.completarDatosInvitadosFacebook(invitados: self.invitados) { success in
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitados.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MatchTableViewCell else {
            fatalError("The dequeued cell is not an instance of MatchTableViewCell.")
        }
        
        initPrototypeCell(cell: cell, invitado: invitados[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    // MARK: - Navigation
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.idUsuarioMatch = self.invitados[indexPath.row].Id
        
        let fotoPerfilInvitadoMatch = UIImageView(frame: CGRect(x: 10, y: 70, width: 250, height: 172))
        fotoPerfilInvitadoMatch.image = invitados[indexPath.row].FotoPerfil.image
        fotoPerfilInvitadoMatch.contentMode = .scaleAspectFit
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.abrirPerfil(_:)))
        fotoPerfilInvitadoMatch.addGestureRecognizer(tap)
        fotoPerfilInvitadoMatch.isUserInteractionEnabled = true
        
        let spacer = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n"
        
        let alertController = UIAlertController(title: "¡Da el próximo paso!" , message: invitados[indexPath.row].Nombre + spacer, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ver perfil", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            FacebookService.shared.abrirPerfil(idUsuario: self.invitados[indexPath.row].Id)
        })
        
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
        })
        
        alertController.view.addSubview(fotoPerfilInvitadoMatch)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func initPrototypeCell(cell: MatchTableViewCell, invitado: UsuarioModel) {
        
        cell.iconCircle.image = invitado.FotoPerfil.image
        cell.iconCircle.layer.cornerRadius = cell.iconCircle.frame.height/2
        cell.iconCircle.layer.masksToBounds = false
        cell.iconCircle.clipsToBounds = true
        cell.name.text = invitado.Nombre
        cell.cardMask.layer.cornerRadius = 4
        cell.contentViewCell.backgroundColor = UIColor(red: 245/255,
                                                       green: 245/255,
                                                       blue: 245/255,
                                                       alpha: 1)
        cell.cardMask.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.cardMask.layer.masksToBounds = false
        cell.cardMask.layer.shadowOpacity = 0.8
        cell.cardMask.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func setIdFiesta(idFiesta: String) {
        self.idFiesta = idFiesta
    }
    
    func abrirPerfil(_ sender: UITapGestureRecognizer) {
        FacebookService.shared.abrirPerfil(idUsuario: idUsuarioMatch)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSinMatches" {
            let meGustasSinResultadosViewController = segue.destination as! MeGustasSinResultadosViewController
            meGustasSinResultadosViewController.setTitulo(titulo: MeGustasService.MIS_MATCHES)
            meGustasSinResultadosViewController.setMensaje(mensaje: MeGustasService.SIN_MATCHES)
        }
    }
}
