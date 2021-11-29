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
    @State private var isVerified: Bool? = false
    @State private var patient_code = ""
    @State private var isPatient: Bool = false
    @State private var isFamily: Bool = false
    @State private var isDoctor: Bool = false
    var body: some View {
        VStack{
            VerificationText()
            
            
            Text("Resend email")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .padding(.bottom, 5)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    Auth.auth().currentUser?.sendEmailVerification { error in
                      print("sending email verification")
                    }
                }
            
            Text("Click once email is verified (this doesn't work idk how to fix)")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
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
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                Text("go back to login")
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
    var body: some View {
        Text("A verification email has just been sent to your email. Please click the link before proceeding to login")
            .font(.body)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
