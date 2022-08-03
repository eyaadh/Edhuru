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
        VStack {
            Text("Hello, world!")
                .padding()
            
            Spacer()
            
            CustomTabBar(selectedTab: $selectedTabs)
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
