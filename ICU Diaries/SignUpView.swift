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

enum User: String, CaseIterable, Identifiable {
    case patient
    case clinician
    case friendsandfamily

    var id: String { self.rawValue }
}

struct SignUpView: View {
    @State var email = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var password = ""
    @State var passwordConfirm = ""
    @State var isEmailValid = true
    @State var isFormValid: Bool? = false
    @State var selectedUser = User.patient
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
            Text("I am a:")
                Picker(selection: $selectedUser,
                       label: Text("I am a:"),
                       content: {
                            Text("Patient").tag(User.patient)
                            Text("Clinician").tag(User.clinician)
                            Text("Friend or Family").tag(User.friendsandfamily)
                        })
                    .pickerStyle(.segmented)
            }
            .padding(.bottom, 10)
            
            Group {
                Text("Email")
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
            
            Group {
                Text("Name")
                HStack{
                    TextField(
                        "First Name",
                        text: $firstName)
                        .disableAutocorrection(true)
                        .cornerRadius(5)
                    
                    TextField(
                        "Last Name",
                        text: $lastName)
                        .disableAutocorrection(true)
                        .cornerRadius(5)
                }
                .padding(.bottom, 10)
            }
            
            Group {
                Text("Password")
                SecureField(
                    "Password",
                    text: $password)
                    .cornerRadius(5)
                
                SecureField(
                    "Re-type Password",
                    text: $passwordConfirm)
                    .cornerRadius(5)
                    .padding(.bottom, 10)
            }
            
            NavigationLink(destination: VerificationView().navigationBarBackButtonHidden(true), tag: true, selection: $isFormValid) {
                EmptyView()
            }
            Text("Sign Up")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    print("sign up clicked")
                    SignUpPressed()
                }
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    func ValidateFields() -> String? {
        if self.firstName.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.lastName.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" ||
            self.email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        let cleanedPass = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
        if !Utilities.isPasswordValid(cleanedPass) {
            return "Please make sure your password is at 6-15 characters, and contains a lowercase letter, uppercase letter, special charater, and a number."
        }
        if self.password != self.passwordConfirm {
            return "Please make sure your passwords match"
        }
        return nil
    }
    
    func SignUpPressed() { //TODO: add email verification
        let temp = ValidateFields() //validate fields
        print("validated fields")
        if temp == nil { //fields are valid, proceed with account creation
            let cleanFirst = self.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanLast = self.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanEmail = self.email.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanPassword = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
            print("fields were valid")
            Auth.auth().createUser(withEmail: cleanEmail, password: cleanPassword) { result, error in
                if let error = error {
                    print("error creating user")
                    isFormValid = false
                    //TODO: add code for displaying "error creating user"
                }
                else {
                    print("going to create user doc in database")
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData([
                        "firstName": cleanFirst,
                        "lastName": cleanLast,
                        "uid": result!.user.uid,
                        "userType": self.selectedUser.rawValue
                    ]) {err in
                        if let err = err {
                            print("error writing doc")
                            isFormValid = false
                        }
                        else {
                            print("doc written succesfully")
                            isFormValid = true
                            Auth.auth().currentUser?.sendEmailVerification { error in
                              print("sending email verification")
                            }
                        }
                    /*
                    (data: ["firstName":cleanFirst, "lastName":cleanLast, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            //user data wasnt saved, try again?
                        }
 */
                    }
                    //TODO: transition screen?
                    print("done adding user doc")
                }
            }
        }
        else { //there was an error with the fields
            print(temp)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

