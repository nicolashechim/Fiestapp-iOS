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
    
    class func initMapView(mapa: MKMapView, latitud: Double, longitud: Double, zoom: Double) {
        let location = CLLocation(latitude: latitud, longitude: longitud)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, zoom, zoom)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        mapa.setRegion(coordinateRegion, animated: true)
        mapa.addAnnotation(annotation)
    }
    
    class func applyGradientView(view: UIView) {
        view.applyGradient(colours: [UIColor(red: 0/255, green: 177/255, blue: 255/255, alpha: 1),
                                     UIColor(red: 232/255, green: 0/255, blue: 166/255, alpha: 1)],
                           locations: [0.0, 1.0])
    }
    
    class func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    class func downloadImage(url: URL, imageView: UIImageView) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    class func initCardMaskCell(viewCell: UIView, viewMask: UIView) {
        viewMask.layer.cornerRadius = 4
        viewCell.backgroundColor = UIColor(red: 245/255,
                                           green: 245/255,
                                           blue: 245/255,
                                           alpha: 1)
        viewMask.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        viewMask.layer.masksToBounds = false
        viewMask.layer.shadowOpacity = 0.8
        viewMask.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    class func goToMap(latitud: Double, longitud: Double, nombreDestino: String) {
        let coordinates = CLLocationCoordinate2DMake(latitud, longitud)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
        
        mapItem.name = nombreDestino
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}
