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
                // profile unage
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
