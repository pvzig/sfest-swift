//
//  MapViewController.swift
//  Sfest-swift
//
//  Created by Peter Zignego on 7/4/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import Contacts

class MapView: MKMapView, CLLocationManagerDelegate {
    
    var stageName: String?
    let locationManager = CLLocationManager()
    
    convenience init(stage:String) {
        self.init()
        frame = CGRect(x: 0, y: 45, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height-45)
        stageName = stage
        setup()
        userLocationManager()
    }
    
    func setup() {
        let span = MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
        var location = userLocation.coordinate
        switch stageName! {
        case "BMO Harris Pavilion":
            location.latitude = 43.02871
            location.longitude = -87.89672
        case "Briggs & Stratton Big Backyard":
            location.latitude = 43.030026
            location.longitude = -87.899661
        case "Harley-Davidson Roadhouse":
            location.latitude = 43.03103
            location.longitude = -87.899731
        case "Johnson Controls World Sound Stage":
            location.latitude = 43.03344
            location.longitude = -87.898385
        case "Marcus Amphitheater":
            location.latitude = 43.027339
            location.longitude = -87.897701
        case "Miller Lite Oasis":
            location.latitude = 43.03209
            location.longitude = -87.899892
        case "U.S. Cellular Connection Stage":
            location.latitude = 43.034468
            location.longitude = -87.898444
        case "Uline Warehouse":
            location.latitude = 43.035354
            location.longitude = -87.898178
        default:
            location.latitude = userLocation.coordinate.latitude
            location.longitude = userLocation.coordinate.longitude
        }
        let region = MKCoordinateRegion(center: location, span: span)
        
        setRegion(region, animated: true)
        regionThatFits(region)
        
        let mapPoint = MapPoint(coordinate: location, title: stageName!)
        addAnnotation(mapPoint)
        selectAnnotation(mapPoint, animated: true)
    }
    
    func userLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.showsUserLocation = true
    }
}

class MapPoint: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
            self.coordinate = coordinate
            self.title = title
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [CNContactPostalAddressesKey as String : ""]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}


