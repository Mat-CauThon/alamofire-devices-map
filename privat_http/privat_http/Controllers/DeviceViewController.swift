//
//  DeviceViewController.swift
//  privat_http
//
//  Created by Roman Mishchenko on 9/30/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import MapKit


class ATM: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let discipline: String
  let coordinate: CLLocationCoordinate2D
    
  var markerTintColor: UIColor  {
    switch discipline {
    case "ATM":
      return UIColor(red:0.36, green:0.62, blue:0.10, alpha:1.0)
    default:
      return .red
    }
  }
    
  init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
    
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
}

class DeviceViewController: UIViewController {
    
    
    var device: Device? = nil
    
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mon: UILabel!
    @IBOutlet weak var tue: UILabel!
    @IBOutlet weak var wed: UILabel!
    @IBOutlet weak var thu: UILabel!
    @IBOutlet weak var fri: UILabel!
    @IBOutlet weak var sat: UILabel!
    @IBOutlet weak var sun: UILabel!
    @IBOutlet weak var hol: UILabel!
    @IBOutlet weak var adress: UILabel!
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        let latitude = Double(device?.latitude ?? "0")!
        let longitude = Double(device?.longitude ?? "0")!
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: initialLocation)
        
        mapView.register(AtmMarkerView.self,
        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let artwork = ATM(title: "Банкомат",
                          locationName: device?.placeRu ?? "Неизвестно",
                          discipline: "ATM",
                          coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView.addAnnotation(artwork)
        
        
        mon.text = device?.mon ?? "Неизвестно"
        tue.text = device?.tue ?? "Неизвестно"
        wed.text = device?.wed ?? "Неизвестно"
        thu.text = device?.thu ?? "Неизвестно"
        fri.text = device?.fri ?? "Неизвестно"
        sun.text = device?.sun ?? "Неизвестно"
        sat.text = device?.sat ?? "Неизвестно"
        hol.text = device?.hol ?? "Неизвестно"
        
        let normalArdess = device?.fullAddressRu?.split(separator: ",")
                           
        // print(normalArdess)
         var adress = " "
         var number = 0
         
        for i in 0...((normalArdess?.count ?? 1)-1) {
            if normalArdess?[i].split(separator: " ").first == "город" {
                 number = i+1
                 break
             }
         }
                           
        for i in number...((normalArdess?.count ?? 1)-1) {
            adress += (normalArdess?[i] ?? "Неизвестно") + ", "
         }
        adress.removeLast()
        adress.removeLast()
        
        adress.removeFirst()
        adress.removeFirst()
        
        self.adress.text = adress
        
    }
    
}


