//
//  DatabaseService.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import Foundation
import Contacts
import Firebase

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
}
