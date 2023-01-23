//
//  LocationProvider.swift
//  
//
//  Created by Davis Allie on 24/5/2022.
//

import CoreLocation

@MainActor
public class LocationProvider: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager
    private var backgroundUpdatesEnabled: Bool
    private var requestedAccuracy: CLLocationAccuracy = kCLLocationAccuracyReduced
    
    @Published
    public private(set) var hasLocationPermission: Bool?
    
    @Published
    public private(set) var currentLocation: CLLocation?
    
    public init(backgroundUpdatesEnabled: Bool = false) {
        let manager = CLLocationManager()
        self.locationManager = manager
        self.backgroundUpdatesEnabled = backgroundUpdatesEnabled
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.hasLocationPermission = true
        case .notDetermined:
            self.hasLocationPermission = nil
        default:
            self.hasLocationPermission = false
        }
        
        super.init()
        
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = backgroundUpdatesEnabled
    }
    
    @discardableResult
    public func startLocationUpdates(accuracy: CLLocationAccuracy) -> Bool {
        locationManager.desiredAccuracy = accuracy
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            return true
        case .restricted, .denied:
            return false
        case .notDetermined:
            requestedAccuracy = accuracy
            if backgroundUpdatesEnabled {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
            
            return false
        }
    }
    
    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.hasLocationPermission = true
        case .notDetermined:
            self.hasLocationPermission = nil
        default:
            self.hasLocationPermission = false
        }
        
        startLocationUpdates(accuracy: requestedAccuracy)
    }
    
}
