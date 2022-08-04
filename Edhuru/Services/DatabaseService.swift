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
        var lookupPhoneNumbers = localContacts.map { contact in
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
        
        // Perform queries while we still have phone numbers to look up
        while !lookupPhoneNumbers.isEmpty {
            
            // Get the first < 10 phone numbers to look up
            let tenPhoneNumbers = Array(lookupPhoneNumbers.prefix(10))
            
            // Remove the < 10 that we're looking up
            lookupPhoneNumbers = Array(lookupPhoneNumbers.dropFirst(10))
            
            // Look up the first 10
            let query = db.collection("users").whereField("phone", in: tenPhoneNumbers)
            
            // Retrieve the users that are on the platform
            query.getDocuments { snapshot, error in
                
                // Check for errors
                if error == nil && snapshot != nil {
                    
                    // For each doc that was fetched, create a user
                    for doc in snapshot!.documents {
                        
                        if let user = try? doc.data(as: User.self) {
                            
                            // Append to the platform users array
                            platformUsers.append(user)
                        }
                    }
                    
                    // Check if we have anymore phone numbers to look up
                    // If not, we can call the completion block and we're done
                    if lookupPhoneNumbers.isEmpty {
                        // Return these users
                        completion(platformUsers)
                    }
                }
            }
        }
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
            "firstname": firstName,
            "lastname": lastName,
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
                    // get full url to image
                    fileRef.downloadURL { url, error in
                        if error == nil && url != nil {
                            // set that image url on the user doc
                            doc.setData(["photo": url!.absoluteString], merge: true) { error in
                                // success, notify caller
                                completion(true)
                            }
                        } else {
                            completion(false)
                        }
                    }
                    
                    
                } else {
                    // upload was not successfull
                    completion(false)
                }
            }
        } else {
            // no images were set
            completion(false)
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
