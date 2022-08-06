//
//  ProfilePicView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 5-8-22.
//

import SwiftUI

struct ProfilePicView: View {
    var user: User
    
    var body: some View {
        ZStack {
            if user.photo == nil {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                    Text(user.firstname?.prefix(1) ?? "")
                        .bold()
                }
            } else {
                // profile image
                // check image cache if the profile pic exists, if so use it
                if let cachedImage = CacheService.getImage(forKey: user.photo!) {
                    cachedImage
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    // otherwise, if not in cache download it
                    AsyncImage(url: URL(string: user.photo ?? "")) { phase in
                        switch phase {
                        case .empty:
                            // currently fetching
                            ProgressView()
                        case .success(let image):
                            // display the fetched image
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .onAppear {
                                    // once downloaded save it in cache
                                    CacheService.setImage(image: image,
                                                          forKey: user.photo!)
                                }
                            
                        case .failure:
                            // couldnt fetch profile photo
                            // display a circle with first letter of first name
                            ZStack {
                                Circle()
                                    .foregroundColor(.white)
                                Text(user.firstname?.prefix(1) ?? "")
                                    .bold()
                            }
                            
                        }
                    }
                }
                
            }
            // border
            Circle()
                .stroke(Color("create-profile-border"), lineWidth: 2)
        }
        .frame(width: 44, height: 44)    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(user: User())
    }
}
