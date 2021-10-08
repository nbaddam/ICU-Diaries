//
//  ContentView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI
import Foundation
import FirebaseAuth


struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isEmailValid = true
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                WelcomeText()
                
                TextField(
                    "Email",
                    text: $username,
                    onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if Utilities.isEmailValid(self.username) {
                                self.isEmailValid = true
                            } else {
                                print("Invalid email entered: \(username)")
                                self.isEmailValid = false
                                self.username = ""
                            }
                        }
                    })
                    .disableAutocorrection(true)
                    .padding()
                    .cornerRadius(5)
                
                if !self.isEmailValid {
                    Text("Email is Not Valid")
                        .font(.callout)
                        .foregroundColor(Color.red)
                }
                
                SecureField(
                    "Password",
                    text: $password)
                    .padding()
                    .cornerRadius(5)
                    .padding(.bottom, 5)
                
                
                Button(action: { loginUser(username, password)
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                }
                .fullScreenCover(isPresented: $isPresented, content:
                    FullScreenModalView.init)
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
    
    func loginUser(_ email: String,_ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil { //there is an error with email or password
                print("error with email/password")
                //self.errorLabel.text = error!.localizedDescription - dont know what these 2 lines are for
                //self.errorLabel.alpha = 1
            }
            else {
                print("timeline?")
                isPresented.toggle()
            }
        }
    }
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
            }
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

struct Timeline: View {
    var body: some View {
        VStack{
            Text("Hello World")
        }
    }
}
