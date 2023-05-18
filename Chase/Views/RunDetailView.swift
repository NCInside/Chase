//
//  RunDetailView.swift
//  Chase
//
//  Created by MacBook Pro on 18/05/23.
//

import SwiftUI

struct RunDetailView: View {
    
    var run: Run
    @StateObject private var controller : RunDetailViewController
    
    init(run: Run) {
        self.run = run
        self._controller = StateObject(wrappedValue: RunDetailViewController(run: run))
    }
    
    var body: some View {
        VStack {
            MapView(controller: controller).frame(height:300)
            Text(controller.distanceLabel)
            Text(controller.dateLabel)
            Text(controller.timeLabel)
            Text(controller.paceLabel)
        }
    }
}

//struct RunDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunDetailView()
//    }
//}
