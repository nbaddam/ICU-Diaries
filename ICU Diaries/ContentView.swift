//
//  ContentView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/1/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isEmailValid = true
    @State var isPresented: Bool = false
    @State var isPresentedSignUp: Bool = false
    @State private var isSecured: Bool = true // NEW
    @State private var inEmailBox: Bool = false
    @State private var inPasswordBox: Bool = false
    @State private var missingField: Bool = false
    @State private var successfulLogin: Bool = true
    @State private var isVerified: Bool = true
    
    @State private var isPatient: Bool = false
    @State private var patient_code = ""
    @State private var isFamily: Bool = false
    @State private var isDoctor: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                WelcomeText()
                TextField(
                    EMAIL_LABEL,
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
                    Text(INVALID_EMAIL_ERR)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                }
                
                HStack {
                    VStack {
                        if isSecured {
                            SecureField(
                                PASSWORD_LABEL,
                                text: $password)
                        
                        } else {
                            TextField(
                                PASSWORD_LABEL,
                                text: $password)
                        }
                        
                    } // VStack
                    
                    Button(action: {
                        self.isSecured.toggle()
                    }) {
                        
                        if isSecured {
                            EyeToggleView(name: CLOSED_EYE_IMAGE)
                        } else {
                            EyeToggleView(name: OPEN_EYE_IMAGE)
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
                        Text(MISSING_FIELDS_ERR)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.red)
                    } else if !isVerified {
                        Text(UNVERIFIED_ACCOUNT_ERR)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.red)
                    } else {
                        Text(INCORRECT_LOGIN_ERR)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.red)
                    }
                }
                
                NavigationLink(destination: MainView(isPatient: isPatient, patient_code: patient_code, isFamily: isFamily, isDoctor: isDoctor, isPresented: $isPresented).navigationBarBackButtonHidden(true), isActive: $isPresented) {
                    EmptyView()
                }
                Text(LOGIN_LABEL)
                    .navigationBarTitle(Text(""), displayMode: .inline)
                    .navigationBarHidden(true)
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
                                        successfulLogin = true
                                        isVerified = true
                                            let db = Firestore.firestore()
                                            let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
                                            docRef.getDocument { (document, error) in
                                                if let document = document, document.exists {
                                                    let testing = document.get("userType") as! String
                                                    if(testing=="patient"){
                                                        self.isPatient = true
                                                        self.patient_code = document.get("code") as! String
                                                    }
                                                    else if(testing=="friendsandfamily"){
                                                        self.isFamily = true
                                                    }
                                                    else{
                                                        self.isDoctor = true
                                                    }
                                                }
                                                self.isPresented = true
                                            }
                                    } else {
                                        print("email is not verified")
                                        self.isPresented = false
                                        successfulLogin = false
                                        isVerified = false
                                    }
                                }
//                                print(password)
                                
                            } // Auth() end
                        } // else
                    } // on tap gesture end
                
                HStack {
                    Text("Don't have an account yet?")
                        .onTapGesture {
                            isPresentedSignUp = true
                        }
                    NavigationLink(destination: SignUpView(isOldPresented: $isPresentedSignUp), isActive: $isPresentedSignUp) {
                        Text(SIGN_UP_LABEL)
                    }
                }
                NavigationLink(destination: ResetPasswordView()) {
                    Text(RESET_PASS_LABEL)
                }
                Spacer()
                
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    func getUserInfo() -> String {
        let user = Auth.auth().currentUser
        var uid = ""
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
            uid = user.uid
        }
        return uid
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
        HStack {
            Text("ICU Diaries")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Image(systemName: BOOK)
                .font(.system(size: 24))
        }
        .padding(.bottom, 20)
    }
}

