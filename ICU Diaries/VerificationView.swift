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
    var body: some View {
        VStack{
            VerificationText()
            
            Text("Resend email")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    Auth.auth().currentUser?.sendEmailVerification { error in
                      print("sending email verification")
                    }
                }
            
        }
    }
}

struct VerificationText: View {
    var body: some View {
        Text("A verification email has just been sent to your email. Please click the link before proceeding to login")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
