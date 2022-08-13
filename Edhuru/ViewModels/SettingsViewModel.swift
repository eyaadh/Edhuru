//
//  SettingsViewModel.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 13-8-22.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @AppStorage(Constants.DarkModeKey) var isDarkMode: Bool = false
    
    var databaseService = DatabaseService()
    
    func deactivateAccount(completion: @escaping () -> Void) {
        // call database service method
        databaseService.deactivateAccount {
            // deactivation completed
            completion()
        }
    }
}
