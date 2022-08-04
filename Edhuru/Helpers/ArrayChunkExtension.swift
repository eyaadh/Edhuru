//
//  ArrayChunkExtension.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import Foundation
import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
