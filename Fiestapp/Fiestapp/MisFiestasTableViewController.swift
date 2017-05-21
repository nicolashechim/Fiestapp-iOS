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
    let fiesta1 = FiestaModel()
    let fiesta2 = FiestaModel()
    let fiesta3 = FiestaModel()
    let fiesta4 = FiestaModel()
    let fiesta5 = FiestaModel()
    let fiesta6 = FiestaModel()
    let fiesta7 = FiestaModel()
    let fiesta8 = FiestaModel()

    let cellHeight: CGFloat = 84
    let cellIdentifier = "FiestaCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fiesta1.Nombre = "Cumpleaños NH"
        fiesta1.Detalle = "26 años"
        fiesta1.Fecha = "03/07/2017"
        fiesta1.Hora = "22hs"
        fiesta1.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/15972442_10211224104379351_5564436370214397033_o.jpg?oh=87f1d6af207de15c05c8b5cbe1ec4e2d&oe=59BA828C"
        
        fiesta2.Nombre = "Fiesta Egresados 2017"
        fiesta2.Detalle = "UAB Posgrado"
        fiesta2.Fecha = "15/07/2017"
        fiesta2.Hora = "21hs"
        fiesta2.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t1.0-9/16299391_10211390939430123_2940222236064796462_n.jpg?oh=f6fb5c27dff094beec813895bb9c99af&oe=59C137C4"
        
        fiesta3.Nombre = "Fiesta Voxel Group"
        fiesta3.Detalle = "By Grow"
        fiesta3.Fecha = "25/11/2017"
        fiesta3.Hora = "19:30hs"
        fiesta3.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/12841146_10208547230139168_4797860291950966288_o.jpg?oh=2d7a0dc2bad3d9bf920f37b6be45cf28&oe=59BDEF37"
        
        fiesta4.Nombre = "Cumpleaños MH"
        fiesta4.Detalle = "28 años"
        fiesta4.Fecha = "26/02/2018"
        fiesta4.Hora = "20hs"
        fiesta4.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t1.0-9/12063695_10207634399358969_1569678471758390639_n.jpg?oh=c8663d47212ea3b74dfe001a8cd3ac99&oe=59BA5652"
        
        fiesta5.Nombre = "Evento Grow"
        fiesta5.Detalle = "Imperdible"
        fiesta5.Fecha = "03/08/2017"
        fiesta5.Hora = "17hs"
        fiesta5.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/12493409_10208102662745261_562445503367844921_o.jpg?oh=f83c3ed83481b39d18ed8669795b6a65&oe=59B281B2"
        
        fiesta6.Nombre = "Recepción UAB"
        fiesta6.Detalle = "Posgrado Apps Móviles"
        fiesta6.Fecha = "18/11/2017"
        fiesta6.Hora = "20:30hs"
        fiesta6.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t1.0-9/1533945_10206710401019588_6693039462749307411_n.jpg?oh=f7e141809ed74aae828b8582642e2b33&oe=59A2BC49"
        
        fiesta7.Nombre = "Beach Fest"
        fiesta7.Detalle = "Festival increíble"
        fiesta7.Fecha = "22/07/2017"
        fiesta7.Hora = "13hs"
        fiesta7.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t31.0-8/11270500_10206560235985556_2653180220809275037_o.jpg?oh=78f9e70844c699854e316691af2a62b3&oe=59AD22BD"
    
        fiesta8.Nombre = "Boda MN"
        fiesta8.Detalle = "Tiramos la casa por la ventana, fiesta imperdible."
        fiesta8.Fecha = "12/12/2020"
        fiesta8.Hora = "21hs"
        fiesta8.Imagen = "https://scontent-cdg2-1.xx.fbcdn.net/v/t1.0-9/10882260_10205537070687063_4629516197500572529_n.jpg?oh=cced900755909bfecf490f62c4a2f0cc&oe=59AA2624"
        
        fiestas = [fiesta1, fiesta2, fiesta3, fiesta4, fiesta5, fiesta6, fiesta7, fiesta8]
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
        
        if let fiestaImageUrl = URL(string: fiesta.Imagen) {
            downloadImage(url: fiestaImageUrl, imageView: cell.iconCircle)
        }
        
        
        cell.iconCircle.layer.cornerRadius = cell.iconCircle.frame.height/2
        cell.iconCircle.layer.masksToBounds = false
        cell.iconCircle.clipsToBounds = true
        cell.title.text = fiesta.Nombre
        cell.details.text = fiesta.FechaHora() + fiesta.Detalle
        cell.cardMask.layer.cornerRadius = 4
        cell.contentViewCell.backgroundColor = UIColor(red: 245/255,
                                                       green: 245/255,
                                                       blue: 245/255,
                                                       alpha: 1)
        cell.cardMask.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cell.cardMask.layer.masksToBounds = false
        cell.cardMask.layer.shadowOpacity = 0.8
        cell.cardMask.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeight
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
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
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
            let fiestaViewController = segue.destination as! FiestaViewController
            fiestaViewController.receivedData = fiestas[selectedRow]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
