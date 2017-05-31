//
//  FiestaTableViewController.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 30/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit
import MapKit

class FiestaTableViewController: UITableViewController {
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//fiestas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformacionCell", for: indexPath) as? InformacionTableViewCell else {
                fatalError("The dequeued cell is not an instance of InformacionTableViewCell.")
            }
            initInformacionCell(cell: cell)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformacionCell", for: indexPath) as? InformacionTableViewCell else {
                fatalError("The dequeued cell is not an instance of InformacionTableViewCell.")
            }
            initInformacionCell(cell: cell)
            return cell
        }
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    /*
     // MARK: - Navigation
     // method to run when table view cell is tapped
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     self.performSegue(withIdentifier: "segueFiesta", sender: self)
     }
     
     // This function is called before the segue
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let indexPath = tableView.indexPathForSelectedRow{
     let selectedRow = indexPath.row
     let fiestaViewController = segue.destination as! FiestaViewController
     //fiestaViewController.receivedData = fiestas[selectedRow]
     }
     }
     */
}
