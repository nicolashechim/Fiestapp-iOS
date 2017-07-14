//
//  MisFiestasTableViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 14/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit

class MisFiestasTableViewController: UITableViewController {
    
    var fiestas = [FiestaModel]()
    let cellHeight: CGFloat = 84
    let cellIdentifier = "FiestaCell"
    var buscarDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressOverlayView.shared.showProgressView(view)
        FiestaService.shared.obtenerFiestas() { fiestas in
            self.buscarDidAppear = true
            if fiestas.count == 0 {
                self.mostrarNotificacionAgregarFiesta()
            }
            else {
                self.fiestas = fiestas
                self.tableView.reloadData()
            }
            
            ProgressOverlayView.shared.hideProgressView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if fiestas.count == 0 && buscarDidAppear {
            self.mostrarNotificacionAgregarFiesta()
        }
    }
    
    func mostrarNotificacionAgregarFiesta() {
        let alertController = UIAlertController(title: "Aún no tenés fiestas", message: "¡Empezá añadiendo la primera!", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel)
        {
            (result : UIAlertAction) -> Void in
        })
        
        
        alertController.addAction(UIAlertAction(title: "Nueva fiesta", style: UIAlertActionStyle.destructive)
        {
            (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "segueAgregarFiesta", sender: self)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let fiestaTableViewController = segue.destination as! FiestaTableViewController
            fiestaTableViewController.receivedData = fiestas[selectedRow]
        }
    }
    
    func initPrototypeCell(cell: FiestaTableViewCell, fiesta: FiestaModel) {
        if let fiestaImageUrl = URL(string: fiesta.Imagen) {
            Common.shared.downloadImage(url: fiestaImageUrl, imageView: cell.iconCircle)
        }
        
        cell.iconCircle.layer.cornerRadius = cell.iconCircle.frame.height/2
        cell.iconCircle.layer.masksToBounds = false
        cell.iconCircle.clipsToBounds = true
        cell.title.text = fiesta.Nombre
        cell.details.text = Common.shared.getFechaHoraString(fecha: fiesta.FechaHora)
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
