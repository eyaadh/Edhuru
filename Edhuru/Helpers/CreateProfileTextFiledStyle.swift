//
//  CreateProfileTextFiledStyle.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import Foundation
import SwiftUI

struct CreateProfileTextfiledStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("input"))
                .cornerRadius(8)
                .frame(height: 46)
            
            // this references the text field
            configuration
                .foregroundColor(Color("text-field"))
                .font(Font.tabBar)
                .textInputAutocapitalization(.never)
                .padding()
            
        }
    }
}
