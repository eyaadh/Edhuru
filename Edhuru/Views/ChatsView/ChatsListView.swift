//
//  ChatsListView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        if chatViewModel.chats.count > 0 {
            List(chatViewModel.chats) { chat in
                Text(chat.id ?? "no chat id")
            }
        }
        
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
            .environmentObject(ChatViewModel())
    }
}
