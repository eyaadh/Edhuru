//
//  User.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var firstname: String?
    var lastname: String?
    var phone: String?
    var photo: String?
}
