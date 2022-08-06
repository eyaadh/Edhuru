//
//  ConversationsView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 5-8-22.
//

import SwiftUI


struct ConversationsView: View {
    @EnvironmentObject var  chatViewModel: ChatViewModel
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    
    @Binding var isChatShowing: Bool
    
    @State var chatMessage: String = ""
    
    @State var participants: [User] = [User]()
    
    @State var selectedImage:UIImage?
    @State var isPickerShowing:Bool = false
    
    @State var isContactsPickerShowing:Bool = false
    
    @State var isSourceMenuShowing:Bool = false
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                // header
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    HStack {
                        // navigation buttons and chat name
                        VStack(alignment:.leading) {
                            
                            HStack {
                                // back button
                                Button {
                                    // dismiss conversations view
                                    isChatShowing = false
                                } label: {
                                    Image(systemName: "arrow.backward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:24, height:24)
                                        .foregroundColor(Color("text-header"))
                                }
                                
                                // new message label for new conversations
                                if self.participants.count == 0 {
                                    Text("New Message")
                                        .font(Font.chatHeading)
                                        .foregroundColor(Color("text-header"))
                                }
                            }
                            .padding(.bottom, 16)
                            
                            // users name
                            if participants.count > 0 {
                                let partipant = participants.first
                                
                                Text("\(partipant?.firstname ?? "") \(partipant?.lastname ?? "")")
                                    .font(Font.chatHeading)
                                    .foregroundColor(Color("text-header"))
                            } else {
                                Text("Recepient")
                                    .font(Font.bodyParagraph)
                                    .foregroundColor(Color("text-input"))
                            }
                        }
                        
                        Spacer()
                        
                        // profile image
                        if participants.count > 0 {
                            let partipant = participants.first
                            
                            ProfilePicView(user: partipant!)
                        } else {
                            // new message button
                            Button {
                                // show contact picker
                                isContactsPickerShowing = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25,height: 25)
                                    .foregroundColor(Color("button-primary"))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 104)
                
                
                Spacer()
                
                // chat log
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 24) {
                            ForEach(Array(chatViewModel.messages.enumerated()), id: \.element) { index, msg in
                                
                                let isFromUser = msg.senderid == AuthViewModel.getLoggedInUserID()
                                
                                // dynamic message
                                HStack {
                                    if isFromUser {
                                        Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                            .font(Font.smallText)
                                            .foregroundColor(Color("text-timestamp"))
                                            .padding(.trailing, 20)
                                        
                                        Spacer()
                                    }
                                    
                                    if msg.imageurl != "" {
                                        // show the photo message
                                        ConversationPhotoMessage(imageUrl: msg.imageurl!, isFromUser: isFromUser)
                                    } else {
                                        // show the text message
                                        ConversationTextMessage(msg: msg.msg, isFromUser: isFromUser)
                                    }
                                    
                                    if !isFromUser {
                                        Spacer()
                                        
                                        Text(DateHelper.chatTimestampFrom(date: msg.timestamp))
                                            .font(Font.smallText)
                                            .foregroundColor(Color("text-timestamp"))
                                            .padding(.leading, 20)
                                    }
                                }
                                .id(index)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 24)
                        
                    }
                    .onChange(of: chatViewModel.messages.count) { newCount in
                        withAnimation {
                            proxy.scrollTo(newCount - 1)
                        }
                    }
                    .onAppear {
                        withAnimation {
                            proxy.scrollTo(chatViewModel.messages.count - 1)
                        }
                    }
                }
                
                // chat message bar
                HStack (spacing: 15) {
                    // camera button
                    Button {
                        // Show picker
                        isSourceMenuShowing = true
                        
                    } label: {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .tint(Color("icons-secondary"))
                    }
                    
                    // text field
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("date-pill"))
                            .cornerRadius(50)
                        
                        // if the chat message is an image, show the image rather
                        if selectedImage != nil {
                            // display image in the message bar
                            Text("Image")
                                .foregroundColor(Color("text-input"))
                                .font(Font.bodyParagraph)
                                .padding(10)
                            
                            // Emoji button
                            HStack {
                                Spacer()
                                
                                Button {
                                    selectedImage = nil
                                } label: {
                                    Image(systemName: "multiply.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(Color("text-input"))
                                }
                            }
                            .padding(.trailing, 12)
                        } else {
                            TextField("Type your message", text: $chatMessage)
                                .foregroundColor(Color("text-input"))
                                .font(Font.bodyParagraph)
                                .padding(10)
                            
                            // Emoji button
                            //                        HStack {
                            //                            Spacer()
                            //
                            //                            Button {
                            //                                // Emojis
                            //                            } label: {
                            //                                Image(systemName: "face.smiling")
                            //                                    .resizable()
                            //                                    .scaledToFit()
                            //                                    .frame(width: 24, height: 24)
                            //                                    .foregroundColor(Color("text-input"))
                            //                            }
                            //                        }
                            //                        .padding(.trailing, 12)
                        }
                    }
                    .frame(height: 44)
                    
                    
                    // send button
                    Button {
                        // check if the image is selected, if so send the image first
                        if selectedImage != nil {
                            // send the selected image
                            chatViewModel.sendPhotoMessage(image: selectedImage!)
                            
                            // clear selected image for new text message
                            self.selectedImage = nil
                        } else {
                            // cleanup chat messages before sending it, remove any leading rubbish
                            chatMessage = chatMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            // Send Message
                            chatViewModel.sendMessage(msg: chatMessage)
                            
                            // clear the chat message after sending
                            chatMessage = ""
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .tint(Color("icons-primary"))
                    }
                    .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines) == "" && selectedImage == nil)
                    
                }
                .padding(.horizontal)
                .frame(height: 76)
                .disabled(participants.count == 0)
                
            }
        }
        .onAppear {
            // call chat view model to retrieve all chat messages
            chatViewModel.getMessages()
            
            // try to get the other partipants as user instances
            let ids = chatViewModel.getParticipantIDs()
            self.participants = contactsViewModel.getParticipants(ids: ids)
            
        }
        .onDisappear {
            // close the listners and cleanup
            chatViewModel.conversationViewCleanup()
        }
        .confirmationDialog("Choose the source of your image.", isPresented: $isSourceMenuShowing, actions: {
            Button {
                self.source = .photoLibrary
                self.isPickerShowing = true
            } label: {
                Text("Photo Library")
            }
            
            // if the camera is unavailable do not show this option
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button {
                    self.source = .camera
                    self.isPickerShowing = true
                } label: {
                    Text("From Camera")
                }
            }
            
        })
        .sheet(isPresented: $isPickerShowing) {
            // show the image picker
            ImagePicker(selectedImage: $selectedImage,
                        isPickerShowing: $isPickerShowing, source: self.source)
        }
        .sheet(isPresented: $isContactsPickerShowing) {
            // on dismiss
        } content: {
            ContactsPicker(isContactsPickerShowing: $isContactsPickerShowing, selectedContacts: $participants)
        }

        
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView(isChatShowing: .constant(true))
            .environmentObject(ChatViewModel())
            .environmentObject(ContactsViewModel())
    }
}
