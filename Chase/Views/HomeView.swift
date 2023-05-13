//
//  HomeView.swift
//  Chase
//
//  Created by MacBook Pro on 13/05/23.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
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
