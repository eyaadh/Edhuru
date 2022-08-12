//
//  SettingsView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 13-8-22.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isSettingsShowing: Bool
    @Binding var isOnboarding: Bool
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            // background
            Color.white
                .ignoresSafeArea()
            
            VStack {
                // heading
                HStack{
                    Text("Settings")
                        .font(Font.pageTitle)
                    
                    Spacer()
                    
                    Button {
                        // Close the settings
                        isSettingsShowing = false
                    } label: {
                        Image(systemName: "multiply")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .tint(Color("icons-secondary"))
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                // The settings form
                Form {
                    Toggle("Dark Mode", isOn: $settingsViewModel.isDarkMode)
                        .font(Font.settings)
                    
                    Button {
                        // TODO: Delete Account
                    } label: {
                        Text("Delete Account")
                            .font(Font.settings)
                    }
                    
                    Button {
                        // log out the client
                        AuthViewModel.logout()
                        
                        // take back to onboarding screen
                        isOnboarding = true
                    } label: {
                        Text("Logout")
                            .font(Font.settings)
                    }


                }
               
            }
            .background(Color("background"))
        }
        .preferredColorScheme(settingsViewModel.isDarkMode ? .dark: .light)
        .onAppear(perform: {
            UITableView.appearance().backgroundColor = .clear
        })
    }
}

