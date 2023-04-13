//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by Ravi Dwivedi on 05/01/23.
//

import SwiftUI

@main
struct UberSwiftUIApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationViewModel)
        }
    }
}
