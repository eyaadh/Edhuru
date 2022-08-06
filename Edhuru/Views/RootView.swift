//
//  RootView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
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
        .onAppear (perform: {
            // Get Local Contacts
            if !isOnboarding {
                contactsViewModel.getLocalContacts()
            }
            
        })
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
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
                chatViewModel.chatListViewCleanup()
            }
        }
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
