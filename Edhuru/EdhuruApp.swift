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
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(ContactsViewModel())
        }
    }
}
