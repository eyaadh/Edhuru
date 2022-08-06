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
    
    var chatListViewListeners = [ListenerRegistration]()
    var conversationsListViewListeners = [ListenerRegistration]()
    
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
    
    // MARK: - CHAT METHODS
    
    /// This method returns all chat documents where the logged in user is a participant
    func getAllChats(completion: @escaping ([Chat]) -> Void) {
        
        // get a reference to the database
        let db = Firestore.firestore()
        
        // perform a query against the chat collection for any chats where the logged in user is a participant
        let chatQuery = db.collection("chats")
            .whereField("participantids", arrayContains: AuthViewModel.getLoggedInUserID())
        
        let listener = chatQuery.addSnapshotListener { snapshot, error in
            if error == nil && snapshot != nil {
                
                var chats = [Chat]()
                
                for doc in snapshot!.documents {
                    // parse the data into chat structs
                    let chat = try? doc.data(as: Chat.self)
                    
                    // add the chat into chat array
                    if let chat = chat {
                        chats.append(chat)
                    }
                }
                
                // return the data
                completion(chats)
            } else {
                print("Error in retreving the Chat from DB.")
                completion([Chat]())
            }
        }
        
        // keep track of the listener so that we can close it later
        self.chatListViewListeners.append(listener)
    }
    
    /// This method returns all the messages for a given chat
    func getAllMessages(chat: Chat, completion: @escaping ([ChatMessage]) -> Void) {
        
        // check that the ID is not nill
        guard chat.id != nil else {
            // cannot fetch data
            completion([ChatMessage]())
            return
        }
        
        // get a reference to the database
        let db = Firestore.firestore()
        
        // create the query
        let msgQuery = db.collection("chats")
            .document(chat.id!)
            .collection("msgs")
            .order(by: "timestamp")
        
        // perform the query
        let listener = msgQuery.addSnapshotListener { snapshot, error in
            if error == nil && snapshot != nil {
                // loop through the message documents and create chat message instances
                var messages = [ChatMessage]()
                
                // parse the data
                for doc in snapshot!.documents {
                    let msg = try? doc.data(as: ChatMessage.self)
                    
                    if let msg = msg {
                        messages.append(msg)
                    }
                }
                
                // return the results
                completion(messages)
            } else {
                print("Error in retreving the MSGs data for the Chat from DB.")
                completion([ChatMessage]())
            }
        }
        
        // keep track of the listener so that we can close it later
        self.conversationsListViewListeners.append(listener)
    }
    
    /// Send a message to the database
    func sendMessage(msg: String, chat: Chat) {
        
        // check that it is a valid chat
        guard chat.id != nil else {
            return
        }
        
        
        // get a reference to db
        let db = Firestore.firestore()
        
        // add message doc
        db.collection("chats")
            .document(chat.id!)
            .collection("msgs")
            .addDocument(data: ["imageurl": "",
                                "msg": msg,
                                "senderid": AuthViewModel.getLoggedInUserID(),
                                "timestamp": Date()])
        
        // update the chat document on DB with the new data
        db.collection("chats")
            .document(chat.id!)
            .setData(["updated": Date(), "lastmsg": msg], merge: true)
    }
    
    /// Send a photo message to the database
    func sendPhotoMessage(image: UIImage, chat: Chat) {
        
        // check that it is a valid chat
        guard chat.id != nil else {
            return
        }
        
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
                        // store a chat message
                        
                        // get a reference to db
                        let db = Firestore.firestore()
                        
                        // add message doc
                        db.collection("chats")
                            .document(chat.id!)
                            .collection("msgs")
                            .addDocument(data: ["imageurl": url!.absoluteString,
                                                "msg": "",
                                                "senderid": AuthViewModel.getLoggedInUserID(),
                                                "timestamp": Date()])
                        
                        // update the chat document on DB with the new data
                        db.collection("chats")
                            .document(chat.id!)
                            .setData(["updated": Date(), "lastmsg": "image"], merge: true)
                    }
                }
            }
        }
    }
    
    func createChat(chat: Chat, completion: @escaping (String) -> Void) {
        
        // get a reference to the database
        let db = Firestore.firestore()
        
        // create a document for chat
        let doc = db.collection("chats").document()
            
        // set the data for document
        try? doc.setData(from: chat, completion: { error in
            // communicate the document id
            completion(doc.documentID)
        })
    }
    
    func detachChatListViewListeners() {
        for listener in chatListViewListeners {
            listener.remove()
        }
    }
    
    func detachConversationListViewListeners() {
        for listener in conversationsListViewListeners {
            listener.remove()
        }
    }
}
