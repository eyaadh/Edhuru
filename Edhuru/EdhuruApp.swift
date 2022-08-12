//
//  EdhuruApp.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

@main
struct EdhuruApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var contactsViewModel = ContactsViewModel()
    @StateObject var chatViewModel = ChatViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(contactsViewModel)
                .environmentObject(chatViewModel)
                .environmentObject(settingsViewModel)
                .preferredColorScheme(settingsViewModel.isDarkMode ? .dark : .light)
        }
    }
}
