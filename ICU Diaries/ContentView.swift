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
    @State private var isPresented: Bool? = false
    
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
                
                NavigationLink(destination: Timeline().navigationBarBackButtonHidden(true), tag: true, selection: $isPresented) {
                    EmptyView()
                }
                Text("Login")
                    .padding(10)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .background(Color.blue)
                    .cornerRadius(2)
                    .foregroundColor(.white)
                    .onTapGesture {
                        Auth.auth().signIn(withEmail: self.username, password: self.password) { result, error in
                            if error != nil { //there is an error with email or password
                                print("error with email/password")
                                self.isPresented = false
                                //self.errorLabel.text = error!.localizedDescription - dont know what these 2 lines are for
                                //self.errorLabel.alpha = 1
                            }
                            else {
                                print("valid login")
                                self.isPresented = true
                            }
                            print(password)
                            //print("success ", success)
                        }
                        /*
                        
                        let valid = true
                        print("valid ", valid)
                        if valid == true {
                            self.isPresented = true
                            print("valid login info")
                        }
                        else {
                            self.isPresented = false
                            print("invalid login info")
 */
                    }
                /*
                NavigationLink(destination: Timeline(), isActive: $isPresented) {
                    Button(action: {
                        print(self.password)
                        let valid = loginUser(username, password)
                        print("valid ", valid)
                        if valid == true {
                            self.isPresented = true
                            print("valid login info")
                        }
                        else {
                            self.isPresented = false
                            print("invalid login info")
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .background(Color.blue)
                    .cornerRadius(2)
                }
                */
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
