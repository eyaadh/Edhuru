//
//  ConversationPhotoMessage.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 6-8-22.
//

import SwiftUI

struct ConversationPhotoMessage: View {
    
    @EnvironmentObject var chatViewModel: ChatViewModel
    
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
            
            cachedImage
                .resizable()
                .scaledToFill()
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(isFromUser ? Color("bubble-primary"): Color("bubble-secondary"))
                .cornerRadius(30, corners: isFromUser ?  [.topLeft, .topRight, .bottomLeft]: [.topLeft, .topRight, .bottomRight])
        } else {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    // currently fetching
                    ProgressView()
                case .success(let image):
                    // display the fetched image
                    image
                        .resizable()
                        .scaledToFill()
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(isFromUser ? Color("bubble-primary"): Color("bubble-secondary"))
                        .cornerRadius(30, corners: isFromUser ?  [.topLeft, .topRight, .bottomLeft]: [.topLeft, .topRight, .bottomRight])
                        .onAppear {
                            CacheService.setImage(image: image, forKey: imageUrl)
                        }
                    
                case .failure:
                    // couldnt fetch the image, show the error
                    ConversationTextMessage(msg: "Could not load the image.",
                                            isFromUser: isFromUser)
                }
            }
        }
    }
}
