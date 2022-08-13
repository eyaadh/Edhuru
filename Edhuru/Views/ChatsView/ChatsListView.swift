//
//  ChatsListView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @Binding var isChatShowing: Bool
    @Binding var isSettingShowing: Bool
    
    var body: some View {
        VStack {
            // heading
            HStack{
                Text("Chats")
                    .font(Font.pageTitle)
                
                Spacer()
                
                Button {
                    // Show Settings
                    isSettingShowing = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tint(Color("icons-secondary"))
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            // chat list
            if chatViewModel.chats.count > 0 {
                List(chatViewModel.chats) { chat in
                    Button  {
                        // set selected chat for the chatviewmodel
                        chatViewModel.selectedChat = chat
                        
                        // display convertation view
                        isChatShowing = true
                    } label: {
                        let otherParticipantIDs = chat.participantids.filter { $0 != AuthViewModel.getLoggedInUserID() }
                        ChatListRow(chat: chat,
                                    otherParticipants: contactsViewModel.getParticipants(ids: otherParticipantIDs))
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                
            } else {
                Spacer()
                
                Image("no-chats-yet")
                
                Text("Hmm... no chats here yet!")
                    .font(Font.titleText)
                    .padding(.top, 32)
                
                Text("Chat a friend to get started")
                    .font(Font.bodyParagraph)
                    .padding(.top, 8)
                
                Spacer()
            }
        }
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView(isChatShowing: .constant(false), isSettingShowing: .constant(false))
            .environmentObject(ChatViewModel())
            .environmentObject(ContactsViewModel())
    }
}
