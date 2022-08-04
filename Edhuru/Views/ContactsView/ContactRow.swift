//
//  ContactRow.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import SwiftUI

struct ContactRow: View {
    var user: User
    var body: some View {
        HStack (spacing: 24) {
            // Profile Image
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
            .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 4){
                // Name
                Text("\(user.firstname ?? "") \(user.lastname ?? "")")
                    .font(Font.button)
                    .foregroundColor(Color("text-primary"))
                // phoneNumber
                Text(user.phone ?? "")
                    .font(Font.bodyParagraph)
                    .foregroundColor(Color("text-input"))
            }
            
            Spacer()
        }
    }
}

struct ContactRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactRow(user: User())
    }
}
