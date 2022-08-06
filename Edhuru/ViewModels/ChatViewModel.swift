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
    
    func clearSelectChat() {
        self.selectedChat = nil
        self.messages.removeAll()
    }
    
    func getChats(){
        // use the database service to retrieve the chats
        databaseService.getAllChats { chats in
            // set the retrieved data to the chats property
            self.chats = chats
        }
    }
    
    /// Search for chat with passed in user, if found update the selected chat, if not found create a new chat
    func getChatFor(contact: User) {
        
        // validate the user
        guard contact.id != nil else {
            return
        }
        
        let foundChat = chats.filter { chat in
            return chat.numparticipants == 2 && chat.participantids.contains(contact.id!)
        }
        
        // found an existing chat
        if !foundChat.isEmpty {
            self.selectedChat = foundChat.first!
            
            // also fetch the messages
            getMessages()
        } else {
            // when there isnt one, create a chat
            let newChat = Chat(
                id: nil,
                numparticipants: 2,
                participantids: [AuthViewModel.getLoggedInUserID(), contact.id!],
                lastmsg: nil,
                updated: nil,
                msgs: nil)
            
            
            // set the selected chat
            self.selectedChat = newChat
            
            // update the selected chat with a chat id from the data we get off callback of the createChat func on dbservice
            databaseService.createChat(chat: newChat) { docid in
                self.selectedChat = Chat(id: docid,
                                         numparticipants: 2,
                                         participantids: [AuthViewModel.getLoggedInUserID(), contact.id!],
                                         lastmsg: nil,
                                         updated: nil,
                                         msgs: nil)
                
                // also add this chat to the chats list
                self.chats.append(self.selectedChat!)
            }
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
    
    func sendPhotoMessage(image: UIImage) {
        // check that there is already a selected chat
        guard self.selectedChat != nil else {
            return
        }
        
        databaseService.sendPhotoMessage(image: image, chat: selectedChat!)
    }
    
    func conversationViewCleanup() {
        databaseService.detachConversationListViewListeners()
    }
    
    func chatListViewCleanup() {
        databaseService.detachChatListViewListeners()
    }
    
    /// Accepts a list  of user ids, removes the logged in user and returns the rest as an array
    func getParticipantIDs() -> [String] {
        
        // check that there is a selected chat
        guard selectedChat != nil else {
            return [String]()
        }
        
        // filter and remove the logged in user and set the new array
        let ids = selectedChat!.participantids.filter({ id in
            id != AuthViewModel.getLoggedInUserID()
        })
        
        return ids
    }
    
    
}
