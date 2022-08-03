//
//  WelcomeView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentStep: OnboardingStep
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("onboarding-welcome")
            
            Text("Welcome to Chat App")
                .font(Font.titleText)
                .padding(.top, 32)
            
            Text("Simple and fuss-free chat experience")
                .font(Font.bodyParagraph)
                .padding(.top, 8)
            
            Spacer()
            
            Button {
                // Next Step
                currentStep = .phonenumber
            } label: {
                Text("Get Started")
            }
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 14)
            
            Text("By tapping ‘Get Started’, you agree to our Privacy Policy.")
                .font(Font.smallText)
                .padding(.bottom, 61)
            
        }
        .padding(.horizontal)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(currentStep: .constant(.welcome))
    }
}
