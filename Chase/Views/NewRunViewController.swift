//
//  NewRunViewController.swift
//  Chase
//
//  Created by MacBook Pro on 13/05/23.
//

import Foundation
import CoreLocation
import MapKit

final class NewRunViewController: NSObject, ObservableObject {
    
    @Published var run: Run?
    @Published var locationManager = LocationManager.shared
    @Published var seconds = 0
    @Published var timer: Timer?
    @Published var distance = Measurement(value: 0, unit: UnitLength.meters)
    @Published var locationList: [CLLocation] = []
    @Published var distanceLabel = "Distance:"
    @Published var timeLabel = "Time:"
    @Published var paceLabel = "Pace:"
    @Published var isRunning = false
    @Published var showAlert =  false
    @Published var map: MKMapView = MKMapView()
    
    override init() {
        super.init()
        checkLocationAuthorization()
    }
    
    func startTapped() {
        isRunning = true
        startRun()
    }
    
    func stopTapped(isSave: Bool) {
        isRunning = false
        stopRun()
        if isSave {
            saveRun()
        }
        timer?.invalidate()
    }
    
    private func startRun() {
        map.removeOverlays(map.overlays)
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        locationManager.stopUpdatingLocation()
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerKilometer)
        
        distanceLabel = "Distance:  \(formattedDistance)"
        timeLabel = "Time:  \(formattedTime)"
        paceLabel = "Pace:  \(formattedPace)"
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func saveRun() {
        let newRun = Run(context: PersistenceController.shared.container.viewContext)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        newRun.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: PersistenceController.shared.container.viewContext)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newRun.addToLocations(locationObject)
        }
        
        PersistenceController.shared.save()
        
        run = newRun
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restricted")
        case .denied:
            print("Denied. Go to Setting to change it")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            
        @unknown default:
            break
        }
    }
    
}

extension NewRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
      
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                map.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                map.setRegion(region, animated: true)
            }
            locationList.append(newLocation)
            
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}

extension NewRunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
