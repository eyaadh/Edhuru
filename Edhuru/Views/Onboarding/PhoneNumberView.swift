//
//  PhoneNumberView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

struct PhoneNumberView: View {
    @Binding var currentStep: OnboardingStep
    @State var phoneNumber = ""
    
    var body: some View {
        VStack {
            Text("Verification")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Enter your mobile number below. We’ll send you a verification code after.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            // Text Field
            ZStack {
                Rectangle()
                    .foregroundColor(Color("input"))
                    .frame(height: 56)
                HStack {
                    TextField("e.g. +1 613 515 0123", text:$phoneNumber)
                        .font(Font.bodyParagraph)
                    
                    Spacer()
                    
                    Button {
                        // clean the phone number
                        phoneNumber = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 19, height: 19)
                            .tint(Color("icons-input"))
                    }
                }
                .padding()
            }
            .padding(.top, 34)
            
            Spacer()
            
            Button {
                // Next Step
                currentStep = .verification
            } label: {
                Text("Next")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.phonenumber))
    }
}
