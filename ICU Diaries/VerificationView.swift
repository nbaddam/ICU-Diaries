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
    var userEmail: String
    @State private var isVerified: Bool? = false
    @State private var patient_code = ""
    @State private var isPatient: Bool = false
    @State private var isFamily: Bool = false
    @State private var isDoctor: Bool = false
    @State private var sentAgain: Bool = false
    var body: some View {
        VStack(spacing: 20){
            VerificationText(email: self.userEmail)
            
            VStack(spacing: 5) {
                Text("Didn't Recieve an Email?")
                .foregroundColor(Color.gray)
                Text("Resend email")
                    .padding(10)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .padding(.bottom, 5)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .onTapGesture {
                        Auth.auth().currentUser?.sendEmailVerification { error in
                            print("sending email verification")
                        }
                        sentAgain = true
                    }
                    .alert(isPresented: $sentAgain) {
                        Alert(
                            title: Text("Email Resent!")
                        )
                    }
            }
            
            VStack(spacing: 5) {
                Text("Already Verified Email?")
                    .foregroundColor(Color.gray)
                Text("Continue to Home Page")
                    .padding(10)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .onTapGesture {
                        let user = Auth.auth().currentUser
                        if (user != nil) {
                            user?.reload { error in
                                if error == nil {
                                    if (Auth.auth().currentUser?.isEmailVerified != true) {
                                        print("email isnt verified")
                                    }
                                    else {
                                        print("email is verified")
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
                                            self.isVerified = true;
                                        }
                                    
                                    }
                                }
                            }
                        }
//                    if (Auth.auth().currentUser?.isEmailVerified != true) {
//                        Auth.auth().currentUser?.sendEmailVerification { error in
//                          print("sending email verification")
//                        }
//                    }
//                    else {
//                        isVerified = true;
//                    }
                }
            }
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                Text("Go Back to Login")
            }
            NavigationLink(destination: MainView(isPatient: self.isPatient, patient_code: self.patient_code, isFamily: self.isFamily, isDoctor: self.isDoctor).navigationBarBackButtonHidden(true), tag: true, selection: $isVerified) {
                EmptyView()
            }

        }
    }
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
struct VerificationText: View {
    var email: String
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "envelope")
                .font(.system(size: 64))
                .foregroundColor(Color.white)
                .padding()
                .background(
                        Circle()
                            .fill(Color(red: 49 / 255, green: 163 / 255, blue: 159 / 255))
                            .frame(width: 100, height: 100)
                    )
            Text("Email Verification Required!")
                .font(.system(size: 24))
                .fontWeight(.semibold)
                .padding(.top, 20)
            Text("An email has just been sent to:")
                .foregroundColor(Color.gray)
            Text(self.email)
                .fontWeight(.semibold)
            Text("Before proceeding to login, please click the link provided in the email to activate your account.")
                .font(.body)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
        } // VStack
    }
}
