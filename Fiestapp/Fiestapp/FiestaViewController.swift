//
//  FiestaViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 13/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class FiestaViewController: UIViewController {
    
    @IBOutlet var viewHeader: UIView!
    
    @IBOutlet var imageProfile: UIImageView!
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
        
        labelCantidadDias.text = String(receivedData.CantidadFotos)
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
    
    
}
