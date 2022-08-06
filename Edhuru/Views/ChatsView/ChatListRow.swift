//
//  ChatListRow.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 5-8-22.
//

import SwiftUI

struct ChatListRow: View {
    
    var chat: Chat
    
    var otherParticipants: [User]?
    
    var body: some View {
        HStack (spacing: 24) {
            
            // Assume at least 1 other partipant in the chat
            let participant = otherParticipants?.first
            
            // Profile Image of participant
            if let participant = participant {
                ProfilePicView(user: participant)
                
                VStack(alignment: .leading, spacing: 4){
                    // Name
                    Text("\(participant.firstname ?? "") \(participant.lastname ?? "")")
                        .font(Font.button)
                        .foregroundColor(Color("text-primary"))
                    // phoneNumber
                    Text(chat.lastmsg ?? "")
                        .font(Font.bodyParagraph)
                        .foregroundColor(Color("text-input"))
                }
                
                Spacer()
                
                // Timestamp
                VStack {
                    Text(chat.updated == nil ? "" : DateHelper.chatTimestampFrom(date: chat.updated))
                        .font(Font.bodyParagraph)
                        .foregroundColor(Color("text-input"))
                    Spacer()
                }
                
            }
        }
    }
}


