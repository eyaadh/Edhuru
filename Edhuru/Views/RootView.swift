//
//  RootView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

struct RootView: View {
    @State var selectedTabs: Tabs = .contacts
    @State var isOnboarding = !AuthViewModel.isUserLoggedIn()
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("background"))
                .ignoresSafeArea()
            
            VStack {
                switch selectedTabs {
                case .chats:
                    ChatsListView()
                case .contacts:
                    ContactsListView()
                }
                
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTabs)
            }
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            // on dismiss
        } content: {
            OnboardingContainerView(isOnboarding: $isOnboarding)
        }
        
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
