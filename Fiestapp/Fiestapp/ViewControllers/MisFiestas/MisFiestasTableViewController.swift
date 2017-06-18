//
//  MisFiestasTableViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 14/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class MisFiestasTableViewController: UITableViewController {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var fiestas = [FiestaModel]()
    let misFiestasService = MisFiestasService()
    let cellHeight: CGFloat = 84
    let cellIdentifier = "FiestaCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressOverlayView.shared.showProgressView(view)
        MisFiestasService.obtenerFiestas(viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mostrarFiestas(fiestas : Array<FiestaModel>){
        self.fiestas = fiestas
        ProgressOverlayView.shared.hideProgressView()
        
        self.tableView.reloadData()
    }
    
    func mostrarError() {}
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiestas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FiestaTableViewCell else {
            fatalError("The dequeued cell is not an instance of FiestaTableViewCell.")
        }
        let fiesta = fiestas[indexPath.row]
        initPrototypeCell(cell: cell, fiesta: fiesta)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
    }
    
    // MARK: - Navigation
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueFiesta", sender: self)
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            let fiestaTableViewController = segue.destination as! FiestaTableViewController
            fiestaTableViewController.receivedData = fiestas[selectedRow]
        }
    }
    
    func initPrototypeCell(cell: FiestaTableViewCell, fiesta: FiestaModel) {
        if let fiestaImageUrl = URL(string: fiesta.Imagen) {
            Common.downloadImage(url: fiestaImageUrl, imageView: cell.iconCircle)
        }
        
        cell.iconCircle.layer.cornerRadius = cell.iconCircle.frame.height/2
        cell.iconCircle.layer.masksToBounds = false
        cell.iconCircle.clipsToBounds = true
        cell.title.text = fiesta.Nombre
        cell.details.text = Common.getFechaHoraString(fecha: fiesta.FechaHora)
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
}
