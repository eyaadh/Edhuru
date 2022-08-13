//
//  ViewExtensions.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 14-8-22.
//

import Foundation
import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignemnt: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
        ZStack (alignment: alignemnt) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
