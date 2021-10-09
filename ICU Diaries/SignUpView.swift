//
//  SignUpView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    var body: some View {
        VStack{
            Button(action: {
                print("clicked")
            }) {
                Text("Patient")
            }
            Button(action: {
                print("clicked")
            }) {
                Text("Clinician")
            }
            Button(action: {
                print("clicked")
            }) {
                Text("Friends and Family")
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

