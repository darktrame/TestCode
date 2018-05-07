//
//  MapViewController.swift
//  ticketBus
//
//  Created by Elatesoftware on 11.10.2017.
//  Copyright © 2017 Elatesoftware. All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
  var placeCoordinates: CLLocationCoordinate2D
  var placeName: String?
  var placeAddress: String?
  
  init(placeCoordinates: CLLocationCoordinate2D!,
       placeName: String!,
       placeAddress: String!) {
    self.placeCoordinates = placeCoordinates
    self.placeName = placeName
    self.placeAddress = placeAddress
  }
  
  var coordinate: CLLocationCoordinate2D {
    return placeCoordinates
  }
  
  var title: String? {
    return placeName
  }
  
  var subtitle: String? {
    return placeAddress
  }
}

class MapViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!

  // MARK: - Variables
  let coordinates = CLLocationCoordinate2D(latitude: 55.598419, longitude: 37.554206)
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    
    title = "Схема проезда"
    
    let annotation = PlaceAnnotation(placeCoordinates: coordinates,
                                     placeName: "АвтоТрансЮг",
                                     placeAddress: "Новоясеневский тупик, 4")
    
    mapView.addAnnotation(annotation)
    
    let camera = MKMapCamera(lookingAtCenter: coordinates, fromEyeCoordinate: coordinates, eyeAltitude: 2000.0)
    mapView.setCamera(camera, animated: true)
  }
}
