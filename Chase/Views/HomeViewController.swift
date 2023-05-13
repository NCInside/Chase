//
//  HomeViewController.swift
//  Chase
//
//  Created by MacBook Pro on 13/05/23.
//

import Foundation

final class HomeViewController: ObservableObject {
    
    @Published var dateFormatterGet = DateFormatter()
    
    init() {
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
}
