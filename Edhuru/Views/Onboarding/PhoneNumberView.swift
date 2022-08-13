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
    @State var isButtonDisabled:Bool = false
    @State var isErrorLabelVisible:Bool = false
    
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
                        .foregroundColor(Color("text-field"))
                        .font(Font.bodyParagraph)
                        .keyboardType(.numberPad)
                        .onReceive(Just(phoneNumber)) { _ in
                            TextHelper.applyPatternOnNumbers(&phoneNumber,
                                                             pattern: "+(###) ####-####",
                                                             replacementCharacter: "#")
                        }
                        .placeholder(when: phoneNumber.isEmpty) {
                            Text("e.g. +1 613 515 0123")
                                .foregroundColor(Color("text-field"))
                                .font(Font.bodyParagraph)
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
            
            // Error message
            Text("Please enter a valid Phone Number.")
                .font(Font.smallText)
                .foregroundColor(.red)
                .padding(.top, 20)
                .opacity(isErrorLabelVisible ? 1 : 0)
            
            Spacer()
            
            Button {
                // hide the error message if it's enabled
                isErrorLabelVisible = false
                
                // disable the button to prevent multiple taps
                isButtonDisabled = true
                
                // Send their phone number to firebase
                AuthViewModel.sendPhoneNumber(phone: phoneNumber) { error in
                    if error == nil {
                        // goto Next Step on onboarding
                        currentStep = .verification
                    } else {
                        // show the user the error that appeared
                        isErrorLabelVisible = true
                        if let error = error {
                            print("An error occured with validating the phone number: \(error)")
                        }
                    }
                
                    // finally re-enable the button
                    isButtonDisabled = false
                }
                
            } label: {
                HStack {
                    Text("Next")
                    
                    if isButtonDisabled {
                        ProgressView()
                            .padding(.leading, 2)
                    }
                }
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
            .disabled(isButtonDisabled)
        }
        .padding(.horizontal)
    }
}

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView(currentStep: .constant(.phonenumber))
    }
}
