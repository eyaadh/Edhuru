//
//  CustomTabBar.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

enum Tabs:Int {
    case chats = 0
    case contacts = 1
}

struct CustomTabBar: View {
    @Binding var selectedTab:Tabs
    @Binding var isChatShowing:Bool
    
    var body: some View {
        HStack(alignment: .center){
            
            Button {
                selectedTab = .chats
            } label: {
                TabBarButton(buttonText: "Chats",
                             imageName: "bubble.left",
                             isActive: selectedTab == .chats)
            }
            .tint(Color("icons-secondary"))
            
            Button {
                // show the new conversation window
                isChatShowing = true
                
            } label: {
                VStack(alignment: .center, spacing: 4) {
                    
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text("New Chat")
                        .font(Font.tabBar)
                }
            }
            .tint(Color("icons-primary"))
            
            
            Button {
                selectedTab = .contacts
            } label: {
                TabBarButton(buttonText: "Contacts",
                             imageName: "person",
                             isActive: selectedTab == .contacts)
            }
            .tint(Color("icons-secondary"))
            
        }
        .frame(height:82)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.contacts), isChatShowing: .constant(false))
    }
}
