//
//  ContactsViewModel.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import Foundation
import Contacts

class ContactsViewModel: ObservableObject {
    @Published var users = [User]()  // list of users on the platform from the local contacts
    private var localContacts = [CNContact]() // list of local contacts from phone address book
    
    func getLocalContacts() {
        // Perform the contact store method asynchronously so that it doesnt block the UI/main thread
        DispatchQueue.init(label: "getcontacts").async {
            do {
                // Ask for permission
                let store = CNContactStore()
                
                // list of keys we want to get
                let keys = [CNContactPhoneNumbersKey,
                            CNContactGivenNameKey,
                            CNContactFamilyNameKey] as! [CNKeyDescriptor]
                
                // create a CNAssociated Fetch Request
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
                
                // get the contacts on the users phone
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, success in
                    // Save the contact on the local array in order to check against the contacts
                    // from firebase storage
                    self.localContacts.append(contact)
                })
                
                // See which local contacts are actually users of this app
                DatabaseService().getPlatformUsers(localContacts: self.localContacts) { platformUsers in
                    // set the fetched users to the published users property
                    DispatchQueue.main.async {
                        self.users = platformUsers
                    }
                }
            } catch {
                // TODO: handle the error
            }
        }
    }
}
