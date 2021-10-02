//
//  ContentView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                WelcomeText()
                
                TextField(
                    "Email",
                     text: $username)
                    .disableAutocorrection(true)
                    .padding()
                    .cornerRadius(5)
                
                SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(5)
                    .padding(.bottom, 5)
                
                Button(action: {
                    print("login")
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                }
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                
                HStack {
                    Text("Don't have an account yet?")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                    }
                }
                
                Spacer()
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("ICU Diaries")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
