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
    // cursor location
    @State var inEmail: Bool = false
    @State var inFirstName: Bool = false
    @State var inLastName: Bool = false
    @State var inPassword: Bool = false
    @State var inConfirmPassword: Bool = false
    // validate fields
    @State var isPasswordMatch: Bool = true
    @State var isFieldMissing: Bool = false
    @State var isPasswordWeak: Bool = false
    // secure passwords
    @State var isPasswordSecured: Bool = true
    @State var isConfirmSecured: Bool = true
    
    var body: some View {
        ScrollView {
            HStack {
                Text("ICU Diaries")
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                Image(systemName: BOOK)
                    .font(.system(size: 20))
            }
            .padding(.bottom, 20)
            
            
            VStack(alignment: .leading, spacing: 5) {
                Group {
                    Text("Create your Account")
                        .fontWeight(.medium)
                    HStack {
                        Text(REQUIRED_FIELD_LABEL)
                            .font(.system(size: 14))
                            .foregroundColor(Color(UIColor.lightGray))
                        Text(ASTERICK_LABEL)
                            .foregroundColor(Color.red)
                            .font(.system(size: 20))
                            .offset(x: -5)
                    }
                    .cornerRadius(8)
                    
                    
                    HStack {
                        Text("I am a:")
                        Text(ASTERICK_LABEL)
                            .foregroundColor(Color.red)
                            .font(.system(size: 20))
                            .offset(x: -5)
                    }
                        Picker(selection: $selectedUser,
                           label: Text("I am a:"),
                               content: {
                            Text(PATIENT_LABEL).tag(User.patient)
                            Text(CLINICIAN_LABEL).tag(User.clinician)
                            Text(FAMILY_FRIEND_LABEL).tag(User.friendsandfamily)
                        })
                        .pickerStyle(.segmented)
                } // Group
                .padding(.bottom, 10)
    
    
                Group {
                    HStack {
                        Text(EMAIL_LABEL)
                        Text(ASTERICK_LABEL)
                            .foregroundColor(Color.red)
                            .font(.system(size: 20))
                            .offset(x: -5)
                    } // HStack
                    TextField(
                        EMAIL_LABEL,
                        text: $email,
                        onEditingChanged: { (isChanged) in
                            if !isChanged {
                                if Utilities.isEmailValid(self.email) || self.email.isEmpty {
                                    self.isEmailValid = true
                                } else {
                                    print("Invalid email entered: \(email)")
                                    self.isEmailValid = false
                                }
                            }
                        })
                        .disableAutocorrection(true)
                        .padding(8)
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(
                                            !isEmailValid ? Color.red : Color(UIColor.lightGray),
                                            lineWidth: inEmail ? 3 : 1
                                        ))
                        .onTapGesture {
                            inEmail = true
                            inFirstName = false
                            inLastName = false
                            inPassword = false
                            inConfirmPassword = false
                        }
                } //Group
                .padding(.bottom, 10)
    
                if !self.isEmailValid {
                    Text(INVALID_EMAIL_ERR)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                } // if
    
                Group {
                    HStack {
                        Text(NAME_LABEL)
                        Text(ASTERICK_LABEL)
                            .foregroundColor(Color.red)
                            .font(.system(size: 20))
                            .offset(x: -5)
                    }
                    TextField(
                        FIRST_NAME_LABEL,
                        text: $firstName)
                        .disableAutocorrection(true)
                        .padding(8)
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(
                                    Color(UIColor.lightGray),
                                        lineWidth: inFirstName ? 3 : 1
                                        ))
                        .onTapGesture {
                            inEmail = false
                            inFirstName = true
                            inLastName = false
                            inPassword = false
                            inConfirmPassword = false
                        }
                        .padding(.bottom, 5)
            
                    TextField(
                        LAST_NAME_LABEL,
                        text: $lastName)
                        .disableAutocorrection(true)
                        .padding(8)
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(
                                            Color(UIColor.lightGray),
                                            lineWidth: inLastName ? 3 : 1
                                        ))
                        .onTapGesture {
                            inEmail = false
                            inFirstName = false
                            inLastName = true
                            inPassword = false
                            inConfirmPassword = false
                        }
                        .padding(.bottom, 10)
                } //Group
                
                Group {
                    HStack {
                        Text(PASSWORD_LABEL)
                        Text(ASTERICK_LABEL)
                            .foregroundColor(Color.red)
                            .font(.system(size: 20))
                            .offset(x: -5)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: CHECKMARK)
                                .font(.system(size: 10))
                            Text("At least 6 characters")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Utilities.isAtLeastSixCharacters(self.password) ?   Color.green : Color(UIColor.gray))
                        HStack {
                            Image(systemName: CHECKMARK)
                                .font(.system(size: 10))
                            Text("Contains a lowercase letter [a-z]")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Utilities.containsLowercaseLetter(self.password) ?   Color.green : Color(UIColor.gray))
                        HStack {
                            Image(systemName: CHECKMARK)
                                .font(.system(size: 10))
                            Text("Contains a uppercase letter [A-Z]")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Utilities.containsCapitalLetter(self.password) ?   Color.green : Color(UIColor.gray))
                        HStack {
                            Image(systemName: CHECKMARK)
                                .font(.system(size: 10))
                            Text("Contains a digit [0-9]")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Utilities.containsDigit(self.password) ? Color.green : Color(UIColor.gray))
                    }
                    HStack {
                        VStack {
                            if isPasswordSecured {
                                SecureField(
                                    PASSWORD_LABEL,
                                    text: $password)
                                
                            } else {
                                TextField(
                                    PASSWORD_LABEL,
                                    text: $password)
                            }
            
                            if self.password.isEmpty {
                                // no password strength meter
                            } else {
                                let strength = Utilities.passwordStrength(self.password)
                                if strength == WEAK_LABEL {
                                    Rectangle()
                                        .fill(Color.red)
                                        .frame(height: 3)
                                        .cornerRadius(16)
                                        .edgesIgnoringSafeArea(.horizontal)
                                } else if strength == FAIR_LABEL {
                                    Rectangle()
                                        .fill(Color.yellow)
                                        .frame(height: 3)
                                        .cornerRadius(16)
                                        .edgesIgnoringSafeArea(.horizontal)
                                } else if strength == STRONG_LABEL {
                                    Rectangle()
                                        .fill(Color.green)
                                        .frame(height: 3)
                                        .cornerRadius(16)
                                        .edgesIgnoringSafeArea(.horizontal)
                                }
                
                            }
                            
            
                        } // VStack
        
                        Button(action: {
                            self.isPasswordSecured.toggle()
                        }) {
            
                            if isPasswordSecured {
                                EyeToggleView(name: CLOSED_EYE_IMAGE)
                            } else {
                                EyeToggleView(name: OPEN_EYE_IMAGE)
                            }
                        }
                        .offset(x: -4, y: -2)
                    } //HStack
                    .disableAutocorrection(true)
                    .padding(8)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        Color(UIColor.lightGray),
                                        lineWidth: inPassword ? 3 : 1
                                    ))
                    .onTapGesture {
                        inEmail = false
                        inFirstName = false
                        inLastName = false
                        inPassword = true
                        inConfirmPassword = false
                    }
                        
            
                } // Group
                .padding(.bottom, 5)
                
                if self.password.isEmpty {
                    // show no message
                }
                else {
                    let strength = Utilities.passwordStrength(self.password)
                    if strength == WEAK_LABEL {
                        Text(WEAK_LABEL)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.red)
                    } else if strength == FAIR_LABEL {
                        Text(FAIR_LABEL)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.yellow)

                    } else if strength == STRONG_LABEL {
                        Text(STRONG_LABEL)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.green)
                    }
    
                } // else
        
                Group {
                    HStack {
                        VStack {
                            if isConfirmSecured {
                                SecureField(
                                    RETYPE_PASSWORD_LABEL,
                                    text: $passwordConfirm)
                
                            } else {
                                TextField(
                                    RETYPE_PASSWORD_LABEL,
                                    text: $passwordConfirm)
                            }
                
                
                        } // VStack
            
                        Button(action: {
                            self.isConfirmSecured.toggle()
                        }) {
                
                            if isConfirmSecured {
                                EyeToggleView(name: CLOSED_EYE_IMAGE)
                            } else {
                                EyeToggleView(name: OPEN_EYE_IMAGE)
                            }
                        }
                        .offset(x: -4, y: -2)
                    } //HStack
                    .disableAutocorrection(true)
                    .padding(8)
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        Color(UIColor.lightGray),
                                        lineWidth: inConfirmPassword ? 3 : 1
                                    ))
                    .onTapGesture {
                        inEmail = false
                        inFirstName = false
                        inLastName = false
                        inPassword = false
                        inConfirmPassword = true
                    }
        
                } // Group
                .padding(.bottom, 10)
    


                if isFieldMissing {
                    Text(MISSING_FIELDS_ERR)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                } else if isPasswordWeak {
                    Text(WEAK_PASSWORD_ERR)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
    
                } else if !isPasswordMatch {
                    Text(MISMATCH_PASSWORD_ERR)
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.red)
                }
                
    
                NavigationLink(destination: VerificationView().navigationBarBackButtonHidden(true), tag: true, selection: $isFormValid) {
                    EmptyView()
                }
                Text(SIGN_UP_LABEL)
                    .padding(10)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .onTapGesture {
                        print("sign up clicked")
                        SignUpPressed()
                    }
                
            } // VStack
            .offset(y: -20)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            

            Spacer()

        } // ScrollView
    } // View
    
    func ValidateFields() -> String? {
        if self.firstName.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.lastName.trimmingCharacters(in: .whitespacesAndNewlines) ==  "" ||
            self.email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            isFieldMissing = true
            return "Please fill in all fields"
        } else {
            isFieldMissing = false
        }
        let cleanedPass = self.password.trimmingCharacters(in: .whitespacesAndNewlines)
        if !Utilities.isPasswordValid(cleanedPass) {
            isPasswordWeak = true
            return "Please make sure your password is at 6-15 characters, and contains a lowercase letter, uppercase letter, and a number."
        } else {
            isPasswordWeak = false
        }
        if self.password != self.passwordConfirm {
            isPasswordMatch = false
            return "Please make sure your passwords match"
        } else {
            isPasswordMatch = true
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

