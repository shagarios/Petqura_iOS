//
//  LocationManager.swift
//  PawWalker
//
//  Created by shagar on 13/11/24.
//

import CoreLocation
import Foundation
import SwiftUI


class LocationManager : NSObject,CLLocationManagerDelegate,ObservableObject {
    var locationManager = CLLocationManager()
    @Published var latitude : Double = 0.0
    @Published  var longtitube : Double = 0.0
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
    }
    
  func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longtitube = location.coordinate.longitude
        }
        manager.startUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    
}


struct Place {
    var city : String = ""
    var country : String = ""
    var region : String = ""
    var address : [String] = []
}

struct AddressData {
    var address : [String] = []
    var locality : String = ""
    var administrativeArea : String = ""
    var postalCode : String = ""
    var country : String = ""
    var subLocality : String = ""
    var latitude : Double = 0
    var longitude : Double = 0
}
