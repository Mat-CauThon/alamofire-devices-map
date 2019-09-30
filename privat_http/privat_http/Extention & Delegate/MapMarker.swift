//
//  MapMarker.swift
//  privat_http
//
//  Created by Roman Mishchenko on 9/30/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import MapKit

class AtmMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      // 1
      guard let atm = newValue as? ATM else { return }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      //rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      // 2
      markerTintColor = atm.markerTintColor
      glyphText = "Б"//String(atm.discipline.first!)
    }
  }
}
