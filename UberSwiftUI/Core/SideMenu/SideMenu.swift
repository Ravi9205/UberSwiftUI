//
//  SideMenu.swift
//  UberSwiftUI
//
//  Created by Ravi Dwivedi on 06/01/23.
//

import SwiftUI


struct MenuItem:Identifiable {
    var id = UUID()
    var title:String
    var imageName:String
    let handler:() -> Void = {
        print("Tapped item")
    }
}


struct MenuContent:View{
    let items: [MenuItem] = [MenuItem(title:"Home",imageName:"house"),
        MenuItem(title:"Settings",imageName:"gear"),
        MenuItem(title:"Profile",imageName:"person.circle"),
        MenuItem(title:"Trip History",imageName:"trip"),
        MenuItem(title:"Payment",imageName:"payment"),
        MenuItem(title:"Wallet",imageName:"wallet"),
        MenuItem(title:"Notifications",imageName:"bell"),
        MenuItem(title:"Share",imageName:"square.and.arrow.up")
    ]
    
    var body:some View{
        
        ZStack{
            
            Color(UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0))
            
            VStack(alignment: .leading, spacing: 0){
                
                ForEach(items) { item in
                    HStack{
                        
                        Image(systemName:item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width:40, height: 40, alignment: .center)
                        
                        Text(item.title)
                            .foregroundColor(Color.white)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 22))
                        Spacer()
                    }
                    .onTapGesture {
                        
                    }
                    .padding()
                    
                    Divider()
            
                }
                
                Spacer()
            }
            .padding(.top,20)
        }
    }
    
}



struct SideMenu: View {
    let width:CGFloat
    var   menuOpened:Bool
    let toggleMenu: () -> Void
    
    
    var body: some View {
        
        ZStack{
            GeometryReader{ _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.5))
            .opacity(self.menuOpened ? 1 : 0)
            .animation(.spring(), value: 0.25)
            .onTapGesture {
                self.toggleMenu()
            }
            //MenuContent
            
            HStack{
                MenuContent()
                    .frame(width: width-20,alignment: .leading)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.spring(), value: 1.0)
                
                Spacer()
            }
            
        }
        
    }
    
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu(width: -20, menuOpened: true) {
            
        }
    }
}
