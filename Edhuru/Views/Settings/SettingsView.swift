//
//  SettingsView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 13-8-22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @Binding var isSettingsShowing: Bool
    @Binding var isOnboarding: Bool
    
    @State private var isPresentingDeleteConfirm: Bool = false
    
    
    var body: some View {
        ZStack {
            // background
            Color.white
                .ignoresSafeArea()
            
            VStack {
                // heading
                HStack{
                    // collect in logged in user details
                    let loggedUser = contactsViewModel.getParticipants(ids: [AuthViewModel.getLoggedInUserID()]).first
                    
                    VStack(alignment: .leading){
                        Text("Settings")
                            .font(Font.pageTitle)
                            .padding(.bottom, 6)
                        
                        // show logged in user details within the header
                        if let loggedUser = loggedUser {
                            Button {
                                // TODO: Allow logged in user to update their profile
                            } label: {
                                HStack {
                                    ProfilePicView(user: loggedUser)
                                    
                                    Text("\(loggedUser.firstname ?? "") \(loggedUser.lastname ?? "") (+\(loggedUser.phone ?? ""))")
                                        .font(Font.bodyParagraph)
                                        .foregroundColor(Color("text-input"))
                                }
                            }
                        }
                    }
                    
                    
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
                        isPresentingDeleteConfirm = true
                    } label: {
                        Text("Delete Account")
                            .font(Font.settings)
                    }
                    .confirmationDialog("Are you sure?",
                                        isPresented: $isPresentingDeleteConfirm) {
                        Button("Delete your account?", role: .destructive) {
                            // Deactivate the account
                            settingsViewModel.deactivateAccount {
                                // logout and show the on boarding
                                AuthViewModel.logout()
                                
                                isOnboarding = true
                            }
                        }
                    } message: {
                        Text("You cannot undo this action")
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

