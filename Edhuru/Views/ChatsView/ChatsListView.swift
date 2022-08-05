//
//  ChatsListView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    @Binding var isChatShowing: Bool
    
    var body: some View {
        if chatViewModel.chats.count > 0 {
            List(chatViewModel.chats) { chat in
                Button  {
                    // set selected chat for the chatviewmodel
                    chatViewModel.selectedChat = chat
                    
                    // display convertation view
                    isChatShowing = true
                } label: {
                    Text(chat.id ?? "no chat id")
                }
            }
        }
        
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView(isChatShowing: .constant(false))
            .environmentObject(ChatViewModel())
    }
}
