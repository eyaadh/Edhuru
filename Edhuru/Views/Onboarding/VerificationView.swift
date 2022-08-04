//
//  VerificationView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI
import Combine

struct VerificationView: View {
    @Binding var currentStep: OnboardingStep
    @State var verifcationCode = ""
    
    var body: some View {
        VStack {
            Text("Verification")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Enter the 6-digit verification code we sent to your device.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            // Text Field
            ZStack {
                Rectangle()
                    .foregroundColor(Color("input"))
                    .frame(height: 56)
                HStack {
                    TextField("000000", text: $verifcationCode)
                        .font(Font.bodyParagraph)
                        .keyboardType(.numberPad)
                        .onReceive(Just(verifcationCode)) { _ in
                            TextHelper.limitText(&verifcationCode, 6)
                        }
                    
                    Spacer()
                    
                    Button {
                        // clean the phone number
                        verifcationCode = ""
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
                // send the verification code to firebase
                AuthViewModel.verifyCode(code: verifcationCode) { error in
                    if error == nil {
                        // goto Next Step on onboarding
                        currentStep = .profile
                    } else {
                        // TODO: Show the error to user
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

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification))
    }
}
