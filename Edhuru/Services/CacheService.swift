//
//  CacheService.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 6-8-22.
//

import Foundation
import SwiftUI

class CacheService {
    
    // stores the image components
    private static var imageCache = [String: Image]()
    
    /// Return image for a given key. Nil if it does not exists
    static func getImage(forKey: String) -> Image? {
        return imageCache[forKey]
    }
    
    /// Stores the image component in cache for the given key
    static func setImage(image: Image, forKey: String) {
        imageCache[forKey] = image
    }
}
