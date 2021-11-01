//
//  VerificationView.swift
//  ICU Diaries
//
//  Created by jacob kurian on 10/26/21.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct VerificationView: View {
    @State private var isVerified: Bool? = false
    
    var body: some View {
        VStack{
            VerificationText()
            
            
            Text("Resend email")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .padding(.bottom, 5)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    Auth.auth().currentUser?.sendEmailVerification { error in
                      print("sending email verification")
                    }
                }
            
            NavigationLink(destination: MainView().navigationBarBackButtonHidden(true), tag: true, selection: $isVerified) {
                EmptyView()
            }
            Text("Click once email is verified (this doesn't work idk how to fix)")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    if (Auth.auth().currentUser?.isEmailVerified != true) {
                        Auth.auth().currentUser?.sendEmailVerification { error in
                          print("sending email verification")
                        }
                    }
                    else {
                        isVerified = true;
                    }
                }
            NavigationLink(destination: ContentView()) {
                Text("go back to login")
            }

        }
    }
}

struct VerificationText: View {
    var body: some View {
        Text("A verification email has just been sent to your email. Please click the link before proceeding to login")
            .font(.body)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
