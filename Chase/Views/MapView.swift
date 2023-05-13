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
    
    func makeUIView(context: Context) -> MKMapView {
        controller.map.delegate = controller
        return controller.map
    }
        
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //
    }
    
}
