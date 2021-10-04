//
//  SignUpView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI

struct SignUpView: View {
    var body: some View {
        VStack{
            NavigationLink(destination: Timeline()) {
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

