//
//  DatabaseService.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import Foundation
import Contacts
import Firebase
import FirebaseStorage
import UIKit

class DatabaseService {
    func getPlatformUsers(localContacts: [CNContact], completion: @escaping([User]) -> Void) {
        // the array where we're storing fetched platform users
        var platformUsers = [User]()
        
        // construct an array of string phone numbers to look up
        let lookupPhoneNumbers = localContacts.map { contact in
            // Turn the contact into a phone number in a string
            return TextHelper.sanatizePhoneNumber(phone: contact.phoneNumbers.first?.value.stringValue ?? "")
            
        }
        
        // make sure that there are lookup phone numbers to continue
        guard lookupPhoneNumbers.count > 0 else {
            completion(platformUsers)
            return
        }
        
        // init the DB for querying
        let db = Firestore.firestore()
        
        // divide the lookupPhoneNumbers array into equal chunks of 10 items
        let chunkedLookupPhoneNumbers = lookupPhoneNumbers.chunked(into: 10)
        
        // loop through the chunks and query the db to check for phone numbers that exists in the platform
        for lookupPhoneNumbersChunk in chunkedLookupPhoneNumbers {
            let query = db.collection("users").whereField("phone", in: lookupPhoneNumbersChunk)
            
            // retrieve the users that are on the platform
            query.getDocuments { snapshot, err in
                // check for errors
                if err == nil && snapshot != nil {
                    // for each doc that was fetched create a user for platformUsers array
                    for doc in snapshot!.documents {
                        if let user = try? doc.data(as: User.self) {
                            platformUsers.append(user)
                        }
                    }
                }
            }
        }
        
        // return these users
        completion(platformUsers)
    }
        
    func setUserProfile(firstName: String, lastName: String, image: UIImage?, completion: @escaping(Bool) -> Void) {
        
        // Guard against logged out users
        guard AuthViewModel.isUserLoggedIn() != false else {
            return
        }
        
        let userUID = AuthViewModel.getLoggedInUserID()
        let userPhone: String = TextHelper.sanatizePhoneNumber(phone: AuthViewModel.getLoggedInUserPhoneNumber())
        
        // get a refernce to Firestore
        let db = Firestore.firestore()
        
        // set the profile data
        let doc = db.collection("users").document(userUID)
        doc.setData([
            "firstName": firstName,
            "lastName": lastName,
            "phone": userPhone
        ])
        
        // check if the image is passed through
        if let image = image {
            // Create storage reference
            let storageRef = Storage.storage().reference()
            
            // Turn our image into data
            let imageData = image.jpegData(compressionQuality: 0.8)
            
            // Check that we were able to convert it to data
            guard imageData != nil else {
                return
            }
            
            // Specify the file path and name
            let path = "images/\(UUID().uuidString).jpg"
            let fileRef = storageRef.child(path)
            
            let uploadTask = fileRef.putData(imageData!, metadata: nil) { meta, err in
                if err == nil && meta != nil {
                    // set that image path on the user doc
                    doc.setData(["photo": path], merge: true) { error in
                        // success, notify caller
                        completion(true)
                    }
                    
                } else {
                    // upload was not successfull
                    completion(false)
                }
            }
            
            
        }
    }
    
    func checkUserProfile(completion: @escaping (Bool) -> Void) {
        
        // check if the user is logged
        guard AuthViewModel.isUserLoggedIn() != false else {
            return
        }
        
        // create firestore reference
        let db = Firestore.firestore()
        
        db.collection("users").document(AuthViewModel.getLoggedInUserID()).getDocument { snapshot, error in
            if error == nil && snapshot != nil {
                completion(snapshot!.exists)
            } else {
                completion(false)
            }
        }
    }
}
