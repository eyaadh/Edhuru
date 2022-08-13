//
//  VerificationView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI
import Combine

struct VerificationView: View {
    @EnvironmentObject var contactsModel: ContactsViewModel
    @EnvironmentObject var chatModel: ChatViewModel
    
    @Binding var currentStep: OnboardingStep
    @Binding var isOnboarding: Bool
    @State var verifcationCode = ""
    @State var isButtonDisabled:Bool = false
    @State var isErrorLabelVisible:Bool = false
    
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
                        .foregroundColor(Color("text-field"))
                        .font(Font.bodyParagraph)
                        .keyboardType(.numberPad)
                        .onReceive(Just(verifcationCode)) { _ in
                            TextHelper.limitText(&verifcationCode, 6)
                        }
                        .placeholder(when: verifcationCode.isEmpty) {
                            Text("000000")
                                .foregroundColor(Color("text-field"))
                                .font(Font.bodyParagraph)
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
            
            
            // Error message
            Text("Invalid Verification Code.")
                .font(Font.smallText)
                .foregroundColor(.red)
                .padding(.top, 20)
                .opacity(isErrorLabelVisible ? 1 : 0)
            
            Spacer()
            
            Button {
                // hide the error if its visible
                isErrorLabelVisible = false
                
                // disable the button to prevent multiple taps
                isButtonDisabled = true
                
                // send the verification code to firebase
                AuthViewModel.verifyCode(code: verifcationCode) { error in
                    if error == nil {
                        // check if the user exists in the platform
                        DatabaseService().checkUserProfile { exists in
                            if exists {
                                // End the onboarding since the user is logging for the second time
                                // use the prior profile
                                isOnboarding = false
                                
                                // load the contacts
                                contactsModel.getLocalContacts()
                                
                                // load chats
                                chatModel.getChats()
                            } else {
                                // goto Next Step on onboarding - profile creation
                                currentStep = .profile
                            }
                        }
                        
                        
                    } else {
                        // Show the error to user
                        isErrorLabelVisible = true
                        
                        if let error = error {
                            print("An error occurred with verifying the verification code: \(error)")
                        }
                    }
                    
                    // re-enable the button finally
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

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(currentStep: .constant(.verification), isOnboarding: .constant(true))
    }
}
