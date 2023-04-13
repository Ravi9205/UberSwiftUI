//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Ravi Dwivedi on 05/01/23.
//

import SwiftUI

struct HomeView: View {
    
    
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel:LocationSearchViewModel
    @State var menuOpened = false

    var body: some View {
        
        ZStack(alignment: .bottom){
            
            ZStack(alignment:.top){
                UbserMapView(mapState: $mapState)
                    .ignoresSafeArea()
                
                if  mapState == .searchingForLocation {
                    LocationSearchView(mapState: $mapState)
                }
                else if mapState == .noInput{
                    LocationSearchActivationView()
                        .padding(.top,72)
                        .onTapGesture {
                            mapState = .searchingForLocation
                        }
                }
                
                if !menuOpened {
                    MapViewActionButton(mapState: $mapState, menuOpen: menuOpened)
                        .padding(.leading,0)
                        .padding(.top,4)
                }
            
            
            }
            
            if mapState == .locationSelected || mapState == .pollyLineAdded {
                RideRequestView(selectedRideType: .uberX)
                    .transition(.move(edge: .bottom))
            }
            
           
        }
       
        .edgesIgnoringSafeArea(.bottom)
        
        .onReceive(LocationManager.shared.$userLocation) { location in
            
            if let location = location {
                print("selected location =\(location)")
                locationViewModel.userLocation = location
            }
        }
        
    }
    
    func toggleMenu()
    {
        self.menuOpened.toggle()
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
