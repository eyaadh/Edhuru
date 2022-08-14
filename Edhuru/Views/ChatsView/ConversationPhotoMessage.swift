//
//  ConversationPhotoMessage.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 6-8-22.
//

import SwiftUI

struct ConversationPhotoMessage: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var msgid: String = ""
    var msg: String
    var imageUrl: String
    var isFromUser: Bool
    var isActive: Bool = true
    
    var body: some View {
        // if the message is from a deleted/inactive user
        // show a text message as a deleted message
        if !isActive {
            ConversationTextMessage(msg: "Photo Deleted",
                                    isFromUser: isFromUser)
            
        } else if let cachedImage = CacheService.getImage(forKey: imageUrl) {
            // check image cache if the profile pic exists, if so use it
            
            VStack {
                cachedImage
                    .resizable()
                    .scaledToFill()
                
                Text(msg)
                    .font(Font.bodyParagraph)
                    .foregroundColor(isFromUser ? Color("text-button"):Color("text-secondary"))
                
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(isFromUser ? Color("bubble-primary"): Color("bubble-secondary"))
            .cornerRadius(30, corners: isFromUser ?  [.topLeft, .topRight, .bottomLeft]: [.topLeft, .topRight, .bottomRight])
            .contextMenu {
                if isFromUser{
                    // Save photo to galary
                    Button {
                        ImageSaver.writeToPhotoAlbum(image: imageUrl)
                    } label: {
                        Label("Save to Photos", systemImage: "tray.and.arrow.down")
                    }
                    
                    // Delete Message
                    Button {
                        deleteMsg(msgid: msgid)
                    } label: {
                        Label("Delete Message", systemImage: "trash")
                    }
                }
            }
            
        } else {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    // currently fetching
                    ProgressView()
                case .success(let image):
                    // display the fetched image
                    VStack {
                        image
                            .resizable()
                            .scaledToFill()
                        
                        Text(msg)
                            .font(Font.bodyParagraph)
                            .foregroundColor(isFromUser ? Color("text-button"):Color("text-secondary"))
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(isFromUser ? Color("bubble-primary"): Color("bubble-secondary"))
                    .cornerRadius(30, corners: isFromUser ?  [.topLeft, .topRight, .bottomLeft]: [.topLeft, .topRight, .bottomRight])
                    .onAppear {
                        CacheService.setImage(image: image, forKey: imageUrl)
                    }
                    .contextMenu {
                        // Save photo to galary
                        Button {
                            ImageSaver.writeToPhotoAlbum(image: imageUrl)
                        } label: {
                            Label("Save to Photos", systemImage: "tray.and.arrow.down")
                        }
                        
                        
                        if isFromUser{
                            // Delete Message
                            Button {
                                deleteMsg(msgid: msgid)
                            } label: {
                                Label("Delete Message", systemImage: "trash")
                            }
                        }
                    }
                    
                case .failure:
                    // couldnt fetch the image, show the error
                    ConversationTextMessage(msg: "Could not load the image.",
                                            isFromUser: isFromUser)
                    .contextMenu {
                        if isFromUser{
                            
                            // Delete Message
                            Button {
                                deleteMsg(msgid: msgid)
                            } label: {
                                Label("Delete Message", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    // delete msg function
    private func deleteMsg(msgid: String) {
        chatViewModel.deleteMessage(msgid: msgid) { result in
            if result {
                chatViewModel.messageDeletionAlertContent = "Message Deleted Successfully."
            } else {
                chatViewModel.messageDeletionAlertContent = "There was an error trying to delete the message."
            }
            chatViewModel.showingMessageDeletionAlert = true
        }
    }
}
