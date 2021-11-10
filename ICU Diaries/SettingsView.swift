//
//  SettingsView.swift
//  ICU Diaries
//
//  Created by Nitya Baddam on 10/8/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SettingsView: View {
    @State private var SignOutSuccess: Bool? = false
    @State var code = ""
    @State var codes: [String] = []
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            Text("oops we're still working on this page!")
            
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), tag: true, selection: $SignOutSuccess) {
                EmptyView()
            }
//Add a code assignemnt button
            Text("Patient Code:")
                TextField(
                    "Type Here",
                    text: $code)
                    .disableAutocorrection(true)
                    .cornerRadius(5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
            Text("Assign")
                .padding(10)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.blue)
                .cornerRadius(2)
                .foregroundColor(.white)
                .onTapGesture {
                    let db = Firestore.firestore()
                    let user_code = db.collection("users").document(Auth.auth().currentUser!.uid)
                    db.collection("codes").getDocuments() { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
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
                                print("code not found")
                            }
                        }//else
                    }//getDocuments
                }//onTap
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
            
            Spacer()
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
