//
//  TextHelper.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import Foundation

class TextHelper {
    static func sanatizePhoneNumber(phone: String) -> String {
        return phone
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "+", with: "")
                .replacingOccurrences(of: " ", with: "")
    }
}
