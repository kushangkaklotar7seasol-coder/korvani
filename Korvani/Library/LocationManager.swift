//
//  LocationManager.swift
//  Korvani
//
//  Created by Kushang kaklotar on 14/07/26.
//

import Foundation
internal import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    
    var locationStatusType = 0 // 0=Allow, 1=Restricted, 2=Denied, 3=authorizedAlways, 4=Location Disable, 5=Loading
    var addressString = ""
    
//    override init() {
//        super.init()
//        
//    }
    
    func checkLocationAuthorization() {
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            print("requestWhenInUseAuthorization")
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            locationStatusType = 1

            let status = ["STATUS": self.locationStatusType]
            NotificationCenter.default.post( name: .didReceiveData, object: nil, userInfo: status)
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            locationStatusType = 2
            
            let status = ["STATUS": self.locationStatusType]
            NotificationCenter.default.post( name: .didReceiveData, object: nil, userInfo: status)
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
            lastKnownLocation = manager.location?.coordinate
            
            self.getStateAndCountry() { address in
                self.addressString = address
            }
            
            let status = ["STATUS": self.locationStatusType]
            NotificationCenter.default.post( name: .didReceiveData, object: nil, userInfo: status)
            
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            locationStatusType = 0
            
            self.getStateAndCountry() { address in
                self.addressString = address
            }
            
            let status = ["STATUS": self.locationStatusType]
            NotificationCenter.default.post( name: .didReceiveData, object: nil, userInfo: status)
            
        @unknown default:
            print("Location service disabled")
            locationStatusType = 4
            
            let status = ["STATUS": self.locationStatusType]
            NotificationCenter.default.post( name: .didReceiveData, object: nil, userInfo: status)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastKnownLocation = locations.first?.coordinate
//    }
    
    func getStateAndCountry(success: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: manager.location?.coordinate.latitude ?? 0.0, longitude: manager.location?.coordinate.longitude ?? 0.0)
        
        // Perform reverse geocoding
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
            
            // Grab the first matched result
            guard let placemark = placemarks?.first else {
                print("No placemark found.")
                return
            }
            
            // Extract State and Country data
            let state = placemark.administrativeArea ?? "Unknown State"
            let subAdministrativeArea = placemark.subAdministrativeArea ?? "Unknown City"
            let country = placemark.country ?? "Unknown Country"
            
            success("\(subAdministrativeArea), \(state), \(country)")
        }
    }

}
