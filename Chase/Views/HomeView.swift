//
//  HomeView.swift
//  Chase
//
//  Created by MacBook Pro on 13/05/23.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var controller = HomeViewController()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Run.distance, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Run>
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(items) { item in
                    
                    NavigationLink {
                        RunDetailView(run: item)
                    } label: {
                        Text("Run at \(item.timestamp!, formatter: controller.dateFormatterGet) For \(item.duration) seconds and \(item.distance) meter")
                    }
                }
            }
            
            NavigationLink {
                NewRunView()
            } label: {
                Text("Start New Run")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
