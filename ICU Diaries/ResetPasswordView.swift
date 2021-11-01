//
//  SignUpView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct ResetPasswordView: View {
    @State var email = ""
    @State var isEmailValid = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Please enter your email. Follow the instructions in the email you recieve to reset your password.")
                TextField(
                    "Email",
                    text: $email,
                    onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if Utilities.isEmailValid(self.email) {
                                self.isEmailValid = true
                            } else {
                                print("Invalid email entered: \(email)")
                                self.isEmailValid = false
                                self.email = ""
                            }
                        }
                    })
                    .disableAutocorrection(true)
                    .cornerRadius(5)
                    .padding(.bottom, 10)
            }
            Text("Reset Password")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    print("sending reset password email")
                    Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                        if(error == nil) {
                            print("sent email")
                        }
                    }
                }
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
