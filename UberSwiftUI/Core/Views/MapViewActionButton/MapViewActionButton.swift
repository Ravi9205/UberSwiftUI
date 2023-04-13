//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Ravi Dwivedi on 05/01/23.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState:MapViewState
    @EnvironmentObject var viewModel:LocationSearchViewModel
    @State var menuOpen:Bool
    
    var body: some View {
         
        Button {
                withAnimation (.spring()){
                    actionForState(mapState)
                    self.menuOpen.toggle()
                 }
            
                
            } label: {
                Image(systemName:changeImage(mapState))
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: .black, radius: 6)
                
            }
            .frame(maxWidth:.infinity,alignment:.leading)
            SideMenu(width:370, menuOpened: menuOpen, toggleMenu: toggleMenu)
           
    }
    
    func toggleMenu()
    {
        self.menuOpen.toggle()
    }
    
    
    func actionForState(_ state:MapViewState){
        switch state {
        case .noInput:
          print("No Input")
        
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected,.pollyLineAdded:
            mapState = .noInput
            viewModel.selectedUberLocation = nil
            
        }
        
    }
    func changeImage(_ state:MapViewState)-> String{
        
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation,.locationSelected,.pollyLineAdded:
            return "arrow.left"
           
        }
    }
    
}


struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.noInput), menuOpen: true)
        
    }
}


