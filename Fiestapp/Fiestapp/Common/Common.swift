//
//  Common.swift
//  Fiestapp
//
//  Created by Nicolás Hechim on 31/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import Foundation
import MapKit

class Common {
    
    static let shared = Common()
    
    func initMapView(mapa: MKMapView, latitud: Double, longitud: Double, zoom: Double) {
        let location = CLLocation(latitude: latitud, longitude: longitud)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, zoom, zoom)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        mapa.setRegion(coordinateRegion, animated: true)
        mapa.addAnnotation(annotation)
    }
    
    func applyGradientView(view: UIView) {
        view.applyGradient(colours: [UIColor(red: 0/255, green: 177/255, blue: 255/255, alpha: 1),
                                     UIColor(red: 232/255, green: 0/255, blue: 166/255, alpha: 1)],
                           locations: [0.0, 1.0])
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
    
    func initCardMaskCell(viewContent: UIView, viewMask: UIView) {
        viewMask.layer.cornerRadius = 4
        viewContent.backgroundColor = UIColor(red: 245/255,
                                           green: 245/255,
                                           blue: 245/255,
                                           alpha: 1)
        viewMask.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        viewMask.layer.masksToBounds = false
        viewMask.layer.shadowOpacity = 0.8
        viewMask.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func goToMap(latitud: Double, longitud: Double, nombreDestino: String) {
        let coordinates = CLLocationCoordinate2DMake(latitud, longitud)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
        
        mapItem.name = nombreDestino
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func getFechaHoraDate(fecha: String) -> Date {
        return Date(timeIntervalSince1970: (Double(fecha)! / 1000.0))
    }
    
    func getFechaHoraString(fecha: String) -> String {
        let date = getFechaHoraDate(fecha: fecha)
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd/MM/yyyy | HH:mm'hs'";
        
        return dateFormatter.string(from: date);
    }
    
    func getDiaMes(fecha: String) -> String {
        let date = getFechaHoraDate(fecha: fecha)
        let diaFormatter = DateFormatter();
        let mesFormatter = DateFormatter();
        diaFormatter.dateFormat = "dd";
        mesFormatter.dateFormat = "MM";
        
        return diaFormatter.string(from: date) + " de " + getNombreMes(nroMes: Int(mesFormatter.string(from: date))!);
    }
    
    func getHora(fecha: String) -> String {
        let date = getFechaHoraDate(fecha: fecha)
        let horaFormatter = DateFormatter();
        horaFormatter.dateFormat = "HH:mm'hs'";
        
        return horaFormatter.string(from: date);
    }
    
    func getNombreMes(nroMes: Int) -> String {
        var mes = "";
        switch nroMes {
        case 1:
            mes = "enero";
        case 2:
            mes = "febrero";
        case 3:
            mes = "marzo";
        case 4:
            mes = "abril";
        case 5:
            mes = "mayo";
        case 6:
            mes = "junio";
        case 7:
            mes = "julio";
        case 8:
            mes = "agosto";
        case 9:
            mes = "septiembre";
        case 10:
            mes = "octubre";
        case 11:
            mes = "noviembre";
        case 12:
            mes = "diciembre";
        default:
            break;
        }
        
        return mes;
    }
    
    func countDaysTo(fecha: String) -> Int {
        let hasta = getFechaHoraDate(fecha: fecha)
        let today = Date()
        
        let calendar = NSCalendar.current
        
        let date1 = calendar.startOfDay(for: today)
        let date2 = calendar.startOfDay(for: hasta)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day! < 0 ? 0 : components.day!
    }
    
    func initUsuariosConListaIds(ids: [String]) -> [UsuarioModel] {
        var usuarios = [UsuarioModel]()
        for id in ids {
            usuarios.append(UsuarioModel(id: id))
        }
        return usuarios
    }
}
