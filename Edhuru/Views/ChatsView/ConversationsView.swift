//
//  ConversationsView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 5-8-22.
//

import SwiftUI

struct ConversationsView: View {
    @Binding var isChatShowing: Bool
    
    @State var chatMessage: String = ""
    
    var body: some View {
        VStack{
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

                    
                    
                    Text("Ahmed Iyad Mohamed")
                        .font(Font.chatHeading)
                        .foregroundColor(Color("text-header"))
                    
                }
                
                Spacer()
                
                // profile image
                ProfilePicView(user: User())
            }
            .frame(height: 104)
            .padding(.horizontal)
            
            Spacer()
            
            // chat log
            ScrollView {
                VStack(spacing: 24) {
                    // example of their message
                    HStack {
                        // actual message
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam")
                            .font(Font.bodyParagraph)
                            .foregroundColor(Color("text-primary"))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(Color("bubble-secondary"))
                            .cornerRadius(30, corners: [.topLeft, .topRight, .bottomRight])
                        
                        Spacer()
                        
                        // timestamp
                        Text("9:49")
                            .font(Font.smallText)
                            .foregroundColor(Color("text-timestamp"))
                            .padding(.leading, 20)
                    }
                    
                    HStack {
                        // timestamp
                        Text("9:49")
                            .font(Font.smallText)
                            .foregroundColor(Color("text-timestamp"))
                            .padding(.trailing, 20)
                        
                        Spacer()
                        
                        // actual message
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit ut aliquam")
                            .font(Font.bodyParagraph)
                            .foregroundColor(Color("text-button"))
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                            .background(Color("bubble-primary"))
                            .cornerRadius(30, corners: [.topLeft, .topRight, .bottomLeft])
                    }
                    
                    
                    //example of your message
                }
                .padding(.horizontal)
                .padding(.top, 24)
                
            }
            .background(Color("background"))
            
            // chat message bar
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                HStack {
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
                        // TODO: Send Message
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .tint(Color("icons-primary"))
                    }

                }
                .padding(.horizontal)
                
            }
            .frame(height: 76)
        }
        
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(isChatShowing: .constant(true))
    }
}
