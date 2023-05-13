//
//  MapView.swift
//  Chase
//
//  Created by MacBook Pro on 13/05/23.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    
    @ObservedObject var controller: NewRunViewController
    var mapView: MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = controller
            return mapView
        }
        
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map view if needed
    }
    
}
