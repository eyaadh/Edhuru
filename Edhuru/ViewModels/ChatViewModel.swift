//
//  ChatViewModel.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 5-8-22.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var chats: [Chat] = [Chat]()
    
    var databaseService = DatabaseService()
    
    init() {
        // retreive chats when this model is created
        getChats()
    }
    
    func getChats(){
        // use the database service to retrieve the chats
        databaseService.getAllChats { chats in
            // set the retrieved data to the chats property
            self.chats = chats
        }
    }
}
