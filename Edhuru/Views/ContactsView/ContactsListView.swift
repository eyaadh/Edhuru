//
//  ContactsListView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 4-8-22.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @State var filterText:String = ""
    
    var body: some View {
        VStack{
            // heading
            HStack{
                Text("Contacts")
                    .font(Font.pageTitle)
                
                Spacer()
                
                Button {
                    // TODO: Settings
                } label: {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .tint(Color("icons-secondary"))
                }
            }
            .padding(.top, 20)
            
            // search bar
            ZStack {
                Rectangle()
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                
                
                TextField("Search contact or number", text: $filterText)
                    .font(Font.tabBar)
                    .foregroundColor(Color("text-field"))
                    .padding()
            }
            .frame(height: 46)
            .onChange(of: filterText) { _ in
                // perform the filter
                contactsViewModel.filteredContacts(filteredBy: filterText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            
            
            if contactsViewModel.filteredUsers.count > 0 {
                // contact list
                List(contactsViewModel.filteredUsers) { user in
                    // Display rows
                    ContactRow(user: user)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .padding(.top, 12)
                
            } else {
                Spacer()
                
                Image("no-contacts-yet")
                
                Text("Hmm... Zero contacts?")
                    .font(Font.titleText)
                    .padding(.top, 32)
                
                Text("Try savings some contacts on your phone!")
                    .font(Font.bodyParagraph)
                    .padding(.top, 8)
                
                Spacer()
            }
            
        }
        .padding(.horizontal)
        .onAppear {
            // Get Local Contacts
            contactsViewModel.getLocalContacts()
        }
    }
}

struct ContactsListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsListView()
            .environmentObject(ContactsViewModel())
    }
}
