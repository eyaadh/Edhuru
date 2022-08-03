//
//  CreateProfileView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

struct CreateProfileView: View {
    @Binding var currentStep: OnboardingStep
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        VStack {
            Text("Setup Profile")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Just a few more details to get started.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            Spacer()
            
            // profile Image button
            Button {
                //
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                    
                    Circle()
                        .stroke(Color("create-profile-border"), lineWidth: 2)
                    
                    Image(systemName: "camera.fill")
                        .foregroundColor(Color("icons-input"))
                }
                .frame(width:134, height:134)
            }
            
            Spacer()
            
            
            // first name
            TextField("Given Name", text: $firstName)
                .textFieldStyle(CreateProfileTextfiledStyle())
            
            // last name
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CreateProfileTextfiledStyle())
            
            
            Spacer()
            
            Button {
                // Next Step
                currentStep = .contacts
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
