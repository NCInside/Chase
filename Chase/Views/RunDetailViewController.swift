//
//  RunDetailViewController.swift
//  Chase
//
//  Created by MacBook Pro on 18/05/23.
//

import Foundation
import CoreLocation
import MapKit

class RunDetailViewController: NewRunViewController {
    
    @Published var dateLabel = "Date:"
    
    init(run: Run) {
        super.init()
        self.run = run
        configureView()
    }
    
    private func configureView() {
        let distance = Measurement(value: run!.distance, unit: UnitLength.meters)
        let seconds = Int(run!.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(run!.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                             seconds: seconds,
                                             outputUnit: UnitSpeed.minutesPerMile)
      
        distanceLabel = "Distance:  \(formattedDistance)"
        dateLabel = formattedDate
        timeLabel = "Time:  \(formattedTime)"
        paceLabel = "Pace:  \(formattedPace)"
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
      guard
        let locations = run!.locations,
        locations.count > 0
      else {
        return nil
      }
      
      let latitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.latitude
      }
      
      let longitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.longitude
      }
      
      let maxLat = latitudes.max()!
      let minLat = latitudes.min()!
      let maxLong = longitudes.max()!
      let minLong = longitudes.min()!
      
      let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                          longitude: (minLong + maxLong) / 2)
      let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                  longitudeDelta: (maxLong - minLong) * 1.3)
      return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> MKPolyline {
      guard let locations = run!.locations else {
        return MKPolyline()
      }
     
      let coords: [CLLocationCoordinate2D] = locations.map { location in
        let location = location as! Location
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      }
      return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    private func loadMap() {
      guard
        let locations = run!.locations,
        locations.count > 0,
        let region = mapRegion()
      else {
          return
      }
      
      map.setRegion(region, animated: true)
        map.addOverlay(polyLine())
    }
    
}
