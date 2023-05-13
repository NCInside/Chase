//
//  ContentView.swift
//  Chase
//
//  Created by MacBook Pro on 07/05/23.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        HomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
