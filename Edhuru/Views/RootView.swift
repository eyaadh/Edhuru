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
    @State var isChatShowing: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("background"))
                .ignoresSafeArea()
            
            VStack {
                switch selectedTabs {
                case .chats:
                    ChatsListView(isChatShowing: $isChatShowing)
                case .contacts:
                    ContactsListView(isChatViewShowing: $isChatShowing)
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
        .fullScreenCover(isPresented: $isChatShowing) {
            // on dismiss
        } content: {
            ConversationsView(isChatShowing: $isChatShowing)
        }
        
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
