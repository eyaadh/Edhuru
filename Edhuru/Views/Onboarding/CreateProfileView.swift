//
//  CreateProfileView.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import SwiftUI

struct CreateProfileView: View {
    @Binding var currentStep: OnboardingStep
    @State var firstName:String = ""
    @State var lastName:String = ""
    
    @State var selectedImage:UIImage?
    @State var isPickerShowing:Bool = false
    
    @State var isSourceMenuShowing:Bool = false
    @State var source:UIImagePickerController.SourceType = .photoLibrary
    
    @State var isSaveButtonDisabled:Bool = false
    
    var body: some View {
        VStack {
            Text("Setup Profile")
                .font(Font.titleText)
                .padding(.top, 52)
            
            Text("Just a few more details to get started.")
                .font(Font.bodyParagraph)
                .padding(.top, 12)
            
            Spacer()
            
            // profile Image button
            Button {
                // trigger the confirmation sheet before action sheet for
                // image picker is show
                isSourceMenuShowing = true
            } label: {
                ZStack {
                    // if the selectedImage is show that image otherwise
                    // the default upload image button
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .foregroundColor(.white)
                        
                        Image(systemName: "camera.fill")
                            .foregroundColor(Color("icons-input"))
                    }
                    
                    Circle()
                        .stroke(Color("create-profile-border"), lineWidth: 2)
                    
                }
                .frame(width:134, height:134)
            }
            
            Spacer()
            
            
            // first name
            TextField("Given Name", text: $firstName)
                .textFieldStyle(CreateProfileTextfiledStyle())
            
            // last name
            TextField("Last Name", text: $lastName)
                .textFieldStyle(CreateProfileTextfiledStyle())
            
            
            Spacer()
            
            Button {
                // Disable the button once pressed to avoid double taps
                self.isSaveButtonDisabled = true
                // Next Step
                DatabaseService().setUserProfile(firstName: firstName,
                                                 lastName: lastName,
                                                 image: selectedImage) { isSuccess in
                    if isSuccess {
                        currentStep = .contacts
                    } else {
                        // TODO: show error message
                    }
                    self.isSaveButtonDisabled = false
                }
                
            } label: {
                Text(self.isSaveButtonDisabled ? "Uploading": "Save")
            }
            .disabled(self.isSaveButtonDisabled)
            .buttonStyle(OnboardingButtonStyle())
            .padding(.bottom, 87)
        }
        .padding(.horizontal)
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
    }
}

struct CreateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileView(currentStep: .constant(.profile))
    }
}
