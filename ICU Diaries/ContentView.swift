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
    @State private var isSecured: Bool = true // NEW
    @State private var inEmailBox: Bool = false
    @State private var inPasswordBox: Bool = false
    @State private var missingField: Bool = false
    @State private var successfulLogin: Bool = true
    @State private var isVerified: Bool = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                WelcomeText()
                
                TextField(
                    "Email",
                    text: $username,
                    onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if Utilities.isEmailValid(self.username) || self.username.isEmpty {
                                self.isEmailValid = true
                            } else {
                                print("Invalid email entered: \(username)")
                                self.isEmailValid = false
                            }
                            inEmailBox = false
                        }
                    })
                    .disableAutocorrection(true)
                    .padding(10)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        !isEmailValid ? Color.red : Color(UIColor.lightGray),
                                        lineWidth: inEmailBox ? 3 : 1
                                    ))
                    .onTapGesture {
                        inEmailBox = true
                        inPasswordBox = false
                    }
                
                if !self.isEmailValid {
                    Text("Email is Not Valid")
                        .font(.callout)
                        .foregroundColor(Color.red)
                }
                
                HStack {
                    VStack {
                        if isSecured {
                            SecureField(
                                "Password",
                                text: $password)
                        
                        } else {
                            TextField(
                                "Password",
                                text: $password)
                        }
                    }
                    
                    Button(action: {
                        self.isSecured.toggle()
                    }) {
                        
                        if isSecured {
                            EyeToggleView(name: "icons8-hide-30")
                        } else {
                            EyeToggleView(name: "icons8-eye-30")
                        }
                    }
                    .offset(x: -4, y: -2)
                    
                } // HStack
                .padding(10)
                .textFieldStyle(PlainTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                Color(UIColor.lightGray),
                                lineWidth: inPasswordBox ? 3 : 1
                        ))
                .onTapGesture {
                    inEmailBox = false
                    inPasswordBox = true
                }
                
                if !successfulLogin {
                    if missingField {
                        Text("Please Fill in all Fields.")
                            .foregroundColor(Color.red)
                            .font(.callout)
                    } else if !isVerified {
                        Text("Please Check Inbox and Verify Account.")
                            .foregroundColor(Color.red)
                            .font(.callout)
                    } else {
                        Text("Incorrect Email/Password. Try Again.")
                            .foregroundColor(Color.red)
                            .font(.callout)
                    }
                }
                
                
                NavigationLink(destination: MainView().navigationBarBackButtonHidden(true), tag: true, selection: $isPresented) {
                    EmptyView()
                }
                Text("Login")
                    .padding(12)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .onTapGesture {
                        // unhighlight password box
                        inPasswordBox = false
                        
                        // reset bools
                        self.missingField = false
                        
                        // if fields are left blank (e.g. missing email or password)
                        if self.username.isEmpty || self.password.isEmpty {
                            self.missingField = true
                            self.successfulLogin = false
                            self.isPresented = false
                            
                        } else {
                            Auth.auth().signIn(withEmail: self.username, password: self.password) { result, error in
                                if error != nil { //there is an error with email or password
                                    print("error with email/password")
                                    self.isPresented = false
                                    successfulLogin = false
                                    //self.errorLabel.text = error!.localizedDescription - dont know what these 2 lines are for
                                    //self.errorLabel.alpha = 1
                                } else {
                                    print("valid login")
                                    // check if email is verfied
                                    if ((Auth.auth().currentUser?.isEmailVerified ?? false)) {
                                        self.isPresented = true
                                        successfulLogin = true
                                        isVerified = true
                                    } else {
                                        print("email is not verified")
                                        self.isPresented = false
                                        successfulLogin = false
                                        isVerified = false
                                    }
                                }
                                print(password)
                                
                            } // Auth() end
                        } // else
                    } // on tap gesture end
                
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
    /*
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
    }*/
    func getUserInfo() {
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
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
