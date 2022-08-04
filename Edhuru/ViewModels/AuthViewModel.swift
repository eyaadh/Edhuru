//
//  AuthViewModel.swift
//  Edhuru
//
//  Created by Ahmed Iyad on 3-8-22.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    static func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func getLoggedInUserID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    static func getLoggedInUserPhoneNumber() -> String {
        return Auth.auth().currentUser?.phoneNumber ?? ""
    }
    
    static func logout() {
        try? Auth.auth().signOut()
    }
    
    static func sendPhoneNumber(phone: String, completion: @escaping (Error?) -> Void){
        // send the phone number to firebase
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if error == nil {
                // got the verification id
                UserDefaults.standard.set(verificationID, forKey: "authVerifcationID")
            }
            
            // notify the UI if there was an error, or otherwise return nil
            DispatchQueue.main.async {
                completion(error)
            }
            
        }
    }
    
    static func verifyCode(code: String, completion: @escaping (Error?) -> Void) {
        
        // get the verification ID from local storage
        let verificationID = UserDefaults.standard.string(forKey: "authVerifcationID") ?? ""
        
        // send the code and the verification id to firebase
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        // sign in the user
        Auth.auth().signIn(with: credential) { authResult, error in
            
            // notify the UI if there was an error, or otherwise return nil
            DispatchQueue.main.async {
                completion(error)
            }
        }
        
    }
}
