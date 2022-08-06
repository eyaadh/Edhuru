//
//  ConversationsView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 5-8-22.
//

import SwiftUI


struct ConversationsView: View {
    @EnvironmentObject var  chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @Binding var isChatShowing: Bool
    
    @State var chatMessage: String = ""
    
    @State var participants: [User] = [User]()
    
    var body: some View {
        VStack(spacing: 0){
            // header
            HStack {
                // navigation buttons and chat name
                VStack(alignment:.leading) {
                    // back button
                    Button {
                        // dismiss conversations view
                        isChatShowing = false
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width:24, height:24)
                            .foregroundColor(Color("text-header"))
                    }

                    
                    // users name
                    if participants.count > 0 {
                        let partipant = participants.first
                        
                        Text("\(partipant?.firstname ?? "") \(partipant?.lastname ?? "")")
                            .font(Font.chatHeading)
                            .foregroundColor(Color("text-header"))
                    }
                }
                
                Spacer()
                
                // profile image
                if participants.count > 0 {
                    let partipant = participants.first
                    
                    ProfilePicView(user: partipant!)
                }
            }
            .frame(height: 104)
            .padding(.horizontal)
            
            Spacer()
            
            // chat log
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        ForEach(Array(chatViewModel.messages.enumerated()), id: \.element) { index, msg in
                            
                            let isFromUser = msg.senderid == AuthViewModel.getLoggedInUserID()
                            
                            // dynamic message
                            HStack {
                                if isFromUser {
                                    Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                        .font(Font.smallText)
                                        .foregroundColor(Color("text-timestamp"))
                                        .padding(.trailing, 20)
                                    
                                    Spacer()
                                }
                                Text(msg.msg)
                                    .font(Font.bodyParagraph)
                                    .foregroundColor(isFromUser ? Color("text-button"):Color("text-primary"))
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 24)
                                    .background(isFromUser ? Color("bubble-primary"): Color("bubble-secondary"))
                                    .cornerRadius(30, corners: isFromUser ?  [.topLeft, .topRight, .bottomLeft]: [.topLeft, .topRight, .bottomRight])
                                
                                if !isFromUser {
                                    Spacer()

                                    Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                        .font(Font.smallText)
                                        .foregroundColor(Color("text-timestamp"))
                                        .padding(.leading, 20)
                                }
                            }
                            .id(index)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    
                }
                .background(Color("background"))
                .onChange(of: chatViewModel.messages.count) { newCount in
                    withAnimation {
                        proxy.scrollTo(newCount - 1)
                    }
                }
            }
            
            // chat message bar
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                HStack (spacing: 15) {
                    // camera button
                    Button {
                        // TODO: Show picker
                    } label: {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .tint(Color("icons-secondary"))
                    }
                    
                    // text field
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("date-pill"))
                            .cornerRadius(50)
                            
                        TextField("Type your message", text: $chatMessage)
                            .foregroundColor(Color("text-input"))
                            .font(Font.bodyParagraph)
                            .padding(10)
                        
                        // Emoji button
                        HStack {
                            Spacer()
                            
                            Button {
                                // Emojis
                            } label: {
                                Image(systemName: "face.smiling")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("text-input"))
                            }
                        }
                        .padding(.trailing, 12)
                    }
                    .frame(height: 44)
                    
                    // send button
                    Button {
                        // cleanup chat messages before sending it, remove any leading rubbish
                        chatMessage = chatMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        // Send Message
                        chatViewModel.sendMessage(msg: chatMessage)
                        
                        // clear the chat message after sending
                        chatMessage = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .tint(Color("icons-primary"))
                    }
                    .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines) == "")

                }
                .padding(.horizontal)
                
            }
            .frame(height: 76)
        }
        .onAppear {
            // call chat view model to retrieve all chat messages
            chatViewModel.getMessages()
            
            // try to get the other partipants as user instances
            let ids = chatViewModel.getParticipantIDs()
            self.participants = contactsViewModel.getParticipants(ids: ids)
            
        }
        .onDisappear {
            // close the listners and cleanup
            chatViewModel.conversationViewCleanup()
        }
        
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(isChatShowing: .constant(true))
            .environmentObject(ChatViewModel())
            .environmentObject(ContactsViewModel())
    }
}
