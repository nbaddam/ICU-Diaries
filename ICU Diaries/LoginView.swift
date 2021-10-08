//
//  LoginView.swift
//  ICU Diaries
//
//  Created by jacob kurian on 10/8/21.
//
import SwiftUI
import Foundation
import FirebaseAuth

func loginUser(_ email: String,_ password: String)->Bool {
    var valid: Bool = false
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
        if error != nil { //there is an error with email or password
            print("error with email/password")
            //self.errorLabel.text = error!.localizedDescription - dont know what these 2 lines are for
            //self.errorLabel.alpha = 1
            valid = false
        }
        else {
            print("timeline?")
            valid = true
        }
    }
    return valid
}
