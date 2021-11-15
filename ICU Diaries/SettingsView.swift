//
//  SettingsView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/8/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @State private var SignOutSuccess: Bool? = false
    @State var code = ""
    @State var codes: [String] = []
    @State var isCodeMatch: Bool = false
    @State var showError: Bool = false
    @State var typing: Bool = false
    @State var isPatient: Bool
    @State var patient_code: String
    @State var isFamily: Bool
    @State var presentAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), tag: true, selection: $SignOutSuccess) {
                EmptyView()
            }
            Text("Sign Out")
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarHidden(true)
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(8)
                .foregroundColor(.white)
                .onTapGesture {
                    do {
                        try Auth.auth().signOut()
                        SignOutSuccess = true;
                    }
                    catch {
                        print("didnt work try again")
                    }
                }//onTap
            
            if(isPatient == true){
                Text("Patient Code: " + patient_code)
            }//if isPatient
            
            if(isFamily == true){
                Text("Patient Code:")
                    TextField(
                        "Type Here",
                        text: $code,
                        onEditingChanged: {(isChanged) in
                            if self.code.isEmpty {
                                showError = false
                            }
                        }
                    )
                        .padding(8)
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(
                                            showError ? Color.red : Color(UIColor.lightGray),
                                            lineWidth: typing ? 3 : 1
                                )
                        )
                        .onTapGesture {
                            typing = true
                            if self.code.isEmpty && showError {
                                showError = false
                            }//if
                        }//ontap
            
            
            if !isCodeMatch && showError {
                Text(CODE_NOT_FOUND_ERR)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.red)
            }//if
            
            Text("Assign")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    typing = false
                    let db = Firestore.firestore()
                    let user_code = db.collection("users").document(Auth.auth().currentUser!.uid)
                    db.collection("codes").getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            isCodeMatch = false
                            showError = false
                            presentAlert = false
                        }
                        else {
                            for document in querySnapshot!.documents {
                                if(document.documentID == code){
                                    user_code.updateData(["code" : code])
                                    self.codes += [code]
                                    break
                                }
                            }//prints all documents in the firebase
                            if !codes.contains(code){
                                print("code NOT found")
                                isCodeMatch = false
                                showError = true
                                presentAlert = false
                            }
                            else {
                                print("code found")
                                isCodeMatch = true
                                showError = false
                                presentAlert = true
                            }
                        }//else
                    }//getDocuments
                }//onTap
            }//if is family
            Spacer()
        }//Vstack
        .alert(isPresented: $presentAlert) {
             Alert(
                 title: Text("Patient Code Assigned!")
             )
         }
    }// Body View
}//SettingsView

/*
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
*/
