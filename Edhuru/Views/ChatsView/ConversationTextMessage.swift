//
//  ConversationTextMessage.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 6-8-22.
//

import SwiftUI

struct ConversationTextMessage: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var msgid: String = ""
    var msg: String
    var isFromUser: Bool
    var name: String?
    var isActive: Bool = true
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            // name
            if let name = name {
                Text(name)
                    .font(Font.chatName)
                    .foregroundColor(Color("bubble-primary"))
            }
            
            // text
            Text(isActive ? msg : "Message Deleted")
                .font(Font.bodyParagraph)
                .foregroundColor(isFromUser ? Color("text-button"):Color("text-secondary"))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(isFromUser ? Color("bubble-primary"): Color("bubble-secondary"))
        .cornerRadius(30, corners: isFromUser ?  [.topLeft, .topRight, .bottomLeft]: [.topLeft, .topRight, .bottomRight])
        .contentShape(
            .contextMenuPreview,
            RoundedRectangle(cornerRadius: 30)
        )
        .contextMenu {
            if isFromUser{
                
                Button {
                    // Delete Message
                    chatViewModel.deleteMessage(msgid: msgid) { result in
                        if result {
                            chatViewModel.messageDeletionAlertContent = "Message Deleted Successfully."
                        } else {
                            chatViewModel.messageDeletionAlertContent = "There was an error trying to delete the message."
                        }
                        chatViewModel.showingMessageDeletionAlert = true
                    }
                    
                } label: {
                    Label("Delete Message", systemImage: "trash")
                }
            }
        }
    }
}
