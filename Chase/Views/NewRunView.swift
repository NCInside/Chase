//
//  NewRunView.swift
//  Chase
//
//  Created by MacBook Pro on 07/05/23.
//

import SwiftUI
import UIKit
import MapKit

struct NewRunView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var controller = NewRunViewController()
        
    var body: some View {
        NavigationStack {
            VStack {
                MapView(controller: controller).frame(height:300)
                Text(controller.distanceLabel)
                Text(controller.timeLabel)
                Text(controller.paceLabel)
                Spacer()
                if controller.isRunning {
                    Button("Stop") {
                        controller.showAlert = true
                    }
                    .alert("Do You Want to Save the Run?", isPresented: $controller.showAlert) {
                        Button("Save") {
                            controller.stopTapped(isSave: true)
                        }
                        Button("Discard") {
                            controller.stopTapped(isSave: false)
                            dismiss()
                        }
                    }
                } else {
                    Button("Start") {
                        controller.startTapped()
                    }
                }
                NavigationLink("", destination:  RunDetailView(), isActive: $controller.isActive)
            }.padding(20)
        }
    }
}

struct NewRunView_Previews: PreviewProvider {
    static var previews: some View {
        NewRunView()
    }
}
