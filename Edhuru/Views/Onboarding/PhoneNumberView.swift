//
//  PhoneNumberView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI
import Combine

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
                        .keyboardType(.numberPad)
                        .onReceive(Just(phoneNumber)) { _ in
                            TextHelper.applyPatternOnNumbers(&phoneNumber,
                                                             pattern: "+# (###) ###-####",
                                                             replacementCharacter: "#")
                        }
                    
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
                // Send their phone number to firebase
                AuthViewModel.sendPhoneNumber(phone: phoneNumber) { error in
                    if error == nil {
                        // goto Next Step on onboarding
                        currentStep = .verification
                    } else {
                        // TODO: show the user the error that appeared
                    }
                }
                
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
