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
        viewHeader.applyGradient(colours: [UIColor(red: 44/255, green: 193/255, blue: 255/255, alpha: 1),
                                           UIColor(red: 44/255, green: 93/255, blue: 255/255, alpha: 1)],
                                 locations: [0.0, 1.0])
        
        labelTitle.text = receivedData.Nombre
        labelDetails.text = receivedData.Detalle
        
        if let fiestaImageUrl = URL(string: receivedData.Imagen) {
            downloadImage(url: fiestaImageUrl, imageView: imageProfile)
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
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformacionCell", for: indexPath) as? InformacionTableViewCell else {
            fatalError("The dequeued cell is not an instance of InformacionTableViewCell.")
        }
        
        cell.labelDia.text = receivedData.FechaHora
        cell.labelHora.text = receivedData.FechaHora
        cell.labelNombreLugar.text = receivedData.Ubicacion.Nombre
        
        let initialLocation = CLLocation(latitude: -31.6432684, longitude: -60.704326)
        
        centerMapOnLocation(location: initialLocation, cell: cell)
        
        cell.viewCardMask.layer.cornerRadius = 4
        cell.viewContentCell.backgroundColor = UIColor(red: 245/255,
                                                       green: 245/255,
                                                       blue: 245/255,
                                                       alpha: 1)
        cell.viewCardMask.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.viewCardMask.layer.masksToBounds = false
        cell.viewCardMask.layer.shadowOpacity = 0.8
        cell.viewCardMask.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return cell
    }
    
    func centerMapOnLocation(location: CLLocation, cell: InformacionTableViewCell) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  300, 300)
        cell.mapaUbicacion.setRegion(coordinateRegion, animated: true)
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
