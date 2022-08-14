//
//  ImageSaver.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 7-8-22.
//

import Foundation
import SwiftUI

class ImageSaver: NSObject {
    static func writeToPhotoAlbum(image: String) {
        
        DispatchQueue.init(label: "saveToGallery").async {
            do {
                let url = URL(string: image)
                if let url = url {
                    let data = try Data(contentsOf: url)
                    let img = UIImage(data: data)
                    if let image = img {
                        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                    }
                    
                }
            }
            catch{
                print(error)
            }
        }
        
    }
    
}

