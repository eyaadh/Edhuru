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
    
    @Published var selectedChat: Chat?
    
    @Published var messages: [ChatMessage] = [ChatMessage]()
    
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
    
    func getMessages(){
        // check if theres any selected chat
        guard selectedChat != nil else {
            return
        }
        
        databaseService.getAllMessages(chat: selectedChat!) { msgs in
            // set returned messages to property
            self.messages = msgs
        }
    }
    
    func sendMessage(msg: String) {
        
        // check that there is already a selected chat
        guard self.selectedChat != nil else {
            return
        }
        
        databaseService.sendMessage(msg: msg, chat: selectedChat!)
    }
}
