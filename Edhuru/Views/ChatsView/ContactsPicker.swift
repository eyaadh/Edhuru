//
//  ContactsPicker.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 6-8-22.
//

import SwiftUI

struct ContactsPicker: View {
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @Binding var isContactsPickerShowing: Bool
    @Binding var selectedContacts: [User]
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack(spacing:0){
                ScrollView {
                    ForEach(contactsViewModel.filteredUsers) { user in
                        
                        // determine if the user is a selected contact
                        let isSelectedContact = selectedContacts.contains { u in
                            u.id == user.id
                        }
                        
                        ZStack {
                            ContactRow(user: user)
                            
                            HStack {
                                Spacer()
                                
                                Button {
                                    // toggle the user to be selected or not
                                    if isSelectedContact {
                                        // find the index of the selected user
                                        let index = selectedContacts.firstIndex(of: user)
                                        
                                        // remove the contacts from selected contact list
                                        if let index = index {
                                            selectedContacts.remove(at: index)
                                        }
                                        
                                    } else {
                                        // only allow a group chat of 4 including u
                                        if selectedContacts.count < 3 {
                                            // otherwise add the contact to selected contact list
                                            selectedContacts.append(user)
                                        } else {
                                            // TODO: warn the user that limit has reached.
                                        }
                                    }
                                } label: {
                                    Image(systemName: isSelectedContact ? "checkmark.circle.fill":"checkmark.circle")
                                        .resizable()
                                        .foregroundColor(Color("button-primary"))
                                        .frame(width:25, height: 25)
                                        
                                }
                            }
                        }
                        .padding(.top, 18)
                        .padding(.horizontal)
                    }
                }
                
                Button {
                    // dismiss the contact picker
                    isContactsPickerShowing = false
                } label: {
                    ZStack {
                        Color("button-primary")
                        
                        Text("Done")
                            .font(Font.button)
                            .foregroundColor(Color("text-button"))
                    }
                    .frame(height: 56)
                }

            }
            
        }
        .onAppear {
            // clear the filter text
            contactsViewModel.filteredContacts(filteredBy: "")
        }
    }
}

